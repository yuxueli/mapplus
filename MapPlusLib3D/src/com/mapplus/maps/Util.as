//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.styles.*;
    import flash.net.*;
    import flash.system.*;

    public class Util {

        public static const ALL_TILES_LOADED:Number = 0.999999;

        public function Util(){
            super();
        }
        public static function extractDomainFromUrl(param1:String):String{
            var _loc_2:RegExp;
            var _loc_3:RegExp;
            if (param1 == null){
                return (null);
            };
            _loc_2 = /^\w+:\/\/""^\w+:\/\//;
            _loc_3 = /(:|\/).*""(:|\/).*/;
            return (param1.replace(_loc_2, "").replace(_loc_3, ""));
        }
        public static function isSsl():Boolean{
            var _loc_1:Object;
            _loc_1 = Bootstrap.getBootstrap().getClientConfiguration();
            if (_loc_1.hasOwnProperty("isSsl")){
                return (_loc_1.isSsl);
            };
            return (((_loc_1.hasOwnProperty("ssl")) && ((_loc_1.ssl == "true"))));
        }
        public static function rectangleIntersects(param1:Rectangle, param2:Rectangle):Boolean{
            if (param1.left > param2.right){
                return (false);
            };
            if (param2.left > param1.right){
                return (false);
            };
            if (param1.top > param2.bottom){
                return (false);
            };
            if (param2.top > param1.bottom){
                return (false);
            };
            return (true);
        }
        public static function dilateRectangle(param1:Rectangle, param2:Point):Rectangle{
            return (new Rectangle((param1.left - param2.x), (param1.top - param2.y), (param1.width + (2 * param2.x)), (param1.height + (2 * param2.y))));
        }
        public static function matrixMultiply(param1:Matrix, param2:Matrix):Matrix{
            return (new Matrix(((param1.a * param2.a) + (param1.c * param2.b)), ((param1.b * param2.a) + (param1.d * param2.b)), ((param1.a * param2.c) + (param1.c * param2.d)), ((param1.b * param2.c) + (param1.d * param2.d)), (((param1.a * param2.tx) + (param1.c * param2.ty)) + param1.tx), (((param1.b * param2.tx) + (param1.d * param2.ty)) + param1.ty)));
        }
        public static function paramsToUrlString(param1:Object):String{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:String;
            var _loc_5:String;
            _loc_2 = "";
            _loc_3 = "";
            for (_loc_4 in param1) {
                _loc_5 = encodeURIComponent(param1[_loc_4]);
                _loc_5 = _loc_5.split("%3A").join(":");
                _loc_5 = _loc_5.split("%20").join("+");
                _loc_5 = _loc_5.split("%2C").join(",");
                _loc_2 = (_loc_2 + _loc_3);
                _loc_2 = (_loc_2 + _loc_4);
                _loc_2 = (_loc_2 + "=");
                _loc_2 = (_loc_2 + _loc_5);
                _loc_3 = "&";
            };
            return (_loc_2);
        }
        public static function extractBaseNameFromUrl(param1:String):String{
            var _loc_2:String;
            var _loc_3:Array;
            if (param1 == null){
                return (null);
            };
            _loc_2 = extractDomainFromUrl(param1);
            _loc_3 = _loc_2.match(/(?:.+?\.)?(.+?)(?:\..+)""(?:.+?\.)?(.+?)(?:\..+)/);
            if (!_loc_3){
                return (_loc_2);
            };
            return (_loc_3[1]);
        }
        public static function getExtension(param1:String):String{
            var _loc_2:Array;
            _loc_2 = getFileNameFromPath(param1).split(".");
            if (_loc_2.length <= 1){
                return (undefined);
            };
            if (_loc_2[(_loc_2.length - 2)] == ""){
                return (undefined);
            };
            return (_loc_2[(_loc_2.length - 1)]);
        }
        public static function rotationMatrix3DCoeffs(param1:Number, param2:Array):Array{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            _loc_3 = ((param1 * Math.PI) / 180);
            _loc_4 = Math.cos(_loc_3);
            _loc_5 = Math.sin(_loc_3);
            _loc_6 = param2[0];
            _loc_7 = param2[1];
            _loc_8 = param2[2];
            _loc_9 = (1 / Math.sqrt((((_loc_6 * _loc_6) + (_loc_7 * _loc_7)) + (_loc_8 * _loc_8))));
            _loc_6 = (_loc_6 * _loc_9);
            _loc_7 = (_loc_7 * _loc_9);
            _loc_8 = (_loc_8 * _loc_9);
            return ([((_loc_6 * _loc_6) + ((1 - (_loc_6 * _loc_6)) * _loc_4)), (((_loc_6 * _loc_7) * (1 - _loc_4)) - (_loc_8 * _loc_5)), (((_loc_6 * _loc_8) * (1 - _loc_4)) + (_loc_7 * _loc_5)), (((_loc_6 * _loc_7) * (1 - _loc_4)) + (_loc_8 * _loc_5)), ((_loc_7 * _loc_7) + ((1 - (_loc_7 * _loc_7)) * _loc_4)), (((_loc_7 * _loc_8) * (1 - _loc_4)) - (_loc_6 * _loc_5)), (((_loc_6 * _loc_8) * (1 - _loc_4)) - (_loc_7 * _loc_5)), (((_loc_7 * _loc_8) * (1 - _loc_4)) + (_loc_6 * _loc_5)), ((_loc_8 * _loc_8) + ((1 - (_loc_8 * _loc_8)) * _loc_4))]);
        }
        public static function singleton(param1:Function):Object{
            var _loc_2:Object;
            _loc_2 = (param1 as Object);
            if (!_loc_2.instance_){
                _loc_2.instance_ = new (param1)();
            };
            return (_loc_2.instance_);
        }
        public static function addArrayElementsToArray(param1:Array, param2:Array):void{
            var _loc_3:Number = NaN;
            _loc_3 = 0;
            while (_loc_3 < param2.length) {
                addValueToArray(param1, param2[_loc_3]);
                _loc_3 = (_loc_3 + 1);
            };
        }
        public static function zoomFactorToOffset(param1:Number, param2:Number):Number{
            if (param2 == 2){
                return ((Math.log(param1) * Math.LOG2E));
            };
            return ((Math.log(param1) / Math.log(param2)));
        }
        public static function copyVariable(param1:Object, param2:Object, param3:String, param4:Class=null):void{
            var _loc_5:Object;
            _loc_5 = param2[param3];
            if (_loc_5 != null){
                return;
            };
            if (!param1.hasOwnProperty(param3)){
                return;
            };
            _loc_5 = param1[param3];
            if (param4 != null){
                _loc_5 = (_loc_5 as param4);
            };
            if (_loc_5 != null){
                param2[param3] = _loc_5;
            };
        }
        public static function rectFromExtents(param1:Number, param2:Number, param3:Number, param4:Number):Rectangle{
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            if (param1 > param3){
                _loc_5 = param1;
                param1 = param3;
                param3 = _loc_5;
            };
            if (param2 > param4){
                _loc_6 = param2;
                param2 = param4;
                param4 = _loc_6;
            };
            return (new Rectangle(param1, param2, (param3 - param1), (param4 - param2)));
        }
        public static function getDefaultButtonStyle():ButtonStyle{
            return (new ButtonStyle({
                allStates:{
                    fillStyle:{alpha:Alpha.OPAQUE},
                    strokeStyle:{
                        color:Color.BLACK,
                        alpha:Alpha.OPAQUE,
                        thickness:1
                    },
                    labelFormat:{
                        font:"_sans",
                        size:12
                    },
                    bevelThickness:2,
                    bevelAlpha:0.5,
                    highlightColor:Color.WHITE,
                    shadowColor:Color.BLACK
                },
                upState:{
                    fillStyle:{color:Color.WHITE},
                    bevelStyle:BevelStyle.BEVEL_RAISED
                },
                downState:{
                    fillStyle:{color:Color.GRAY15},
                    labelFormat:{bold:true},
                    bevelStyle:BevelStyle.BEVEL_LOWERED
                },
                overState:{
                    fillStyle:{color:Color.WHITE},
                    bevelStyle:BevelStyle.BEVEL_RAISED
                }
            }));
        }
        public static function degreesToRadians(param1:Number):Number{
            return ((param1 * (Math.PI / 180)));
        }
        public static function windowMatrix(param1:Rectangle, param2:Rectangle, param3:Boolean=false):Matrix{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = param2.width / param1.width;
            _loc_5 = param2.height / param1.height * (param3 ? -1 : 1);
			return new Matrix(_loc_4, 0, 0, _loc_5, param2.left - _loc_4 * param1.left, param2.top - _loc_5 * (param3 ? param1.bottom : param1.top));
        }
        public static function rectCenter(param1:Rectangle):Point{
            return (new Point((param1.left + (0.5 * param1.width)), (param1.top + (0.5 * param1.height))));
        }
        public static function radiansToDegrees(param1:Number):Number{
            return ((param1 / (Math.PI / 180)));
        }
        public static function getFracZoom(param1:Number, param2:Number):Number{
            var _loc_3:Number = NaN;
            _loc_3 = Math.floor(param1);
            return (Math.pow(param2, (param1 - _loc_3)));
        }
        public static function rotationMatrix(param1:Number, param2:Point=null):Matrix{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_3 = ((param1 * Math.PI) / 180);
            _loc_4 = Math.sin(_loc_3);
            _loc_5 = Math.cos(_loc_3);
            if (param2){
                return (new Matrix(_loc_5, _loc_4, -(_loc_4), _loc_5, (((1 - _loc_5) * param2.x) + (_loc_4 * param2.y)), ((-(_loc_4) * param2.x) + ((1 - _loc_5) * param2.y))));
            };
            return (new Matrix(_loc_5, _loc_4, -(_loc_4), _loc_5));
        }
        public static function loadAddingAcceptLanguageHeaderIfAir(param1:Loader, param2:URLRequest, param3:LoaderContext=null):void{
            var _loc_4:Object;
            _loc_4 = Bootstrap.getBootstrap().getClientConfiguration();
            if (((_loc_4) && (_loc_4.hasOwnProperty("loadAddingAcceptLanguageHeaderIfAir")))){
                _loc_4.loadAddingAcceptLanguageHeaderIfAir(param1, param2, param3);
                return;
            };
            param1.load(param2, param3);
        }
        public static function xyzToLatLng(param1:Array):LatLng{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_2 = param1[0];
            _loc_3 = param1[1];
            _loc_4 = param1[2];
            _loc_5 = (180 / Math.PI);
            return (new LatLng(((Math.acos(_loc_4) * _loc_5) - 90), (Math.atan2(_loc_3, _loc_2) * _loc_5)));
        }
        public static function transformRectangle(param1:Matrix, param2:Rectangle):Rectangle{
            return (new Rectangle((((param1.a * param2.left) + (param1.b * param2.top)) + param1.tx), (((param1.c * param2.left) + (param1.d * param2.top)) + param1.ty), ((param1.a * param2.width) + (param1.b * param2.height)), ((param1.c * param2.width) + (param1.d * param2.height))));
        }
        public static function sqrDistToMidpoint(param1:Point, param2:Point, param3:Point):Number{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = (param1.x - (0.5 * (param2.x + param3.x)));
            _loc_5 = (param1.y - (0.5 * (param2.y + param3.y)));
            return (((_loc_4 * _loc_4) + (_loc_5 * _loc_5)));
        }
        public static function scalePoint(param1:Point, param2:Number):void{
            param1.x = (param1.x * param2);
            param1.y = (param1.y * param2);
        }
        public static function urlStringToParams(param1:String):Object{
            var _loc_2:Object;
            var _loc_3:uint;
            var _loc_4:String;
            var _loc_5:Array;
            var _loc_6:String;
            _loc_2 = {};
            _loc_3 = param1.indexOf("?");
            if (_loc_3 >= 0){
                param1 = param1.substr((_loc_3 + 1));
            };
            for each (_loc_4 in param1.split("&")) {
                _loc_5 = _loc_4.split("=");
                _loc_6 = _loc_5[1];
                _loc_6 = _loc_6.split("+").join(" ");
                _loc_2[_loc_5[0]] = decodeURIComponent(_loc_6);
            };
            return (_loc_2);
        }
        public static function rectangleExtend(param1:Rectangle, param2:Point):void{
            var _loc_3:*;
            if (param1.width < 0){
                _loc_3 = param2.x;
                param1.right = param2.x;
                param1.left = _loc_3;
                _loc_3 = param2.y;
                param1.bottom = param2.y;
                param1.top = _loc_3;
            } else {
                param1.left = Math.min(param1.left, param2.x);
                param1.right = Math.max(param1.right, param2.x);
                param1.top = Math.min(param1.top, param2.y);
                param1.bottom = Math.max(param1.bottom, param2.y);
            };
        }
        public static function cloneStyleSheet(param1:StyleSheet):StyleSheet{
            var _loc_2:StyleSheet;
            var _loc_3:Array;
            var _loc_4:int;
            _loc_2 = new StyleSheet();
            _loc_3 = param1.styleNames;
            _loc_4 = 0;
            while (_loc_4 < _loc_3.length) {
                _loc_2.setStyle(_loc_3[_loc_4], param1.getStyle(_loc_3[_loc_4]));
                _loc_4++;
            };
            return (_loc_2);
        }
        public static function checkDomainImpl(param1:Object, param2:String):Boolean{
            var _loc_3:String;
            _loc_3 = param1.requestDomain.replace(/^https?:\/\/""^https?:\/\//, "");
            return ((_loc_3 == param2.replace(/^https?:\/\/""^https?:\/\//, "")));
        }
        public static function addValueToArray(param1:Array, param2):void{
            var _loc_3:Number = NaN;
            _loc_3 = 0;
            while (_loc_3 < param1.length) {
                if (param1[_loc_3] === param2){
                    return;
                };
                _loc_3 = (_loc_3 + 1);
            };
            param1.push(param2);
        }
        public static function rectFromPoints(param1:Point, param2:Point):Rectangle{
            return (new Rectangle(param1.x, param1.y, (param2.x - param1.x), (param2.y - param1.y)));
        }
        public static function sqrDist(param1:Point, param2:Point):Number{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            _loc_3 = (param1.x - param2.x);
            _loc_4 = (param1.y - param2.y);
            return (((_loc_3 * _loc_3) + (_loc_4 * _loc_4)));
        }
        public static function getFileNameFromPath(param1:String):String{
            var _loc_2:Number = NaN;
            _loc_2 = Math.max(param1.lastIndexOf("/"), param1.lastIndexOf("\\"));
            return (((_loc_2 >= 0)) ? param1.substr((_loc_2 + 1)) : param1);
        }
        public static function rectangleExtendByBounds(param1:Rectangle, param2:Rectangle):void{
            if (param2.width >= 0){
                param1.left = Math.min(param1.left, param2.left);
                param1.right = Math.max(param1.right, param2.right);
                param1.top = Math.min(param1.top, param2.top);
                param1.bottom = Math.max(param1.bottom, param2.bottom);
            };
        }
        public static function attitudeEquals(param1:Attitude, param2:Attitude):Boolean{
            if (param1){
                return (param1.equals(param2));
            };
            return ((param2 == null));
        }
        public static function getTileCoordinates(param1:LatLng, param2:Number, param3:IProjection, param4:Number):Point{
            var _loc_5:Point;
            _loc_5 = param3.fromLatLngToPixel(param1, Math.floor(param2));
            _loc_5.x = Math.floor((_loc_5.x / param4));
            _loc_5.y = Math.floor((_loc_5.y / param4));
            return (_loc_5);
        }
        public static function latLngToXYZ(param1:LatLng):Array{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            _loc_2 = (Math.PI / 180);
            _loc_3 = ((param1.lat() + 90) * _loc_2);
            _loc_4 = (param1.lng() * _loc_2);
            _loc_5 = Math.sin(_loc_3);
            _loc_6 = Math.cos(_loc_3);
            _loc_7 = Math.sin(_loc_4);
            _loc_8 = Math.cos(_loc_4);
            return ([(_loc_8 * _loc_5), (_loc_7 * _loc_5), _loc_6]);
        }
        public static function checkDomain(param1:Object):Boolean{
            return (checkDomainImpl(param1, Bootstrap.getBootstrap().getApiSiteUrl()));
        }
        public static function matrixMultiplyPoint3D(param1:Array, param2:Array):Array{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_3 = param2[0];
            _loc_4 = param2[1];
            _loc_5 = param2[2];
            return ([(((param1[0] * _loc_3) + (param1[1] * _loc_4)) + (param1[2] * _loc_5)), (((param1[3] * _loc_3) + (param1[4] * _loc_4)) + (param1[5] * _loc_5)), (((param1[6] * _loc_3) + (param1[7] * _loc_4)) + (param1[8] * _loc_5))]);
        }
        public static function bound(param1:Number, param2:Number=NaN, param3:Number=NaN):Number{
            if (!isNaN(param2)){
                param1 = Math.max(param1, param2);
            };
            if (!isNaN(param3)){
                param1 = Math.min(param1, param3);
            };
            return (param1);
        }
        public static function copyData(param1:Object, param2:Object, param3:Array=null, param4:Class=null):void{
            var _loc_5:Number = NaN;
            var _loc_6:String;
            if (param3 != null){
                _loc_5 = 0;
                while (_loc_5 < param3.length) {
                    copyVariable(param1, param2, param3[_loc_5], param4);
                    _loc_5 = (_loc_5 + 1);
                };
            } else {
                for (_loc_6 in param1) {
                    copyVariable(param1, param2, _loc_6, param4);
                };
            };
        }

    }
}//package com.mapplus.maps 
