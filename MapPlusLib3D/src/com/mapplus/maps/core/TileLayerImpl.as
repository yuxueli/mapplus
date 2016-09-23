//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.errors.*;

    public class TileLayerImpl implements ITileLayerAsync {

        private static const TEMPLATE_X:String = "{X}";
        private static const TEMPLATE_Y:String = "{Y}";
        private static const TEMPLATE_Z:String = "{Z}";

        private var copyrightCollection:ICopyrightCollection;
        private var tileSize:Number;
        private var _wrapper:Object;
        private var baseUrls:Array;
        private var minResolution:Number;
        private var alpha:Number;
        private var domains:Array;
        private var maxResolution:Number;
        private var mapType:IMapType;
        private var tileUrlTemplate:String;

        public function TileLayerImpl(param1:int, param2:Array, param3:ICopyrightCollection=null, param4:Number=NaN, param5:Number=NaN, param6:Number=1, param7:String=null){
            super();
            this.copyrightCollection = ((param3)!=null) ? param3 : new CopyrightCollection();
            this.minResolution = (isNaN(param4)) ? 0 : param4;
            this.maxResolution = (isNaN(param5)) ? this.minResolution : param5;
            this.alpha = param6;
            this.tileUrlTemplate = param7;
            mapType = null;
            this.tileSize = param1;
            this.baseUrls = param2;
            domains = computeDomains(this.baseUrls);
        }
        static function isEmbeddedParamTemplate(param1:String):Boolean{
            var _loc_2:RegExp;
            _loc_2 = /<[a-z]>""<[a-z]>/;
            return ((param1.search(_loc_2) >= 0));
        }
        static function replaceEmbeddedParams(param1:String, param2:int, param3:int, param4:int):String{
            var _loc_5:RegExp;
            var _loc_6:String;
            var _loc_7:int;
            var _loc_8:String;
            _loc_5 = /<[a-z]>""<[a-z]>/;
            _loc_6 = "";
            _loc_7 = param1.search(_loc_5);
            while (_loc_7 >= 0) {
                _loc_6 = (_loc_6 + param1.substr(0, _loc_7));
                _loc_8 = param1.charAt((_loc_7 + 1));
                if (_loc_8 == "x"){
                    _loc_6 = (_loc_6 + param2);
                } else {
                    if (_loc_8 == "y"){
                        _loc_6 = (_loc_6 + param3);
                    } else {
                        if (_loc_8 == "z"){
                            _loc_6 = (_loc_6 + param4);
                        } else {
                            if (_loc_8 == "t"){
                                _loc_6 = (_loc_6 + getQuadTreeEncoding(param2, param3, param4));
                            } else {
                                _loc_6 = (_loc_6 + param1.substr(_loc_7, 3));
                            };
                        };
                    };
                };
                param1 = param1.substr((_loc_7 + 3));
                _loc_7 = param1.search(_loc_5);
            };
            return ((_loc_6 + param1));
        }
        static function getQuadTreeEncoding(param1:int, param2:int, param3:int):String{
            var _loc_4:String;
            var _loc_5:Array;
            var _loc_6:Number = NaN;
            _loc_4 = "";
            _loc_5 = [["q", "r"], ["t", "s"]];
            _loc_6 = 0;
            while (_loc_6 < param3) {
                _loc_4 = (_loc_5[(param2 & 1)][(param1 & 1)] + _loc_4);
                param1 = (param1 >> 1);
                param2 = (param2 >> 1);
                _loc_6 = (_loc_6 + 1);
            };
            return (("t" + _loc_4));
        }
        private static function computeDomains(param1:Array):Array{
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:String;
            var _loc_5:int;
            var _loc_6:int;
            _loc_2 = [];
            _loc_3 = 0;
            while (_loc_3 < param1.length) {
                _loc_4 = param1[_loc_3];
                _loc_5 = _loc_4.indexOf("://");
                if (_loc_5 >= 0){
                    _loc_6 = _loc_4.indexOf("/", (_loc_5 + 3));
                    if (_loc_6 < 0){
                        _loc_6 = _loc_4.length;
                    };
                    _loc_2.push(_loc_4.substring(_loc_5, _loc_6));
                } else {
                    _loc_2.push(_loc_4);
                };
                _loc_3++;
            };
            return (_loc_2);
        }

        public function getTileDomain(param1:int, param2:int, param3:int):String{
            return (domains[getTileIndex(param1, param2, param3)]);
        }
        public function getMapType():IMapType{
            return (mapType);
        }
        public function get interfaceChain():Array{
            return (["ITileLayer"]);
        }
        public function getMaxResolution():Number{
            return (maxResolution);
        }
        public function loadTileAsync(param1:int, param2:int, param3:int):ITile{
            throw (new IllegalOperationError("Method not implemented"));
        }
        public function getTileSize():Number{
            return (tileSize);
        }
        private function getTileIndex(param1:int, param2:int, param3:int):int{
            return (((param1 + (2 * param2)) % baseUrls.length));
        }
        public function get wrapper():Object{
            return (_wrapper);
        }
        public function getAlpha():Number{
            return (alpha);
        }
        public function set wrapper(param1:Object):void{
            _wrapper = param1;
        }
        public function getCopyrightCollection():ICopyrightCollection{
            return (copyrightCollection);
        }
        public function getTileBaseUrl(param1:int, param2:int, param3:int):String{
            return (baseUrls[getTileIndex(param1, param2, param3)]);
        }
        public function loadTile(param1:Point, param2:Number):DisplayObject{
            return ((loadTileAsync(param1.x, param1.y, param2) as DisplayObject));
        }
        private function replaceTemplateArg(param1:String, param2:String, param3:Object):String{
            var _loc_4:Number = NaN;
            _loc_4 = param1.indexOf(param2);
            if (_loc_4 < 0){
                return (param1);
            };
            return (((param1.substr(0, _loc_4) + param3) + param1.substr((_loc_4 + param2.length))));
        }
        public function setMapType(param1:IMapType):void{
            this.mapType = param1;
        }
        public function getMinResolution():Number{
            return (minResolution);
        }

    }
}//package com.mapplus.maps.core 
