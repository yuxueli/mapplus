//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class ZoomLayer {

        private var latLng:LatLng;
        private var viewportSize:Point;
        private var loadScheduler:LoadScheduler;
        private var tilePaneSize:Point;
        private var parentMc:Sprite;
        private var canLoadTilesValue:Boolean;
        private var camera:Camera;
        private var integerZoom:Number;
        private var mapType:IMapType;
        private var containerMc:Sprite;
        private var tilePanes:Array;

        public function ZoomLayer(param1:Sprite, param2:LoadScheduler){
            super();
            parentMc = param1;
            viewportSize = new Point(0, 0);
            tilePanes = [];
            this.loadScheduler = param2;
            mapType = null;
            canLoadTiles = true;
        }
        public function update(param1:LatLng=null):Boolean{
            var _loc_2:Boolean;
            var _loc_3:TilePane;
            if (!param1){
                param1 = latLng;
            };
            _loc_2 = false;
            for each (_loc_3 in tilePanes) {
                if (_loc_3.update(latLng, param1, integerZoom, viewportSize)){
                    _loc_2 = true;
                };
            };
            return (_loc_2);
        }
        public function get canLoadTiles():Boolean{
            return (canLoadTilesValue);
        }
        public function clear():void{
            var _loc_1:TilePane;
            for each (_loc_1 in tilePanes) {
                _loc_1.clear();
            };
            alpha = Alpha.OPAQUE;
        }
        private function setZoom(param1:Camera, param2:Number):void{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Object;
            var _loc_7:TilePane;
            var _loc_8:Sprite;
            integerZoom = param2;
            _loc_3 = Math.pow(param1.base, (param1.zoom - integerZoom));
            _loc_4 = ((viewportSize.x * (1 - _loc_3)) / 2);
            _loc_5 = ((viewportSize.y * (1 - _loc_3)) / 2);
            _loc_6 = mapType;
            for each (_loc_7 in tilePanes) {
                _loc_8 = _loc_7.getDisplayObject();
                _loc_8.x = _loc_4;
                _loc_8.y = _loc_5;
                _loc_8.scaleX = _loc_3;
                _loc_8.scaleY = _loc_3;
            };
            setPosition(param1.center);
        }
        public function get alpha():Number{
            return (getDisplayObject().alpha);
        }
        public function configure(param1:IMapType, param2:Camera, param3:Number):void{
            var _loc_4:Array;
            var _loc_5:ITileLayer;
            var _loc_6:TilePane;
            var _loc_7:Sprite;
            var _loc_8:TilePane;
            this.camera = param2;
            if (mapType != param1){
                if (tilePanes){
                    for each (_loc_6 in tilePanes) {
                        _loc_6.clear();
                    };
                };
                if (containerMc){
                    parentMc.removeChild(containerMc);
                };
                tilePanes = [];
                containerMc = new Sprite();
                parentMc.addChild(containerMc);
                _loc_4 = param1.getTileLayers();
                for each (_loc_5 in _loc_4) {
                    _loc_7 = new Sprite();
                    containerMc.addChild(_loc_7);
                    _loc_8 = new TilePane(_loc_7, _loc_5, param1.getTileSize(), param1.getProjection(), canLoadTiles, loadScheduler);
                    tilePanes.push(_loc_8);
                };
                mapType = param1;
            };
            setZoom(param2, param3);
        }
        public function setViewport(param1:Point):void{
            if (!param1.equals(this.viewportSize)){
                this.viewportSize = param1;
                if (((((mapType) && (latLng))) && (integerZoom))){
                    configure(mapType, camera, integerZoom);
                };
            };
        }
        public function setPosition(param1:LatLng):void{
            latLng = param1;
        }
        public function set canLoadTiles(param1:Boolean):void{
            var _loc_2:TilePane;
            if (canLoadTilesValue != param1){
                for each (_loc_2 in tilePanes) {
                    _loc_2.setLoadTiles(param1);
                };
                canLoadTilesValue = param1;
            };
        }
        public function getDisplayObject():Sprite{
            return (parentMc);
        }
        public function set alpha(param1:Number):void{
            getDisplayObject().visible = (param1 > 0);
            getDisplayObject().alpha = param1;
        }
        public function loadedProportion():Number{
            var _loc_1:Number = NaN;
            var _loc_2:TilePane;
            _loc_1 = 0;
            for each (_loc_2 in tilePanes) {
                _loc_1 = (_loc_1 + _loc_2.loadedProportion());
            };
            if (tilePanes.length){
                _loc_1 = (_loc_1 / tilePanes.length);
            };
            return (_loc_1);
        }

    }
}//package com.mapplus.maps.core 
