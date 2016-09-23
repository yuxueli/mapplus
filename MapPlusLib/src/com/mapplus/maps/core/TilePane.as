//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import flash.geom.*;
    import com.mapplus.maps.*;

    public class TilePane implements ITilePane {

        public static const MINIMUM_OFFSCREEN_TILE:Number = 0.75;
        public static const DEFAULT_TILE_SIZE:Number = 0x0100;

        private var numTilesToLoad:int;
        private var wrapOffset:Number;
        private var tiles:Object;
        private var mc:Sprite;
        private var origin:Point;
        private var tileRect:Rectangle;
        private var tileWrapSize:Number;
        private var tileLayer:ITileLayer;
        private var tileSize:Number;
        private var zoom:Number;
        private var projection:IProjection;
        private var canLoadTiles:Boolean;
        private var tileAdded:Boolean;
        private var loadScheduler:LoadScheduler;

        public function TilePane(param1:Sprite, param2:ITileLayer, param3:Number, param4:IProjection, param5:Boolean, param6:LoadScheduler){
            super();
            this.mc = param1;
            this.mc.alpha = param2.getAlpha();
            this.zoom = NaN;
            this.tileLayer = param2;
            this.projection = param4;
            this.tileSize = ((param3) || (0x0100));
            this.numTilesToLoad = 0;
            this.loadScheduler = param6;
            this.canLoadTiles = param5;
            this.tiles = {};
        }
        private static function isLoadComplete(param1:LoaderInfo):Boolean{
            return ((((param1.bytesTotal > 0)) && ((param1.bytesLoaded == param1.bytesTotal))));
        }

        public function onTileCreated(param1:TileLoader, param2:Object):void{
            var _loc_3:String;
            var _loc_4:DisplayObject;
            if ((((((((param1.x < this.tileRect.left)) || ((param1.x > this.tileRect.right)))) || ((param1.y < this.tileRect.top)))) || ((param1.y > this.tileRect.bottom)))){
                return;
            };
            _loc_3 = this.generateTileId(param1.wrappedX, param1.y);
            _loc_4 = this.getTileDisplayObject(param2);
            this.mc.addChild(_loc_4);
            this.placeTile(param2, _loc_3, param1.x, param1.y);
        }
        public function getDisplayObject():Sprite{
            return (this.mc);
        }
        public function getTileLayer():ITileLayer{
            return (this.tileLayer);
        }
        private function calculateTileSet(param1:Point, param2:Point):Rectangle{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            _loc_3 = Math.floor((param1.x / this.tileSize));
            _loc_4 = Math.floor((((param1.x + param2.x) - 1) / this.tileSize));
            _loc_5 = Math.floor((param1.y / this.tileSize));
            _loc_6 = Math.floor((((param1.y + param2.y) - 1) / this.tileSize));
            return (new Rectangle(_loc_3, _loc_5, ((_loc_4 - _loc_3) + 1), ((_loc_6 - _loc_5) + 1)));
        }
        private function updateTile(param1:Object, param2:int, param3:int, param4:int, param5:int):void{
            var _loc_6:Number = NaN;
            var _loc_7:String;
            var _loc_8:Object;
            var _loc_9:TileLoader;
            var _loc_11:* = (this.numTilesToLoad + 1);
            this.numTilesToLoad = _loc_11;
            _loc_6 = MapUtil.wrapHalfOpen(param2, 0, this.tileWrapSize);
            _loc_7 = this.generateTileId(_loc_6, param3);
            _loc_8 = this.removeTile(param1, _loc_7);
            if (_loc_8){
                this.placeTile(_loc_8, _loc_7, param2, param3);
            } else {
                if (this.canLoadTiles){
                    _loc_9 = new TileLoader(this, param5);
                    _loc_9.loadTile(param2, _loc_6, param3, param4);
                    this.tileAdded = true;
                };
            };
        }
        public function tileSpan(param1:Number, param2:Number):Rectangle{
            var _loc_3:Number = NaN;
            _loc_3 = Math.floor((param1 / this.tileWrapSize));
            return (new Rectangle(((param1 * this.tileSize) - (this.wrapOffset * _loc_3)), (param2 * this.tileSize), this.tileSize, this.tileSize));
        }
        private function getTileWrapSize(param1:Number):Number{
            return (Math.ceil((this.projection.getWrapWidth(param1) / this.tileSize)));
        }
        private function deleteAllTiles(param1:Object):void{
            var _loc_2:Object;
            var _loc_3:Object;
            var _loc_4:Array;
            _loc_2 = null;
            if (param1){
                for each (_loc_3 in param1) {
                    _loc_4 = (_loc_3 as Array);
                    if (_loc_4){
                        for each (_loc_2 in _loc_4) {
                            this.unloadTile(_loc_2);
                        };
                    } else {
                        this.unloadTile(_loc_3);
                    };
                };
            };
        }
        private function generateTileId(param1:Number, param2:Number):String{
            return (((((this.zoom + "_") + param1) + "_") + param2));
        }
        public function getLoadScheduler():LoadScheduler{
            return (this.loadScheduler);
        }
        public function update(param1:LatLng, param2:LatLng, param3:Number, param4:Point):Boolean{
            var _loc_5:Point;
            var _loc_6:Rectangle;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:int;
            var _loc_15:int;
            var _loc_16:Point;
            var _loc_17:Point;
            var _loc_18:Object;
            var _loc_19:Object;
            this.tileAdded = false;
            if (param3 != this.zoom){
                _loc_19 = this.tiles;
                this.tiles = {};
                this.deleteAllTiles(_loc_19);
                this.zoom = param3;
            };
            this.tileWrapSize = this.getTileWrapSize(param3);
            this.wrapOffset = ((this.tileWrapSize * this.tileSize) - this.projection.getWrapWidth(param3));
            _loc_5 = this.projection.fromLatLngToPixel(param1, param3);
            this.origin = new Point((_loc_5.x - (param4.x / 2)), (_loc_5.y - (param4.y / 2)));
            _loc_6 = new Rectangle(this.origin.x, this.origin.y, param4.x, param4.y);
            _loc_7 = (MINIMUM_OFFSCREEN_TILE * this.tileSize);
            _loc_6.inflate(_loc_7, _loc_7);
            _loc_8 = Math.floor((_loc_5.x / this.tileSize));
            _loc_9 = Math.floor((_loc_5.y / this.tileSize));
            _loc_9 = Util.bound(_loc_9, 0, (this.tileWrapSize - 1));
            _loc_10 = int.MAX_VALUE;
            _loc_11 = int.MIN_VALUE;
            _loc_12 = int.MAX_VALUE;
            _loc_13 = int.MIN_VALUE;
            _loc_14 = _loc_8;
            while (this.tileSpan(_loc_14, _loc_9).left < _loc_6.right) {
                _loc_11 = _loc_14;
                _loc_14++;
            };
            _loc_14 = _loc_8;
            while (this.tileSpan(_loc_14, _loc_9).right > _loc_6.left) {
                _loc_10 = _loc_14;
                _loc_14 = (_loc_14 - 1);
            };
            _loc_15 = _loc_9;
            while ((((_loc_15 < this.tileWrapSize)) && ((this.tileSpan(_loc_8, _loc_15).top < _loc_6.bottom)))) {
                _loc_13 = _loc_15;
                _loc_15++;
            };
            _loc_15 = _loc_9;
            while ((((_loc_15 >= 0)) && ((this.tileSpan(_loc_8, _loc_15).bottom > _loc_6.top)))) {
                _loc_12 = _loc_15;
                _loc_15 = (_loc_15 - 1);
            };
            if ((_loc_11 - _loc_10) >= (this.tileWrapSize - 1)){
                _loc_11 = (_loc_11 + 1);
            };
            this.tileRect = new Rectangle(_loc_10, _loc_12, (_loc_11 - _loc_10), (_loc_13 - _loc_12));
            _loc_16 = this.projection.fromLatLngToPixel((param2) ? param2 : param1, param3);
            _loc_17 = new Point(Util.bound(Math.floor((_loc_16.x / this.tileSize)), this.tileRect.left, this.tileRect.right), Util.bound(Math.floor((_loc_16.y / this.tileSize)), this.tileRect.top, this.tileRect.bottom));
            _loc_18 = this.tiles;
            this.tiles = {};
            this.numTilesToLoad = 0;
            this.updateTilesConcentrically(_loc_18, _loc_17, this.tileRect);
            this.deleteAllTiles(_loc_18);
            return (this.tileAdded);
        }
        public function clear():void{
            var _loc_1:Object;
            _loc_1 = this.tiles;
            this.tiles = {};
            this.deleteAllTiles(_loc_1);
        }
        private function removeTile(param1:Object, param2:String):Object{
            var _loc_3:Object;
            var _loc_4:Array;
            var _loc_5:Object;
            _loc_3 = param1[param2];
            if (!(_loc_3)){
                return (null);
            };
            _loc_4 = (_loc_3 as Array);
            _loc_5 = null;
            if (_loc_4){
                _loc_5 = _loc_4.shift();
                if (_loc_4.length < 2){
                    param1[param2] = _loc_4[0];
                };
            } else {
                _loc_5 = _loc_3;
                if (_loc_5){
                    delete param1[param2];
                };
            };
            return (_loc_5);
        }
        private function unloadTile(param1:Object):void{
            var _loc_2:DisplayObject;
            var _loc_3:ITile;
            var _loc_4:Function;
            _loc_2 = this.getTileDisplayObject(param1);
            if (((_loc_2) && ((_loc_2.parent == this.mc)))){
                this.mc.removeChild(_loc_2);
            };
            _loc_3 = (param1 as ITile);
            if (_loc_3){
                _loc_3.unload();
            } else {
                if (param1.hasOwnProperty("unload")){
                    _loc_4 = (param1["unload"] as Function);
                    _loc_4();
                };
            };
        }
        private function placeTile(param1:Object, param2:String, param3:int, param4:int):void{
            var _loc_5:DisplayObject;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            _loc_5 = this.getTileDisplayObject(param1);
            _loc_6 = Math.floor((param3 / this.tileWrapSize));
            _loc_7 = (((this.tileSize * param3) - this.origin.x) - (_loc_6 * this.wrapOffset));
            _loc_8 = ((this.tileSize * param4) - this.origin.y);
            _loc_5.x = _loc_7;
            _loc_5.y = _loc_8;
            _loc_5.visible = true;
            this.addTile(param2, param1);
        }
        private function getTileDisplayObject(param1:Object):DisplayObject{
            var _loc_2:ITile;
            _loc_2 = (param1 as ITile);
            return ((_loc_2) ? _loc_2.getDisplayObject() : (param1 as DisplayObject));
        }
        private function addTile(param1:String, param2:Object):void{
            var _loc_3:Object;
            var _loc_4:Array;
            _loc_3 = this.tiles[param1];
            if (!(_loc_3)){
                this.tiles[param1] = param2;
                return;
            };
            _loc_4 = (_loc_3 as Array);
            if (_loc_4){
                _loc_4.push(param2);
                return;
            };
            _loc_4 = [_loc_3, param2];
            this.tiles[param1] = _loc_4;
        }
        private function updateTilesConcentrically(param1:Object, param2:Point, param3:Rectangle):void{
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            this.updateTile(param1, param2.x, param2.y, this.zoom, 0);
            _loc_4 = Math.max(param3.width, param3.height);
            _loc_5 = 1;
            while (_loc_5 < _loc_4) {
                _loc_8 = Math.max(param3.left, (param2.x - _loc_5));
                _loc_9 = Math.min(param3.right, (param2.x + _loc_5));
                _loc_10 = Math.max(param3.top, (param2.y - _loc_5));
                _loc_11 = Math.min(param3.bottom, (param2.y + _loc_5));
                _loc_6 = (param2.x - _loc_5);
                if ((((_loc_6 >= param3.left)) && ((_loc_6 <= param3.right)))){
                    _loc_7 = _loc_10;
                    while (_loc_7 <= _loc_11) {
                        this.updateTile(param1, _loc_6, _loc_7, this.zoom, _loc_5);
                        _loc_7++;
                    };
                    _loc_8++;
                };
                _loc_6 = (param2.x + _loc_5);
                if ((((_loc_6 >= param3.left)) && ((_loc_6 <= param3.right)))){
                    _loc_7 = _loc_10;
                    while (_loc_7 <= _loc_11) {
                        this.updateTile(param1, _loc_6, _loc_7, this.zoom, _loc_5);
                        _loc_7++;
                    };
                    _loc_9 = (_loc_9 - 1);
                };
                _loc_7 = (param2.y - _loc_5);
                if ((((_loc_7 >= param3.top)) && ((_loc_7 <= param3.bottom)))){
                    _loc_6 = _loc_8;
                    while (_loc_6 <= _loc_9) {
                        this.updateTile(param1, _loc_6, _loc_7, this.zoom, _loc_5);
                        _loc_6++;
                    };
                };
                _loc_7 = (param2.y + _loc_5);
                if ((((_loc_7 >= param3.top)) && ((_loc_7 <= param3.bottom)))){
                    _loc_6 = _loc_8;
                    while (_loc_6 <= _loc_9) {
                        this.updateTile(param1, _loc_6, _loc_7, this.zoom, _loc_5);
                        _loc_6++;
                    };
                };
                _loc_5++;
            };
        }
        private function checkIsLoaded(param1:Object):Boolean{
            if (param1.hasOwnProperty("loadComplete")){
                return (param1["loadComplete"]);
            };
            if ((param1 is Loader)){
                return (isLoadComplete((param1 as Loader).contentLoaderInfo));
            };
            return (true);
        }
        public function setLoadTiles(param1:Boolean):void{
            this.canLoadTiles = param1;
        }
        public function loadedProportion():Number{
            var _loc_1:Number = NaN;
            var _loc_2:String;
            var _loc_3:Object;
            var _loc_4:Array;
            var _loc_5:Object;
            if (this.numTilesToLoad == 0){
                return (1);
            };
            _loc_1 = 0;
            for (_loc_2 in this.tiles) {
                _loc_3 = this.tiles[_loc_2];
                _loc_4 = (_loc_3 as Array);
                if (_loc_4){
                    for each (_loc_5 in _loc_4) {
                        if (this.checkIsLoaded(_loc_5)){
                            _loc_1 = (_loc_1 + 1);
                        };
                    };
                } else {
                    if (this.checkIsLoaded(_loc_3)){
                        _loc_1 = (_loc_1 + 1);
                    };
                };
            };
            return ((_loc_1 / this.numTilesToLoad));
        }

    }
}//package com.mapplus.maps.core 
