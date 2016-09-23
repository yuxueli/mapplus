//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.wrappers.*;

    public class Overlay extends WrappableEventDispatcher implements IOverlay {

        public static const FLAGS_NONE:int = 0;
        public static const FLAG_DISPATCHMOUSEEVENTS:int = 2;
        public static const FLAG_HASSHADOW:int = 1;

        protected var isClickValid:Boolean;
        private var mouse:IMouse;
        private var _visible:Boolean;
        protected var _shadow:Sprite;
        protected var _pane:IPaneInternal;
        protected var _timedDoubleClick:TimedDoubleClick;
        protected var _foreground:Sprite;
        private var clickValidRegion:Rectangle;
        private var _overlayFlags:int;

        public function Overlay(param1:int){
            super();
            var _loc_2:ISpriteFactory;
            this.mouse = MouseHandler.instance();
            this._overlayFlags = param1;
            this._visible = true;
            _loc_2 = Bootstrap.getSpriteFactory();
            this._foreground = _loc_2.createComponent().getSprite();
            if (this.hasShadow()){
                this._shadow = _loc_2.createComponent().getSprite();
            };
            this._timedDoubleClick = new TimedDoubleClick();
        }
        public function get pane():IPane{
            return (this._pane);
        }
        protected function getWrapOffset(param1:LatLng):Number{
            var _loc_2:LatLng;
            _loc_2 = this.getLatLngClosestToCenter(param1);
            return ((this.camera.latLngToViewport(_loc_2).x - this.camera.latLngToViewport(param1).x));
        }
        public function isHidden():Boolean{
            return (!(this.visible));
        }
        public function remove():void{
            if (this.pane){
                this.pane.removeOverlay(this);
            };
        }
        protected function onOverlayMouseDown(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            this.isClickValid = true;
            this.clickValidRegion = new Rectangle(event.stageX, event.stageY);
            if (this.map){
                _loc_2 = this.map.mouseClickRange;
                this.clickValidRegion.inflate(_loc_2, _loc_2);
            };
            this.dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_DOWN);
        }
        override public function get interfaceChain():Array{
            return (["IOverlay"]);
        }
        private function getWorldClipPoly2D(param1:Boolean=false):Array{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Rectangle;
            var _loc_5:Point;
            _loc_2 = this.camera.viewportToWorld(new Point(0, 0));
            _loc_3 = this.camera.viewportToWorld(this.camera.viewport);
            _loc_4 = new Rectangle(_loc_2.x, _loc_2.y);
            Util.rectangleExtend(_loc_4, _loc_3);
            if (param1){
                _loc_5 = this.camera.getWorldCenter();
                _loc_4 = _loc_4.intersection(new Rectangle((_loc_5.x - 128), 0, 0x0100, 0x0100));
            };
            return ([_loc_4.topLeft, new Point(_loc_4.right, _loc_4.top), _loc_4.bottomRight, new Point(_loc_4.left, _loc_4.bottom)]);
        }
        protected function getLatLngClosestToCenter(param1:LatLng):LatLng{
            return (this.camera.getLatLngClosestToCenter(param1));
        }
        protected function dispatchMouseEvent(event:MouseEvent, param2:String):void{
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, param2, this, this.getMouseEventLatLng(event)));
        }
        protected function dispatchMouseEventIfEnabled(event:MouseEvent, param2:String):void{
            if (this.canDispatchMouseEvents()){
                this.dispatchMouseEvent(event, param2);
            };
        }
        public function get visible():Boolean{
            return (this._visible);
        }
        protected function get isSingleWorld():Boolean{
            return (false);
        }
        public function get shadow():DisplayObject{
            return (this._shadow);
        }
        protected function onOverlayMouseOver(event:MouseEvent):void{
            this.dispatchMouseEventIfEnabled(event, MapMouseEvent.ROLL_OVER);
        }
        public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_OVERLAYS));
        }
        protected function onOverlayClick(event:MouseEvent):void{
            if (((!(this.canDispatchMouseEvents())) || (!(this.isClickValid)))){
                return;
            };
            this.dispatchMouseEvent(event, MapMouseEvent.CLICK);
            if (this._timedDoubleClick.clickReturnTrueIfDoubleClick()){
                this.dispatchMouseEvent(event, MapMouseEvent.DOUBLE_CLICK);
            };
        }
        protected function onOverlayMouseMove(event:MouseEvent):void{
            if (((!(this.clickValidRegion)) || (!(this.clickValidRegion.contains(event.stageX, event.stageY))))){
                this.isClickValid = false;
                this._timedDoubleClick.reset();
            };
            this.dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_MOVE);
        }
        protected function getWorldClipPoly(param1:Boolean=false):Array{
            return (this.getWorldClipPoly2D(param1));
        }
        protected function get camera():Camera{
            return ((this._pane) ? this._pane.getCamera() : null);
        }
        protected function worldPointToPane(param1:Point, param2:Number, param3:Point, param4:Point):void{
            var _loc_5:Point;
            if (this.is3DView()){
                _loc_5 = this.camera.worldToViewport(param3.add(param1));
                param4.x = _loc_5.x;
                param4.y = _loc_5.y;
            } else {
                param4.x = (param2 * (param1.x + param3.x));
                param4.y = (param2 * (param1.y + param3.y));
            };
        }
        public function hide():void{
            this.visible = false;
        }
        public function get foreground():DisplayObject{
            return (this._foreground);
        }
        protected function getProjection():IProjection{
            return (this.map.getCurrentMapType().getProjection());
        }
        protected function onAddedToPane():void{
            this.mouse.addListener(this.foreground, MouseEvent.ROLL_OVER, this.onOverlayMouseOver);
            this.mouse.addListener(this.foreground, MouseEvent.ROLL_OUT, this.onOverlayMouseOut);
            this.mouse.addListener(this.foreground, MouseEvent.CLICK, this.onOverlayClick);
            this.mouse.addListener(this.foreground, MouseEvent.MOUSE_DOWN, this.onOverlayMouseDown);
            this.mouse.addListener(this.foreground, MouseEvent.MOUSE_UP, this.onOverlayMouseUp);
            this.mouse.addListener(this.foreground, MouseEvent.MOUSE_MOVE, this.onOverlayMouseMove);
        }
        protected function onRemovedFromPane():void{
            this.mouse.removeListener(this.foreground, MouseEvent.ROLL_OVER, this.onOverlayMouseOver);
            this.mouse.removeListener(this.foreground, MouseEvent.ROLL_OUT, this.onOverlayMouseOut);
            this.mouse.removeListener(this.foreground, MouseEvent.CLICK, this.onOverlayClick);
            this.mouse.removeListener(this.foreground, MouseEvent.MOUSE_DOWN, this.onOverlayMouseDown);
            this.mouse.removeListener(this.foreground, MouseEvent.MOUSE_UP, this.onOverlayMouseUp);
            this.mouse.removeListener(this.foreground, MouseEvent.MOUSE_MOVE, this.onOverlayMouseMove);
        }
        public function set pane(param1:IPane):void{
            if (param1){
                this._pane = IPaneInternal(param1);
                this.onAddedToPane();
            } else {
                this.onRemovedFromPane();
                this._pane = null;
            };
        }
        protected function getMouseEventLatLng(event:MouseEvent):LatLng{
            var _loc_2:Point;
            var _loc_3:Point;
            _loc_2 = new Point(event.stageX, event.stageY);
            _loc_3 = this._pane.getForeground().globalToLocal(_loc_2);
            return (LatLng.wrapLatLng(this.camera.viewportToLatLng(_loc_3)));
        }
        private function hasShadow():Boolean{
            return (!(((this._overlayFlags & FLAG_HASSHADOW) == 0)));
        }
        private function canDispatchMouseEvents():Boolean{
            return (!(((this._overlayFlags & FLAG_DISPATCHMOUSEEVENTS) == 0)));
        }
        protected function get map():IMapBase2{
            return ((this._pane) ? this._pane.getMapInstance() : null);
        }
        public function getPane():IPane{
            return (this.pane);
        }
        protected function is3DView():Boolean{
            return (this.map.getCamera().is3D);
        }
        public function positionOverlay(param1:Boolean):void{
        }
        public function getDisplayObject():DisplayObject{
            return (this.foreground);
        }
        protected function onOverlayMouseUp(event:MouseEvent):void{
            this.dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_UP);
        }
        protected function latLngToWorld(param1:LatLng):Point{
            return (this.getProjection().fromLatLngToPixel(param1, 0));
        }
        protected function redraw():void{
        }
        protected function getWorldWrapOffset(param1:Point):Number{
            var _loc_2:Point;
            _loc_2 = this.camera.getWorldCenter();
            return ((MapUtil.wrapPeriod(param1.x, (_loc_2.x - 128), (_loc_2.x + 128), 0x0100) - param1.x));
        }
        protected function onOverlayMouseOut(event:MouseEvent):void{
            this.dispatchMouseEventIfEnabled(event, MapMouseEvent.ROLL_OUT);
        }
        public function set visible(param1:Boolean):void{
            if (this._visible == param1){
                return;
            };
            this._visible = param1;
            this.foreground.visible = param1;
            if (this.shadow){
                this.shadow.visible = param1;
            };
            if (param1){
                this.redraw();
            };
            if (this.map){
                this.map.dispatchEvent(new MapEvent(MapEvent.VISIBILITY_CHANGED, this));
            };
            dispatchEvent(new MapEvent(MapEvent.VISIBILITY_CHANGED, this));
        }
        public function show():void{
            this.visible = true;
        }
        protected function offsetPoly(param1:Array, param2:Number, param3:Number):void{
            var _loc_4:int;
            _loc_4 = 0;
            while (_loc_4 < param1.length) {
                param1[_loc_4].offset(param2, param3);
                _loc_4++;
            };
        }

    }
}//package com.mapplus.maps.overlays 
