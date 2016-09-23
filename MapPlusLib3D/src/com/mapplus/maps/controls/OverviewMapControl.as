//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;

    public class OverviewMapControl extends IWrappableSpriteWrapper implements IOverviewMapControl, IEventDispatcher {

        private static const ZOOM_WINDOW_MAX_FACTOR:Number = 0.66;
        private static const DRAG_MAP:uint = 1;
        private static const DRAG_NULL:uint = 0;
        private static const DRAG_NAVI:uint = 2;
        private static const NAVIGATOR_COLOR:Number = 4474043;

        private var container:Sprite;
        private var contentMask:Sprite;
        private var _oldLatLng:LatLng;
        private var _state:Number;
        private var ignoreMapMoveEvents:Boolean;
        private var options:OverviewMapControlOptions;
        private var mapView:MapImpl;
        private var _latLng:LatLng;
        private var zoomDelta:Number;
        private var background:Sprite;
        private var _dragging:Number;
        private var _dragNaviPoint:Point;
        private var _dragPoint:Point;
        private var _newLatLng:LatLng;
        private var _naviNew:Sprite;
        private var map:IMap;
        private var _dragMousePoint:Point;
        private var _naviOld:Sprite;
        private var navigatorSize:Point;
        private var content:Sprite;

        public function OverviewMapControl(param1:OverviewMapControlOptions=null){
            super();
            var _loc_2:Object;
            _loc_2 = {};
            this.options = OverviewMapControlOptions.merge([getDefaultOptions(), param1]);
            _dragPoint = new Point(0, 0);
            _dragging = DRAG_NULL;
            _state = 0;
            ignoreMapMoveEvents = false;
            zoomDelta = 32;
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
        private static function getLocalCoords(event:MouseEvent, param2:DisplayObject):Point{
            return (param2.globalToLocal(new Point(event.stageX, event.stageY)));
        }

        private function resizeNavigator():void{
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Point;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            if (!mainAndOverviewMapsLoaded()){
                return;
            };
            _loc_1 = ((navigatorSize) || (new Point(0, 0)));
            _loc_2 = Math.floor(map.getZoom());
            _loc_3 = map.getSize();
            _loc_4 = mapView.getZoom();
            _loc_5 = Math.pow(mapView.getCamera().base, (_loc_4 - _loc_2));
            navigatorSize = new Point((_loc_3.x * _loc_5), (_loc_3.y * _loc_5));
            if (((!((navigatorSize.x == _loc_1.x))) || (!((navigatorSize.y == _loc_1.y))))){
                drawNavigator();
            };
            if ((((navigatorSize.x >= viewportWidth)) || ((navigatorSize.y >= viewportHeight)))){
                _naviNew.visible = false;
            } else {
                _naviNew.visible = true;
            };
        }
        private function getXYFromLatLng(param1:LatLng, param2:Number):Point{
            var _loc_3:Point;
            _loc_3 = getProjection().fromLatLngToPixel(param1, param2);
            return (_loc_3);
        }
        public function size():void{
            contentMask.graphics.clear();
            Render.drawRect(contentMask, new Rectangle(borderThicknessX, borderThicknessY, viewportWidth, viewportHeight), Color.BLACK, Alpha.PERCENT_50, Color.BLACK, Alpha.UNSEEN);
            mapView.setSize(new Point(viewportWidth, viewportHeight));
            mapView.getDisplayObject().x = borderThicknessX;
            mapView.getDisplayObject().y = borderThicknessY;
            calculateZoomDelta();
            invalidate();
        }
        private function stopMousePropagation(event:MouseEvent):void{
            event.stopPropagation();
        }
        private function onMapResized(event:Event):void{
            setmapView();
        }
        private function onMapMoveEnd(event:Event):void{
            if (_dragging == DRAG_NULL){
                _newLatLng = map.getCenter();
                _latLng = map.getCenter();
                setmapView();
                _naviOld.visible = false;
                _state = 0;
                ignoreMapMoveEvents = false;
            };
        }
        override public function get interfaceChain():Array{
            return (["IOverviewMapControl", "IControl"]);
        }
        private function onMapDragStart(event:Event):void{
            ignoreMapMoveEvents = false;
            _naviOld.visible = false;
            _state = 0;
        }
        public function getDisplayObject():DisplayObject{
            return (container);
        }
        public function redraw():void{
            background.graphics.clear();
            background.filters = Render.createBevelFilters(options.controlStyle);
            Render.drawRectOutlineStyle(background.graphics, new Rectangle(0, 0, options.size.x, options.size.y), options.controlStyle.strokeStyle, options.controlStyle.fillStyle);
            updateNavigator();
        }
        private function dragNow(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:Point;
            if (_dragging == DRAG_NULL){
                return;
            };
            _loc_3 = mapView.getZoom();
            if (_dragging == DRAG_MAP){
                _loc_4 = getLocalCoords(param2, container);
                _dragPoint = _dragPoint.add(_dragMousePoint.subtract(_loc_4));
                _dragPoint.y = clampToMapHeight(_dragPoint.y);
                _latLng = getLatLngFromXY(_dragPoint, _loc_3);
                _newLatLng = _latLng.clone();
                mapView.setCenter(_latLng);
                updateNavigator();
                _dragMousePoint = _loc_4;
            };
            if (_dragging == DRAG_NAVI){
                _loc_5 = getLocalCoords(param2, container);
                _dragPoint = _dragPoint.add(_loc_5.subtract(_dragNaviPoint));
                _dragPoint.y = clampToMapHeight(_dragPoint.y);
                _newLatLng = getLatLngFromXY(_dragPoint, _loc_3);
                _loc_6 = getXYFromLatLng(_latLng, _loc_3);
                if ((((Math.abs((_loc_6.x - _dragPoint.x)) > (viewportWidth / 2))) || ((Math.abs((_loc_6.y - _dragPoint.y)) > (viewportHeight / 2))))){
                    _naviNew.addEventListener(Event.ENTER_FRAME, dragAuto);
                } else {
                    _naviNew.removeEventListener(Event.ENTER_FRAME, dragAuto);
                };
                updateNavigator();
                _dragNaviPoint = _loc_5;
            };
        }
        private function dragAuto(event:Event):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Point;
            event.stopPropagation();
            if (_dragging != DRAG_NAVI){
                return;
            };
            _loc_2 = 0;
            _loc_3 = 0;
            _loc_4 = borderThicknessX;
            _loc_5 = borderThicknessY;
            _loc_6 = mapView.getZoom();
            if (_naviNew.x < _loc_4){
                _loc_2 = ((_loc_4 - _naviNew.x) / 5);
            } else {
                if ((_naviNew.x + navigatorSize.x) > (viewportWidth + _loc_4)){
                    _loc_2 = (((viewportWidth + _loc_4) - (_naviNew.x + navigatorSize.x)) / 5);
                };
            };
            if (_naviNew.y < _loc_5){
                _loc_3 = ((_loc_5 - _naviNew.y) / 5);
            } else {
                if ((_naviNew.y + navigatorSize.y) > (viewportHeight + _loc_5)){
                    _loc_3 = (((viewportHeight + _loc_5) - (_naviNew.y + navigatorSize.y)) / 5);
                };
            };
            if (((!((_loc_2 == 0))) || (!((_loc_3 == 0))))){
                _dragPoint.x = (_dragPoint.x - _loc_2);
                _dragPoint.y = (_dragPoint.y - _loc_3);
                _dragPoint.y = clampToMapHeight(_dragPoint.y);
                _newLatLng = getLatLngFromXY(_dragPoint, _loc_6);
                _loc_7 = getXYFromLatLng(_latLng, _loc_6);
                getXYFromLatLng(_latLng, _loc_6).x = (_loc_7.x - _loc_2);
                _loc_7.y = (_loc_7.y - _loc_3);
                _latLng = getLatLngFromXY(_loc_7, _loc_6);
                mapView.setCenter(_latLng);
                updateNavigator();
                _dragPoint = getXYFromLatLng(_newLatLng, _loc_6);
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
            if (!mainAndOverviewMapsLoaded()){
                return;
            };
            _loc_1 = mapView.getZoom();
            _loc_2 = getXYFromLatLng(_latLng, _loc_1);
            _loc_3 = getXYFromLatLng(_newLatLng, _loc_1);
            _loc_4 = ((((width - navigatorSize.x) / 2) + _loc_3.x) - _loc_2.x);
            _loc_5 = ((((height - navigatorSize.y) / 2) + _loc_3.y) - _loc_2.y);
            _loc_6 = getProjection().getWrapWidth(_loc_1);
            _loc_7 = MapUtil.wrapHalfOpen(_loc_4, ((width - _loc_6) / 2), ((width + _loc_6) / 2));
            _naviNew.x = _loc_7;
            _naviNew.y = _loc_5;
            if (_naviOld.visible){
                _loc_3 = getXYFromLatLng(_oldLatLng, _loc_1);
                _loc_4 = ((((width - navigatorSize.x) / 2) + _loc_3.x) - _loc_2.x);
                _loc_5 = ((((height - navigatorSize.y) / 2) + _loc_3.y) - _loc_2.y);
                _loc_7 = MapUtil.wrapHalfOpen(_loc_4, ((width - _loc_6) / 2), ((width + _loc_6) / 2));
                _naviOld.x = _loc_7;
                _naviOld.y = _loc_5;
            };
        }
        public function updatePlacement():void{
            mapView.setSize(new Point(viewportWidth, viewportHeight));
            calculateZoomDelta();
            resizeNavigator();
        }
        private function dragStart(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            event.stopPropagation();
            MouseHandler.instance().addGlobalMouseMoveListener(dragNow);
            MouseHandler.instance().addGlobalMouseUpListener(dragStop);
            _loc_2 = mapView.getZoom();
            _dragPoint = getXYFromLatLng(_latLng, _loc_2);
            _dragMousePoint = getLocalCoords(event, container);
            if (!_naviNew.visible){
                _dragging = DRAG_MAP;
            } else {
                if ((((((((_dragMousePoint.x >= _naviNew.x)) && ((_dragMousePoint.x <= (_naviNew.x + navigatorSize.x))))) && ((_dragMousePoint.y >= _naviNew.y)))) && ((_dragMousePoint.y <= (_naviNew.y + navigatorSize.y))))){
                    _dragNaviPoint = getLocalCoords(event, container);
                    _dragging = DRAG_NAVI;
                } else {
                    _dragging = DRAG_MAP;
                };
            };
            if (_naviNew.visible){
                _naviOld.visible = true;
            };
            _oldLatLng = _latLng.clone();
            _state = 0;
            updateNavigator();
        }
        public function get height():Number{
            return (options.size.y);
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!container){
                container = getSprite();
            };
        }
        private function onMapZoomChanged(event:Event):void{
            setmapView();
        }
        private function onMapViewDoubleClick(event:Event):void{
            var _loc_2:MapMouseEvent;
            _loc_2 = (event as MapMouseEvent);
            if (_loc_2){
                map.panTo(_loc_2.latLng);
            };
        }
        public function setSize(param1:Point):void{
            options.size = param1;
            size();
            updatePlacement();
        }
        private function get borderThicknessY():Number{
            return ((Number(options.controlStyle.strokeStyle.thickness) + options.padding.y));
        }
        private function clampToMapHeight(param1:Number):Number{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = mapView.getZoom();
            _loc_3 = getProjection().getWrapWidth(_loc_2);
            return (Util.bound(param1, 0, _loc_3));
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
        }
        public function invalidate():void{
            DelayHandler.delayCall(redraw);
        }
        private function onMapReady(event:Event=null):void{
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            _latLng = map.getCenter();
            _newLatLng = map.getCenter();
            setmapView();
            map.placeControl(this, getControlPosition());
        }
        private function get borderThicknessX():Number{
            return ((Number(options.controlStyle.strokeStyle.thickness) + options.padding.x));
        }
        private function get viewportWidth():Number{
            return ((width - (borderThicknessX * 2)));
        }
        private function onMapMoveStart(event:Event):void{
        }
        private function getProjection():IProjection{
            return (mapView.getCurrentMapType().getProjection());
        }
        private function removeFromMap():void{
            var _loc_1:IMouse;
            while (content.numChildren) {
                content.removeChildAt(0);
            };
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(background, MouseEvent.MOUSE_DOWN, stopMousePropagation);
            _loc_1.removeListener(background, MouseEvent.MOUSE_WHEEL, stopMousePropagation);
            map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
            map.removeEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            map.removeEventListener(MapEvent.SIZE_CHANGED, onMapResized);
            map.removeEventListener(MapMoveEvent.MOVE_START, onMapMoveStart);
            map.removeEventListener(MapMoveEvent.MOVE_STEP, onMapMove);
            map.removeEventListener(MapMoveEvent.MOVE_END, onMapMoveEnd);
            map.removeEventListener(MapMouseEvent.MOUSE_DOWN, onMapPress);
            map.removeEventListener(MapMouseEvent.DRAG_START, onMapDragStart);
            map.removeEventListener(MapMouseEvent.DRAG_END, onMapDragEnd);
            map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, onMapZoomChanged);
            mapView.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapViewReadyInternal);
            mapView.removeEventListener(MapMouseEvent.DRAG_END, onMapViewDragEnd);
            mapView.removeEventListener(MapMouseEvent.DOUBLE_CLICK, onMapViewDoubleClick);
            mapView.unload();
        }
        private function onMapPress(event:Event):void{
            _naviOld.visible = false;
            _state = 0;
            updateNavigator();
        }
        private function getLatLngFromXY(param1:Point, param2:Number):LatLng{
            var _loc_3:LatLng;
            _loc_3 = getProjection().fromPixelToLatLng(param1, param2);
            return (_loc_3);
        }
        public function initControlWithMap(param1:IMap):void{
            var _loc_2:Sprite;
            var _loc_3:IMouse;
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (param1){
                background = new Sprite();
                container.addChild(background);
                content = Bootstrap.createChildComponent(container);
                _loc_2 = Bootstrap.createChildComponent(content);
                _loc_2.mouseEnabled = false;
                mapView = new MapImpl(UsageTracker.URL_ARGVAL_USAGETYPE_OVERVIEW);
                mapView.legacyInitialize(_loc_2, _loc_2);
                mapView.setSize(new Point(viewportWidth, viewportHeight));
                mapView.suppressCopyrightInternal((param1 as MapImpl));
                mapView.disableControlByKeyboard();
                mapView.setDoubleClickMode(MapAction.ACTION_PAN);
                _naviOld = Bootstrap.createChildSprite(content);
                _naviOld.visible = false;
                _naviOld.mouseEnabled = false;
                _naviOld.mouseChildren = false;
                _naviNew = Bootstrap.createChildSprite(content);
                contentMask = Bootstrap.createChildSprite(container);
                content.mask = contentMask;
                _loc_3 = MouseHandler.instance();
                _loc_3.addListener(content, MouseEvent.MOUSE_DOWN, dragStart);
                param1.addEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
                param1.addEventListener(MapEvent.SIZE_CHANGED, onMapResized);
                param1.addEventListener(MapMoveEvent.MOVE_START, onMapMoveStart);
                param1.addEventListener(MapMoveEvent.MOVE_STEP, onMapMove);
                param1.addEventListener(MapMoveEvent.MOVE_END, onMapMoveEnd);
                param1.addEventListener(MapMouseEvent.MOUSE_DOWN, onMapPress);
                param1.addEventListener(MapMouseEvent.DRAG_START, onMapDragStart);
                param1.addEventListener(MapMouseEvent.DRAG_END, onMapDragEnd);
                param1.addEventListener(MapZoomEvent.ZOOM_CHANGED, onMapZoomChanged);
                mapView.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapViewReadyInternal);
                mapView.addEventListener(MapMouseEvent.DRAG_END, onMapViewDragEnd);
                mapView.addEventListener(MapMouseEvent.DOUBLE_CLICK, onMapViewDoubleClick);
                if (param1.isLoaded()){
                    onMapReady();
                } else {
                    param1.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReady);
                };
                size();
                redraw();
            };
        }
        private function setmapView():void{
            if (!mainAndOverviewMapsLoaded()){
                return;
            };
            calculateZoomDelta();
            mapView.setCenter(map.getCenter(), getOverviewMapZoom(), getOverviewMapType());
            resizeNavigator();
            updateNavigator();
        }
        public function get width():Number{
            return (options.size.x);
        }
        private function dragStop(param1:Boolean, param2:MouseEvent):void{
            if (_dragging == DRAG_MAP){
                _dragging = DRAG_NULL;
                _state = 1;
                ignoreMapMoveEvents = true;
                map.panTo(_latLng);
                _oldLatLng = _latLng.clone();
            };
            if (_dragging == DRAG_NAVI){
                _dragging = DRAG_NULL;
                _state = 2;
                map.panTo(_newLatLng);
            };
            MouseHandler.instance().removeGlobalMouseMoveListener(dragNow);
            MouseHandler.instance().removeGlobalMouseUpListener(dragStop);
        }
        private function onMapDragEnd(event:Event):void{
            ignoreMapMoveEvents = false;
            _newLatLng = map.getCenter();
            _latLng = map.getCenter();
            setmapView();
        }
        private function mainAndOverviewMapsLoaded():Boolean{
            return (((map.isLoaded()) && (mapView.isLoaded())));
        }
        private function onMapTypeChanged(event:Event):void{
            setmapView();
        }
        private function getOverviewMapType():IMapType{
            var _loc_1:IMapType;
            _loc_1 = map.getCurrentMapType();
            if ((((_loc_1 == Bootstrap.getBootstrap().getSatelliteMapType())) || ((_loc_1 == Bootstrap.getBootstrap().getHybridMapType())))){
                _loc_1 = ((Math.floor(map.getZoom()) < 6)) ? Bootstrap.getBootstrap().getSatelliteMapType() : Bootstrap.getBootstrap().getHybridMapType();
            };
            return (_loc_1);
        }
        private function getOverviewMapZoom():Number{
            var _loc_1:Number = NaN;
            _loc_1 = Math.floor((map.getZoom() - zoomDelta));
            return (((_loc_1 >= 0)) ? _loc_1 : 0);
        }
        public function setControlPosition(param1:ControlPosition):void{
            options.position = param1;
            if (map){
                map.placeControl(this, getControlPosition());
            };
        }
        private function onMapViewReadyInternal(event:Event):void{
            setmapView();
        }
        private function calculateZoomDelta():void{
            var _loc_6:*;
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!mainAndOverviewMapsLoaded()){
                return;
            };
            _loc_1 = map.getSize();
            _loc_2 = (width * ZOOM_WINDOW_MAX_FACTOR);
            _loc_3 = (height * ZOOM_WINDOW_MAX_FACTOR);
            zoomDelta = 0;
            _loc_4 = (map as MapImpl).getCamera().base;
            while ((((_loc_2 < _loc_1.x)) || ((_loc_3 < _loc_1.y)))) {
                _loc_6 = (zoomDelta + 1);
                zoomDelta = _loc_6;
                _loc_2 = (_loc_2 * _loc_4);
                _loc_3 = (_loc_3 * _loc_4);
            };
        }
        private function onMapViewDragEnd(event:Event):void{
            map.panTo(mapView.getCenter());
        }
        private function get viewportHeight():Number{
            return ((height - (borderThicknessY * 2)));
        }
        private function drawNavigator():void{
            var _loc_1:Rectangle;
            _loc_1 = new Rectangle(0, 0, navigatorSize.x, navigatorSize.y);
            _naviNew.graphics.clear();
            Render.drawRectOutlineStyle(_naviNew.graphics, _loc_1, options.navigatorStyle.strokeStyle, options.navigatorStyle.fillStyle);
            _naviOld.graphics.clear();
            Render.drawRectOutlineStyle(_naviOld.graphics, _loc_1, options.navigatorStyle.strokeStyle, options.navigatorStyle.fillStyle);
        }
        private function onMapMove(event:Event):void{
            if (!mainAndOverviewMapsLoaded()){
                return;
            };
            if (_dragging != DRAG_NULL){
                return;
            };
            if (_state == 1){
                _oldLatLng = _latLng.clone();
                updateNavigator();
            } else {
                if (_state == 2){
                    _latLng = map.getCenter();
                    _oldLatLng = _latLng.clone();
                    setmapView();
                } else {
                    if (!ignoreMapMoveEvents){
                        _latLng = map.getCenter();
                        _newLatLng = _latLng.clone();
                        setmapView();
                    };
                };
            };
        }
        public function getControlPosition():ControlPosition{
            return (options.position);
        }
        public function getSize():Point{
            return (new Point(width, height));
        }

    }
}//package com.mapplus.maps.controls 
