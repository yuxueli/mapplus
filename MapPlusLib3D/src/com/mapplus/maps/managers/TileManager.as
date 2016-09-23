//Created by yuxueli 2011.6.6
package com.mapplus.maps.managers {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class TileManager implements ITileManager {

        private static const MIN_OPAQUE_PROPORTION:Number = 0.9;
        private static const DELTA_ALPHA:Number = 1E-6;

        private var currentMapType:IMapType;
        private var spriteFactory:ISpriteFactory;
        private var tilesLoadedPending:Boolean;
        private var mc:Sprite;
        private var isDragging:Boolean;
        private var _map:IMapBase;
        private var _layers:Array;
        private var shouldUpdate:Boolean;
        private var currentCenter:LatLng;
        private var loadScheduler:LoadScheduler;
        private var currentZoom:Number;

        public function TileManager(param1:IMapBase, param2:Sprite, param3:ISpriteFactory){
            super();
            this.mc = param2;
            this.spriteFactory = param3;
            _map = param1;
            loadScheduler = new LoadScheduler();
            _layers = [];
            param1.addEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            param1.addEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            param1.addEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            param1.addEventListener(MapMouseEvent.DRAG_START, onDragStart);
            param1.addEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            param1.addEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            param1.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            param1.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        static function alphaAsSin(param1:Number):Number{
            if (param1 == 0){
                return (0);
            };
            if (param1 == 1){
                return (1);
            };
            return (((Math.sin(((param1 - 0.5) * Math.PI)) * 0.5) + 0.5));
        }

        public function isAnimatingBlend():Boolean{
            return ((((_layers.length > 0)) && ((_layers[0].alpha < 1))));
        }
        private function onEnterFrame(event:Event):void{
            if (shouldUpdate){
                updateView();
            };
            checkTileLoadComplete();
        }
        public function setTargetZoom(param1:int, param2:Boolean):void{
            var _loc_3:LayerElement;
            var _loc_4:int;
            var _loc_5:Sprite;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:int;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            _loc_4 = getZoomLayerIndex(param1);
            if (_loc_4 < 0){
                _loc_5 = spriteFactory.createSprite().getSprite();
                spriteFactory.addChild(mc, _loc_5);
                _loc_6 = ((_layers.length == 0)) ? 1 : 0;
                _loc_3 = new LayerElement(param1, _loc_6, new ZoomLayer(_loc_5, loadScheduler));
                _layers.unshift(_loc_3);
            } else {
                if (_loc_4 > 0){
                    _loc_7 = 1;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_4) {
                        _loc_7 = (_loc_7 * (1 - _layers[_loc_8].alpha));
                        _loc_8++;
                    };
                    _loc_3 = _layers[_loc_4];
                    _loc_9 = (_loc_3.alpha * _loc_7);
                    _layers.splice(_loc_4, 1);
                    _layers.unshift(_loc_3);
                    mc.setChildIndex(_loc_3.layer.getDisplayObject(), (mc.numChildren - 1));
                    _loc_3.alpha = _loc_9;
                    _loc_10 = (1 / Math.max(1E-6, (1 - _loc_9)));
                    _loc_8 = 1;
                    while (_loc_8 <= _loc_4) {
                        _layers[_loc_8].alpha = Math.min(1, (_layers[_loc_8].alpha * _loc_10));
                        _loc_8++;
                    };
                };
            };
            if (param2){
                _layers[0].alpha = 1;
                iterateBlend();
            };
        }
        public function destroy():void{
            var _loc_1:int;
            var _loc_2:ZoomLayer;
            var _loc_3:DisplayObject;
            loadScheduler.clear();
            _loc_1 = 0;
            while (_loc_1 < _layers.length) {
                _loc_2 = _layers[_loc_1].layer;
                _loc_3 = _loc_2.getDisplayObject();
                _loc_2.clear();
                spriteFactory.removeChild(mc, _loc_3);
                _loc_1++;
            };
            map.removeEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            map.removeEventListener(MapEvent.MAPTYPE_CHANGED, onMapTypeChanged);
            map.removeEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            map.removeEventListener(MapMouseEvent.DRAG_START, onDragStart);
            map.removeEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            map.removeEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            map.removeEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            map.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            currentCenter = null;
        }
        private function configureLayer(param1:LayerElement, param2:Boolean, param3:Boolean, param4:Boolean):Boolean{
            var _loc_5:ZoomLayer;
            _loc_5 = param1.layer;
            if (!param3){
                _loc_5.clear();
                return (false);
            };
            _loc_5.canLoadTiles = param2;
            _loc_5.alpha = alphaAsSin(param1.alpha);
            _loc_5.setViewport(map.getSize());
            _loc_5.configure(map.getCurrentMapType(), map.getCamera(), param1.zoom);
            if (param4){
                return (_loc_5.update(getFocus()));
            };
            return (false);
        }
        private function updateView():void{
            if (!map.isLoaded()){
                return;
            };
            configureAllLayers(true);
            shouldUpdate = false;
        }
        private function onInitialize(event:Event):void{
            setTargetZoom(Math.floor(map.getZoom()), true);
            updateView();
        }
        private function reviseLayerAlphas():void{
            var _loc_1:int;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:ZoomLayer;
            _loc_1 = -1;
            _loc_2 = (_layers.length - 1);
            while (_loc_2 >= 0) {
                _layers[_loc_2].alpha = Math.min(1, (_layers[_loc_2].alpha + DELTA_ALPHA));
                if ((((_layers[_loc_2].alpha >= 1)) && ((_layers[_loc_2].layer.loadedProportion() >= MIN_OPAQUE_PROPORTION)))){
                    _loc_1 = _loc_2;
                };
                _loc_2--;
            };
            if (_loc_1 >= 0){
                _loc_1 = (_loc_1 + 1);
                _loc_2 = (_loc_1 + 1);
                while (_loc_2 < _layers.length) {
                    _loc_4 = _layers[_loc_2].layer;
                    spriteFactory.removeChild(mc, _loc_4.getDisplayObject());
                    _loc_4.clear();
                    _loc_2++;
                };
                _loc_3 = (_layers.length - (_loc_1 + 1));
                if (_loc_3 > 0){
                    _layers.splice((_loc_1 + 1), _loc_3);
                };
            };
        }
        private function invalidate(event:Event):void{
            if (isDragging){
                shouldUpdate = true;
            } else {
                updateView();
            };
        }
        function getFocus():LatLng{
            return (map.getFocus());
        }
        private function onMapTypeChanged(event:Event):void{
            onInitialize(event);
        }
        private function onDragEnd(event:Event):void{
            isDragging = false;
        }
        private function configureAllLayerAlphas():void{
            var _loc_1:int;
            var _loc_2:Number = NaN;
            _loc_1 = 0;
            while (_loc_1 < _layers.length) {
                _loc_2 = alphaAsSin(_layers[_loc_1].alpha);
                _layers[_loc_1].layer.alpha = _loc_2;
                _loc_1++;
            };
        }
        private function onDragStart(event:Event):void{
            isDragging = true;
        }
        function getZoomLayerIndex(param1:int):int{
            var _loc_2:int;
            _loc_2 = 0;
            while (_loc_2 < _layers.length) {
                if (_layers[_loc_2].zoom == param1){
                    return (_loc_2);
                };
                _loc_2++;
            };
            return (-1);
        }
        public function get map():IMapBase{
            return (_map);
        }
        public function iterateBlend():void{
            reviseLayerAlphas();
            configureAllLayerAlphas();
        }
        private function checkTileLoadComplete():void{
            if (((((tilesLoadedPending) && ((_layers.length > 0)))) && ((_layers[0].layer.loadedProportion() >= Util.ALL_TILES_LOADED)))){
                map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED, map));
                tilesLoadedPending = false;
            };
        }
        function configureAllLayers(param1:Boolean):void{
            var _loc_2:Number = NaN;
            var _loc_3:LatLng;
            var _loc_4:IMapType;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Boolean;
            var _loc_8:int;
            var _loc_9:LayerElement;
            var _loc_10:Boolean;
            var _loc_11:Boolean;
            _loc_2 = map.getZoom();
            _loc_3 = map.getCenter();
            _loc_4 = map.getCurrentMapType();
            param1 = ((param1) || (((!(_loc_3.equals(currentCenter))) || (!((_loc_4 === currentMapType))))));
            currentCenter = _loc_3;
            currentMapType = _loc_4;
            if (param1){
                loadScheduler.clear();
            };
            _loc_5 = Math.floor(_loc_2);
            _loc_6 = (_loc_2 - _loc_5);
            _loc_7 = false;
            _loc_8 = 0;
            while (_loc_8 < _layers.length) {
                _loc_9 = _layers[_loc_8];
                _loc_10 = (_loc_8 == 0);
                _loc_11 = (_loc_8 <= 4);
                if (configureLayer(_loc_9, _loc_10, _loc_11, param1)){
                    _loc_7 = true;
                };
                _loc_8++;
            };
            if (param1){
                loadScheduler.start();
            };
            if (_loc_7){
                map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING, map));
                tilesLoadedPending = true;
            };
            checkTileLoadComplete();
        }
        public function getLayers():Array{
            return (_layers);
        }

    }
}//package com.mapplus.maps.managers 

import com.mapplus.maps.core.*;

class LayerElement {

    public var layer:ZoomLayer;
    public var zoom:int;
    public var alpha:Number;

    public function LayerElement(param1:int, param2:Number, param3:ZoomLayer){
        super();
        this.zoom = param1;
        this.alpha = param2;
        this.layer = param3;
    }
    public function toString():String{
        return ((((((("{" + alpha) + "@") + zoom) + ",") + (layer) ? "non-null" : "null") + "}"));
    }

}
