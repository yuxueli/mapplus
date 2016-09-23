//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;

    public class Marker extends Overlay implements IMarker, IDepthSortable {

        private static const ANIMATE_MAX_HEIGHT:Number = 13;
        private static const RIGHT:Number = 2;
        private static const TOP:Number = 0;
        private static const LEFT:Number = 0;
        private static const BOTTOM:Number = 32;
        private static const MIDDLE:Number = 16;
        private static const CENTER:Number = 1;
        private static const TAIL_HEIGHT:Number = 1.5;
        private static const VERTICAL_MASK:Number = 48;
        private static const HORIZONTAL_MASK:Number = 3;

        private static var defaultOptions:MarkerOptions = new MarkerOptions({
            strokeStyle:{
                thickness:2,
                alpha:1,
                color:Color.BLACK,
                pixelHinting:false
            },
            fillStyle:{
                color:16741994,
                alpha:1
            },
            labelFormat:{
                font:"_sans",
                size:12,
                color:Color.BLACK
            },
            gravity:0.8,
            radius:9,
            hasShadow:true,
            draggable:false,
            distanceScaling:false
        });

        private var _dragOffset:Point;
        private var currentIcon:CustomContent;
        private var options:MarkerOptions;
        private var _latLng:LatLng;
        private var labelMc:TextField;
        private var crossSprite:Sprite;
        public var infoWindow:IInfoWindow;
        private var currentIconShadow:CustomContent;
        private var _dragged:Boolean;
        private var animateVelocity:Number;
        private var animator:Animator;
        private var animateHeight:Number;
        private var markerMc:Sprite;
        private var dropShadow:DropShadow;

        public function Marker(param1:LatLng, param2:MarkerOptions=null){
            super(Overlay.FLAG_HASSHADOW);
            currentIcon = new CustomContent();
            currentIconShadow = new CustomContent();
            this.options = MarkerOptions.merge([Marker.getDefaultOptions(), param2]);
            this._latLng = param1.clone();
            markerMc = Bootstrap.createChildComponent(mc);
            updateButtonMode();
        }
        public static function setDefaultOptions(param1:MarkerOptions):void{
            if (param1.icon){
                throw (new Error("Default options cannot include a custom icon"));
            };
            Marker.defaultOptions = MarkerOptions.merge([Marker.defaultOptions, param1]);
        }
        public static function getDefaultOptions():MarkerOptions{
            return (Marker.defaultOptions);
        }

        public function getOptions():MarkerOptions{
            return (options);
        }
        private function removeCrossSprite():void{
            if (crossSprite){
                mc.removeChild(crossSprite);
                crossSprite = null;
            };
        }
        private function isDraggable():Boolean{
            return ((options.draggable as Boolean));
        }
        override protected function onOverlayMouseDown(event:MouseEvent):void{
            var _loc_2:IMouse;
            var _loc_3:Point;
            var _loc_4:Point;
            super.onOverlayMouseDown(event);
            event.stopPropagation();
            _loc_2 = MouseHandler.instance();
            _loc_2.addGlobalMouseUpListener(onMouseUp);
            if (isDraggable()){
                _loc_3 = camera.latLngToViewport(_latLng);
                _loc_4 = new Point(event.stageX, event.stageY);
                _dragOffset = _loc_4.subtract(_loc_3);
                _dragged = false;
                _loc_2.addGlobalMouseMoveListener(onMouseMove);
            };
            dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_DOWN);
        }
        override public function get interfaceChain():Array{
            return (["IMarker", "IOverlay"]);
        }
        override public function positionOverlay(param1:Boolean):void{
            positionMarker();
        }
        private function endAnimation():void{
            removeCrossSprite();
            dispatchEvent(new MapEvent(MapEvent.OVERLAY_ANIMATE_END, this));
        }
        private function renderStandardMarker():void{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            var _loc_5:TextFormat;
            _loc_1 = getRadius();
            Render.setStroke(markerMc.graphics, getStrokeStyle());
            Render.beginFill(markerMc.graphics, getFillStyle());
            _loc_2 = ((Math.SQRT2 - 1) * _loc_1);
            _loc_3 = (Math.SQRT1_2 * _loc_1);
            markerMc.graphics.moveTo(0, -(_loc_1));
            markerMc.graphics.curveTo(_loc_2, -(_loc_1), _loc_3, -(_loc_3));
            markerMc.graphics.curveTo(_loc_1, -(_loc_2), _loc_1, 0);
            markerMc.graphics.curveTo(_loc_1, _loc_2, _loc_3, _loc_3);
            markerMc.graphics.curveTo(0, (_loc_1 * TAIL_HEIGHT), 0, (_loc_1 * (1 + TAIL_HEIGHT)));
            markerMc.graphics.curveTo(0, (_loc_1 * TAIL_HEIGHT), -(_loc_3), _loc_3);
            markerMc.graphics.curveTo(-(_loc_1), _loc_2, -(_loc_1), 0);
            markerMc.graphics.curveTo(-(_loc_1), -(_loc_2), -(_loc_3), -(_loc_3));
            markerMc.graphics.curveTo(-(_loc_2), -(_loc_1), 0, -(_loc_1));
            markerMc.graphics.endFill();
            _loc_4 = getLabel();
            if (_loc_4){
                if (!labelMc){
                    labelMc = new TextField();
                    labelMc.autoSize = TextFieldAutoSize.LEFT;
                    labelMc.selectable = false;
                    labelMc.border = false;
                    labelMc.embedFonts = false;
                    labelMc.mouseEnabled = false;
                    markerMc.addChild(labelMc);
                };
                labelMc.width = _loc_1;
                labelMc.height = _loc_1;
                labelMc.text = _loc_4;
                labelMc.x = (-(labelMc.width) * 0.5);
                labelMc.y = (-(labelMc.height) * 0.5);
                _loc_5 = getLabelFormat();
                if (_loc_5){
                    labelMc.setTextFormat(_loc_5);
                };
            } else {
                if (labelMc){
                    markerMc.removeChild(labelMc);
                    labelMc = null;
                };
            };
        }
        override public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_MARKER));
        }
        private function get mc():Sprite{
            return (super._foreground);
        }
        public function setLatLng(param1:LatLng):void{
            _latLng = param1;
            redraw();
            dispatchEvent(new MapEvent(MapEvent.OVERLAY_MOVED, this));
        }
        private function getGravity():Number{
            return ((options.gravity as Number));
        }
        private function isDragging():Boolean{
            return (!((_dragOffset == null)));
        }
        private function get shadowMc():Sprite{
            return (super._shadow);
        }
        private function getStrokeStyle():StrokeStyle{
            return (options.strokeStyle);
        }
        public function get height():Number{
            return (markerMc.height);
        }
        public function openInfoWindow(param1:InfoWindowOptions=null, param2:Boolean=false):IInfoWindow{
            var _loc_3:IPaneManagerInternal;
            var _loc_4:DisplayObject;
            var _loc_5:Point;
            var _loc_6:Rectangle;
            if (((!(map)) || (!(visible)))){
                return (null);
            };
            if (!param1){
                param1 = new InfoWindowOptions();
            };
            if (!param1.pointOffset){
                _loc_4 = getIcon();
                if (_loc_4){
                    _loc_5 = getContentOffset();
                    _loc_6 = _loc_4.getBounds(_loc_4);
                    param1.pointOffset = new Point((_loc_5.x + (_loc_6.width / 2)), _loc_5.y);
                } else {
                    param1.pointOffset = new Point(0, -(((getRadius() * (2 + TAIL_HEIGHT)) + 2)));
                };
            };
            map.addEventListener(MapEvent.INFOWINDOW_CLOSED, onInfoWindowClosed);
            map.addEventListener(MapEvent.INFOWINDOW_CLOSING, onInfoWindowClosing);
            Pane(pane).lock();
            if (!param2){
                infoWindow = map.openInfoWindowOnOverlay(_latLng, this, param1);
            } else {
                infoWindow = map.openInfoWindow(_latLng, param1);
            };
            _loc_3 = (pane.paneManager as IPaneManagerInternal);
            if (_loc_3){
                _loc_3.placePaneShadow(infoWindow.pane, pane);
            };
            Pane(pane).unlock();
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_OPENED, infoWindow));
            return (infoWindow);
        }
        public function getLatLng():LatLng{
            return (_latLng);
        }
        private function setAnimateHeight(param1:Number):void{
            animateHeight = Util.bound(param1, 0, ANIMATE_MAX_HEIGHT);
        }
        private function onCurrentIconReady(param1:Boolean):void{
            positionMarker();
        }
        override protected function onOverlayMouseMove(event:MouseEvent):void{
            super.onOverlayMouseMove(event);
            dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_MOVE);
        }
        private function getRadius():Number{
            return ((options.radius as Number));
        }
        private function updateButtonMode():void{
            var _loc_1:Boolean;
            _loc_1 = isClickable();
            markerMc.useHandCursor = _loc_1;
            markerMc.buttonMode = _loc_1;
        }
        override protected function onOverlayMouseOver(event:MouseEvent):void{
            var _loc_2:String;
            super.onOverlayMouseOver(event);
            if (!isDragging()){
                _loc_2 = getTooltip();
                if (((_loc_2) && ((_loc_2.length > 0)))){
                    map.displayHint(_loc_2);
                };
                if (map.overlayRaising){
                    pane.bringToTop(this);
                };
            };
            dispatchMarkerMouseEvent(event, MapMouseEvent.ROLL_OVER);
        }
        private function getFillStyle():FillStyle{
            return (options.fillStyle);
        }
        override protected function onOverlayClick(event:MouseEvent):void{
            super.onOverlayClick(event);
            if (((isClickValid) && (isClickable()))){
                dispatchMarkerMouseEvent(event, MapMouseEvent.CLICK);
                if (_timedDoubleClick.clickReturnTrueIfDoubleClick()){
                    dispatchMarkerMouseEvent(event, MapMouseEvent.DOUBLE_CLICK);
                };
            };
        }
        private function initFloat():void{
            impulseToHeight(ANIMATE_MAX_HEIGHT);
        }
        public function getContentOffset():Point{
            var _loc_1:Point;
            var _loc_2:Rectangle;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            _loc_1 = new Point(0, 0);
            switch ((_loc_3 & HORIZONTAL_MASK)){
                case LEFT:
                    break;
                case RIGHT:
                    break;
                case CENTER:
                    break;
            };
            switch ((_loc_3 & VERTICAL_MASK)){
                case TOP:
                    break;
                case BOTTOM:
                    break;
                case MIDDLE:
                    break;
            };
            if (_loc_4){
            };
            return (_loc_1);
        }
        private function SetDropShadowState(param1:Boolean):void{
            if (param1){
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
        private function onMouseUp(param1:Boolean, param2:MouseEvent):void{
            var mouse:* = null;
            var hasBounced:* = false;
            var param1:* = param1;
            var param2:* = param2;
            var isReceived:* = param1;
            var event:* = param2;
            if (isDragging()){
                _dragOffset = null;
                mouse = MouseHandler.instance();
                mouse.removeGlobalMouseMoveListener(onMouseMove);
                mouse.removeGlobalMouseUpListener(onMouseUp);
                positionMarker();
                if (_dragged){
                    _dragged = false;
                    animator.run(function ():Boolean{
                        doPhysicalStep();
                        positionMarker();
                        if (animateHeight <= 0){
                            if (hasBounced){
                                return (false);
                            };
                            impulseToHeight((ANIMATE_MAX_HEIGHT * 0.5));
                            hasBounced = true;
                        };
                        return (true);
                    }, endAnimation);
                    dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_END);
                    dispatchEvent(new MapEvent(MapEvent.OVERLAY_MOVED, this));
                };
            };
            dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_UP);
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            animateVelocity = 0;
            animateHeight = 0;
            animator = new Animator();
            _dragOffset = null;
            _dragged = false;
            configureShadow(hasShadow());
            redraw();
        }
        private function getLabel():String{
            return (options.label);
        }
        public function get width():Number{
            return (markerMc.width);
        }
        private function configureShadow(param1:Boolean):void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            SetDropShadowState(((param1) && (!(getIconShadow()))));
        }
        private function onInfoWindowClosed(event:Event):void{
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSED, onInfoWindowClosed);
            infoWindow = null;
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSED, Object(event).feature));
        }
        override protected function redraw():void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            renderMarker();
            positionMarker();
        }
        private function getIconAlignment():Number{
            return ((options.iconAlignment as Number));
        }
        private function getTooltip():String{
            return (options.tooltip);
        }
        private function getLabelFormat():TextFormat{
            return (options.labelFormat);
        }
        public function closeInfoWindow():void{
            if (infoWindow){
                map.closeInfoWindow();
            };
        }
        private function isClickable():Boolean{
            return ((((options.clickable == null)) || ((options.clickable as Boolean))));
        }
        private function distanceScaling():Boolean{
            return (options.distanceScaling);
        }
        private function hasShadow():Boolean{
            return ((options.hasShadow as Boolean));
        }
        private function positionMarker():void{
            var _loc_1:LatLng;
            var _loc_2:Number = NaN;
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Point;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            if (((!(map)) || (!(visible)))){
                return;
            };
            if (currentIcon.pending){
                currentIcon.callback = onCurrentIconReady;
                return;
            };
            if (currentIconShadow.pending){
                currentIconShadow.callback = onCurrentIconReady;
            };
            _loc_1 = getLatLngClosestToCenter(_latLng);
            if (camera.isAhead(_loc_1)){
                markerMc.visible = true;
                _loc_2 = 1;
                if (distanceScaling()){
                    _loc_8 = camera.latLngToWorld(_loc_1);
                    _loc_3 = camera.worldToViewport(_loc_8);
                    _loc_9 = camera.worldDistance(_loc_8);
                    _loc_10 = camera.worldDistance(camera.getWorldCenter());
                    _loc_2 = (_loc_10 / _loc_9);
                } else {
                    _loc_3 = camera.latLngToViewport(_loc_1);
                };
                if (crossSprite){
                    crossSprite.x = _loc_3.x;
                    crossSprite.y = _loc_3.y;
                };
                _loc_4 = getContentOffset();
                _loc_5 = new Point(0, -(animateHeight));
                _loc_6 = (_loc_3.x + (_loc_2 * (_loc_4.x + _loc_5.x)));
                _loc_7 = (_loc_3.y + (_loc_2 * (_loc_4.y + _loc_5.y)));
                markerMc.x = _loc_6;
                markerMc.y = _loc_7;
                markerMc.scaleX = _loc_2;
                markerMc.scaleY = _loc_2;
                if (shadowMc){
                    shadowMc.visible = true;
                    shadowMc.x = _loc_6;
                    shadowMc.y = _loc_7;
                    shadowMc.scaleX = _loc_2;
                    shadowMc.scaleY = _loc_2;
                };
                if (hasShadow()){
                    if (dropShadow){
                        dropShadow.positionShadow(_loc_5, camera.shadowMatrix);
                    };
                    if (currentIconShadow.displayObject){
                        DropShadow.positionShadowObject(currentIconShadow.displayObject, _loc_5, camera.shadowMatrix);
                    };
                };
            } else {
                markerMc.visible = false;
                if (shadowMc){
                    shadowMc.visible = false;
                };
            };
        }
        public function setOptions(param1:MarkerOptions):void{
            options = MarkerOptions.merge([options, param1]);
            updateButtonMode();
            configureShadow(hasShadow());
            redraw();
        }
        private function getIconOffset():Point{
            return (options.iconOffset);
        }
        private function dispatchMarkerMouseEvent(event:MouseEvent, param2:String):void{
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, param2, this, _latLng));
        }
        private function impulseToHeight(param1:Number):void{
            var _loc_2:Number = NaN;
            _loc_2 = (param1 - animateHeight);
            animateVelocity = Math.ceil(Math.sqrt(((2 * getGravity()) * _loc_2)));
        }
        private function doPhysicalStep():void{
            animateVelocity = (animateVelocity - getGravity());
            setAnimateHeight((animateHeight + animateVelocity));
        }
        private function getIcon():DisplayObject{
            return (options.icon);
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:IMouse;
            _loc_1 = Bootstrap.getSpriteFactory();
            if (currentIcon.displayObject){
                _loc_1.removeChild(markerMc, currentIcon.displayObject);
                currentIcon.content = null;
            };
            if (currentIconShadow.displayObject){
                _loc_1.removeChild(shadowMc, currentIconShadow.displayObject);
                shadowMc.filters = [];
                currentIconShadow.content = null;
            };
            configureShadow(false);
            _loc_2 = MouseHandler.instance();
            _loc_2.removeGlobalMouseUpListener(onMouseUp);
            _loc_2.removeGlobalMouseMoveListener(onMouseMove);
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSED, onInfoWindowClosed);
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSING, onInfoWindowClosing);
            if (animator){
                animator.stop();
                animator = null;
            };
            super.onRemovedFromPane();
        }
        private function getIconShadow():DisplayObject{
            return (options.iconShadow);
        }
        private function onMouseMove(param1:Boolean, param2:MouseEvent):void{
            var mouseCoord:* = null;
            var pt:* = null;
            var world:* = null;
            var param1:* = param1;
            var param2:* = param2;
            var isMouseDown:* = param1;
            var event:* = param2;
            if (((isDragging()) && (isMouseDown))){
                if (!_dragged){
                    _dragged = true;
                    map.displayHint("");
                    closeInfoWindow();
                    if (!crossSprite){
                        crossSprite = new Sprite();
                        mc.addChild(crossSprite);
                    };
                    crossSprite.graphics.lineStyle(0, Color.BLACK);
                    crossSprite.graphics.moveTo(-8, -6);
                    crossSprite.graphics.lineTo(8, 6);
                    crossSprite.graphics.moveTo(-8, 6);
                    crossSprite.graphics.lineTo(8, -6);
                    initFloat();
                    animator.run(function ():Boolean{
                        var _loc_1:Boolean;
                        doPhysicalStep();
                        positionMarker();
                        _loc_1 = ((((ANIMATE_MAX_HEIGHT - animateHeight) < 0.1)) || ((animateVelocity < 0)));
                        if (_loc_1){
                            animateHeight = ANIMATE_MAX_HEIGHT;
                            return (false);
                        };
                        return (true);
                    });
                    dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_START);
                };
                mouseCoord = new Point(event.stageX, event.stageY);
                pt = mouseCoord.subtract(_dragOffset);
                world = camera.viewportToWorld(pt);
                world.y = Util.bound(world.y, 0, 0x0100);
                pt = camera.worldToViewport(world);
                _latLng = LatLng.wrapLatLng(camera.viewportToLatLng(pt));
                positionMarker();
                dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_STEP);
            };
        }
        private function onInfoWindowClosing(event:Event):void{
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSING, onInfoWindowClosing);
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSING, Object(event).feature));
        }
        override protected function onOverlayMouseOut(event:MouseEvent):void{
            super.onOverlayMouseOut(event);
            map.displayHint("");
            dispatchMarkerMouseEvent(event, MapMouseEvent.ROLL_OUT);
        }
        private function renderMarker():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:DisplayObject;
            var _loc_3:DisplayObject;
            markerMc.graphics.clear();
            _loc_1 = Bootstrap.getSpriteFactory();
            _loc_2 = getIcon();
            if (currentIcon.content != _loc_2){
                if (currentIcon.displayObject){
                    _loc_1.removeChild(markerMc, currentIcon.displayObject);
                };
                currentIcon.content = _loc_2;
                if (currentIcon.displayObject){
                    _loc_1.addChild(markerMc, currentIcon.displayObject);
                };
            };
            _loc_3 = getIconShadow();
            if (currentIconShadow.content != _loc_3){
                if (currentIconShadow.displayObject){
                    _loc_1.removeChild(shadowMc, currentIconShadow.displayObject);
                    shadowMc.filters = [];
                };
                currentIconShadow.content = _loc_3;
                if (currentIconShadow.displayObject){
                    _loc_1.addChild(shadowMc, currentIconShadow.displayObject);
                    shadowMc.filters = [DropShadow.shadowFilter()];
                };
            };
            if (!_loc_2){
                renderStandardMarker();
            };
            if (dropShadow){
                dropShadow.draw(markerMc);
            };
        }

    }
}//package com.mapplus.maps.overlays 

import flash.events.*;
import com.mapplus.maps.core.*;
import flash.display.*;
import com.mapplus.maps.*;
import flash.utils.*;

class Animator {

    private var timer:Timer;
    private var onComplete:Function;
    private var onIteration:Function;

    public function Animator(){
        super();
    }
    private function onTimer(event:TimerEvent):void{
        if ((((onIteration == null)) || (!(onIteration())))){
            stop();
            if (onComplete != null){
                onComplete();
            };
        };
    }
    public function stop():void{
        if (timer){
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer = null;
        };
    }
    public function run(param1:Function, param2:Function=null):void{
        this.onIteration = param1;
        this.onComplete = param2;
        if (param1 != null){
            if (!timer){
                timer = new Timer(40, 0);
                timer.addEventListener(TimerEvent.TIMER, onTimer);
                timer.start();
            };
        } else {
            if (timer){
                stop();
            };
        };
    }

}
class CustomContent {

    private var displayObjectValue:DisplayObject;
    private var callbackValue:Function;
    private var loaderInfoValue:LoaderInfo;
    private var contentValue:DisplayObject;
    private var pendingValue:Boolean;

    public function CustomContent(){
        super();
    }
    public function get displayObject():DisplayObject{
        return (displayObjectValue);
    }
    public function get callback():Function{
        return (callbackValue);
    }
    private function onLoaderInit(event:Event):void{
        removeListeners();
        runCallback(true);
    }
    public function set callback(param1:Function):void{
        callbackValue = param1;
    }
    private function onUIComponentInitialized(event:Event):void{
        removeListeners();
        runCallback(true);
    }
    public function set content(param1:DisplayObject):void{
        var factory:* = null;
        var loader:* = null;
        var width:* = NaN;
        var param1:* = param1;
        var value:* = param1;
        removeListeners();
        contentValue = value;
        if (!value){
            return;
        };
        factory = Bootstrap.getSpriteFactory();
        pendingValue = false;
        if ((((factory.version >= 3)) && (factory.isUIComponent(contentValue)))){
            displayObjectValue = factory.createComponentContainer(contentValue).getSprite();
            if (!displayObjectValue.visible){
                displayObjectValue.addEventListener(MapEvent.COMPONENT_INITIALIZED, onUIComponentInitialized);
                pendingValue = true;
            };
        } else {
            displayObjectValue = contentValue;
            if ((contentValue is Loader)){
                loader = (contentValue as Loader);
                try {
                    width = loader.contentLoaderInfo.width;
                } catch(e:Error) {
                };
                if (width <= 0){
                    pendingValue = true;
                    loaderInfoValue = loader.contentLoaderInfo;
                    loaderInfoValue.addEventListener(Event.INIT, onLoaderInit);
                    loaderInfoValue.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
                };
            };
        };
    }
    private function runCallback(param1:Boolean):void{
        if (callbackValue != null){
            callbackValue(param1);
        };
    }
    public function get content():DisplayObject{
        return (contentValue);
    }
    private function removeListeners():void{
        pendingValue = false;
        if (loaderInfoValue){
            loaderInfoValue.removeEventListener(Event.INIT, onLoaderInit);
            loaderInfoValue.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
            loaderInfoValue = null;
        };
        if (displayObjectValue){
            displayObjectValue.removeEventListener(MapEvent.COMPONENT_INITIALIZED, onUIComponentInitialized);
        };
    }
    private function onLoaderIOError(event:IOErrorEvent):void{
        removeListeners();
        runCallback(false);
    }
    public function get pending():Boolean{
        return (pendingValue);
    }

}
