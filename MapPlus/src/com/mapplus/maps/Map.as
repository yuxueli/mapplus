//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    
    import mx.events.*;

    public class Map extends IMapWrapper implements IMap {

        private var delayedCalls:Array;
        private var controlList:Array;
        private var timer:Timer;
        private var isInitialized:Boolean;
        private var unloaded:Boolean;
        private var initOptions:MapOptions;

        public function Map(){
            super();
            this.controlList = [];
            this.delayedCalls = [];
            this.unloaded = false;
            this.isInitialized = false;
            this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
            this.setInitialSize();
        }
        private function onRemoved(event:Event):void{
            this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
            configureSize(false);
        }
        public function get channel():String{
            return (BootstrapConfiguration.getInstance().channel);
        }
        private function configureSize(param1:Boolean):void{
        }
        protected function delayCall(param1:Function):void{
            if (this.timer == null){
                this.timer = new Timer(1, 1);
                this.timer.addEventListener(TimerEvent.TIMER, this.executeDelayedCalls);
                this.timer.start();
            };
            this.delayedCalls.push(param1);
        }
        override public function setSize(param1:Point):void{
            this.width = param1.x;
            this.height = param1.y;
        }
        public function get ssl():String{
            return (BootstrapConfiguration.getInstance().ssl);
        }
        public function set channel(param1:String):void{
            BootstrapConfiguration.getInstance().channel = param1;
        }
        private function onMapReadyInternal(event:Event):void{
            var _loc_2:Number = NaN;
            this.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReadyInternal);
            internalSetSize(new Point(this.width, this.height));
            _loc_2 = 0;
            while (_loc_2 < controlList.length) {
                super.addControl(controlList[_loc_2]);
                _loc_2 = (_loc_2 + 1);
            };
            controlList = [];
        }
        private function internalSetSize(param1:Point):void{
            if (this.isLoaded()){
                super.setSize(param1);
            };
        }
        public function set client(param1:String):void{
            BootstrapConfiguration.getInstance().client = param1;
        }
        public function set ssl(ssl:String):void{
            BootstrapConfiguration.getInstance().ssl = ssl;
        }
        public function get languages():String{
            return (BootstrapConfiguration.getInstance().languages);
        }
        public function get countryCode():String{
            return (BootstrapConfiguration.getInstance().countryCode);
        }
        private function executeDelayedCalls(event:Event):void{
            var _loc_4:*;
            var _loc_2:Array;
            var _loc_3:int;
            this.timer.removeEventListener(TimerEvent.TIMER, this.executeDelayedCalls);
            this.timer = null;
            _loc_2 = this.delayedCalls;
            this.delayedCalls = [];
            if (_loc_2 != null){
                while (_loc_3 < _loc_2.length) {
                    _loc_4 = _loc_2;
                    var _local5 = _loc_4._loc_2;
                    _local5[_loc_3]();
                    _loc_3 = (_loc_3 + 1);
                };
            };
        }
        private function setInitialSize():void{
            this.addEventListener(ResizeEvent.RESIZE, onUIComponentResized);
            this.width = 0x0100;
            this.height = 0x0100;
        }
        public function setInitOptions(param1:MapOptions):void{
            this.initOptions = param1;
        }
        public function set language(param1:String):void{
            BootstrapConfiguration.getInstance().language = param1;
        }
        public function set version(param1:String):void{
            BootstrapConfiguration.getInstance().version = param1;
        }
        override public function removeControl(param1:IControl):void{
            var _loc_2:ClientBootstrap;
            var _loc_3:int;
            _loc_2 = ClientBootstrap.getInstance();
            if (_loc_2.isReady()){
                super.removeControl(param1);
            } else {
                _loc_3 = controlList.indexOf(param1);
                if (_loc_3 >= 0){
                    controlList.splice(_loc_3, 1);
                };
            };
        }
        public function get sensor():String{
            return (BootstrapConfiguration.getInstance().sensor);
        }
        private function bootstrapFailure(param1:String):void{
            var _loc_2:TextField;
            Log.log0(("Bootstrap failure: " + param1));
            _loc_2 = new TextField();
            _loc_2.background = true;
            _loc_2.autoSize = TextFieldAutoSize.CENTER;
            _loc_2.defaultTextFormat = new TextFormat("_sans", 14);
            _loc_2.x = (this.width / 2);
            _loc_2.y = (this.height / 2);
            _loc_2.text = param1;
            addChild(_loc_2);
            dispatchEvent(new MapEvent(MapEvent.MAP_INITIALIZE_FAILED, this));
        }
        public function set languages(languages:String):void{
            BootstrapConfiguration.getInstance().languages = languages;
        }
        public function set key(param1:String):void{
            BootstrapConfiguration.getInstance().key = param1;
        }
        private function onUIComponentResized(event:ResizeEvent):void{
            internalSetSize(new Point(this.width, this.height));
        }
        public function get client():String{
            return (BootstrapConfiguration.getInstance().client);
        }
        public function set countryCode(param1:String):void{
            BootstrapConfiguration.getInstance().countryCode = param1;
        }
        override public function isLoaded():Boolean{
            return (((!((this.instance == null))) && (super.isLoaded())));
        }
        public function getInterfaceVersion():String{
            return (Release.version);
        }
        public function get version():String{
            return (BootstrapConfiguration.getInstance().version);
        }
        public function get key():String{
            return (BootstrapConfiguration.getInstance().key);
        }
        private function onAdded(event:Event):void{
            var configuration:* = null;
            var bootstrap:* = null;
            var event:* = event;
            this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			//this.addEventListener(MapEvent.MAP_PREINITIALIZE,onPreInitialize);
			
            configureSize(true);
            if (!(this.isInitialized)){
                configuration = BootstrapConfiguration.getInstance();
                configuration.initialize(this.root.loaderInfo, this.stage);
                try {
                    configuration.lock();
                } catch(e:Error) {
                    bootstrapFailure(e.message);
                    return;
                };
                bootstrap = ClientBootstrap.getInstance();
                bootstrap.addEventListener(ClientBootstrap.BOOTSTRAP_FAILED, onBootstrapFailed);
                bootstrap.loadBootstrap();
                bootstrap.registerObject(this);
                if (bootstrap.isReady()){
                    bindInstance();
                    onBootstrapInitComplete();
                } else {
                    bootstrap.addEventListener(ClientBootstrap.LIBRARY_LOADED, this.bindInstance);
                    bootstrap.addEventListener(ClientBootstrap.INIT_COMPLETE, this.onBootstrapInitComplete);
                };
            };
            this.isInitialized = true;
        }
        public function set url(param1:String):void{
            BootstrapConfiguration.getInstance().url = param1;
        }
        public function get language():String{
            return (BootstrapConfiguration.getInstance().language);
        }
        private function onBootstrapFailed(event:Event):void{
            var _loc_2:ClientBootstrap;
            var _loc_3:String;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_2.removeEventListener(ClientBootstrap.BOOTSTRAP_FAILED, onBootstrapFailed);
            _loc_3 = (client) ? "client id" : "API key";
            bootstrapFailure("地图窗口载入中,请稍候...");
        }
        public function get url():String{
            return (BootstrapConfiguration.getInstance().url);
        }
        private function onBootstrapInitComplete(event:Event=null):void{
            var _loc_2:ClientBootstrap;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_2.removeEventListener(ClientBootstrap.BOOTSTRAP_FAILED, this.onBootstrapFailed);
            _loc_2.removeEventListener(ClientBootstrap.LIBRARY_LOADED, this.bindInstance);
            _loc_2.removeEventListener(ClientBootstrap.INIT_COMPLETE, this.onBootstrapInitComplete);
            if (this.unloaded){
                return;
            };
            this.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReadyInternal);
			if (onMapReady!=null)
				this.addEventListener(MapEvent.MAP_READY,onMapReady);
			configureMap();
        }
		//用户自定义事件  by于学利
		private var onMapReady:Function;		
		public function set mapevent_mapready(param1:Function):void{			
			
			onMapReady=param1;
		}
		private var onPreInitialize:Function;
		public function set mapevent_mappreinitialize(param1:Function):void{						
			onPreInitialize=param1;
		}
		
        private function bindInstance(event:Event=null):void{
            var _loc_2:ClientBootstrap;
            var _loc_3:IMapsFactory;
            var _loc_4:Object;
            if (this.unloaded){
                return;
            };
			if (onPreInitialize!=null)
				this.addEventListener(MapEvent.MAP_PREINITIALIZE,onPreInitialize);
            dispatchEvent(new MapEvent(MapEvent.MAP_PREINITIALIZE, this));
            _loc_2 = ClientBootstrap.getInstance();
            _loc_3 = _loc_2.getMapsFactory();
            _loc_4 = _loc_3.createMap2(this.initOptions);
            Wrapper.instance().wrap(_loc_4, this, IMap, Map);
        }
        public function set sensor(param1:String):void{
            BootstrapConfiguration.getInstance().sensor = param1;
        }
        override public function addControl(control:IControl):void{
            var _loc_2:ClientBootstrap;
            _loc_2 = ClientBootstrap.getInstance();
            if (_loc_2.isReady()){
                super.addControl(control);
            } else {
                controlList.push(control);
            };
        }
        override public function unload():void{
            var _loc_1:ClientBootstrap;
            if (this.isLoaded()){
                super.unload();
            };
            if (this.parent != null){
                this.parent.removeChild(this);
            };
            this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
            this.unloaded = true;
            this.controlList = null;
            this.clearWrapper();
            _loc_1 = ClientBootstrap.getInstance();
            _loc_1.removeEventListener(ClientBootstrap.BOOTSTRAP_FAILED, onBootstrapFailed);
            _loc_1.unregisterObject(this);
        }

    }
}//package com.mapplus.maps 
