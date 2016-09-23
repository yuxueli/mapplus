//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import com.mapplus.maps.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.filters.*;
    import flash.system.*;
    import flash.net.*;
    import flash.events.*;

    public final class Tile extends Sprite implements ITile {

        private static var errorImage:Object = {};

        private var size:int;
        private var loader:Loader;
        private var errorId:String;
        private var finished:Boolean;
        private var discarded:Boolean;
        private var tileUrl:String;

        public function Tile(param1:String, param2:int, param3:String){
            super();
            var _loc_4:LoaderContext;
            if (param1){
                this.tileUrl = param1;
                this.loader = new Loader();
                this.addLoaderEventListeners(this.loader);
                _loc_4 = new LoaderContext(true);
                this.loader.load(new URLRequest(param1), _loc_4);
                addChild(this.loader);
                this.finished = false;
                this.discarded = false;
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

        public function get loadComplete():Boolean{
            return (this.finished);
        }
        private function removeLoaderEventListeners(param1:Loader):void{
            param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            param1.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
        }
        private function onLoadError(event:Event):void{
            var _loc_2:String;
            this.finished = true;
            if (this.discarded){
                this.unload();
            } else {
                _loc_2 = ((this.errorId + "#") + this.size);
                if (!(errorImage[_loc_2])){
                    errorImage[_loc_2] = createLabelBitmapData(Bootstrap.getBootstrap().getMessage(this.errorId), this.size, false);
                };
                addChild(new Bitmap(errorImage[_loc_2]));
                this.removeLoaderEventListeners(this.loader);
                dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            };
        }
        private function onLoadComplete(event:Event):void{
            this.finished = true;
            if (this.discarded){
                this.unload();
            } else {
                this.removeLoaderEventListeners(this.loader);
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }
        private function addLoaderEventListeners(param1:Loader):void{
            param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            param1.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
        }
        public function getDisplayObject():DisplayObject{
            return (this);
        }
        public function unload():void{
            if (!(this.finished)){
                this.discarded = true;
                dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                this.finished = true;
            } else {
                if (this.loader){
                    this.removeLoaderEventListeners(this.loader);
                    removeChild(this.loader);
                    this.loader.unload();
                    this.loader = null;
                };
            };
        }

    }
}//package com.mapplus.maps.core 
