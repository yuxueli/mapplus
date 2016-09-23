package local
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.text.TextFormat;
    
    import mx.events.FlexEvent;
    import mx.preloaders.IPreloaderDisplay;

    public class LogoPreloader extends Sprite implements IPreloaderDisplay
    {
        // Settings fiddle with these as you like
        private var _minimumDuration:Number = 3000;   // even if the preloader is done, take this long to "finish"

        // Implementation variables, used to make everything work properly
        private var _IsInitComplete		: Boolean = false;
        private var _timer 				: Timer;			// this is so we can redraw the progress bar
        private var _bytesLoaded 		: uint = 0;
        private var _bytesExpected 		: uint = 1;			// we start at 1 to avoid division by zero errors.
        private var _fractionLoaded 	: Number = 0;		// Will be used for the width of the loading bar
        private var _preloader			: Sprite;
        private var _currentStatus		: String;			// The current stats of the application, downloaded, initilising etc
        
        // Display properties of the loader, these are set in the mx:Application tag
        private var _backgroundColor	: uint = 0x000000;
        private var _stageHeight		: Number = 1;
        private var _stageWidth			: Number = 1;
        private var _loadingBarColour	: uint = 0xFFFFFF;
        
        // Display elements
        private var _loadingBar 		: Rectangle;		// The loading bar that will be drawn
        private var loadingImage 		: flash.display.Loader;
        private var progressText		: TextField;
        private var statusText			: TextField;
        private var titleText	   	    : TextField;
        private var versionText			: TextField;
        
        public function LogoPreloader()
        {
            super();
        }
        
        // Called when the appication is ready for the preloading screen
        public function initialize():void
        {
        	drawBackground();

			// Load in your logo or loading image
			loadingImage = new flash.display.Loader();       
			loadingImage.contentLoaderInfo.addEventListener( Event.COMPLETE, loader_completeHandler);
			loadingImage.load(new URLRequest("assets/images/preloaderLogo.png")); // This path needs to be relative to your swf on the server, you could use an absolute value if you are unsure
        }
        
        private function loader_completeHandler(event:Event):void
        {
        	// At this stage we are sure the image has loaded so we can start drawing the progress bar and other info
        	
        	// Draw the loading image
            addChild(loadingImage);

            loadingImage.x = width / 2 - loadingImage.width / 2
            loadingImage.y = (height / 2 - loadingImage.height / 2) - 100;
            
			// Draw your loading bar in it's full state - x,y,width,height
            _loadingBar = new Rectangle((width / 2) - (200 / 2), 
            							(height / 2 - loadingImage.height / 2) + loadingImage.height - 80, 
            							200, 10);
            
            // New text format
            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xFFFFFF;
            format.size = 18;
            format.align = "center";
                      
            // Create a text area for your title text
            titleText = new TextField(); 
            titleText.defaultTextFormat = format;
            titleText.x = (width / 2) - (200 / 2);    
            titleText.y = (height / 2 - loadingImage.height / 2) - 155;
            titleText.width = 200;
            titleText.height = 30;
            addChild(titleText);
            
            format.font = "Verdana";
            format.color = 0xFFFFFF;
            format.size = 14;
            format.align = "center";
                        
            // Create a text area for your title text
            versionText = new TextField(); 
            versionText.defaultTextFormat = format;
            versionText.x = (width / 2) - (200 / 2);    
            versionText.y = (height / 2 - loadingImage.height / 2) - 130;
            versionText.width = 200;
            versionText.height = 20;
            addChild(versionText);            
                        
            // Text format
            format.font = "Verdana";
            format.color = 0xFFFFFF;
            format.size = 10;
            format.align = "center";
                      
            // Create a text area for your progress text
            progressText = new TextField(); 
            progressText.defaultTextFormat = format;
            progressText.x = (width / 2) - (200 / 2);    
            progressText.y = (height / 2 - loadingImage.height / 2) + loadingImage.height - 60;
            progressText.width = 200;
            progressText.height = 20;
            addChild(progressText);
			
			// Create a text area for your status text
            statusText = new TextField();
            statusText.defaultTextFormat = format;
            statusText.x = (width / 2) - (200 / 2);    
            statusText.y = (height / 2 - loadingImage.height / 2) + loadingImage.height - 40;
            statusText.width = 200;
            statusText.height = 20;
            addChild(statusText);
            
            // The first change to this var will be Download Complete
            _currentStatus = 'Downloading...';	
            
			// Start a timer to redraw your loading elements frequently
            _timer = new Timer(50);
            _timer.addEventListener(TimerEvent.TIMER, timerHandler);
            _timer.start();
        }
        
        // This is called repeatidly untill we are finished loading
        private function draw():void
        {
			graphics.beginFill( _loadingBarColour , 1);
            graphics.drawRect(_loadingBar.x, _loadingBar.y, _loadingBar.width * _fractionLoaded, _loadingBar.height);
            graphics.endFill();
            progressText.text = (Math.round(_bytesLoaded / 1024)).toString() + 'kb of ' + (Math.round(_bytesExpected / 1024)) + 'kb downloaded';
            statusText.text = _currentStatus;
            titleText.text = "";    //"Neon";
            versionText.text = "";  //"Version :: 0.0.0.36";
        }
        
        private function drawBackground():void
        {
			// Draw the background using the background colour (set in the mx:Application MXML tag)
			graphics.beginFill( _backgroundColor, 1);
 			graphics.drawRect( 0, 0, stageWidth, stageHeight);
			graphics.endFill();
        }
        
         // This code comes from DownloadProgressBar.  I have modified it to remove some unused event handlers.
        public function set preloader(value:Sprite):void
        {
            _preloader = value;
        
            value.addEventListener(ProgressEvent.PROGRESS, progressHandler);    
            value.addEventListener(Event.COMPLETE, completeHandler);
            
        //    value.addEventListener(RSLEvent.RSL_PROGRESS, rslProgressHandler);
        //    value.addEventListener(RSLEvent.RSL_COMPLETE, rslCompleteHandler);
        //    value.addEventListener(RSLEvent.RSL_ERROR, rslErrorHandler);
            
            value.addEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
            value.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
        }

		// Getters and setters for values, most are set via the MXML in the mx:Application tag
        public function set backgroundAlpha(alpha:Number):void{}
        public function get backgroundAlpha():Number { return 1; }
        
        public function set backgroundColor(color:uint):void { _backgroundColor = color; }
        public function get backgroundColor():uint { return _backgroundColor; }
        
        public function set backgroundImage(image:Object):void {}
        public function get backgroundImage():Object { return null; }
        
        public function set backgroundSize(size:String):void {}
        public function get backgroundSize():String { return "auto"; }
        
        public function set stageHeight(height:Number):void { _stageHeight = height; }
        public function get stageHeight():Number { return _stageHeight; }

        public function set stageWidth(width:Number):void { _stageWidth = width; }
        public function get stageWidth():Number { return _stageWidth; }

        //--------------------------------------------------------------------------
        //
        //  Event handlers
        //
        //--------------------------------------------------------------------------
        
        // Called by the application as the download progresses.
        private function progressHandler(event:ProgressEvent):void
        {
            _bytesLoaded = event.bytesLoaded;
            _bytesExpected = event.bytesTotal;
            _fractionLoaded = Number(_bytesLoaded) / Number(_bytesExpected);
        }
        
        // Called when the download is complete
        private function completeHandler(event:Event):void
        {
        	_currentStatus = 'Download Completed';
        	trace(_currentStatus);
        }
    
        // Called by the application as the initilisation progresses.        
        private function initProgressHandler(event:Event):void
        {
        	if( !_IsInitComplete) // This seems to be called right at the end for some reason, so this stopps it if the app is already complete
        	{
            	_currentStatus = 'Initilising Application...';
            	trace(_currentStatus);
         	}
        }
    
        // Called when both download and initialisation are complete    
        private function initCompleteHandler(event:Event):void
        {
        	_currentStatus = 'Initilisation Completed';
        	trace(_currentStatus);
            _IsInitComplete = true;
            
        }

        // Called as often as possible
        private function timerHandler(event:Event):void
        {
            if ( _IsInitComplete && getTimer() > _minimumDuration )
            {    
                // Everything is now ready, so we can tell the application to show the main application
                // NOTE: If you have set a min duration, your application may already have started running
                _timer.stop();
                _timer.removeEventListener(TimerEvent.TIMER,timerHandler);
                dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
            	// Update the screen with the latest progress
                draw();
            }
        }
    }
}