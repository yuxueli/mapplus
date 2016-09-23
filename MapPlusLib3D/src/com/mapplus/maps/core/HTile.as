//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;

    public class HTile {

        private var failed_:Boolean;
        private var bitmapData_:BitmapData;
        private var coord_:TileCoord;
        private var bitmap_:Bitmap;
        private var bounds_:Rectangle;
        private var loader:IEventDispatcher;
        private var tileDisplayObject_:DisplayObject;
        private var callback_:Function;
        private var slaves:Array;

        public function HTile(param1:TileCoord){
            super();
            this.coord_ = param1;
            this.bounds_ = param1.getWorldBounds();
        }
        private static function isLoadComplete(param1:LoaderInfo):Boolean{
            return ((((param1.bytesTotal > 0)) && ((param1.bytesLoaded == param1.bytesTotal))));
        }
        private static function getContentAsBitmap(param1:DisplayObject):Bitmap{
            if ((param1 is Bitmap)){
                return ((param1 as Bitmap));
            };
            if ((param1 is Loader)){
                return ((Bootstrap.getLoaderContent((param1 as Loader)) as Bitmap));
            };
            return (null);
        }

        private function clearLoaderAndCompletionHandlers():void{
            loader.removeEventListener(Event.COMPLETE, onLoadComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
            loader = null;
        }
        private function onLoadFailed(event:IOErrorEvent):void{
            failed_ = true;
            clearLoaderAndCompletionHandlers();
            if (callback_ != null){
                callback_(this);
            };
        }
        public function get bounds():Rectangle{
            return (bounds_);
        }
        public function get loadPending():Boolean{
            return (!((loader == null)));
        }
        public function get tileDisplayObject():DisplayObject{
            return (tileDisplayObject_);
        }
        public function addLoadCompleteCallback(param1:HTile, param2:Function):void{
            param1.callback_ = param2;
            if (loader){
                param1.loader = loader;
                param1.addCompletionHandlers();
            } else {
                if (!slaves){
                    slaves = [];
                };
                slaves.push(param1);
            };
        }
        private function addCompletionHandlers():void{
            loader.addEventListener(Event.COMPLETE, onLoadComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
        }
        public function get bitmap():Bitmap{
            return (bitmap_);
        }
        public function setTile(param1:Object, param2:Function):void{
            var _loc_3:ITile;
            var _loc_4:HTile;
            _loc_3 = (param1 as ITile);
            callback_ = param2;
            failed_ = false;
            bitmap_ = null;
            bitmapData_ = null;
            loader = null;
            if (_loc_3){
                if (!_loc_3.loadComplete){
                    loader = _loc_3;
                } else {
                    tileDisplayObject_ = (param1 as DisplayObject);
                    bitmap_ = getContentAsBitmap(param1.getLoader());
                };
            } else {
                if ((((param1 is Loader)) && (!(isLoadComplete((param1 as Loader).contentLoaderInfo))))){
                    loader = (param1 as Loader).contentLoaderInfo;
                } else {
                    tileDisplayObject_ = (param1 as DisplayObject);
                    bitmap_ = getContentAsBitmap(tileDisplayObject_);
                };
            };
            if (loader){
                loader.addEventListener(Event.COMPLETE, onLoadComplete);
                loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
                if (slaves){
                    for each (_loc_4 in slaves) {
                        _loc_4.loader = loader;
                        _loc_4.addCompletionHandlers();
                    };
                    slaves = [];
                };
            };
        }
        public function clearCallback():void{
            if (callback_ != null){
                callback_ = null;
            };
        }
        public function get coord():TileCoord{
            return (coord_);
        }
        public function get bitmapData():BitmapData{
            if (bitmap_){
                return (bitmap_.bitmapData);
            };
            if (!bitmapData_){
                bitmapData_ = new BitmapData(tileDisplayObject_.width, tileDisplayObject_.height, true, 0);
                Bootstrap.drawBitmapData(bitmapData_, tileDisplayObject_);
            };
            return (bitmapData_);
        }
        public function get failed():Boolean{
            return (failed_);
        }
        private function onLoadComplete(event:Event):void{
            if ((event.target is LoaderInfo)){
                tileDisplayObject_ = (Bootstrap.getLoaderInfoContent((event.target as LoaderInfo)) as DisplayObject);
            } else {
                tileDisplayObject_ = (event.target.getLoader() as DisplayObject);
            };
            bitmap_ = getContentAsBitmap(tileDisplayObject_);
            clearLoaderAndCompletionHandlers();
            if (callback_ != null){
                callback_(this);
            };
        }

    }
}//package com.mapplus.maps.core 
