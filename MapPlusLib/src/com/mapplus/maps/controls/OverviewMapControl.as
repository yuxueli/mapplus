//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.geom.*;
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;

    public class OverviewMapControl extends IWrappableSpriteWrapper implements IOverviewMapControl, IEventDispatcher {

        private static const ZOOM_WINDOW_MAX_FACTOR:Number = 0.66;
        private static const DRAG_MAP:uint = 1;
        private static const DRAG_NULL:uint = 0;
        private static const DRAG_NAVI:uint = 2;
        private static const NAVIGATOR_COLOR:Number = 4474043;

        private var contentMask:Sprite;
        private var ignoreMapMoveEvents:Boolean;
        private var mapView:MapImpl;
        private var _latLng:LatLng;
        private var background:Sprite;
        private var _dragPoint:Point;
        private var _newLatLng:LatLng;
        private var map:IMap;
        private var _dragMousePoint:Point;
        private var _naviOld:Sprite;
        private var content:Sprite;
        private var container:Sprite;
        private var _oldLatLng:LatLng;
        private var _state:Number;
        private var zoomDelta:Number;
        private var options:OverviewMapControlOptions;
        private var _dragging:Number;
        private var _dragNaviPoint:Point;
        private var _naviNew:Sprite;
        private var navigatorSize:Point;

        public function OverviewMapControl(param1:OverviewMapControlOptions=null){
            super();
            var _loc_2:Object;
            _loc_2 = {};
            this.options = OverviewMapControlOptions.merge([getDefaultOptions(), param1]);
            this._dragPoint = new Point(0, 0);
            this._dragging = DRAG_NULL;
            this._state = 0;
            this.ignoreMapMoveEvents = false;
            this.zoomDelta = 32;
        }
        private static function getLocalCoords(event:MouseEvent, param2:DisplayObject):Point{
            return (param2.globalToLocal(new Point(event.stageX, event.stageY)));
        }
        private static function getDefaultOptions():OverviewMapControlOptions{
            return (new OverviewMapControlOptions({
                size:{
                    x:100,
                    y:100
                },
                padding:{
                    x:4,
                    y:4
                },
                controlStyle:{
                    fillStyle:{
                        color:Color.WHITE,
                        alpha:1
                    },
                    strokeStyle:{
                        color:Color.BLACK,
                        alpha:1,
                        thickness:1
                    },
                    bevelStyle:BevelStyle.BEVEL_RAISED,
                    bevelThickness:2,
                    bevelAlpha:0.6,
                    highlightColor:Color.WHITE,
                    shadowColor:Color.BLACK
                },
                navigatorStyle:{
                    fillStyle:{
                        color:NAVIGATOR_COLOR,
                        alpha:Alpha.PERCENT_20
                    },
                    strokeStyle:{
                        thickness:2,
                        color:NAVIGATOR_COLOR,
                        alpha:1
                    }
                },
                position:new ControlPosition(ControlPosition.ANCHOR_BOTTOM_RIGHT, 10)
            }));
        }

        public function size():void{
            this.contentMask.graphics.clear();
            Render.drawRect(this.contentMask, new Rectangle(this.borderThicknessX, this.borderThicknessY, this.viewportWidth, this.viewportHeight), Color.BLACK, Alpha.PERCENT_50, Color.BLACK, Alpha.UNSEEN);
            this.mapView.setSize(new Point(this.viewportWidth, this.viewportHeight));
            this.mapView.getDisplayObject().x = this.borderThicknessX;
            this.mapView.getDisplayObject().y = this.borderThicknessY;
            this.calculateZoomDelta();
            this.invalidate();
        }
        private function resizeNavigator():void{
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Point;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            if (!(this.mainAndOverviewMapsLoaded())){
                return;
            };
            _loc_1 = ((this.navigatorSize) || (new Point(0, 0)));
            _loc_2 = Math.floor(this.map.getZoom());
            _loc_3 = this.map.getSize();
            _loc_4 = this.mapView.getZoom();
            _loc_5 = Math.pow(this.mapView.getCamera().base, (_loc_4 - _loc_2));
            this.navigatorSize = new Point((_loc_3.x * _loc_5), (_loc_3.y * _loc_5));
            if (((!((this.navigatorSize.x == _loc_1.x))) || (!((this.navigatorSize.y == _loc_1.y))))){
                this.drawNavigator();
            };
            if ((((this.navigatorSize.x >= this.viewportWidth)) || ((this.navigatorSize.y >= this.viewportHeight)))){
                this._naviNew.visible = false;
            } else {
                this._naviNew.visible = true;
            };
        }
        override public function get interfaceChain():Array{
            return (["IOverviewMapControl", "IControl"]);
        }
        private function stopMousePropagation(event:MouseEvent):void{
            event.stopPropagation();
        }
        private function onMapDragStart(event:Event):void{
            this.ignoreMapMoveEvents = false;
            this._naviOld.visible = false;
            this._state = 0;
        }
        private function dragAuto(event:Event):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Point;
            event.stopPropagation();
            if (this._dragging != DRAG_NAVI){
                return;
            };
            _loc_2 = 0;
            _loc_3 = 0;
            _loc_4 = this.borderThicknessX;
            _loc_5 = this.borderThicknessY;
            _loc_6 = this.mapView.getZoom();
            if (this._naviNew.x < _loc_4){
                _loc_2 = ((_loc_4 - this._naviNew.x) / 5);
            } else {
                if ((this._naviNew.x + this.navigatorSize.x) > (this.viewportWidth + _loc_4)){
                    _loc_2 = (((this.viewportWidth + _loc_4) - (this._naviNew.x + this.navigatorSize.x)) / 5);
                };
            };
            if (this._naviNew.y < _loc_5){
                _loc_3 = ((_loc_5 - this._naviNew.y) / 5);
            } else {
                if ((this._naviNew.y + this.navigatorSize.y) > (this.viewportHeight + _loc_5)){
                    _loc_3 = (((this.viewportHeight + _loc_5) - (this._naviNew.y + this.navigatorSize.y)) / 5);
                };
            };
            if (((!((_loc_2 == 0))) || (!((_loc_3 == 0))))){
                this._dragPoint.x = (this._dragPoint.x - _loc_2);
                this._dragPoint.y = (this._dragPoint.y - _loc_3);
                this._dragPoint.y = this.clampToMapHeight(this._dragPoint.y);
                this._newLatLng = this.getLatLngFromXY(this._dragPoint, _loc_6);
                _loc_7 = this.getXYFromLatLng(this._latLng, _loc_6);
                this.getXYFromLatLng(this._latLng, _loc_6).x = (_loc_7.x - _loc_2);
                _loc_7.y = (_loc_7.y - _loc_3);
                this._latLng = this.getLatLngFromXY(_loc_7, _loc_6);
                this.mapView.setCenter(this._latLng);
                this.updateNavigator();
                this._dragPoint = this.getXYFromLatLng(this._newLatLng, _loc_6);
            };
        }
        private function dragNow(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:Point;
            if (this._dragging == DRAG_NULL){
                return;
            };
            _loc_3 = this.mapView.getZoom();
            if (this._dragging == DRAG_MAP){
                _loc_4 = getLocalCoords(param2, this.container);
                this._dragPoint = this._dragPoint.add(this._dragMousePoint.subtract(_loc_4));
                this._dragPoint.y = this.clampToMapHeight(this._dragPoint.y);
                this._latLng = this.getLatLngFromXY(this._dragPoint, _loc_3);
                this._newLatLng = this._latLng.clone();
                this.mapView.setCenter(this._latLng);
                this.updateNavigator();
                this._dragMousePoint = _loc_4;
            };
            if (this._dragging == DRAG_NAVI){
                _loc_5 = getLocalCoords(param2, this.container);
                this._dragPoint = this._dragPoint.add(_loc_5.subtract(this._dragNaviPoint));
                this._dragPoint.y = this.clampToMapHeight(this._dragPoint.y);
                this._newLatLng = this.getLatLngFromXY(this._dragPoint, _loc_3);
                _loc_6 = this.getXYFromLatLng(this._latLng, _loc_3);
                if ((((Math.abs((_loc_6.x - this._dragPoint.x)) > (this.viewportWidth / 2))) || ((Math.abs((_loc_6.y - this._dragPoint.y)) > (this.viewportHeight / 2))))){
                    this._naviNew.addEventListener(Event.ENTER_FRAME, this.dragAuto);
                } else {
                    this._naviNew.removeEventListener(Event.ENTER_FRAME, this.dragAuto);
                };
                this.updateNavigator();
                this._dragNaviPoint = _loc_5;
            };
        }
        public function updatePlacement():void{
            this.mapView.setSize(new Point(this.viewportWidth, this.viewportHeight));
            this.calculateZoomDelta();
            this.resizeNavigator();
        }
        public function get height():Number{
            return (this.options.size.y);
        }
        private function onMapZoomChanged(event:Event):void{
            this.setmapView();
        }
        private function removeFromMap():void{
            var _loc_1:IMouse;
            while (this.content.numChildren) {
                this.content.removeChildAt(0);
            };
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(this.background, MouseEvent.MOUSE_DOWN, this.stopMousePropagation);
            _loc_1.removeListener(this.background, MouseEvent.MOUSE_WHEEL, this.stopMousePropagation);
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this.map.removeEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
            this.map.removeEventListener(MapEvent.SIZE_CHANGED, this.onMapResized);
            this.map.removeEventListener(MapMoveEvent.MOVE_START, this.onMapMoveStart);
            this.map.removeEventListener(MapMoveEvent.MOVE_STEP, this.onMapMove);
            this.map.removeEventListener(MapMoveEvent.MOVE_END, this.onMapMoveEnd);
            this.map.removeEventListener(MapMouseEvent.MOUSE_DOWN, this.onMapPress);
            this.map.removeEventListener(MapMouseEvent.DRAG_START, this.onMapDragStart);
            this.map.removeEventListener(MapMouseEvent.DRAG_END, this.onMapDragEnd);
            this.map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, this.onMapZoomChanged);
            this.mapView.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapViewReadyInternal);
            this.mapView.removeEventListener(MapMouseEvent.DRAG_END, this.onMapViewDragEnd);
            this.mapView.removeEventListener(MapMouseEvent.DOUBLE_CLICK, this.onMapViewDoubleClick);
            this.mapView.unload();
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        public function invalidate():void{
            DelayHandler.delayCall(this.redraw);
        }
        private function getProjection():IProjection{
            return (this.mapView.getCurrentMapType().getProjection());
        }
        private function onMapPress(event:Event):void{
            this._naviOld.visible = false;
            this._state = 0;
            this.updateNavigator();
        }
        private function dragStop(param1:Boolean, param2:MouseEvent):void{
            if (this._dragging == DRAG_MAP){
                this._dragging = DRAG_NULL;
                this._state = 1;
                this.ignoreMapMoveEvents = true;
                this.map.panTo(this._latLng);
                this._oldLatLng = this._latLng.clone();
            };
            if (this._dragging == DRAG_NAVI){
                this._dragging = DRAG_NULL;
                this._state = 2;
                this.map.panTo(this._newLatLng);
            };
            MouseHandler.instance().removeGlobalMouseMoveListener(this.dragNow);
            MouseHandler.instance().removeGlobalMouseUpListener(this.dragStop);
        }
        private function getLatLngFromXY(param1:Point, param2:Number):LatLng{
            var _loc_3:LatLng;
            _loc_3 = this.getProjection().fromPixelToLatLng(param1, param2);
            return (_loc_3);
        }
        private function getOverviewMapZoom():Number{
            var _loc_1:Number = NaN;
            _loc_1 = Math.floor((this.map.getZoom() - this.zoomDelta));
            return (((_loc_1 >= 0)) ? _loc_1 : 0);
        }
        private function onMapViewReadyInternal(event:Event):void{
            this.setmapView();
        }
        private function get viewportHeight():Number{
            return ((this.height - (this.borderThicknessY * 2)));
        }
        public function getControlPosition():ControlPosition{
            return (this.options.position);
        }
        private function drawNavigator():void{
            var _loc_1:Rectangle;
            _loc_1 = new Rectangle(0, 0, this.navigatorSize.x, this.navigatorSize.y);
            this._naviNew.graphics.clear();
            Render.drawRectOutlineStyle(this._naviNew.graphics, _loc_1, this.options.navigatorStyle.strokeStyle, this.options.navigatorStyle.fillStyle);
            this._naviOld.graphics.clear();
            Render.drawRectOutlineStyle(this._naviOld.graphics, _loc_1, this.options.navigatorStyle.strokeStyle, this.options.navigatorStyle.fillStyle);
        }
        private function onMapViewDragEnd(event:Event):void{
            this.map.panTo(this.mapView.getCenter());
        }
        private function onMapMove(event:Event):void{
            if (!(this.mainAndOverviewMapsLoaded())){
                return;
            };
            if (this._dragging != DRAG_NULL){
                return;
            };
            if (this._state == 1){
                this._oldLatLng = this._latLng.clone();
                this.updateNavigator();
            } else {
                if (this._state == 2){
                    this._latLng = this.map.getCenter();
                    this._oldLatLng = this._latLng.clone();
                    this.setmapView();
                } else {
                    if (!(this.ignoreMapMoveEvents)){
                        this._latLng = this.map.getCenter();
                        this._newLatLng = this._latLng.clone();
                        this.setmapView();
                    };
                };
            };
        }
        public function getSize():Point{
            return (new Point(this.width, this.height));
        }
        private function setmapView():void{
            if (!(this.mainAndOverviewMapsLoaded())){
                return;
            };
            this.calculateZoomDelta();
            this.mapView.setCenter(this.map.getCenter(), this.getOverviewMapZoom(), this.getOverviewMapType());
            this.resizeNavigator();
            this.updateNavigator();
        }
        private function onMapResized(event:Event):void{
            this.setmapView();
        }
        public function setSize(param1:Point):void{
            this.options.size = param1;
            this.size();
            this.updatePlacement();
        }
        private function getXYFromLatLng(param1:LatLng, param2:Number):Point{
            var _loc_3:Point;
            _loc_3 = this.getProjection().fromLatLngToPixel(param1, param2);
            return (_loc_3);
        }
        private function onMapDragEnd(event:Event):void{
            this.ignoreMapMoveEvents = false;
            this._newLatLng = this.map.getCenter();
            this._latLng = this.map.getCenter();
            this.setmapView();
        }
        private function onMapMoveEnd(event:Event):void{
            if (this._dragging == DRAG_NULL){
                this._newLatLng = this.map.getCenter();
                this._latLng = this.map.getCenter();
                this.setmapView();
                this._naviOld.visible = false;
                this._state = 0;
                this.ignoreMapMoveEvents = false;
            };
        }
        private function onMapMoveStart(event:Event):void{
        }
        private function onMapViewDoubleClick(event:Event):void{
            var _loc_2:MapMouseEvent;
            _loc_2 = (event as MapMouseEvent);
            if (_loc_2){
                this.map.panTo(_loc_2.latLng);
            };
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!(this.container)){
                this.container = getSprite();
            };
        }
        public function updateNavigator():void{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (!(this.mainAndOverviewMapsLoaded())){
                return;
            };
            _loc_1 = this.mapView.getZoom();
            _loc_2 = this.getXYFromLatLng(this._latLng, _loc_1);
            _loc_3 = this.getXYFromLatLng(this._newLatLng, _loc_1);
            _loc_4 = ((((this.width - this.navigatorSize.x) / 2) + _loc_3.x) - _loc_2.x);
            _loc_5 = ((((this.height - this.navigatorSize.y) / 2) + _loc_3.y) - _loc_2.y);
            _loc_6 = this.getProjection().getWrapWidth(_loc_1);
            _loc_7 = MapUtil.wrapHalfOpen(_loc_4, ((this.width - _loc_6) / 2), ((this.width + _loc_6) / 2));
            this._naviNew.x = _loc_7;
            this._naviNew.y = _loc_5;
            if (this._naviOld.visible){
                _loc_3 = this.getXYFromLatLng(this._oldLatLng, _loc_1);
                _loc_4 = ((((this.width - this.navigatorSize.x) / 2) + _loc_3.x) - _loc_2.x);
                _loc_5 = ((((this.height - this.navigatorSize.y) / 2) + _loc_3.y) - _loc_2.y);
                _loc_7 = MapUtil.wrapHalfOpen(_loc_4, ((this.width - _loc_6) / 2), ((this.width + _loc_6) / 2));
                this._naviOld.x = _loc_7;
                this._naviOld.y = _loc_5;
            };
        }
        private function dragStart(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            event.stopPropagation();
            MouseHandler.instance().addGlobalMouseMoveListener(this.dragNow);
            MouseHandler.instance().addGlobalMouseUpListener(this.dragStop);
            _loc_2 = this.mapView.getZoom();
            this._dragPoint = this.getXYFromLatLng(this._latLng, _loc_2);
            this._dragMousePoint = getLocalCoords(event, this.container);
            if (!(this._naviNew.visible)){
                this._dragging = DRAG_MAP;
            } else {
                if ((((((((this._dragMousePoint.x >= this._naviNew.x)) && ((this._dragMousePoint.x <= (this._naviNew.x + this.navigatorSize.x))))) && ((this._dragMousePoint.y >= this._naviNew.y)))) && ((this._dragMousePoint.y <= (this._naviNew.y + this.navigatorSize.y))))){
                    this._dragNaviPoint = getLocalCoords(event, this.container);
                    this._dragging = DRAG_NAVI;
                } else {
                    this._dragging = DRAG_MAP;
                };
            };
            if (this._naviNew.visible){
                this._naviOld.visible = true;
            };
            this._oldLatLng = this._latLng.clone();
            this._state = 0;
            this.updateNavigator();
        }
        private function get borderThicknessY():Number{
            return ((Number(this.options.controlStyle.strokeStyle.thickness) + this.options.padding.y));
        }
        private function clampToMapHeight(param1:Number):Number{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = this.mapView.getZoom();
            _loc_3 = this.getProjection().getWrapWidth(_loc_2);
            return (Util.bound(param1, 0, _loc_3));
        }
        private function onMapReady(event:Event=null):void{
            this.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
            this._latLng = this.map.getCenter();
            this._newLatLng = this.map.getCenter();
            this.setmapView();
            this.map.placeControl(this, this.getControlPosition());
        }
        private function get borderThicknessX():Number{
            return ((Number(this.options.controlStyle.strokeStyle.thickness) + this.options.padding.x));
        }
        private function get viewportWidth():Number{
            return ((this.width - (this.borderThicknessX * 2)));
        }
        public function get width():Number{
            return (this.options.size.x);
        }
        private function getOverviewMapType():IMapType{
            var _loc_1:IMapType;
            _loc_1 = this.map.getCurrentMapType();
            if ((((_loc_1 == Bootstrap.getBootstrap().getSatelliteMapType())) || ((_loc_1 == Bootstrap.getBootstrap().getHybridMapType())))){
                _loc_1 = ((Math.floor(this.map.getZoom()) < 6)) ? Bootstrap.getBootstrap().getSatelliteMapType() : Bootstrap.getBootstrap().getHybridMapType();
            };
            return (_loc_1);
        }
        public function initControlWithMap(param1:IMap):void{
            var _loc_2:Sprite;
            var _loc_3:IMouse;
            if (this.map){
                this.removeFromMap();
            };
            this.map = param1;
            if (param1){
                this.background = new Sprite();
                this.container.addChild(this.background);
                this.content = Bootstrap.createChildComponent(this.container);
                _loc_2 = Bootstrap.createChildComponent(this.content);
                _loc_2.mouseEnabled = false;
                this.mapView = new MapImpl(UsageTracker.URL_ARGVAL_USAGETYPE_OVERVIEW);
                this.mapView.legacyInitialize(_loc_2, _loc_2);
                this.mapView.setSize(new Point(this.viewportWidth, this.viewportHeight));
                this.mapView.suppressCopyrightInternal((param1 as MapImpl));
                this.mapView.disableControlByKeyboard();
                this.mapView.setDoubleClickMode(MapAction.ACTION_PAN);
                this._naviOld = Bootstrap.createChildSprite(this.content);
                this._naviOld.visible = false;
                this._naviOld.mouseEnabled = false;
                this._naviOld.mouseChildren = false;
                this._naviNew = Bootstrap.createChildSprite(this.content);
                this.contentMask = Bootstrap.createChildSprite(this.container);
                this.content.mask = this.contentMask;
                _loc_3 = MouseHandler.instance();
                _loc_3.addListener(this.content, MouseEvent.MOUSE_DOWN, this.dragStart);
                param1.addEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
                param1.addEventListener(MapEvent.SIZE_CHANGED, this.onMapResized);
                param1.addEventListener(MapMoveEvent.MOVE_START, this.onMapMoveStart);
                param1.addEventListener(MapMoveEvent.MOVE_STEP, this.onMapMove);
                param1.addEventListener(MapMoveEvent.MOVE_END, this.onMapMoveEnd);
                param1.addEventListener(MapMouseEvent.MOUSE_DOWN, this.onMapPress);
                param1.addEventListener(MapMouseEvent.DRAG_START, this.onMapDragStart);
                param1.addEventListener(MapMouseEvent.DRAG_END, this.onMapDragEnd);
                param1.addEventListener(MapZoomEvent.ZOOM_CHANGED, this.onMapZoomChanged);
                this.mapView.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapViewReadyInternal);
                this.mapView.addEventListener(MapMouseEvent.DRAG_END, this.onMapViewDragEnd);
                this.mapView.addEventListener(MapMouseEvent.DOUBLE_CLICK, this.onMapViewDoubleClick);
                if (param1.isLoaded()){
                    this.onMapReady();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReady);
                };
                this.size();
                this.redraw();
            };
        }
        private function mainAndOverviewMapsLoaded():Boolean{
            return (((this.map.isLoaded()) && (this.mapView.isLoaded())));
        }
        private function onMapTypeChanged(event:Event):void{
            this.setmapView();
        }
        private function calculateZoomDelta():void{
            var _loc_6:*;
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!(this.mainAndOverviewMapsLoaded())){
                return;
            };
            _loc_1 = this.map.getSize();
            _loc_2 = (this.width * ZOOM_WINDOW_MAX_FACTOR);
            _loc_3 = (this.height * ZOOM_WINDOW_MAX_FACTOR);
            this.zoomDelta = 0;
            _loc_4 = (this.map as MapImpl).getCamera().base;
            while ((((_loc_2 < _loc_1.x)) || ((_loc_3 < _loc_1.y)))) {
                _loc_6 = (this.zoomDelta + 1);
                this.zoomDelta = _loc_6;
                _loc_2 = (_loc_2 * _loc_4);
                _loc_3 = (_loc_3 * _loc_4);
            };
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, this.getControlPosition());
            };
        }
        public function redraw():void{
            this.background.graphics.clear();
            this.background.filters = Render.createBevelFilters(this.options.controlStyle);
            Render.drawRectOutlineStyle(this.background.graphics, new Rectangle(0, 0, this.options.size.x, this.options.size.y), this.options.controlStyle.strokeStyle, this.options.controlStyle.fillStyle);
            this.updateNavigator();
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }

    }
}//package com.mapplus.maps.controls 
