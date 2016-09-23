//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public class TileStore {

        private var table_:Object;
        private var size_:Number;

        public function TileStore():void{
            super();
            table_ = {};
            size_ = 0;
        }
        public function removePreLoadTiles():void{
            var _loc_6:*;
            var _loc_1:String;
            var _loc_2:HTile;
            for (_loc_1 in table_) {
                _loc_2 = table_[_loc_1];
                if (((((!(_loc_2.tileDisplayObject)) && (!(_loc_2.loadPending)))) && (!(_loc_2.failed)))){
                    delete table_[_loc_1];
                    _loc_6 = (size_ - 1);
                    size_ = _loc_6;
                };
            };
        }
        public function add(param1:HTile):void{
            var _loc_3:*;
            if (!contains(param1.coord)){
                table_[param1.coord.getQuadTreePath()] = param1;
                _loc_3 = (size_ + 1);
                size_ = _loc_3;
            };
        }
        public function remove(param1:TileCoord):void{
            removeById(param1.getQuadTreePath());
        }
        public function size():Number{
            return (size_);
        }
        public function lookup(param1:TileCoord):HTile{
            return (table_[param1.getQuadTreePath()]);
        }
        public function purge(param1:Object):void{
            var _loc_2:Object;
            var _loc_3:int;
            var _loc_4:String;
            var _loc_5:HTile;
            _loc_2 = {};
            _loc_3 = 0;
            for (_loc_4 in param1) {
                _loc_5 = table_[_loc_4];
                if (_loc_5){
                    _loc_2[_loc_4] = _loc_5;
                    _loc_3++;
                };
            };
            table_ = _loc_2;
            size_ = _loc_3;
        }
        public function lookupById(param1:String):HTile{
            return (table_[param1]);
        }
        public function clear():void{
            table_ = {};
            size_ = 0;
        }
        public function removeById(param1:String):void{
            delete table_[param1];
            var _loc_3:* = (size_ - 1);
            size_ = _loc_3;
        }
        public function clearTileCallbacks():void{
            var _loc_1:HTile;
            for each (_loc_1 in table_) {
                _loc_1.clearCallback();
            };
        }
        public function toString():String{
            var _loc_1:Array;
            var _loc_2:HTile;
            _loc_1 = [];
            for each (_loc_2 in table_) {
                _loc_1.push(_loc_2.coord);
            };
            return (("\n  " + _loc_1.join("\n  ")));
        }
        public function contains(param1:TileCoord):Boolean{
            return (!((table_[param1.getQuadTreePath()] == undefined)));
        }

    }
}//package com.mapplus.maps.core 
