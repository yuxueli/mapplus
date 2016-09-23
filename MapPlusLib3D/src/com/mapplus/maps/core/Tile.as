//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import com.mapplus.maps.*;
    import flash.net.*;
    import flash.system.*;
    import flash.filters.*;

    public final class Tile extends Sprite implements ITile {

        private static var errorImage:Object = {};

        private var size:int;
        private var errorId:String;
        private var tileUrl:String;
        private var finished:Boolean;
        private var loader:Loader;
        private var discarded:Boolean;

        public function Tile(param1:String, param2:int, param3:String){
            super();
            var _loc_4:LoaderContext;
            if (param1){
                this.tileUrl = param1;
                loader = new Loader();
                addLoaderEventListeners(loader);
                _loc_4 = new LoaderContext(true);
                loader.load(new URLRequest(param1), _loc_4);
                addChild(loader);
                finished = false;
                discarded = false;
                this.size = param2;
                this.errorId = param3;
            };
        }
        public static function createLabelBitmapData(param1:String, param2:int, param3:Boolean):BitmapData{
            var _loc_4:int;
            var _loc_5:BitmapData;
            var _loc_6:DisplayObject;
            _loc_4 = param1.search("<p>");
            if (_loc_4 > 0){
                param1 = ((("<p>" + param1.substring(0, _loc_4)) + "</p>") + param1.substring(_loc_4, param1.length));
            };
            _loc_5 = new BitmapData(param2, param2, param3, (param3) ? 0 : 4294967295);
            _loc_6 = createCenteredLabel(param2, param1, Color.BLACK, 12, false);
            _loc_5.draw(_loc_6, new Matrix(1, 0, 0, 1, (0.5 * (param2 - _loc_6.width)), (0.5 * (param2 - _loc_6.height))));
            return (_loc_5);
        }
        public static function createCenteredLabel(param1:int, param2:String, param3:uint, param4:Number, param5:Boolean):TextField{
            var _loc_6:TextField;
            var _loc_7:TextFormat;
            _loc_6 = new TextField();
            _loc_6.alpha = 0.3;
            _loc_6.filters = [new GlowFilter(Color.WHITE, 1, 2, 2)];
            _loc_6.autoSize = TextFieldAutoSize.LEFT;
            _loc_6.width = (param1 - (param1 / 8));
            _loc_6.multiline = true;
            _loc_6.wordWrap = true;
            _loc_6.selectable = false;
            _loc_6.htmlText = param2;
            _loc_6.mouseEnabled = false;
            _loc_7 = new TextFormat();
            _loc_7.color = param3;
            _loc_7.font = "_sans";
            _loc_7.size = param4;
            _loc_7.bold = param5;
            _loc_7.align = TextFormatAlign.CENTER;
            _loc_6.setTextFormat(_loc_7);
            return (_loc_6);
        }

        private function onLoadError(event:Event):void{
            var _loc_2:String;
            finished = true;
            if (discarded){
                unload();
            } else {
                _loc_2 = ((errorId + "#") + size);
                if (!errorImage[_loc_2]){
                    errorImage[_loc_2] = createLabelBitmapData(Bootstrap.getBootstrap().getMessage(errorId), size, false);
                };
                addChild(new Bitmap(errorImage[_loc_2]));
                removeLoaderEventListeners(loader);
                dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            };
        }
        public function getLoader():Loader{
            return (loader);
        }
        public function unload():void{
            if (!finished){
                discarded = true;
                dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                finished = true;
            } else {
                if (loader){
                    removeLoaderEventListeners(loader);
                    removeChild(loader);
                    loader.unload();
                    loader = null;
                };
            };
        }
        public function getDisplayObject():DisplayObject{
            return (this);
        }
        private function addLoaderEventListeners(param1:Loader):void{
            param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            param1.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
        }
        private function removeLoaderEventListeners(param1:Loader):void{
            param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            param1.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
        }
        private function onLoadComplete(event:Event):void{
            finished = true;
            if (discarded){
                unload();
            } else {
                removeLoaderEventListeners(loader);
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }
        public function get loadComplete():Boolean{
            return (finished);
        }

    }
}//package com.mapplus.maps.core 
