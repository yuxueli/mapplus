//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.geom.*;

    public class TileLayerImpl implements ITileLayerAsync {

        private static const TEMPLATE_X:String = "{X}";
        private static const TEMPLATE_Y:String = "{Y}";
        private static const TEMPLATE_Z:String = "{Z}";

        private var alpha:Number;
        private var copyrightCollection:ICopyrightCollection;
        private var mapType:IMapType;
        private var tileSize:Number;
        private var _wrapper:Object;
        private var baseUrls:Array;
        private var minResolution:Number;
        private var maxResolution:Number;
        private var domains:Array;
        private var tileUrlTemplate:String;

        public function TileLayerImpl(tileSize:int, baseUrls:Array, copyrightCollection:ICopyrightCollection=null, minResolution:Number=NaN, maxResolution:Number=NaN, alpha:Number=1, tileUrlTemplate:String=null){
            super();
            this.copyrightCollection = (!((copyrightCollection == null))) ? copyrightCollection : new CopyrightCollection();
            this.minResolution = (isNaN(minResolution)) ? 0 : minResolution;
            this.maxResolution = (isNaN(maxResolution)) ? this.minResolution : maxResolution;
            this.alpha = alpha;
            this.tileUrlTemplate = tileUrlTemplate;
            this.mapType = null;
            this.tileSize = tileSize;
            this.baseUrls = baseUrls;
            this.domains = computeDomains(this.baseUrls);
        }
        public static function isEmbeddedParamTemplate(param1:String):Boolean{
            var _loc_2:RegExp;
            _loc_2 = /<[a-z]>/;
            return ((param1.search(_loc_2) >= 0));
        }
        public static function replaceEmbeddedParams(param1:String, param2:int, param3:int, param4:int):String{
            var _loc_5:RegExp;
            var _loc_6:String;
            var _loc_7:int;
            var _loc_8:String;
            _loc_5 = /<[a-z]>/;
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
        public static function getQuadTreeEncoding(param1:int, param2:int, param3:int):String{
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

        private function replaceTemplateArg(param1:String, param2:String, param3:Object):String{
            var _loc_4:Number = NaN;
            _loc_4 = param1.indexOf(param2);
            if (_loc_4 < 0){
                return (param1);
            };
            return (((param1.substr(0, _loc_4) + param3) + param1.substr((_loc_4 + param2.length))));
        }
        public function get wrapper():Object{
            return (this._wrapper);
        }
        public function get interfaceChain():Array{
            return (["ITileLayer"]);
        }
        public function getMapType():IMapType{
            return (this.mapType);
        }
        public function getAlpha():Number{
            return (this.alpha);
        }
        public function getTileSize():Number{
            return (this.tileSize);
        }
        public function loadTile(param1:Point, param2:Number):DisplayObject{
            return ((this.loadTileAsync(param1.x, param1.y, param2) as DisplayObject));
        }
        private function getTileIndex(param1:int, param2:int, param3:int):int{
            return (((param1 + (2 * param2)) % this.baseUrls.length));
        }
        public function set wrapper(param1:Object):void{
            this._wrapper = param1;
        }
        public function getCopyrightCollection():ICopyrightCollection{
            return (this.copyrightCollection);
        }
        public function getTileBaseUrl(param1:int, param2:int, param3:int):String{
            return (this.baseUrls[this.getTileIndex(param1, param2, param3)]);
        }
        public function getTileDomain(param1:int, param2:int, param3:int):String{
            return (this.domains[this.getTileIndex(param1, param2, param3)]);
        }
        public function loadTileAsync(x:int, y:int, zoom:int):ITile{
            throw (new IllegalOperationError("Method not implemented"));
        }
        public function getMinResolution():Number{
            return (this.minResolution);
        }
        public function setMapType(param1:IMapType):void{
            this.mapType = param1;
        }
        public function getMaxResolution():Number{
            return (this.maxResolution);
        }

    }
}//package com.mapplus.maps.core 
