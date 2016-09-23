//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class TileLoader implements ILoaderInfo {

        private var _priority:int;
        private var _tile:Object;
        private var _wrappedX:int;
        private var _tilePane:ITilePane;
        private var _domain:String;
        private var _zoom:int;
        private var _x:int;
        private var _y:int;

        public function TileLoader(param1:ITilePane, param2:int){
            super();
            this._tilePane = param1;
            this._priority = param2;
        }
        public function get y():int{
            return (_y);
        }
        public function get wrappedX():int{
            return (_wrappedX);
        }
        public function get domain():String{
            return (_domain);
        }
        private function onLoadFailed(event:Event):void{
            _tile.removeEventListener(Event.COMPLETE, onLoadCompleted);
            _tile.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            _tilePane.getLoadScheduler().completed(this);
        }
        public function loadTile(param1:int, param2:int, param3:int, param4:int):void{
            var _loc_5:ITileLayerAsync;
            this._x = param1;
            this._wrappedX = param2;
            this._y = param3;
            this._zoom = param4;
            _loc_5 = (getTileLayer() as ITileLayerAsync);
            if (_loc_5){
                _domain = _loc_5.getTileDomain(param1, param3, param4);
                getLoadScheduler().queue(this);
            } else {
                _tile = getTileLayer().loadTile(new Point(param2, param3), param4);
                getTilePane().onTileCreated(this, _tile);
            };
        }
        public function onScheduled():void{
            var _loc_1:ITileLayerAsync;
            _loc_1 = ITileLayerAsync(getTileLayer());
            _tile = _loc_1.loadTileAsync(_wrappedX, y, zoom);
            if (((!(_tile)) || (_tile.loadComplete))){
                _tilePane.getLoadScheduler().completed(this);
            } else {
                _tile.addEventListener(Event.COMPLETE, onLoadCompleted);
                _tile.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            };
            getTilePane().onTileCreated(this, _tile);
        }
        private function getTileLayer():ITileLayer{
            return (_tilePane.getTileLayer());
        }
        public function get zoom():int{
            return (_zoom);
        }
        private function onLoadCompleted(event:Event):void{
            _tile.removeEventListener(Event.COMPLETE, onLoadCompleted);
            _tile.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            _tilePane.getLoadScheduler().completed(this);
        }
        private function getTilePane():ITilePane{
            return (_tilePane);
        }
        public function get x():int{
            return (_x);
        }
        public function toString():String{
            return (((((("TileLoaderInfo: (" + x) + ", ") + y) + ")@") + zoom));
        }
        public function get priority():int{
            return (_priority);
        }
        private function getLoadScheduler():LoadScheduler{
            return (_tilePane.getLoadScheduler());
        }

    }
}//package com.mapplus.maps.core 
