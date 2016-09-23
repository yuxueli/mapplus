//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.geom.*;

    public class ZoomLayer {

        private var container:Sprite;
        private var latLng:LatLng;
        private var viewportSize:Point;
        private var mapTypeVar:IMapType;
        private var tilePaneSize:Point;
        private var canLoadTilesValue:Boolean;
        private var camera:Camera;
        private var parent:Sprite;
        private var loadScheduler:LoadScheduler;
        private var integerZoom:Number;
        private var tilePanes:Array;

        public function ZoomLayer(param1:Sprite, param2:LoadScheduler, param3:IMapType){
            super();
            this.parent = param1;
            this.viewportSize = new Point(0, 0);
            this.tilePanes = [];
            this.loadScheduler = param2;
            this.mapTypeVar = param3;
            this.canLoadTiles = true;
        }
        public function update(param1:LatLng=null):Boolean{
            var _loc_2:Boolean;
            var _loc_3:TilePane;
            if (!(param1)){
                param1 = this.latLng;
            };
            _loc_2 = false;
            for each (_loc_3 in this.tilePanes) {
                if (_loc_3.update(this.latLng, param1, this.integerZoom, this.viewportSize)){
                    _loc_2 = true;
                };
            };
            return (_loc_2);
        }
        public function clear():void{
            var _loc_1:TilePane;
            for each (_loc_1 in this.tilePanes) {
                _loc_1.clear();
            };
            this.alpha = Alpha.OPAQUE;
        }
        public function get canLoadTiles():Boolean{
            return (this.canLoadTilesValue);
        }
        private function setZoom(param1:Camera, param2:Number):void{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:TilePane;
            var _loc_7:Sprite;
            this.integerZoom = param2;
            _loc_3 = Math.pow(param1.base, (param1.zoom - this.integerZoom));
            _loc_4 = ((this.viewportSize.x * (1 - _loc_3)) / 2);
            _loc_5 = ((this.viewportSize.y * (1 - _loc_3)) / 2);
            for each (_loc_6 in this.tilePanes) {
                _loc_7 = _loc_6.getDisplayObject();
                _loc_7.x = _loc_4;
                _loc_7.y = _loc_5;
                _loc_7.scaleX = _loc_3;
                _loc_7.scaleY = _loc_3;
            };
            this.setPosition(param1.center);
        }
        public function set canLoadTiles(param1:Boolean):void{
            var _loc_2:TilePane;
            if (this.canLoadTilesValue != param1){
                for each (_loc_2 in this.tilePanes) {
                    _loc_2.setLoadTiles(param1);
                };
                this.canLoadTilesValue = param1;
            };
        }
        public function configure(param1:Camera, param2:Number):void{
            var _loc_3:Array;
            var _loc_4:ITileLayer;
            var _loc_5:Sprite;
            var _loc_6:TilePane;
            this.camera = param1;
            if (((this.mapTypeVar) && (!(this.container)))){
                this.container = new Sprite();
                this.parent.addChild(this.container);
                _loc_3 = this.mapTypeVar.getTileLayers();
                this.tilePanes = [];
                for each (_loc_4 in _loc_3) {
                    _loc_5 = new Sprite();
                    this.container.addChild(_loc_5);
                    _loc_6 = new TilePane(_loc_5, _loc_4, this.mapTypeVar.getTileSize(), this.mapTypeVar.getProjection(), this.canLoadTiles, this.loadScheduler);
                    this.tilePanes.push(_loc_6);
                };
            };
            this.setZoom(param1, param2);
        }
        public function setViewport(param1:Point):void{
            if (!(param1.equals(this.viewportSize))){
                this.viewportSize = param1;
                if (((((this.container) && (this.latLng))) && (this.integerZoom))){
                    this.configure(this.camera, this.integerZoom);
                };
            };
        }
        public function setPosition(param1:LatLng):void{
            this.latLng = param1;
        }
        public function get alpha():Number{
            return (this.getDisplayObject().alpha);
        }
        public function getDisplayObject():Sprite{
            return (this.parent);
        }
        public function get mapType():IMapType{
            return (this.mapTypeVar);
        }
        public function set alpha(param1:Number):void{
            this.getDisplayObject().visible = (param1 > 0);
            this.getDisplayObject().alpha = param1;
        }
        public function loadedProportion():Number{
            var _loc_1:Number = NaN;
            var _loc_2:TilePane;
            _loc_1 = 0;
            for each (_loc_2 in this.tilePanes) {
                _loc_1 = (_loc_1 + _loc_2.loadedProportion());
            };
            if (this.tilePanes.length){
                _loc_1 = (_loc_1 / this.tilePanes.length);
            };
            return (_loc_1);
        }

    }
}//package com.mapplus.maps.core 
