//Created by yuxueli 2011.6.6
package com.mapplus.maps.window {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;

    public class InfoWindow extends Overlay implements IInfoWindow {
		[Embed(source="/assets/images/InfoWindow_CloseImage.png")]
        private static const CloseImage:Class ;//= InfoWindow_CloseImage;

        private static var defaultOptions:InfoWindowOptions = createInitialDefaultOptions();

        private var closeButtonMc:Sprite;
        private var overlayValue:IOverlay;
        private var contentField:TextField;
        private var titleField:TextField;
        private var _defaultContent:Sprite;
        private var options:InfoWindowOptions;
        private var _latLng:LatLng;
        private var _contentAutoSize:String;
        private var closeButtonImage:DisplayObject;
        private var closeEventTarget:EventDispatcher;
        private var _currentCustomContent:DisplayObject;
        private var _customContentContainer:DisplayObject;
        private var backgroundMc:Sprite;
        private var dropShadow:DropShadow;
        private var windowFrameSize:Point;

        public function InfoWindow(param1:LatLng, param2:IOverlay, param3:InfoWindowOptions=null){
            super(FLAG_HASSHADOW);
            this._latLng = param1;
            overlayValue = param2;
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
            return (_latLng);
        }
        override protected function redraw():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:DisplayObject;
            if (isHidden()){
                return;
            };
            _loc_1 = Bootstrap.getSpriteFactory();
            _loc_2 = (_currentCustomContent) ? _currentCustomContent : _defaultContent;
            if (getCustomContent()){
                _customContentContainer = ((_loc_1.version >= 2)) ? _loc_1.createComponentContainer(getCustomContent()).getSprite() : null;
                _currentCustomContent = (_customContentContainer) ? _customContentContainer : getCustomContent();
            } else {
                _currentCustomContent = createDefaultContent();
            };
            if (_loc_2 != _currentCustomContent){
                if (_loc_2){
                    _loc_1.removeChild(mc, _loc_2);
                };
                if (_currentCustomContent){
                    _loc_1.addChild(mc, _currentCustomContent);
                };
            };
            if (shouldDrawDefaultFrame()){
                fixLayout();
                displayBackground(_currentCustomContent);
            } else {
                _currentCustomContent.x = 0;
                _currentCustomContent.y = 0;
            };
            displayCloseButton();
            if (((dropShadow) && (hasShadow()))){
                if (((!(dropShadow.draw(mc))) && (shouldDrawDefaultFrame()))){
                    _loc_1.removeChild(mc, _currentCustomContent);
                    dropShadow.draw(mc);
                    _loc_1.addChild(mc, _currentCustomContent);
                };
            };
            positionContentAndShadow();
        }
        private function hasTail():Boolean{
            return ((options.hasTail as Boolean));
        }
        private function getPointOffset():Point{
            return ((options.pointOffset) ? options.pointOffset : new Point(0, 0));
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
            if (!backgroundMc){
                backgroundMc = new Sprite();
                backgroundMc.name = "bg_mc";
                mc.addChildAt(backgroundMc, 0);
            };
            backgroundMc.graphics.clear();
            Render.setStroke(backgroundMc.graphics, getStrokeStyle());
            Render.beginFill(backgroundMc.graphics, getFillStyle());
            _loc_2 = getCornerRadius();
            _loc_3 = getPadding();
            _loc_4 = Math.max(getHeight(), (param1.height + (2 * _loc_3)));
            _loc_5 = Math.max(Number(options.width), (param1.width + (2 * _loc_3)));
            _loc_6 = param1.getBounds(param1);
            param1.x = (_loc_3 - _loc_6.left);
            param1.y = (_loc_3 - _loc_6.top);
            backgroundMc.graphics.moveTo(_loc_2, 0);
            backgroundMc.graphics.lineTo((_loc_5 - _loc_2), 0);
            backgroundMc.graphics.curveTo(_loc_5, 0, _loc_5, _loc_2);
            backgroundMc.graphics.lineTo(_loc_5, (_loc_4 - _loc_2));
            backgroundMc.graphics.curveTo(_loc_5, _loc_4, (_loc_5 - _loc_2), _loc_4);
            windowFrameSize = new Point(_loc_5, (_loc_4 + getTailHeight()));
            if (hasTail()){
                _loc_7 = (_loc_5 / 2);
                _loc_8 = getTailWidth();
                _loc_9 = getTailHeight();
                _loc_10 = getTailOffset();
                switch (getTailAlign()){
                    case InfoWindowOptions.ALIGN_RIGHT:
                        backgroundMc.graphics.lineTo(((_loc_7 + _loc_8) + _loc_10), _loc_4);
                        backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        backgroundMc.graphics.lineTo((_loc_7 + _loc_10), _loc_4);
                        break;
                    case InfoWindowOptions.ALIGN_LEFT:
                        backgroundMc.graphics.lineTo((_loc_7 - _loc_10), _loc_4);
                        backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        backgroundMc.graphics.lineTo(((_loc_7 - _loc_8) - _loc_10), _loc_4);
                        break;
                    case InfoWindowOptions.ALIGN_CENTER:
                        backgroundMc.graphics.lineTo((_loc_7 + (_loc_8 / 2)), _loc_4);
                        backgroundMc.graphics.lineTo(_loc_7, (_loc_4 + _loc_9));
                        backgroundMc.graphics.lineTo((_loc_7 - (_loc_8 / 2)), _loc_4);
                        break;
                };
            };
            backgroundMc.graphics.lineTo(_loc_2, _loc_4);
            backgroundMc.graphics.curveTo(0, _loc_4, 0, (_loc_4 - _loc_2));
            backgroundMc.graphics.lineTo(0, _loc_2);
            backgroundMc.graphics.curveTo(0, 0, _loc_2, 0);
            backgroundMc.graphics.endFill();
        }
        public function updatePosition():void{
            redraw();
        }
        override public function getDefaultPane(param1:IMap):IPane{
            if (overlayValue){
                return (overlayValue.pane);
            };
            return (IMapBase2(param1).getPane(PaneId.PANE_FLOAT));
        }
        private function createDefaultContent():DisplayObject{
            var _loc_1:ISpriteFactory;
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:DisplayObject;
            var _loc_6:DisplayObject;
            _loc_1 = Bootstrap.getSpriteFactory();
            if (!_defaultContent){
                _defaultContent = _loc_1.createSprite().getSprite();
            };
            _loc_2 = fixLayout();
            _loc_3 = (_loc_2.x - (2 * getPadding()));
            _loc_4 = 0;
            _loc_5 = createTitle(_defaultContent, _loc_3);
            if (_loc_5){
                _loc_5.x = 0;
                _loc_5.y = _loc_4;
                _loc_4 = (_loc_4 + (_loc_5.height + getPadding()));
            };
            _loc_6 = createContent(_defaultContent, _loc_3);
            if (_loc_6){
                _loc_6.x = 0;
                _loc_6.y = _loc_4;
            };
            return (_defaultContent);
        }
        private function get mc():Sprite{
            return (super._foreground);
        }
        private function getHtmlContent():String{
            return (options.contentHTML);
        }
        private function getCustomContent():DisplayObject{
            return (options.customContent);
        }
        private function getContentFormat():TextFormat{
            return (options.contentFormat);
        }
        private function getTailHeight():Number{
            return ((options.tailHeight as Number));
        }
        private function getHeight():Number{
            return ((options.height as Number));
        }
        private function fixLayout():Point{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_1 = 0;
            _loc_2 = 0;
            options.padding = Math.max((options.padding as Number), 0);
            _loc_3 = ((getPadding() * 2) + closeButtonImage.width);
            _loc_1 = Math.max((options.width as Number), _loc_3);
            options.width = _loc_1;
            if (options.height != null){
                _loc_4 = getPadding();
                if (hasTitle > 0){
                    _loc_4 = (_loc_4 + getPadding());
                };
                if (hasContent > 0){
                    _loc_4 = (_loc_4 + getPadding());
                };
                _loc_2 = Math.max((options.height as Number), _loc_4);
                options.height = _loc_2;
            };
            return (new Point(_loc_1, _loc_2));
        }
        override public function get interfaceChain():Array{
            return (["IInfoWindow", "IOverlay"]);
        }
        private function getStrokeStyle():StrokeStyle{
            return (options.strokeStyle);
        }
        private function allowHtmlTitle():Boolean{
            return (!((options.titleHTML == null)));
        }
        private function positionContentAndShadow():void{
            var _loc_1:Point;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            _loc_1 = camera.latLngToViewport(getLatLngClosestToCenter(_latLng));
            _loc_2 = getContentOffset();
            _loc_3 = getPointOffset();
            _loc_4 = _loc_1.subtract(_loc_2).add(_loc_3);
            mc.x = _loc_4.x;
            mc.y = _loc_4.y;
            shadowMc.x = _loc_4.x;
            shadowMc.y = _loc_4.y;
            if (((hasShadow()) && (dropShadow))){
                dropShadow.positionShadow(_loc_3, camera.shadowMatrix);
            };
        }
        private function displayCloseButton():void{
            var _loc_1:EventDispatcher;
            var _loc_2:Boolean;
            var _loc_3:Rectangle;
            _loc_1 = null;
            _loc_2 = false;
            if (hasCloseButton()){
                _loc_3 = calculateCloseRect();
                if (_loc_3){
                    if (!closeButtonMc){
                        closeButtonMc = new Sprite();
                        closeButtonMc.useHandCursor = true;
                        closeButtonMc.buttonMode = true;
                        closeButtonMc.addChild(closeButtonImage);
                        mc.addChild(closeButtonMc);
                    };
                    closeButtonMc.x = _loc_3.left;
                    closeButtonMc.y = _loc_3.top;
                    closeButtonMc.width = _loc_3.width;
                    closeButtonMc.height = _loc_3.height;
                    closeButtonMc.alpha = (shouldDrawDefaultFrame()) ? 1 : 0;
                    _loc_1 = closeButtonMc;
                    _loc_2 = true;
                } else {
                    _loc_1 = mc;
                    _loc_1 = mc;
                };
            };
            if (!_loc_2){
                if (closeButtonMc){
                    mc.removeChild(closeButtonMc);
                    closeButtonMc.removeChild(closeButtonImage);
                };
            };
            enableCloseButton(_loc_1);
        }
        private function getTitle():String{
            return (options.title);
        }
        private function closeButtonHandler(event:Event):void{
            map.closeInfoWindow();
        }
        private function calculateCloseRect():Rectangle{
            var _loc_1:Rectangle;
            _loc_1 = getCustomCloseRect();
            if (_loc_1){
                return (_loc_1);
            };
            if (shouldDrawDefaultFrame()){
                return (new Rectangle(((windowFrameSize.x - closeButtonImage.width) - getPadding()), getPadding(), closeButtonImage.width, closeButtonImage.height));
            };
            return (null);
        }
        private function getHtmlTitle():String{
            return (options.titleHTML);
        }
        private function getTitleFormat():TextFormat{
            return (options.titleFormat);
        }
        public function getContentOffset():Point{
            var _loc_1:Point;
            if (shouldDrawDefaultFrame()){
                _loc_1 = new Point((windowFrameSize.x / 2), windowFrameSize.y);
            } else {
                _loc_1 = (getCustomOffset()) ? getCustomOffset() : new Point(0, 0);
            };
            return (_loc_1);
        }
        private function getFillStyle():FillStyle{
            return (options.fillStyle);
        }
        private function createTextField():TextField{
            var _loc_1:IClientFactory;
            _loc_1 = Bootstrap.getBootstrap().getClientFactory();
            if (_loc_1){
                return (_loc_1.createTextField());
            };
            return (new TextField());
        }
        private function getContent():String{
            return (options.content);
        }
        override protected function onAddedToPane():void{
            var _loc_1:IMouse;
            super.onAddedToPane();
            closeButtonImage = new CloseImage();
            initializeShadow();
            redraw();
            _loc_1 = MouseHandler.instance();
            _loc_1.addListener(mc, MouseEvent.MOUSE_DOWN, stopPropagation);
            _loc_1.addListener(mc, MouseEvent.MOUSE_UP, stopPropagation);
            _loc_1.addListener(mc, MouseEvent.MOUSE_MOVE, stopPropagation);
            if (initializationPending){
                _customContentContainer.addEventListener(MapEvent.COMPONENT_INITIALIZED, onCustomContentInitialized);
            };
            if (overlayValue){
                overlayValue.addEventListener(MapEvent.OVERLAY_MOVED, onOverlayMoved);
            };
        }
        private function allowHtmlContent():Boolean{
            return (!((options.contentHTML == null)));
        }
        private function enableCloseButton(param1:EventDispatcher):void{
            if (closeEventTarget != param1){
                if (closeEventTarget){
                    closeEventTarget.removeEventListener(MouseEvent.CLICK, closeButtonHandler);
                    closeEventTarget = null;
                };
                if (param1){
                    param1.addEventListener(MouseEvent.CLICK, closeButtonHandler);
                };
            };
            closeEventTarget = param1;
        }
        private function onOverlayMoved(event:MapEvent):void{
            var _loc_2:IMarker;
            _loc_2 = (overlayValue as IMarker);
            if (_loc_2){
                _latLng = _loc_2.getLatLng();
                redraw();
            };
        }
        private function createTitle(param1:DisplayObjectContainer, param2:Number):DisplayObject{
            if (hasTitle){
                if (!titleField){
                    titleField = createTextField();
                    param1.addChild(titleField);
                };
                titleField.name = "title_txt";
                titleField.width = param2;
                titleField.autoSize = TextFieldAutoSize.LEFT;
                titleField.selectable = true;
                titleField.multiline = true;
                titleField.wordWrap = true;
                if (allowHtmlTitle()){
                    titleField.styleSheet = getTitleStyleSheet();
                    titleField.htmlText = getHtmlTitle();
                } else {
                    titleField.text = getTitle();
                    titleField.setTextFormat(getTitleFormat());
                };
            } else {
                if (titleField){
                    param1.removeChild(titleField);
                    titleField = null;
                };
            };
            return (titleField);
        }
        private function getCornerRadius():Number{
            return ((options.cornerRadius as Number));
        }
        private function getTailWidth():Number{
            return ((options.tailWidth as Number));
        }
        private function hasCloseButton():Boolean{
            if (options.hasCloseButton == null){
                if (shouldDrawDefaultFrame()){
                    return (true);
                };
                return (!((options.customCloseRect == null)));
            };
            return ((options.hasCloseButton as Boolean));
        }
        private function getContentStyleSheet():StyleSheet{
            return (options.contentStyleSheet);
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:IMouse;
            if (overlayValue){
                overlayValue.removeEventListener(MapEvent.OVERLAY_MOVED, onOverlayMoved);
            };
            if (_customContentContainer){
                _customContentContainer.removeEventListener(MapEvent.COMPONENT_INITIALIZED, onCustomContentInitialized);
            };
            if (dropShadow){
                dropShadow.remove();
            };
            enableCloseButton(null);
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(mc, MouseEvent.MOUSE_DOWN, stopPropagation);
            _loc_1.removeListener(mc, MouseEvent.MOUSE_UP, stopPropagation);
            _loc_1.removeListener(mc, MouseEvent.MOUSE_MOVE, stopPropagation);
            super.onRemovedFromPane();
        }
        private function getCustomCloseRect():Rectangle{
            return (options.customCloseRect);
        }
        private function get shadowMc():Sprite{
            return (super._shadow);
        }
        public function get initializationPending():Boolean{
            return (((_customContentContainer) && (!(_customContentContainer.visible))));
        }
        private function hasShadow():Boolean{
            return ((options.hasShadow as Boolean));
        }
        private function getPadding():Number{
            return (Math.max((options.padding as Number), getCornerRadius()));
        }
        private function createContent(param1:DisplayObjectContainer, param2:Number):DisplayObject{
            if (hasContent){
                if (!contentField){
                    contentField = createTextField();
                    param1.addChild(contentField);
                };
                contentField.name = "content_txt";
                contentField.width = param2;
                contentField.autoSize = TextFieldAutoSize.LEFT;
                contentField.selectable = true;
                contentField.multiline = true;
                contentField.wordWrap = true;
                if (allowHtmlContent()){
                    contentField.styleSheet = getContentStyleSheet();
                    contentField.htmlText = getHtmlContent();
                } else {
                    contentField.text = getContent();
                    contentField.setTextFormat(getContentFormat());
                };
            } else {
                if (contentField){
                    param1.removeChild(contentField);
                    contentField = null;
                };
            };
            return (contentField);
        }
        private function getTailAlign():Number{
            return ((options.tailAlign as Number));
        }
        public function get removed():Boolean{
            return ((pane == null));
        }
        private function getCustomOffset():Point{
            return (options.customOffset);
        }
        private function shouldDrawDefaultFrame():Boolean{
            return (((!(options.customContent)) || (options.drawDefaultFrame)));
        }
        public function get hasTitle():Boolean{
            return (((((options.titleHTML) && ((options.titleHTML.length > 0)))) || (((options.title) && ((options.title.length > 0))))));
        }
        private function initializeShadow():void{
            if (hasShadow()){
                if (!dropShadow){
                    dropShadow = new DropShadow(shadowMc);
                };
            } else {
                if (dropShadow){
                    dropShadow.remove();
                    dropShadow = null;
                };
            };
        }
        private function onCustomContentInitialized(event:Event):void{
            event.target.removeEventListener(MapEvent.COMPONENT_INITIALIZED, onCustomContentInitialized);
            redraw();
            dispatchEvent(event);
        }
        override public function positionOverlay(param1:Boolean):void{
            positionContentAndShadow();
        }
        public function getViewportBounds():Rectangle{
            var _loc_1:Rectangle;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:DisplayObject;
            if (!shouldDrawDefaultFrame()){
                _loc_5 = getCustomContent();
                _loc_1 = _loc_5.getBounds(mc);
            } else {
                _loc_1 = new Rectangle(0, 0, windowFrameSize.x, windowFrameSize.y);
            };
            _loc_2 = camera.latLngToViewport(getLatLngClosestToCenter(_latLng));
            _loc_3 = getContentOffset();
            _loc_4 = getPointOffset();
            _loc_1.offset(((_loc_2.x - _loc_3.x) + _loc_4.x), ((_loc_2.y - _loc_3.y) + _loc_4.y));
            return (_loc_1);
        }
        private function getTitleStyleSheet():StyleSheet{
            return (options.titleStyleSheet);
        }
        private function getTailOffset():Number{
            return ((options.tailOffset as Number));
        }
        public function get hasContent():Boolean{
            return (((((options.contentHTML) && ((options.contentHTML.length > 0)))) || (((options.content) && ((options.content.length > 0))))));
        }

    }
}//package com.mapplus.maps.window 
