//Created by yuxueli 2011.6.6
package com.mapplus.maps.managers {
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.*;
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    public class TileManager implements ITileManager {

        private static const MIN_OPAQUE_PROPORTION:Number = 0.9;
        private static const DELTA_ALPHA:Number = 0.142858142857143;

        private var currentMapType:IMapType;
        private var spriteFactory:ISpriteFactory;
        private var mc:Sprite;
        private var isDragging:Boolean;
        private var _map:IMapBase;
        private var currentCenter:LatLng;
        private var tilesLoadedPending:Boolean;
        private var shouldUpdate:Boolean;
        private var _layers:Array;
        private var currentZoom:Number;
        private var loadScheduler:LoadScheduler;

        public function TileManager(param1:IMapBase, param2:Sprite, param3:ISpriteFactory){
            super();
            this.mc = param2;
            this.spriteFactory = param3;
            this._map = param1;
            this.loadScheduler = new LoadScheduler();
            this._layers = [];
            param1.addEventListener(MapEvent.SIZE_CHANGED, this.onInitialize);
            param1.addEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
            param1.addEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, this.onMapTypeStyleChanged);
            param1.addEventListener(MapMouseEvent.DRAG_START, this.onDragStart);
            param1.addEventListener(MapMouseEvent.DRAG_END, this.onDragEnd);
            param1.addEventListener(MapMoveEvent.MOVE_STEP, this.invalidate);
            param1.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, this.invalidate);
            param1.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
        public static function alphaAsSin(param1:Number):Number{
            if (param1 == 0){
                return (0);
            };
            if (param1 == 1){
                return (1);
            };
            return (((Math.sin(((param1 - 0.5) * Math.PI)) * 0.5) + 0.5));
        }

        public function setTargetZoom(param1:int, param2:Boolean):void{
            var _loc_3:LayerElement;
            var _loc_4:IMapType;
            var _loc_5:int;
            var _loc_6:Sprite;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:int;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            _loc_4 = this.map.getCurrentMapType();
            _loc_5 = this.getZoomLayerIndex(param1, _loc_4);
            if (_loc_5 < 0){
                _loc_6 = this.spriteFactory.createSprite().getSprite();
                this.spriteFactory.addChild(this.mc, _loc_6);
                _loc_7 = ((this._layers.length == 0)) ? 1 : 0;
                _loc_3 = new LayerElement(param1, _loc_7, new ZoomLayer(_loc_6, this.loadScheduler, _loc_4));
                this._layers.unshift(_loc_3);
            } else {
                if (_loc_5 > 0){
                    _loc_8 = 1;
                    _loc_9 = 0;
                    while (_loc_9 < _loc_5) {
                        _loc_8 = (_loc_8 * (1 - this._layers[_loc_9].alpha));
                        _loc_9++;
                    };
                    _loc_3 = this._layers[_loc_5];
                    _loc_10 = (_loc_3.alpha * _loc_8);
                    this._layers.splice(_loc_5, 1);
                    this._layers.unshift(_loc_3);
                    this.mc.setChildIndex(_loc_3.layer.getDisplayObject(), (this.mc.numChildren - 1));
                    _loc_3.alpha = _loc_10;
                    _loc_11 = (1 / Math.max(1E-6, (1 - _loc_10)));
                    _loc_9 = 1;
                    while (_loc_9 <= _loc_5) {
                        this._layers[_loc_9].alpha = Math.min(1, (this._layers[_loc_9].alpha * _loc_11));
                        _loc_9++;
                    };
                };
            };
            if (param2){
                this._layers[0].alpha = 1;
                this.iterateBlend();
            };
        }
        private function configureLayer(param1:LayerElement, param2:Boolean, param3:Boolean):Boolean{
            var _loc_4:ZoomLayer;
            _loc_4 = param1.layer;
            if (!(param3)){
                _loc_4.clear();
                return (false);
            };
            _loc_4.canLoadTiles = param2;
            _loc_4.alpha = alphaAsSin(param1.alpha);
            _loc_4.setViewport(this.map.getSize());
            _loc_4.configure(this.map.getCamera(), param1.zoom);
            return (_loc_4.update(this.getFocus()));
        }
        private function updateView():void{
            if (!(this.map.isLoaded())){
                return;
            };
            this.configureAllLayers();
            this.shouldUpdate = false;
        }
        private function getFocus():LatLng{
            return (this.map.getFocus());
        }
        private function onDragEnd(event:Event):void{
            this.isDragging = false;
        }
        private function getZoomLayerIndex(param1:int, param2:IMapType):int{
            var _loc_3:int;
            _loc_3 = 0;
            while (_loc_3 < this._layers.length) {
                if ((((((this._layers[_loc_3].zoom == param1)) && ((this._layers[_loc_3].layer.mapType == param2)))) && (!(this._layers[_loc_3].old)))){
                    return (_loc_3);
                };
                _loc_3++;
            };
            return (-1);
        }
        private function configureAllLayerAlphas():void{
            var _loc_1:int;
            var _loc_2:Number = NaN;
            _loc_1 = 0;
            while (_loc_1 < this._layers.length) {
                _loc_2 = alphaAsSin(this._layers[_loc_1].alpha);
                this._layers[_loc_1].layer.alpha = _loc_2;
                _loc_1++;
            };
        }
        private function onEnterFrame(event:Event):void{
            if (this.shouldUpdate){
                this.updateView();
            };
            this.checkTileLoadComplete();
        }
        private function checkTileLoadComplete():void{
            if (((((this.tilesLoadedPending) && ((this._layers.length > 0)))) && ((this._layers[0].layer.loadedProportion() >= Util.ALL_TILES_LOADED)))){
                this.map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED, this.map));
                this.tilesLoadedPending = false;
            };
        }
        private function onMapTypeStyleChanged(event:Event):void{
            var _loc_2:IMapType;
            var _loc_3:LayerElement;
            _loc_2 = this.map.getCurrentMapType();
            for each (_loc_3 in this._layers) {
                if (_loc_3.layer.mapType == _loc_2){
                    _loc_3.old = true;
                };
            };
            this.setTargetZoom(Math.floor(this.map.getZoom()), true);
            this.updateView();
        }
        private function invalidate(event:Event):void{
            if (this.isDragging){
                this.shouldUpdate = true;
            } else {
                this.updateView();
            };
        }
        public function getLayers():Array{
            return (this._layers);
        }
        private function onInitialize(event:Event):void{
            this.setTargetZoom(Math.floor(this.map.getZoom()), true);
            this.updateView();
        }
        private function onMapTypeChanged(event:Event):void{
            this.onInitialize(event);
        }
        public function get map():IMapBase{
            return (this._map);
        }
        private function reviseLayerAlphas():void{
            var _loc_1:int;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:ZoomLayer;
            _loc_1 = -1;
            _loc_2 = (this._layers.length - 1);
            while (_loc_2 >= 0) {
                this._layers[_loc_2].alpha = Math.min(1, (this._layers[_loc_2].alpha + DELTA_ALPHA));
                if ((((this._layers[_loc_2].alpha >= 1)) && ((this._layers[_loc_2].layer.loadedProportion() >= MIN_OPAQUE_PROPORTION)))){
                    _loc_1 = _loc_2;
                };
                _loc_2 = (_loc_2 - 1);
            };
            if (_loc_1 >= 0){
                _loc_1 = (_loc_1 + 1);
                _loc_2 = (_loc_1 + 1);
                while (_loc_2 < this._layers.length) {
                    _loc_4 = this._layers[_loc_2].layer;
                    this.spriteFactory.removeChild(this.mc, _loc_4.getDisplayObject());
                    _loc_4.clear();
                    _loc_2++;
                };
                _loc_3 = (this._layers.length - (_loc_1 + 1));
                if (_loc_3 > 0){
                    this._layers.splice((_loc_1 + 1), _loc_3);
                };
            };
        }
        private function onDragStart(event:Event):void{
            this.isDragging = true;
        }
        public function iterateBlend():void{
            this.reviseLayerAlphas();
            this.configureAllLayerAlphas();
        }
        public function destroy():void{
            var _loc_1:int;
            var _loc_2:ZoomLayer;
            var _loc_3:DisplayObject;
            this.loadScheduler.clear();
            _loc_1 = 0;
            while (_loc_1 < this._layers.length) {
                _loc_2 = this._layers[_loc_1].layer;
                _loc_3 = _loc_2.getDisplayObject();
                _loc_2.clear();
                this.spriteFactory.removeChild(this.mc, _loc_3);
                _loc_1++;
            };
            this.map.removeEventListener(MapEvent.SIZE_CHANGED, this.onInitialize);
            this.map.removeEventListener(MapEvent.MAPTYPE_CHANGED, this.onMapTypeChanged);
            this.map.removeEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, this.onMapTypeStyleChanged);
            this.map.removeEventListener(MapMouseEvent.DRAG_START, this.onDragStart);
            this.map.removeEventListener(MapMouseEvent.DRAG_END, this.onDragEnd);
            this.map.removeEventListener(MapMoveEvent.MOVE_STEP, this.invalidate);
            this.map.removeEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, this.invalidate);
            this.map.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            this.currentCenter = null;
        }
        public function configureAllLayers():void{
            var _loc_1:Number = NaN;
            var _loc_2:LatLng;
            var _loc_3:IMapType;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Boolean;
            var _loc_7:int;
            var _loc_8:LayerElement;
            var _loc_9:Boolean;
            var _loc_10:Boolean;
            _loc_1 = this.map.getZoom();
            _loc_2 = this.map.getCenter();
            _loc_3 = this.map.getCurrentMapType();
            this.currentCenter = _loc_2;
            this.currentMapType = _loc_3;
            this.loadScheduler.clear();
            _loc_4 = Math.floor(_loc_1);
            _loc_5 = (_loc_1 - _loc_4);
            _loc_6 = false;
            _loc_7 = 0;
            while (_loc_7 < this._layers.length) {
                _loc_8 = this._layers[_loc_7];
                _loc_9 = (_loc_7 == 0);
                _loc_10 = (_loc_7 <= 4);
                if (this.configureLayer(_loc_8, _loc_9, _loc_10)){
                    _loc_6 = true;
                };
                _loc_7++;
            };
            this.loadScheduler.start();
            if (_loc_6){
                this.map.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING, this.map));
                this.tilesLoadedPending = true;
            };
            this.checkTileLoadComplete();
        }
        public function isAnimatingBlend():Boolean{
            return ((((this._layers.length > 0)) && ((this._layers[0].alpha < 1))));
        }

    }
}//package com.mapplus.maps.managers 

import com.mapplus.maps.core.*;

class LayerElement {

    public var layer:ZoomLayer;
    public var zoom:int;
    public var old:Boolean;
    public var alpha:Number;

    public function LayerElement(param1:int, param2:Number, param3:ZoomLayer){
        super();
        this.zoom = param1;
        this.alpha = param2;
        this.layer = param3;
        this.old = false;
    }
    public function toString():String{
        return ((((((("{" + this.alpha) + "@") + this.zoom) + ",") + (this.layer) ? "non-null" : "null") + "}"));
    }

}
