//Created by yuxueli 2011.6.6
package com.mapplus.maps.window {
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.styles.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class InfoWindow extends Overlay implements IInfoWindow {
		[Embed(source="/assets/images/InfoWindow_CloseImage.png")]
        private static const CloseImage:Class;// InfoWindow_CloseImage;

        private static var defaultOptions:InfoWindowOptions = createInitialDefaultOptions();

        private var contentField:TextField;
        private var overlayValue:IOverlay;
        private var _latLng:LatLng;
        private var _defaultContent:Sprite;
        private var closeButtonImage:DisplayObject;
        private var backgroundMc:Sprite;
        private var closeButtonMc:Sprite;
        private var titleField:TextField;
        private var _contentAutoSize:String;
        private var options:InfoWindowOptions;
        private var _currentCustomContent:DisplayObject;
        private var closeEventTarget:EventDispatcher;
        private var _customContentContainer:DisplayObject;
        private var dropShadow:DropShadow;
        private var windowFrameSize:Point;

        public function InfoWindow(param1:LatLng, param2:IOverlay, param3:InfoWindowOptions=null){
            super(FLAG_HASSHADOW);
            this._latLng = param1;
            this.overlayValue = param2;
            this.options = InfoWindowOptions.merge([InfoWindow.getDefaultOptions(), param3]);
        }
        private static function stopPropagation(event:Event):void{
            event.stopPropagation();
        }
        private static function createInitialDefaultOptions():InfoWindowOptions{
            var _loc_1:StyleSheet;
            var _loc_2:StyleSheet;
            var _loc_3:Object;
            _loc_1 = new StyleSheet();
            _loc_1.setStyle("p", {fontFamily:"_sans"});
            _loc_2 = new StyleSheet();
            _loc_2.setStyle("p", {fontFamily:"_sans"});
            _loc_3 = {
                strokeStyle:{
                    thickness:2,
                    alpha:1,
                    color:Color.BLACK,
                    pixelHinting:true
                },
                fillStyle:{
                    color:0xFFFFFF,
                    alpha:1
                },
                title:null,
                titleHTML:null,
                titleFormat:new TextFormat("_sans"),
                titleStyleSheet:_loc_1,
                content:null,
                contentHTML:null,
                contentFormat:new TextFormat("_sans"),
                contentStyleSheet:_loc_2,
                width:200,
                height:null,
                cornerRadius:5,
                padding:0,
                hasCloseButton:null,
                hasTail:true,
                tailWidth:20,
                tailHeight:20,
                tailOffset:0,
                tailAlign:InfoWindowOptions.ALIGN_LEFT,
                pointOffset:new Point(0, 0),
                hasShadow:true,
                customContent:null,
                customOffset:null,
                customCloseRect:null,
                drawDefaultFrame:false
            };
            return (new InfoWindowOptions(_loc_3));
        }
        public static function getDefaultOptions():InfoWindowOptions{
            return (defaultOptions);
        }
        public static function setDefaultOptions(param1:InfoWindowOptions):void{
            defaultOptions = InfoWindowOptions.merge([defaultOptions, param1]);
        }

        public function getLatLng():LatLng{
            return (this._latLng);
        }
        private function hasTail():Boolean{
            return ((this.options.hasTail as Boolean));
        }
        private function getTailAlign():Number{
            return ((this.options.tailAlign as Number));
        }
        private function getPointOffset():Point{
            return ((this.options.pointOffset) ? this.options.pointOffset : new Point(0, 0));
        }
        public function updatePosition():void{
            this.redraw();
        }
        private function createDefaultContent():DisplayObject{
            var _loc_1:ISpriteFactory;
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:DisplayObject;
            var _loc_6:DisplayObject;
            _loc_1 = Bootstrap.getSpriteFactory();
            if (!(this._defaultContent)){
                this._defaultContent = _loc_1.createSprite().getSprite();
            };
            _loc_2 = this.fixLayout();
            _loc_3 = (_loc_2.x - (2 * this.getPadding()));
            _loc_4 = 0;
            _loc_5 = this.createTitle(this._defaultContent, _loc_3);
            if (_loc_5){
                _loc_5.x = 0;
                _loc_5.y = _loc_4;
                _loc_4 = (_loc_4 + (_loc_5.height + this.getPadding()));
            };
            _loc_6 = this.createContent(this._defaultContent, _loc_3);
            if (_loc_6){
                _loc_6.x = 0;
                _loc_6.y = _loc_4;
            };
            return (this._defaultContent);
        }
        override public function get interfaceChain():Array{
            return (["IInfoWindow", "IOverlay"]);
        }
        private function getHtmlContent():String{
            return (this.options.contentHTML);
        }
        private function getCustomContent():DisplayObject{
            return (this.options.customContent);
        }
        override public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_FLOAT));
        }
        private function getHeight():Number{
            return ((this.options.height as Number));
        }
        private function getContentFormat():TextFormat{
            return (this.options.contentFormat);
        }
        private function getStrokeStyle():StrokeStyle{
            return (this.options.strokeStyle);
        }
        private function allowHtmlTitle():Boolean{
            return (!((this.options.titleHTML == null)));
        }
        private function displayCloseButton():void{
            var _loc_1:EventDispatcher;
            var _loc_2:Boolean;
            var _loc_3:Rectangle;
            _loc_1 = null;
            _loc_2 = false;
            if (this.hasCloseButton()){
                _loc_3 = this.calculateCloseRect();
                if (_loc_3){
                    if (!(this.closeButtonMc)){
                        this.closeButtonMc = new Sprite();
                        this.closeButtonMc.useHandCursor = true;
                        this.closeButtonMc.buttonMode = true;
                        this.closeButtonMc.addChild(this.closeButtonImage);
                        this.mc.addChild(this.closeButtonMc);
                    };
                    this.closeButtonMc.x = _loc_3.left;
                    this.closeButtonMc.y = _loc_3.top;
                    this.closeButtonMc.width = _loc_3.width;
                    this.closeButtonMc.height = _loc_3.height;
                    this.closeButtonMc.alpha = (this.shouldDrawDefaultFrame()) ? 1 : 0;
                    _loc_1 = this.closeButtonMc;
                    _loc_2 = true;
                } else {
                    _loc_1 = this.mc;
                    _loc_1 = this.mc;
                };
            };
            if (!(_loc_2)){
                if (this.closeButtonMc){
                    this.mc.removeChild(this.closeButtonMc);
                    this.closeButtonMc.removeChild(this.closeButtonImage);
                };
            };
            this.enableCloseButton(_loc_1);
        }
        private function calculateCloseRect():Rectangle{
            var _loc_1:Rectangle;
            _loc_1 = this.getCustomCloseRect();
            if (_loc_1){
                return (_loc_1);
            };
            if (this.shouldDrawDefaultFrame()){
                return (new Rectangle(((this.windowFrameSize.x - this.closeButtonImage.width) - this.getPadding()), this.getPadding(), this.closeButtonImage.width, this.closeButtonImage.height));
            };
            return (null);
        }
        private function getTitleFormat():TextFormat{
            return (this.options.titleFormat);
        }
        override protected function onAddedToPane():void{
            var _loc_1:IMouse;
            super.onAddedToPane();
            this.closeButtonImage = new CloseImage();
            this.initializeShadow();
            this.redraw();
            _loc_1 = MouseHandler.instance();
            _loc_1.addListener(this.mc, MouseEvent.MOUSE_DOWN, stopPropagation);
            _loc_1.addListener(this.mc, MouseEvent.MOUSE_UP, stopPropagation);
            _loc_1.addListener(this.mc, MouseEvent.MOUSE_MOVE, stopPropagation);
            if (this.initializationPending){
                this._customContentContainer.addEventListener(MapEvent.COMPONENT_INITIALIZED, this.onCustomContentInitialized);
            };
            if (this.overlayValue){
                this.overlayValue.addEventListener(MapEvent.OVERLAY_MOVED, this.onOverlayMoved);
            };
        }
        private function allowHtmlContent():Boolean{
            return (!((this.options.contentHTML == null)));
        }
        private function getFillStyle():FillStyle{
            return (this.options.fillStyle);
        }
        private function createTextField():TextField{
            var _loc_1:IClientFactory;
            _loc_1 = Bootstrap.getBootstrap().getClientFactory();
            if (_loc_1){
                return (_loc_1.createTextField());
            };
            return (new TextField());
        }
        private function getCustomCloseRect():Rectangle{
            return (this.options.customCloseRect);
        }
        private function hasCloseButton():Boolean{
            if (this.options.hasCloseButton == null){
                if (this.shouldDrawDefaultFrame()){
                    return (true);
                };
                return (!((this.options.customCloseRect == null)));
            };
            return ((this.options.hasCloseButton as Boolean));
        }
        private function hasShadow():Boolean{
            return ((this.options.hasShadow as Boolean));
        }
        private function getContent():String{
            return (this.options.content);
        }
        public function get removed():Boolean{
            return ((pane == null));
        }
        public function get hasContent():Boolean{
            return (((((this.options.contentHTML) && ((this.options.contentHTML.length > 0)))) || (((this.options.content) && ((this.options.content.length > 0))))));
        }
        private function getTitleStyleSheet():StyleSheet{
            return (this.options.titleStyleSheet);
        }
        private function displayBackground(param1:DisplayObject):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Rectangle;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            if (!(this.backgroundMc)){
                this.backgroundMc = new Sprite();
                this.backgroundMc.name = "bg_mc";
                this.mc.addChildAt(this.backgroundMc, 0);
            };
            this.backgroundMc.graphics.clear();
            Render.setStroke(this.backgroundMc.graphics, this.getStrokeStyle());
            Render.beginFill(this.backgroundMc.graphics, this.getFillStyle());
            _loc_2 = this.getCornerRadius();
            _loc_3 = this.getPadding();
            _loc_4 = Math.max(this.getHeight(), (param1.height + (2 * _loc_3)));
            _loc_5 = Math.max(Number(this.options.width), (param1.width + (2 * _loc_3)));
            _loc_6 = param1.getBounds(param1);
            param1.x = (_loc_3 - _loc_6.left);
            param1.y = (_loc_3 - _loc_6.top);
            this.backgroundMc.graphics.moveTo(_loc_2, 0);
            this.backgroundMc.graphics.lineTo((_loc_5 - _loc_2), 0);
            this.backgroundMc.graphics.curveTo(_loc_5, 0, _loc_5, _loc_2);
            this.backgroundMc.graphics.lineTo(_loc_5, (_loc_4 - _loc_2));
            this.backgroundMc.graphics.curveTo(_loc_5, _loc_4, (_loc_5 - _loc_2), _loc_4);
            this.windowFrameSize = new Point(_loc_5, (_loc_4 + this.getTailHeight()));
            if (this.hasTail()){
                _loc_7 = (_loc_5 / 2);
                _loc_8 = this.getTailWidth();
                _loc_9 = this.getTailHeight();
                _loc_10 = this.getTailOffset();
                switch (this.getTailAlign()){
                    case InfoWindowOptions.ALIGN_RIGHT:
                        this.backgroundMc.graphics.lineTo(((_loc_7 + _loc_8) + _loc_10), _loc_4);
                        this.backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        this.backgroundMc.graphics.lineTo((_loc_7 + _loc_10), _loc_4);
                        break;
                    case InfoWindowOptions.ALIGN_LEFT:
                        this.backgroundMc.graphics.lineTo((_loc_7 - _loc_10), _loc_4);
                        this.backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        this.backgroundMc.graphics.lineTo(((_loc_7 - _loc_8) - _loc_10), _loc_4);
                        break;
                    case InfoWindowOptions.ALIGN_CENTER:
                        this.backgroundMc.graphics.lineTo((_loc_7 + (_loc_8 / 2)), _loc_4);
                        this.backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        this.backgroundMc.graphics.lineTo((_loc_7 - (_loc_8 / 2)), _loc_4);
                        break;
                };
            };
            this.backgroundMc.graphics.lineTo(_loc_2, _loc_4);
            this.backgroundMc.graphics.curveTo(0, _loc_4, 0, (_loc_4 - _loc_2));
            this.backgroundMc.graphics.lineTo(0, _loc_2);
            this.backgroundMc.graphics.curveTo(0, 0, _loc_2, 0);
            this.backgroundMc.graphics.endFill();
        }
        private function get mc():Sprite{
            return (super._foreground);
        }
        private function getTailHeight():Number{
            return ((this.options.tailHeight as Number));
        }
        private function fixLayout():Point{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_1 = 0;
            _loc_2 = 0;
            this.options.padding = Math.max((this.options.padding as Number), 0);
            _loc_3 = ((this.getPadding() * 2) + this.closeButtonImage.width);
            _loc_1 = Math.max((this.options.width as Number), _loc_3);
            this.options.width = _loc_1;
            if (this.options.height != null){
                _loc_4 = this.getPadding();
                if (this.hasTitle > 0){
                    _loc_4 = (_loc_4 + this.getPadding());
                };
                if (this.hasContent > 0){
                    _loc_4 = (_loc_4 + this.getPadding());
                };
                _loc_2 = Math.max((this.options.height as Number), _loc_4);
                this.options.height = _loc_2;
            };
            return (new Point(_loc_1, _loc_2));
        }
        private function positionContentAndShadow():void{
            var _loc_1:Point;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            _loc_1 = camera.latLngToViewport(getLatLngClosestToCenter(this._latLng));
            _loc_2 = this.getContentOffset();
            _loc_3 = this.getPointOffset();
            _loc_4 = _loc_1.subtract(_loc_2).add(_loc_3);
            this.mc.x = _loc_4.x;
            this.mc.y = _loc_4.y;
            this.shadowMc.x = _loc_4.x;
            this.shadowMc.y = _loc_4.y;
            if (((this.hasShadow()) && (this.dropShadow))){
                this.dropShadow.positionShadow(_loc_3, camera.shadowMatrix);
            };
        }
        private function getTitle():String{
            return (this.options.title);
        }
        private function closeButtonHandler(event:Event):void{
            map.closeInfoWindow();
        }
        public function getContentOffset():Point{
            var _loc_1:Point;
            if (this.shouldDrawDefaultFrame()){
                _loc_1 = new Point((this.windowFrameSize.x / 2), this.windowFrameSize.y);
            } else {
                _loc_1 = (this.getCustomOffset()) ? this.getCustomOffset() : new Point(0, 0);
            };
            return (_loc_1);
        }
        private function getHtmlTitle():String{
            return (this.options.titleHTML);
        }
        private function createTitle(param1:DisplayObjectContainer, param2:Number):DisplayObject{
            if (this.hasTitle){
                if (!(this.titleField)){
                    this.titleField = this.createTextField();
                    param1.addChild(this.titleField);
                };
                this.titleField.name = "title_txt";
                this.titleField.width = param2;
                this.titleField.autoSize = TextFieldAutoSize.LEFT;
                this.titleField.selectable = true;
                this.titleField.multiline = true;
                this.titleField.wordWrap = true;
                if (this.allowHtmlTitle()){
                    this.titleField.styleSheet = this.getTitleStyleSheet();
                    this.titleField.htmlText = this.getHtmlTitle();
                } else {
                    this.titleField.text = this.getTitle();
                    this.titleField.setTextFormat(this.getTitleFormat());
                };
            } else {
                if (this.titleField){
                    param1.removeChild(this.titleField);
                    this.titleField = null;
                };
            };
            return (this.titleField);
        }
        private function getCornerRadius():Number{
            return ((this.options.cornerRadius as Number));
        }
        private function onOverlayMoved(event:MapEvent):void{
            var _loc_2:IMarker;
            _loc_2 = (this.overlayValue as IMarker);
            if (_loc_2){
                this._latLng = _loc_2.getLatLng();
                this.redraw();
            };
        }
        private function enableCloseButton(param1:EventDispatcher):void{
            if (this.closeEventTarget != param1){
                if (this.closeEventTarget){
                    this.closeEventTarget.removeEventListener(MouseEvent.CLICK, this.closeButtonHandler);
                    this.closeEventTarget = null;
                };
                if (param1){
                    param1.addEventListener(MouseEvent.CLICK, this.closeButtonHandler);
                };
            };
            this.closeEventTarget = param1;
        }
        private function getTailWidth():Number{
            return ((this.options.tailWidth as Number));
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:IMouse;
            if (this.overlayValue){
                this.overlayValue.removeEventListener(MapEvent.OVERLAY_MOVED, this.onOverlayMoved);
            };
            if (this._customContentContainer){
                this._customContentContainer.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.onCustomContentInitialized);
            };
            if (this.dropShadow){
                this.dropShadow.remove();
            };
            this.enableCloseButton(null);
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(this.mc, MouseEvent.MOUSE_DOWN, stopPropagation);
            _loc_1.removeListener(this.mc, MouseEvent.MOUSE_UP, stopPropagation);
            _loc_1.removeListener(this.mc, MouseEvent.MOUSE_MOVE, stopPropagation);
            super.onRemovedFromPane();
        }
        private function get shadowMc():Sprite{
            return (super._shadow);
        }
        private function getContentStyleSheet():StyleSheet{
            return (this.options.contentStyleSheet);
        }
        private function getCustomOffset():Point{
            return (this.options.customOffset);
        }
        private function getPadding():Number{
            return (Math.max((this.options.padding as Number), this.getCornerRadius()));
        }
        private function createContent(param1:DisplayObjectContainer, param2:Number):DisplayObject{
            if (this.hasContent){
                if (!(this.contentField)){
                    this.contentField = this.createTextField();
                    param1.addChild(this.contentField);
                };
                this.contentField.name = "content_txt";
                this.contentField.width = param2;
                this.contentField.autoSize = TextFieldAutoSize.LEFT;
                this.contentField.selectable = true;
                this.contentField.multiline = true;
                this.contentField.wordWrap = true;
                if (this.allowHtmlContent()){
                    this.contentField.styleSheet = this.getContentStyleSheet();
                    this.contentField.htmlText = this.getHtmlContent();
                } else {
                    this.contentField.text = this.getContent();
                    this.contentField.setTextFormat(this.getContentFormat());
                };
            } else {
                if (this.contentField){
                    param1.removeChild(this.contentField);
                    this.contentField = null;
                };
            };
            return (this.contentField);
        }
        public function get initializationPending():Boolean{
            return (((this._customContentContainer) && (!(this._customContentContainer.visible))));
        }
        override public function positionOverlay(param1:Boolean):void{
            this.positionContentAndShadow();
        }
        private function initializeShadow():void{
            if (this.hasShadow()){
                if (!(this.dropShadow)){
                    this.dropShadow = new DropShadow(this.shadowMc);
                };
            } else {
                if (this.dropShadow){
                    this.dropShadow.remove();
                    this.dropShadow = null;
                };
            };
        }
        private function shouldDrawDefaultFrame():Boolean{
            return (((!(this.options.customContent)) || (this.options.drawDefaultFrame)));
        }
        public function get hasTitle():Boolean{
            return (((((this.options.titleHTML) && ((this.options.titleHTML.length > 0)))) || (((this.options.title) && ((this.options.title.length > 0))))));
        }
        private function onCustomContentInitialized(event:Event):void{
            event.target.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.onCustomContentInitialized);
            this.redraw();
            dispatchEvent(event);
        }
        override protected function redraw():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:DisplayObject;
            if (isHidden()){
                return;
            };
            _loc_1 = Bootstrap.getSpriteFactory();
            _loc_2 = (this._currentCustomContent) ? this._currentCustomContent : this._defaultContent;
            if (this.getCustomContent()){
                this._customContentContainer = ((_loc_1.version >= 2)) ? _loc_1.createComponentContainer(this.getCustomContent()).getSprite() : null;
                this._currentCustomContent = (this._customContentContainer) ? this._customContentContainer : this.getCustomContent();
            } else {
                this._currentCustomContent = this.createDefaultContent();
            };
            if (_loc_2 != this._currentCustomContent){
                if (_loc_2){
                    _loc_1.removeChild(this.mc, _loc_2);
                };
                if (this._currentCustomContent){
                    _loc_1.addChild(this.mc, this._currentCustomContent);
                };
            };
            if (this.shouldDrawDefaultFrame()){
                this.fixLayout();
                this.displayBackground(this._currentCustomContent);
            } else {
                this._currentCustomContent.x = 0;
                this._currentCustomContent.y = 0;
            };
            this.displayCloseButton();
            if (((this.dropShadow) && (this.hasShadow()))){
                if (((!(this.dropShadow.draw(this.mc))) && (this.shouldDrawDefaultFrame()))){
                    _loc_1.removeChild(this.mc, this._currentCustomContent);
                    this.dropShadow.draw(this.mc);
                    _loc_1.addChild(this.mc, this._currentCustomContent);
                };
            };
            this.positionContentAndShadow();
        }
        public function getViewportBounds():Rectangle{
            var _loc_1:Rectangle;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:DisplayObject;
            if (!(this.shouldDrawDefaultFrame())){
                _loc_5 = this.getCustomContent();
                _loc_1 = _loc_5.getBounds(this.mc);
            } else {
                _loc_1 = new Rectangle(0, 0, this.windowFrameSize.x, this.windowFrameSize.y);
            };
            _loc_2 = camera.latLngToViewport(getLatLngClosestToCenter(this._latLng));
            _loc_3 = this.getContentOffset();
            _loc_4 = this.getPointOffset();
            _loc_1.offset(((_loc_2.x - _loc_3.x) + _loc_4.x), ((_loc_2.y - _loc_3.y) + _loc_4.y));
            return (_loc_1);
        }
        private function getTailOffset():Number{
            return ((this.options.tailOffset as Number));
        }

    }
}//package com.mapplus.maps.window 
