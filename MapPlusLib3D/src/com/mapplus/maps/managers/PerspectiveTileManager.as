//Created by yuxueli 2011.6.6
package com.mapplus.maps.managers {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class PerspectiveTileManager implements ITileManager {

        private var container:Sprite;
        private var prevMapType:IMapType;
        private var currentMapType:IMapType;
        private var spriteFactory:ISpriteFactory;
        private var currentAttitude:Attitude;
        private var tilesLoadedPending:Boolean;
        private var tileEnumerator:TileEnumerator;
        private var shouldUpdate:Boolean;
        private var isDragging:Boolean;
        private var parent:Sprite;
        private var map:IMap;
        private var currentZoom:Number;
        private var currentCenter:LatLng;
        private var loadScheduler:LoadScheduler;
        private var tilePanes:Array;

        public function PerspectiveTileManager(param1:IMap, param2:Sprite, param3:ISpriteFactory){
            super();
            this.map = param1;
            this.container = param2;
            this.spriteFactory = param3;
            parent = null;
            tilePanes = [];
            loadScheduler = new LoadScheduler();
            param1.addEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            param1.addEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            param1.addEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            param1.addEventListener(MapMouseEvent.DRAG_START, onDragStart);
            param1.addEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            param1.addEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            param1.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            param1.addEventListener(Event.ENTER_FRAME, onEnterFrame);
            param1.addEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, onZoomRangeChanged);
        }
        private function updateView(param1:Boolean):void{
            var _loc_2:Camera;
            var _loc_3:Boolean;
            var _loc_4:PerspectiveTilePane;
            _loc_2 = MapImpl(map).getCamera();
            if (((((((((!(param1)) && (_loc_2.center.equals(currentCenter)))) && ((_loc_2.zoom == currentZoom)))) && (Util.attitudeEquals(_loc_2.attitude, currentAttitude)))) && ((map.getCurrentMapType() == currentMapType)))){
                return;
            };
            currentCenter = _loc_2.center;
            currentMapType = map.getCurrentMapType();
            currentZoom = _loc_2.zoom;
            currentAttitude = _loc_2.attitude;
            loadScheduler.clear();
            _loc_3 = false;
            for each (_loc_4 in tilePanes) {
                if (_loc_4.configure(_loc_2)){
                    _loc_3 = true;
                };
            };
            loadScheduler.start();
            shouldUpdate = false;
            if (_loc_3){
                map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING, map));
                tilesLoadedPending = true;
            };
            checkTileLoadComplete();
        }
        private function onInitialize(event:Event):void{
            initializePanes();
        }
        private function onMapTypeChanged(event:Event):void{
            initializePanes();
        }
        private function destroyPanes():void{
            var _loc_1:PerspectiveTilePane;
            var _loc_2:DisplayObject;
            for each (_loc_1 in tilePanes) {
                _loc_2 = _loc_1.getDisplayObject();
                _loc_1.destroy();
                spriteFactory.removeChild(parent, _loc_2);
            };
            tilePanes = [];
        }
        public function setTargetZoom(param1:int, param2:Boolean):void{
        }
        public function isAnimatingBlend():Boolean{
            return (false);
        }
        private function initializePanes():void{
            var _loc_1:IMapType;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Array;
            var _loc_6:int;
            var _loc_7:ITileLayer;
            var _loc_8:Sprite;
            _loc_1 = map.getCurrentMapType();
            if (((_loc_1) && (!((_loc_1 == prevMapType))))){
                prevMapType = _loc_1;
                destroyPanes();
                if (parent){
                    spriteFactory.removeChild(container, parent);
                };
                parent = spriteFactory.createSprite().getSprite();
                spriteFactory.addChild(container, parent);
                _loc_2 = _loc_1.getTileSize();
                _loc_3 = ((PerspectiveConstants.AREA_RATIO_THRESHOLD * _loc_2) * _loc_2);
                _loc_4 = _loc_1.getMaximumResolution();
                tileEnumerator = new TileEnumerator(_loc_2, _loc_3, PerspectiveConstants.BREADTH_THRESHOLD, _loc_4);
                _loc_5 = _loc_1.getTileLayers();
                _loc_6 = 0;
                while (_loc_6 < _loc_5.length) {
                    _loc_7 = _loc_5[_loc_6];
                    _loc_8 = spriteFactory.createSprite().getSprite();
                    spriteFactory.addChild(parent, _loc_8);
                    tilePanes.push(new PerspectiveTilePane(_loc_8, _loc_7, tileEnumerator, loadScheduler));
                    _loc_6++;
                };
            };
            updateView(true);
        }
        public function destroy():void{
            loadScheduler.clear();
            destroyPanes();
            map.removeEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            map.removeEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            map.removeEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            map.removeEventListener(MapMouseEvent.DRAG_START, onDragStart);
            map.removeEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            map.removeEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            map.removeEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            map.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            map.removeEventListener(MapZoomEvent.ZOOM_RANGE_CHANGED, onZoomRangeChanged);
            currentCenter = null;
        }
        private function onDragEnd(event:Event):void{
            isDragging = false;
        }
        private function onZoomRangeChanged(event:MapZoomEvent):void{
            if (tileEnumerator){
                tileEnumerator.setMaxZoom(map.getMaxZoomLevel());
            };
        }
        private function onDragStart(event:Event):void{
            isDragging = true;
        }
        private function onEnterFrame(event:Event):void{
            if (shouldUpdate){
                updateView(false);
            };
            checkTileLoadComplete();
        }
        public function iterateBlend():void{
        }
        private function invalidate(event:Event):void{
            if (isDragging){
                shouldUpdate = true;
            } else {
                updateView(false);
            };
        }
        private function checkTileLoadComplete():void{
            var _loc_1:PerspectiveTilePane;
            if (!tilesLoadedPending){
                return;
            };
            for each (_loc_1 in tilePanes) {
                if (_loc_1.loadedProportion() < Util.ALL_TILES_LOADED){
                    return;
                };
            };
            map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED, map));
            tilesLoadedPending = false;
        }

    }
}//package com.mapplus.maps.managers 
