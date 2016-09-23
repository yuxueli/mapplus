//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

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
            mouse = MouseHandler.instance();
            _overlayFlags = param1;
            _visible = true;
            _loc_2 = Bootstrap.getSpriteFactory();
            _foreground = _loc_2.createComponent().getSprite();
            if (hasShadow()){
                _shadow = _loc_2.createComponent().getSprite();
            };
            _timedDoubleClick = new TimedDoubleClick();
        }
        static function clipPolyToEdge(param1:Array, param2:Point, param3:Point):Array{
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:Point;
            var _loc_7:int;
            var _loc_8:Point;
            _loc_4 = [];
            _loc_5 = param1.length;
            if (_loc_5 == 0){
                return (_loc_4);
            };
            _loc_6 = param1[(_loc_5 - 1)];
            _loc_7 = 0;
            while (_loc_7 < _loc_5) {
                _loc_8 = param1[_loc_7];
                if (isInside(param2, param3, _loc_8)){
                    if (!isInside(param2, param3, _loc_6)){
                        _loc_4.push(getIntersection(param2, param3, _loc_6, _loc_8));
                    };
                    _loc_4.push(_loc_8);
                } else {
                    if (isInside(param2, param3, _loc_6)){
                        _loc_4.push(getIntersection(param2, param3, _loc_8, _loc_6));
                    };
                };
                _loc_6 = _loc_8;
                _loc_7++;
            };
            return (_loc_4);
        }
        static function isInside(param1:Point, param2:Point, param3:Point):Boolean{
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            _loc_4 = param3.subtract(param1);
            _loc_5 = ((param2.x * _loc_4.y) - (param2.y * _loc_4.x));
            return ((_loc_5 > 0));
        }
        static function getIntersection(param1:Point, param2:Point, param3:Point, param4:Point):Point{
            var _loc_5:Number = NaN;
            _loc_5 = ((((param3.y - param1.y) * param2.x) - ((param3.x - param1.x) * param2.y)) / (((param4.x - param3.x) * param2.y) - ((param4.y - param3.y) * param2.x)));
            return (new Point(((_loc_5 * param4.x) + ((1 - _loc_5) * param3.x)), ((_loc_5 * param4.y) + ((1 - _loc_5) * param3.y))));
        }

        protected function getWorldWrapOffset(param1:Point):Number{
            var _loc_2:Point;
            _loc_2 = camera.getWorldCenter();
            return ((MapUtil.wrapPeriod(param1.x, (_loc_2.x - 128), (_loc_2.x + 128), 0x0100) - param1.x));
        }
        public function remove():void{
            if (pane){
                pane.removeOverlay(this);
            };
        }
        protected function redraw():void{
        }
        protected function onOverlayMouseUp(event:MouseEvent):void{
            dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_UP);
        }
        override public function get interfaceChain():Array{
            return (["IOverlay"]);
        }
        private function getWorldClipPoly2D(param1:Boolean=false):Array{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Rectangle;
            var _loc_5:Point;
            _loc_2 = camera.viewportToWorld(new Point(0, 0));
            _loc_3 = camera.viewportToWorld(camera.viewport);
            _loc_4 = new Rectangle(_loc_2.x, _loc_2.y);
            Util.rectangleExtend(_loc_4, _loc_3);
            if (param1){
                _loc_5 = camera.getWorldCenter();
                _loc_4 = _loc_4.intersection(new Rectangle((_loc_5.x - 128), 0, 0x0100, 0x0100));
            };
            return ([_loc_4.topLeft, new Point(_loc_4.right, _loc_4.top), _loc_4.bottomRight, new Point(_loc_4.left, _loc_4.bottom)]);
        }
        public function show():void{
            visible = true;
        }
        protected function getLatLngClosestToCenter(param1:LatLng):LatLng{
            return (camera.getLatLngClosestToCenter(param1));
        }
        public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_OVERLAYS));
        }
        protected function dispatchMouseEventIfEnabled(event:MouseEvent, param2:String):void{
            if (canDispatchMouseEvents()){
                dispatchMouseEvent(event, param2);
            };
        }
        protected function dispatchMouseEvent(event:MouseEvent, param2:String):void{
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, param2, this, getMouseEventLatLng(event)));
        }
        protected function onOverlayClick(event:MouseEvent):void{
            if (((!(canDispatchMouseEvents())) || (!(isClickValid)))){
                return;
            };
            dispatchMouseEvent(event, MapMouseEvent.CLICK);
            if (_timedDoubleClick.clickReturnTrueIfDoubleClick()){
                dispatchMouseEvent(event, MapMouseEvent.DOUBLE_CLICK);
            };
        }
        protected function get isSingleWorld():Boolean{
            return (false);
        }
        private function getProjectedViewportEdgeDirection(param1:Point, param2:int):Point{
            var _loc_3:Point;
            _loc_3 = ((((param2 == 0)) || ((param2 == 2)))) ? camera.mapViewportToWorld.projectUnitX(param1) : camera.mapViewportToWorld.projectUnitY(param1);
            if ((((param2 == 2)) || ((param2 == 3)))){
                _loc_3.x = -(_loc_3.x);
                _loc_3.y = -(_loc_3.y);
            };
            return (_loc_3);
        }
        protected function onOverlayMouseMove(event:MouseEvent):void{
            if (((!(clickValidRegion)) || (!(clickValidRegion.contains(event.stageX, event.stageY))))){
                isClickValid = false;
                _timedDoubleClick.reset();
            };
            dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_MOVE);
        }
        public function get shadow():DisplayObject{
            return (_shadow);
        }
        protected function onOverlayMouseOver(event:MouseEvent):void{
            dispatchMouseEventIfEnabled(event, MapMouseEvent.ROLL_OVER);
        }
        protected function get camera():Camera{
            return ((_pane) ? _pane.getCamera() : null);
        }
        protected function getWorldClipPoly(param1:Boolean=false):Array{
            var _loc_2:Rectangle;
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:Array;
            var _loc_6:Array;
            var _loc_7:Boolean;
            var _loc_8:Point;
            var _loc_9:HPoint;
            var _loc_10:int;
            var _loc_11:Point;
            if (!is3DView()){
                return (getWorldClipPoly2D(param1));
            };
            _loc_2 = _pane.getViewportBounds();
            _loc_2.inflate(4, 4);
            _loc_3 = new Point((0.5 * (_loc_2.left + _loc_2.right)), (0.5 * (_loc_2.top + _loc_2.bottom)));
            _loc_4 = camera.viewportToWorld(_loc_3);
            _loc_5 = [new Point((_loc_4.x - 128), 0), new Point((_loc_4.x + 128), 0), new Point((_loc_4.x + 128), 0x0100), new Point((_loc_4.x - 128), 0x0100)];
            _loc_6 = [_loc_2.topLeft, new Point(_loc_2.right, _loc_2.top), _loc_2.bottomRight, new Point(_loc_2.left, _loc_2.bottom)];
            _loc_7 = true;
            _loc_10 = 0;
            while (_loc_10 < 4) {
                _loc_8 = _loc_6[_loc_10];
                _loc_9 = camera.viewportToWorldHPoint(_loc_8);
                if (_loc_9.w < 0){
                    _loc_11 = _loc_9.euclideanPoint();
                    if (!_loc_7){
                        _loc_5 = clipPolyToEdge(_loc_5, _loc_11, getProjectedViewportEdgeDirection(_loc_8, ((_loc_10 + 3) % 4)));
                    };
                    _loc_5 = clipPolyToEdge(_loc_5, _loc_11, getProjectedViewportEdgeDirection(_loc_8, _loc_10));
                    _loc_7 = true;
                } else {
                    _loc_7 = false;
                };
                _loc_10++;
            };
            if (!_loc_7){
                _loc_8 = _loc_6[0];
                _loc_9 = camera.viewportToWorldHPoint(_loc_8);
                if (_loc_9.w < 0){
                    _loc_5 = clipPolyToEdge(_loc_5, _loc_9.euclideanPoint(), getProjectedViewportEdgeDirection(_loc_8, 3));
                };
            };
            return (_loc_5);
        }
        protected function worldPointToPane(param1:Point, param2:Number, param3:Point, param4:Point):void{
            var _loc_5:Point;
            if (is3DView()){
                _loc_5 = camera.worldToViewport(param3.add(param1));
                param4.x = _loc_5.x;
                param4.y = _loc_5.y;
            } else {
                param4.x = (param2 * (param1.x + param3.x));
                param4.y = (param2 * (param1.y + param3.y));
            };
        }
        public function hide():void{
            visible = false;
        }
        public function get foreground():DisplayObject{
            return (_foreground);
        }
        protected function getProjection():IProjection{
            return (map.getCurrentMapType().getProjection());
        }
        protected function onAddedToPane():void{
            mouse.addListener(foreground, MouseEvent.ROLL_OVER, onOverlayMouseOver);
            mouse.addListener(foreground, MouseEvent.ROLL_OUT, onOverlayMouseOut);
            mouse.addListener(foreground, MouseEvent.CLICK, onOverlayClick);
            mouse.addListener(foreground, MouseEvent.MOUSE_DOWN, onOverlayMouseDown);
            mouse.addListener(foreground, MouseEvent.MOUSE_UP, onOverlayMouseUp);
            mouse.addListener(foreground, MouseEvent.MOUSE_MOVE, onOverlayMouseMove);
        }
        protected function getMouseEventLatLng(event:MouseEvent):LatLng{
            var _loc_2:Point;
            var _loc_3:Point;
            _loc_2 = new Point(event.stageX, event.stageY);
            _loc_3 = _pane.getForeground().globalToLocal(_loc_2);
            return (LatLng.wrapLatLng(camera.viewportToLatLng(_loc_3)));
        }
        protected function onRemovedFromPane():void{
            mouse.removeListener(foreground, MouseEvent.ROLL_OVER, onOverlayMouseOver);
            mouse.removeListener(foreground, MouseEvent.ROLL_OUT, onOverlayMouseOut);
            mouse.removeListener(foreground, MouseEvent.CLICK, onOverlayClick);
            mouse.removeListener(foreground, MouseEvent.MOUSE_DOWN, onOverlayMouseDown);
            mouse.removeListener(foreground, MouseEvent.MOUSE_UP, onOverlayMouseUp);
            mouse.removeListener(foreground, MouseEvent.MOUSE_MOVE, onOverlayMouseMove);
        }
        private function canDispatchMouseEvents():Boolean{
            return (!(((_overlayFlags & FLAG_DISPATCHMOUSEEVENTS) == 0)));
        }
        public function set pane(param1:IPane):void{
            if (param1){
                _pane = IPaneInternal(param1);
                onAddedToPane();
            } else {
                onRemovedFromPane();
                _pane = null;
            };
        }
        private function hasShadow():Boolean{
            return (!(((_overlayFlags & FLAG_HASSHADOW) == 0)));
        }
        protected function get map():IMapBase2{
            return ((_pane) ? _pane.getMapInstance() : null);
        }
        public function getPane():IPane{
            return (pane);
        }
        protected function is3DView():Boolean{
            return (map.getCamera().is3D);
        }
        public function set visible(param1:Boolean):void{
            if (_visible == param1){
                return;
            };
            _visible = param1;
            foreground.visible = param1;
            if (shadow){
                shadow.visible = param1;
            };
            if (param1){
                redraw();
            };
            if (map){
                map.dispatchEvent(new MapEvent(MapEvent.VISIBILITY_CHANGED, this));
            };
            dispatchEvent(new MapEvent(MapEvent.VISIBILITY_CHANGED, this));
        }
        public function positionOverlay(param1:Boolean):void{
        }
        public function getDisplayObject():DisplayObject{
            return (foreground);
        }
        protected function latLngToWorld(param1:LatLng):Point{
            return (getProjection().fromLatLngToPixel(param1, 0));
        }
        public function get visible():Boolean{
            return (_visible);
        }
        protected function getWrapOffset(param1:LatLng):Number{
            var _loc_2:LatLng;
            _loc_2 = getLatLngClosestToCenter(param1);
            return ((camera.latLngToViewport(_loc_2).x - camera.latLngToViewport(param1).x));
        }
        public function isHidden():Boolean{
            return (!(visible));
        }
        protected function onOverlayMouseDown(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            isClickValid = true;
            clickValidRegion = new Rectangle(event.stageX, event.stageY);
            if (map){
                _loc_2 = map.mouseClickRange;
                clickValidRegion.inflate(_loc_2, _loc_2);
            };
            dispatchMouseEventIfEnabled(event, MapMouseEvent.MOUSE_DOWN);
        }
        public function get pane():IPane{
            return (_pane);
        }
        protected function onOverlayMouseOut(event:MouseEvent):void{
            dispatchMouseEventIfEnabled(event, MapMouseEvent.ROLL_OUT);
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
