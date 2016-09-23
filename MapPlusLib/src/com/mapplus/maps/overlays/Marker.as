//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.events.*;
    import com.mapplus.maps.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;
    import flash.text.*;

    public class Marker extends Overlay implements IMarker, IDepthSortable {

        private static const ANIMATE_MAX_HEIGHT:Number = 13;
        private static const VERTICAL_MASK:Number = 48;
        private static const TAIL_HEIGHT:Number = 1.5;
        private static const HORIZONTAL_MASK:Number = 3;
        private static const BOTTOM:Number = 32;
        private static const CENTER:Number = 1;
        private static const LEFT:Number = 0;
        private static const TOP:Number = 0;
        private static const MIDDLE:Number = 16;
        private static const RIGHT:Number = 2;

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

        private var crossSprite:Sprite;
        private var _latLng:LatLng;
        public var infoWindow:IInfoWindow;
        private var _dragged:Boolean;
        private var currentIconShadow:CustomContent;
        private var markerMc:Sprite;
        private var animateHeight:Number;
        private var currentIcon:CustomContent;
        private var labelMc:TextField;
        private var options:MarkerOptions;
        private var _dragOffset:Point;
        private var animateVelocity:Number;
        private var dropShadow:DropShadow;
        private var animator:Animator;

        public function Marker(param1:LatLng, param2:MarkerOptions=null){
            super(Overlay.FLAG_HASSHADOW);
            this.currentIcon = new CustomContent();
            this.currentIconShadow = new CustomContent();
            this.options = MarkerOptions.merge([Marker.getDefaultOptions(), param2]);
            this._latLng = param1.clone();
            this.markerMc = Bootstrap.createChildComponent(this.mc);
            this.updateButtonMode();
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

        private function removeCrossSprite():void{
            if (this.crossSprite){
                this.mc.removeChild(this.crossSprite);
                this.crossSprite = null;
            };
        }
        private function onMouseMove(param1:Boolean, param2:MouseEvent):void{
            var mouseCoord:* = null;
            var pt:* = null;
            var world:* = null;
            var param1:* = param1;
            var param2:* = param2;
            var isMouseDown:* = param1;
            var event:* = param2;
            if (((this.isDragging()) && (isMouseDown))){
                if (!(this._dragged)){
                    this._dragged = true;
                    map.displayHint("");
                    this.closeInfoWindow();
                    if (!(this.crossSprite)){
                        this.crossSprite = new Sprite();
                        this.mc.addChild(this.crossSprite);
                    };
                    this.crossSprite.graphics.lineStyle(0, Color.BLACK);
                    this.crossSprite.graphics.moveTo(-8, -6);
                    this.crossSprite.graphics.lineTo(8, 6);
                    this.crossSprite.graphics.moveTo(-8, 6);
                    this.crossSprite.graphics.lineTo(8, -6);
                    this.initFloat();
                    this.animator.run(function ():Boolean{
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
                    this.dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_START);
                };
                mouseCoord = new Point(event.stageX, event.stageY);
                pt = mouseCoord.subtract(this._dragOffset);
                world = camera.viewportToWorld(pt);
                world.y = Util.bound(world.y, 0, 0x0100);
                pt = camera.worldToViewport(world);
                this._latLng = LatLng.wrapLatLng(camera.viewportToLatLng(pt));
                this.positionMarker();
                this.dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_STEP);
            };
        }
        private function getIcon():DisplayObject{
            return (this.options.icon);
        }
        override public function get interfaceChain():Array{
            return (["IMarker", "IOverlay"]);
        }
        private function getGravity():Number{
            return ((this.options.gravity as Number));
        }
        override public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_MARKER));
        }
        private function getIconShadow():DisplayObject{
            return (this.options.iconShadow);
        }
        private function getStrokeStyle():StrokeStyle{
            return (this.options.strokeStyle);
        }
        public function openInfoWindow(param1:InfoWindowOptions=null, param2:Boolean=false):IInfoWindow{
            var _loc_3:IPaneManagerInternal;
            var _loc_4:DisplayObject;
            var _loc_5:Point;
            var _loc_6:Rectangle;
            if (((!(map)) || (!(visible)))){
                return (null);
            };
            if (!(param1)){
                param1 = new InfoWindowOptions();
            };
            if (!(param1.pointOffset)){
                _loc_4 = this.getIcon();
                if (_loc_4){
                    _loc_5 = this.getContentOffset();
                    _loc_6 = _loc_4.getBounds(_loc_4);
                    param1.pointOffset = new Point((_loc_5.x + (_loc_6.width / 2)), _loc_5.y);
                } else {
                    param1.pointOffset = new Point(0, -(((this.getRadius() * (2 + TAIL_HEIGHT)) + 2)));
                };
            };
            map.addEventListener(MapEvent.INFOWINDOW_CLOSED, this.onInfoWindowClosed);
            map.addEventListener(MapEvent.INFOWINDOW_CLOSING, this.onInfoWindowClosing);
            Pane(pane).lock();
            this.infoWindow = map.openInfoWindow(this._latLng, param1);
            _loc_3 = (pane.paneManager as IPaneManagerInternal);
            if (_loc_3){
                _loc_3.placePaneShadow(this.infoWindow.pane, pane);
            };
            Pane(pane).unlock();
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_OPENED, this.infoWindow));
            return (this.infoWindow);
        }
        public function get height():Number{
            return (this.markerMc.height);
        }
        private function onCurrentIconReady(param1:Boolean):void{
            this.positionMarker();
        }
        public function setLatLng(param1:LatLng):void{
            this._latLng = param1;
            this.redraw();
            dispatchEvent(new MapEvent(MapEvent.OVERLAY_MOVED, this));
        }
        private function initFloat():void{
            this.impulseToHeight(ANIMATE_MAX_HEIGHT);
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            this.animateVelocity = 0;
            this.animateHeight = 0;
            this.animator = new Animator();
            this._dragOffset = null;
            this._dragged = false;
            this.configureShadow(this.hasShadow());
            this.redraw();
        }
        private function onMouseUp(param1:Boolean, param2:MouseEvent):void{
            var mouse:* = null;
            var hasBounced:* = false;
            var param1:* = param1;
            var param2:* = param2;
            var isReceived:* = param1;
            var event:* = param2;
            if (this.isDragging()){
                this._dragOffset = null;
                mouse = MouseHandler.instance();
                mouse.removeGlobalMouseMoveListener(this.onMouseMove);
                mouse.removeGlobalMouseUpListener(this.onMouseUp);
                this.positionMarker();
                if (this._dragged){
                    this._dragged = false;
                    this.animator.run(function ():Boolean{
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
                    }, this.endAnimation);
                    this.dispatchMarkerMouseEvent(event, MapMouseEvent.DRAG_END);
                    dispatchEvent(new MapEvent(MapEvent.OVERLAY_MOVED, this));
                };
            };
            this.dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_UP);
        }
        private function SetDropShadowState(param1:Boolean):void{
            if (param1){
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
        private function onInfoWindowClosed(event:Event):void{
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSED, this.onInfoWindowClosed);
            this.infoWindow = null;
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSED, Object(event).feature));
        }
        public function closeInfoWindow():void{
            if (this.infoWindow){
                map.closeInfoWindow();
            };
        }
        private function getFillStyle():FillStyle{
            return (this.options.fillStyle);
        }
        private function setAnimateHeight(param1:Number):void{
            this.animateHeight = Util.bound(param1, 0, ANIMATE_MAX_HEIGHT);
        }
        private function dispatchMarkerMouseEvent(event:MouseEvent, param2:String):void{
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, param2, this, this._latLng));
        }
        private function doPhysicalStep():void{
            this.animateVelocity = (this.animateVelocity - this.getGravity());
            this.setAnimateHeight((this.animateHeight + this.animateVelocity));
        }
        private function getIconOffset():Point{
            return (this.options.iconOffset);
        }
        override protected function onOverlayMouseDown(event:MouseEvent):void{
            var _loc_2:IMouse;
            var _loc_3:Point;
            var _loc_4:Point;
            super.onOverlayMouseDown(event);
            event.stopPropagation();
            _loc_2 = MouseHandler.instance();
            _loc_2.addGlobalMouseUpListener(this.onMouseUp);
            if (this.isDraggable()){
                _loc_3 = camera.latLngToViewport(this._latLng);
                _loc_4 = new Point(event.stageX, event.stageY);
                this._dragOffset = _loc_4.subtract(_loc_3);
                this._dragged = false;
                _loc_2.addGlobalMouseMoveListener(this.onMouseMove);
            };
            this.dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_DOWN);
        }
        private function onInfoWindowClosing(event:Event):void{
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSING, this.onInfoWindowClosing);
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSING, Object(event).feature));
        }
        private function renderMarker():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:DisplayObject;
            var _loc_3:DisplayObject;
            this.markerMc.graphics.clear();
            _loc_1 = Bootstrap.getSpriteFactory();
            _loc_2 = this.getIcon();
            if (this.currentIcon.content != _loc_2){
                if (this.currentIcon.displayObject){
                    _loc_1.removeChild(this.markerMc, this.currentIcon.displayObject);
                };
                this.currentIcon.content = _loc_2;
                if (this.currentIcon.displayObject){
                    _loc_1.addChild(this.markerMc, this.currentIcon.displayObject);
                };
            };
            _loc_3 = this.getIconShadow();
            if (this.currentIconShadow.content != _loc_3){
                if (this.currentIconShadow.displayObject){
                    _loc_1.removeChild(this.shadowMc, this.currentIconShadow.displayObject);
                    this.shadowMc.filters = [];
                };
                this.currentIconShadow.content = _loc_3;
                if (this.currentIconShadow.displayObject){
                    _loc_1.addChild(this.shadowMc, this.currentIconShadow.displayObject);
                    this.shadowMc.filters = [DropShadow.shadowFilter()];
                };
            };
            if (!(_loc_2)){
                this.renderStandardMarker();
            };
            if (this.dropShadow){
                this.dropShadow.draw(this.markerMc);
            };
        }
        private function isDraggable():Boolean{
            return ((this.options.draggable as Boolean));
        }
        private function hasShadow():Boolean{
            return ((this.options.hasShadow as Boolean));
        }
        private function getRadius():Number{
            return ((this.options.radius as Number));
        }
        private function get mc():Sprite{
            return (super._foreground);
        }
        override protected function onOverlayClick(event:MouseEvent):void{
            super.onOverlayClick(event);
            if (((isClickValid) && (this.isClickable()))){
                this.dispatchMarkerMouseEvent(event, MapMouseEvent.CLICK);
                if (_timedDoubleClick.clickReturnTrueIfDoubleClick()){
                    this.dispatchMarkerMouseEvent(event, MapMouseEvent.DOUBLE_CLICK);
                };
            };
        }
        private function isDragging():Boolean{
            return (!((this._dragOffset == null)));
        }
        private function renderStandardMarker():void{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            var _loc_5:TextFormat;
            _loc_1 = this.getRadius();
            Render.setStroke(this.markerMc.graphics, this.getStrokeStyle());
            Render.beginFill(this.markerMc.graphics, this.getFillStyle());
            _loc_2 = ((Math.SQRT2 - 1) * _loc_1);
            _loc_3 = (Math.SQRT1_2 * _loc_1);
            this.markerMc.graphics.moveTo(0, -(_loc_1));
            this.markerMc.graphics.curveTo(_loc_2, -(_loc_1), _loc_3, -(_loc_3));
            this.markerMc.graphics.curveTo(_loc_1, -(_loc_2), _loc_1, 0);
            this.markerMc.graphics.curveTo(_loc_1, _loc_2, _loc_3, _loc_3);
            this.markerMc.graphics.curveTo(0, (_loc_1 * TAIL_HEIGHT), 0, (_loc_1 * (1 + TAIL_HEIGHT)));
            this.markerMc.graphics.curveTo(0, (_loc_1 * TAIL_HEIGHT), -(_loc_3), _loc_3);
            this.markerMc.graphics.curveTo(-(_loc_1), _loc_2, -(_loc_1), 0);
            this.markerMc.graphics.curveTo(-(_loc_1), -(_loc_2), -(_loc_3), -(_loc_3));
            this.markerMc.graphics.curveTo(-(_loc_2), -(_loc_1), 0, -(_loc_1));
            this.markerMc.graphics.endFill();
            _loc_4 = this.getLabel();
            if (_loc_4){
                if (!(this.labelMc)){
                    this.labelMc = new TextField();
                    this.labelMc.autoSize = TextFieldAutoSize.LEFT;
                    this.labelMc.selectable = false;
                    this.labelMc.border = false;
                    this.labelMc.embedFonts = false;
                    this.labelMc.mouseEnabled = false;
                    this.markerMc.addChild(this.labelMc);
                };
                this.labelMc.width = _loc_1;
                this.labelMc.height = _loc_1;
                this.labelMc.text = _loc_4;
                this.labelMc.x = (-(this.labelMc.width) * 0.5);
                this.labelMc.y = (-(this.labelMc.height) * 0.5);
                _loc_5 = this.getLabelFormat();
                if (_loc_5){
                    this.labelMc.setTextFormat(_loc_5);
                };
            } else {
                if (this.labelMc){
                    this.markerMc.removeChild(this.labelMc);
                    this.labelMc = null;
                };
            };
        }
        override protected function onOverlayMouseMove(event:MouseEvent):void{
            super.onOverlayMouseMove(event);
            this.dispatchMarkerMouseEvent(event, MapMouseEvent.MOUSE_MOVE);
        }
        override protected function onOverlayMouseOver(event:MouseEvent):void{
            var _loc_2:String;
            super.onOverlayMouseOver(event);
            if (!(this.isDragging())){
                _loc_2 = this.getTooltip();
                if (((_loc_2) && ((_loc_2.length > 0)))){
                    map.displayHint(_loc_2);
                };
                if (map.overlayRaising){
                    pane.bringToTop(this);
                };
            };
            this.dispatchMarkerMouseEvent(event, MapMouseEvent.ROLL_OVER);
        }
        public function getOptions():MarkerOptions{
            return (this.options);
        }
        private function impulseToHeight(param1:Number):void{
            var _loc_2:Number = NaN;
            _loc_2 = (param1 - this.animateHeight);
            this.animateVelocity = Math.ceil(Math.sqrt(((2 * this.getGravity()) * _loc_2)));
        }
        private function getLabel():String{
            return (this.options.label);
        }
        private function getIconAlignment():Number{
            return ((this.options.iconAlignment as Number));
        }
        private function configureShadow(param1:Boolean):void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            this.SetDropShadowState(((param1) && (!(this.getIconShadow()))));
        }
        private function updateButtonMode():void{
            var _loc_1:Boolean;
            _loc_1 = this.isClickable();
            this.markerMc.useHandCursor = _loc_1;
            this.markerMc.buttonMode = _loc_1;
        }
        public function getContentOffset():Point{
            var _loc_1:Point;
            var _loc_2:Rectangle;
            var _loc_3:Number = NaN;
            var _loc_4:Point = this.getIconOffset();
            _loc_1 = new Point();
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
                _loc_1 = _loc_4;
            };
            return (_loc_1);
        }
        private function positionMarker():void{
            var _loc_1:LatLng;
            var _loc_2:Number = NaN;
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (((!(map)) || (!(visible)))){
                return;
            };
            if (this.currentIcon.pending){
                this.currentIcon.callback = this.onCurrentIconReady;
                return;
            };
            if (this.currentIconShadow.pending){
                this.currentIconShadow.callback = this.onCurrentIconReady;
            };
            _loc_1 = getLatLngClosestToCenter(this._latLng);
            if (camera.isAhead(_loc_1)){
                this.markerMc.visible = true;
                _loc_2 = 1;
                _loc_3 = camera.latLngToViewport(_loc_1);
                if (this.crossSprite){
                    this.crossSprite.x = _loc_3.x;
                    this.crossSprite.y = _loc_3.y;
                };
                _loc_4 = this.getContentOffset();
                _loc_5 = new Point(0, -(this.animateHeight));
                _loc_6 = (_loc_3.x + (_loc_2 * (_loc_4.x + _loc_5.x)));
                _loc_7 = (_loc_3.y + (_loc_2 * (_loc_4.y + _loc_5.y)));
                this.markerMc.x = _loc_6;
                this.markerMc.y = _loc_7;
                this.markerMc.scaleX = _loc_2;
                this.markerMc.scaleY = _loc_2;
                if (this.shadowMc){
                    this.shadowMc.visible = true;
                    this.shadowMc.x = _loc_6;
                    this.shadowMc.y = _loc_7;
                    this.shadowMc.scaleX = _loc_2;
                    this.shadowMc.scaleY = _loc_2;
                };
                if (this.hasShadow()){
                    if (this.dropShadow){
                        this.dropShadow.positionShadow(_loc_5, camera.shadowMatrix);
                    };
                    if (this.currentIconShadow.displayObject){
                        DropShadow.positionShadowObject(this.currentIconShadow.displayObject, _loc_5, camera.shadowMatrix);
                    };
                };
            } else {
                this.markerMc.visible = false;
                if (this.shadowMc){
                    this.shadowMc.visible = false;
                };
            };
        }
        public function get width():Number{
            return (this.markerMc.width);
        }
        private function getTooltip():String{
            return (this.options.tooltip);
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:ISpriteFactory;
            var _loc_2:IMouse;
            _loc_1 = Bootstrap.getSpriteFactory();
            if (this.currentIcon.displayObject){
                _loc_1.removeChild(this.markerMc, this.currentIcon.displayObject);
                this.currentIcon.content = null;
            };
            if (this.currentIconShadow.displayObject){
                _loc_1.removeChild(this.shadowMc, this.currentIconShadow.displayObject);
                this.shadowMc.filters = [];
                this.currentIconShadow.content = null;
            };
            this.configureShadow(false);
            _loc_2 = MouseHandler.instance();
            _loc_2.removeGlobalMouseUpListener(this.onMouseUp);
            _loc_2.removeGlobalMouseMoveListener(this.onMouseMove);
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSED, this.onInfoWindowClosed);
            map.removeEventListener(MapEvent.INFOWINDOW_CLOSING, this.onInfoWindowClosing);
            if (this.animator){
                this.animator.stop();
                this.animator = null;
            };
            super.onRemovedFromPane();
        }
        private function getLabelFormat():TextFormat{
            return (this.options.labelFormat);
        }
        private function get shadowMc():Sprite{
            return (super._shadow);
        }
        private function isClickable():Boolean{
            return ((((this.options.clickable == null)) || ((this.options.clickable as Boolean))));
        }
        public function setOptions(param1:MarkerOptions):void{
            this.options = MarkerOptions.merge([this.options, param1]);
            this.updateButtonMode();
            this.configureShadow(this.hasShadow());
            this.redraw();
        }
        override public function positionOverlay(param1:Boolean):void{
            this.positionMarker();
        }
        private function endAnimation():void{
            this.removeCrossSprite();
            dispatchEvent(new MapEvent(MapEvent.OVERLAY_ANIMATE_END, this));
        }
        override protected function redraw():void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            this.renderMarker();
            this.positionMarker();
        }
        override protected function onOverlayMouseOut(event:MouseEvent):void{
            super.onOverlayMouseOut(event);
            map.displayHint("");
            this.dispatchMarkerMouseEvent(event, MapMouseEvent.ROLL_OUT);
        }
        public function getLatLng():LatLng{
            return (this._latLng);
        }

    }
}//package com.mapplus.maps.overlays 

import flash.events.*;
import flash.utils.*;
import com.mapplus.maps.*;
import flash.display.*;
import com.mapplus.maps.core.*;

class Animator {

    private var timer:Timer;
    private var onComplete:Function;
    private var onIteration:Function;

    public function Animator(){
        super();
    }
    public function stop():void{
        if (this.timer){
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer = null;
        };
    }
    private function onTimer(event:TimerEvent):void{
        if ((((this.onIteration == null)) || (!(this.onIteration())))){
            this.stop();
            if (this.onComplete != null){
                this.onComplete();
            };
        };
    }
    public function run(param1:Function, param2:Function=null):void{
        this.onIteration = param1;
        this.onComplete = param2;
        if (param1 != null){
            if (!(this.timer)){
                this.timer = new Timer(40, 0);
                this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
                this.timer.start();
            };
        } else {
            if (this.timer){
                this.stop();
            };
        };
    }

}
class CustomContent {

    private var loaderInfoValue:LoaderInfo;
    private var displayObjectValue:DisplayObject;
    private var pendingValue:Boolean;
    private var callbackValue:Function;
    private var contentValue:DisplayObject;

    public function CustomContent(){
        super();
    }
    private function onLoaderInit(event:Event):void{
        this.removeListeners();
        this.runCallback(true);
    }
    public function get callback():Function{
        return (this.callbackValue);
    }
    public function set callback(param1:Function):void{
        this.callbackValue = param1;
    }
    private function removeListeners():void{
        this.pendingValue = false;
        if (this.loaderInfoValue){
            this.loaderInfoValue.removeEventListener(Event.INIT, this.onLoaderInit);
            this.loaderInfoValue.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoaderIOError);
            this.loaderInfoValue = null;
        };
        if (this.displayObjectValue){
            this.displayObjectValue.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.onUIComponentInitialized);
        };
    }
    public function get pending():Boolean{
        return (this.pendingValue);
    }
    public function get displayObject():DisplayObject{
        return (this.displayObjectValue);
    }
    private function onUIComponentInitialized(event:Event):void{
        this.removeListeners();
        this.runCallback(true);
    }
    public function set content(param1:DisplayObject):void{
        var factory:* = null;
        var loader:* = null;
        var width:* = NaN;
        var param1:* = param1;
        var value:* = param1;
        this.removeListeners();
        this.contentValue = value;
        if (!(value)){
            return;
        };
        factory = Bootstrap.getSpriteFactory();
        this.pendingValue = false;
        if ((((factory.version >= 3)) && (factory.isUIComponent(this.contentValue)))){
            this.displayObjectValue = factory.createComponentContainer(this.contentValue).getSprite();
            if (!(this.displayObjectValue.visible)){
                this.displayObjectValue.addEventListener(MapEvent.COMPONENT_INITIALIZED, this.onUIComponentInitialized);
                this.pendingValue = true;
            };
        } else {
            this.displayObjectValue = this.contentValue;
            if ((this.contentValue is Loader)){
                loader = (this.contentValue as Loader);
                try {
                    width = loader.contentLoaderInfo.width;
                } catch(e:Error) {
                };
                if (width <= 0){
                    this.pendingValue = true;
                    this.loaderInfoValue = loader.contentLoaderInfo;
                    this.loaderInfoValue.addEventListener(Event.INIT, this.onLoaderInit);
                    this.loaderInfoValue.addEventListener(IOErrorEvent.IO_ERROR, this.onLoaderIOError);
                };
            };
        };
    }
    private function onLoaderIOError(event:IOErrorEvent):void{
        this.removeListeners();
        this.runCallback(false);
    }
    public function get content():DisplayObject{
        return (this.contentValue);
    }
    private function runCallback(param1:Boolean):void{
        if (this.callbackValue != null){
            this.callbackValue(param1);
        };
    }

}
