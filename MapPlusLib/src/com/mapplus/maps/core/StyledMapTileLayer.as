//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.styles.*;

    public class StyledMapTileLayer extends MapTileLayer {

        private static var FEATURE_TYPES:Object = createFeatureTypes();
        private static var STYLER_KEYS:Object = {
            hue:"h",
            saturation:"s",
            lightness:"l",
            gamma:"g",
            invert_lightness:"il",
            visibility:"v"
        };
        private static var ELEMENT_TYPES:Object = createElementTypes();

        private var extraParams:String;
        private var styleVar:Array;

        public function StyledMapTileLayer(param1:Array){
            var _loc_2:IMapType;
            var _loc_3:ITileLayer;
            _loc_2 = Bootstrap.getBootstrap().getNormalMapType();
            _loc_3 = _loc_2.getTileLayers()[0];
            super(_loc_2.getTileSize(), Bootstrap.getBootstrap().getSettings().tile_urls.map_urls, _loc_3.getCopyrightCollection(), _loc_2.getMaximumResolution());
            this.styleVar = param1;
            this.initExtraParams();
        }
        static function validateElement(param1:String):String{
            return (((((param1) && (ELEMENT_TYPES[param1.toLowerCase()]))) || (null)));
        }
        static function validateFeature(param1:String){
            var _loc_2:* = undefined;
            _loc_2 = ((param1) && (FEATURE_TYPES[param1.toLowerCase()]));
            return ((!((_loc_2 == null))) ? _loc_2 : null);
        }
        private static function createElementTypes():Object{
            var _loc_1:Object;
            _loc_1 = {};
            _loc_1[MapTypeStyleElementType.ALL] = "";
            _loc_1[MapTypeStyleElementType.GEOMETRY] = "g";
            _loc_1[MapTypeStyleElementType.LABELS] = "l";
            return (_loc_1);
        }
        static function validateKey(param1:String):String{
            return (((((param1) && (STYLER_KEYS[param1.toLowerCase()]))) || (null)));
        }
        static function stylerToString(param1:Object):String{
            var _loc_2:String;
            var _loc_3:* = undefined;
            var _loc_4:String;
            for (_loc_2 in param1) {
                _loc_3 = param1[_loc_2];
                _loc_4 = validateKey(_loc_2);
                if (((_loc_4) && (validateValue(_loc_3)))){
                    if (_loc_4 == "h"){
                        _loc_3 = htmlColor(_loc_3);
                    };
                    return (((("p." + _loc_4) + ":") + encodeURIComponent(_loc_3)));
                };
            };
            return ("");
        }
        static function htmlColor(param1:uint):String{
            var _loc_2:String;
            _loc_2 = (param1 & 0xFFFFFF).toString(16);
            return (("#000000".substr(0, (7 - _loc_2.length)) + _loc_2));
        }
        static function getEncodedStyle(param1:MapTypeStyle):String{
            var _loc_2:Array;
            var _loc_3:String;
            var _loc_4:String;
            var _loc_5:int;
            var _loc_6:String;
            _loc_2 = [];
            _loc_3 = validateFeature(param1.featureType);
            if (_loc_3){
                _loc_2.push(("s.t:" + _loc_3));
            };
            _loc_4 = validateElement(param1.elementType);
            if (_loc_4){
                _loc_2.push(("s.e:" + _loc_4));
            };
            _loc_5 = 0;
            while (_loc_5 < param1.stylers.length) {
                _loc_6 = stylerToString(param1.stylers[_loc_5]);
                if (_loc_6){
                    _loc_2.push(_loc_6);
                };
                _loc_5++;
            };
            return (_loc_2.join("|"));
        }
        static function validateValue(param1){
            return (((((((param1 is Number)) || ((param1 is String)))) || ((typeof(param1) == "boolean")))) ? param1 : null);
        }
        private static function createFeatureTypes():Object{
            var _loc_1:Object;
            _loc_1 = {};
            _loc_1[MapTypeStyleFeatureType.ALL] = FeatureTypeCategory.TYPE_ALL;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE] = FeatureTypeCategory.TYPE_ADMINISTRATIVE;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE_COUNTRY] = FeatureTypeCategory.TYPE_COUNTRY;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE_PROVINCE] = FeatureTypeCategory.TYPE_PROVINCE;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE_LOCALITY] = FeatureTypeCategory.TYPE_LOCALITY;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE_NEIGHBORHOOD] = FeatureTypeCategory.TYPE_NEIGHBORHOOD;
            _loc_1[MapTypeStyleFeatureType.ADMINISTRATIVE_LAND_PARCEL] = FeatureTypeCategory.TYPE_LAND_PARCEL;
            _loc_1[MapTypeStyleFeatureType.POI] = FeatureTypeCategory.TYPE_POI;
            _loc_1[MapTypeStyleFeatureType.POI_GOVERNMENT] = FeatureTypeCategory.TYPE_GOVERNMENT;
            _loc_1[MapTypeStyleFeatureType.POI_SCHOOL] = FeatureTypeCategory.TYPE_SCHOOL;
            _loc_1[MapTypeStyleFeatureType.POI_MEDICAL] = FeatureTypeCategory.TYPE_MEDICAL;
            _loc_1[MapTypeStyleFeatureType.POI_ATTRACTION] = FeatureTypeCategory.TYPE_ATTRACTION;
            _loc_1[MapTypeStyleFeatureType.POI_PLACE_OF_WORSHIP] = FeatureTypeCategory.TYPE_PLACE_OF_WORSHIP;
            _loc_1[MapTypeStyleFeatureType.POI_SPORTS_COMPLEX] = FeatureTypeCategory.TYPE_SPORTS_COMPLEX;
            _loc_1[MapTypeStyleFeatureType.POI_PARK] = FeatureTypeCategory.TYPE_PARK;
            _loc_1[MapTypeStyleFeatureType.ROAD] = FeatureTypeCategory.TYPE_ROAD;
            _loc_1[MapTypeStyleFeatureType.ROAD_HIGHWAY] = FeatureTypeCategory.TYPE_HIGHWAY;
            _loc_1[MapTypeStyleFeatureType.ROAD_ARTERIAL] = FeatureTypeCategory.TYPE_ARTERIAL_ROAD;
            _loc_1[MapTypeStyleFeatureType.ROAD_LOCAL] = FeatureTypeCategory.TYPE_LOCAL_ROAD;
            _loc_1[MapTypeStyleFeatureType.TRANSIT] = FeatureTypeCategory.TYPE_TRANSIT;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_LINE] = FeatureTypeCategory.TYPE_TRANSIT_LINE;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_STATION] = FeatureTypeCategory.TYPE_TRANSIT_STATION;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_STATION_RAIL] = FeatureTypeCategory.TYPE_RAIL_STATION;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_STATION_BUS] = FeatureTypeCategory.TYPE_BUS_STOP;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_STATION_AIRPORT] = FeatureTypeCategory.TYPE_AIRPORT;
            _loc_1[MapTypeStyleFeatureType.TRANSIT_STATION_FERRY] = FeatureTypeCategory.TYPE_FERRY_TERMINAL;
            _loc_1[MapTypeStyleFeatureType.LANDSCAPE] = FeatureTypeCategory.TYPE_LANDSCAPE;
            _loc_1[MapTypeStyleFeatureType.LANDSCAPE_MAN_MADE] = FeatureTypeCategory.TYPE_MAN_MADE_STRUCTURE;
            _loc_1[MapTypeStyleFeatureType.LANDSCAPE_NATURAL] = FeatureTypeCategory.TYPE_NATURAL_FEATURE;
            _loc_1[MapTypeStyleFeatureType.WATER] = FeatureTypeCategory.TYPE_WATER;
            return (_loc_1);
        }

        private function initExtraParams():void{
            var _loc_1:int;
            var _loc_2:Array;
            var _loc_3:int;
            _loc_1 = this.styleVar.length;
            _loc_2 = new Array(_loc_1);
            _loc_3 = 0;
            while (_loc_3 < _loc_1) {
                _loc_2[_loc_3] = getEncodedStyle((this.styleVar[_loc_3] as MapTypeStyle));
                _loc_3++;
            };
            this.extraParams = ("&apistyle=" + _loc_2.join(","));
        }
        override protected function getExtraTileUrlParams():String{
            return (this.extraParams);
        }
        public function set style(param1:Array):void{
            this.styleVar = param1;
            this.initExtraParams();
        }
        public function get style():Array{
            return (this.styleVar);
        }

    }
}//package com.mapplus.maps.core 
