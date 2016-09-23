//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import com.mapplus.maps.interfaces.*;
    import flash.geom.*;

    public class TileLoader implements ILoaderInfo {

        private var _x:int;
        private var _priority:int;
        private var _tile:Object;
        private var _wrappedX:int;
        private var _tilePane:ITilePane;
        private var _domain:String;
        private var _zoom:int;
        private var _y:int;

        public function TileLoader(param1:ITilePane, param2:int){
            super();
            this._tilePane = param1;
            this._priority = param2;
        }
        private function onLoadFailed(event:Event):void{
            this._tile.removeEventListener(Event.COMPLETE, this.onLoadCompleted);
            this._tile.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
            this._tilePane.getLoadScheduler().completed(this);
        }
        public function get domain():String{
            return (this._domain);
        }
        public function get y():int{
            return (this._y);
        }
        public function get wrappedX():int{
            return (this._wrappedX);
        }
        public function onScheduled():void{
            var _loc_1:ITileLayerAsync;
            _loc_1 = ITileLayerAsync(this.getTileLayer());
            this._tile = _loc_1.loadTileAsync(this._wrappedX, this.y, this.zoom);
            if (((!(this._tile)) || (this._tile.loadComplete))){
                this._tilePane.getLoadScheduler().completed(this);
            } else {
                this._tile.addEventListener(Event.COMPLETE, this.onLoadCompleted);
                this._tile.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
            };
            this.getTilePane().onTileCreated(this, this._tile);
        }
        public function get zoom():int{
            return (this._zoom);
        }
        private function getTileLayer():ITileLayer{
            return (this._tilePane.getTileLayer());
        }
        private function getTilePane():ITilePane{
            return (this._tilePane);
        }
        private function onLoadCompleted(event:Event):void{
            this._tile.removeEventListener(Event.COMPLETE, this.onLoadCompleted);
            this._tile.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
            this._tilePane.getLoadScheduler().completed(this);
        }
        public function toString():String{
            return (((((("TileLoaderInfo: (" + this.x) + ", ") + this.y) + ")@") + this.zoom));
        }
        public function loadTile(param1:int, param2:int, param3:int, param4:int):void{
            var _loc_5:ITileLayerAsync;
            this._x = param1;
            this._wrappedX = param2;
            this._y = param3;
            this._zoom = param4;
            _loc_5 = (this.getTileLayer() as ITileLayerAsync);
            if (_loc_5){
                this._domain = _loc_5.getTileDomain(param1, param3, param4);
                this.getLoadScheduler().queue(this);
            } else {
                this._tile = this.getTileLayer().loadTile(new Point(param2, param3), param4);
                this.getTilePane().onTileCreated(this, this._tile);
            };
        }
        public function get x():int{
            return (this._x);
        }
        public function get priority():int{
            return (this._priority);
        }
        private function getLoadScheduler():LoadScheduler{
            return (this._tilePane.getLoadScheduler());
        }

    }
}//package com.mapplus.maps.core 
