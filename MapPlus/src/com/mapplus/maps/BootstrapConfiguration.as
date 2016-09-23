//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.system.*;
    import com.adobe.crypto.*;
    import flash.display.*;
    import flash.net.*;

    public class BootstrapConfiguration {

        public static const DEFAULT_LOCAL_URL:String = "file://*";
        private static const ERROR_UNKNOWN_AIR_URL:String = "安装失败: 请设置应用程序的 URL.";
        private static const ERROR_UNKNOWN_KEY:String = "安装失败: 请设置 API key 或者 client id.";
        private static const BOOTSTRAP_PARAMS:Array = [];
        private static const HTML_PARAMS:Array = ["key", "client", "channel", "sensor", "language", "languages", "countryCode", "version", "ssl"];
        private static const MAP_3D_CLASSES:Array = ["com.mapplus.maps.Map3D", "com.mapplus.maps.controls.AttitudeControl"];
        private static const PREFIX_HTTP:String = "http:";
        private static const ERROR_CLIENT_BUT_NO_SENSOR:String = "安装失败: 请设置 sensor 的属性.";
        private static const PREFIX_HTTPS:String = "https:";
        private static const NATIVE_APPLICATION_NAME:String = "flash.desktop.NativeApplication";
        private static const MFE_REQUEST_PARAMS:Array = ["key", "client", "channel"];
        private static const MAJOR_VERSION_DEFAULT:String = "1";

        private static const BOOTSTRAP_PATH:String ="MapPlus.swf";

        private static var instance:BootstrapConfiguration;

        private var _acceptLanguageHeader:String;
        private var _version:String;
        private var _languages:String;
        private var _key:String = "google";
        private var _locked:Boolean;
        private var _clientConfiguration:String;
        private var _url:String;
        private var _language:String;
        private var _channel:String;
        private var _mfeRequestParams:String;
        private var _ssl:String;
        private var nativeApplication:Object;
        private var _sensor:String = "false";
        private var _countryCode:String;
        private var _client:String;
        private var _hash:String;
        private var _is3D:Boolean;
        private var _stage:DisplayObject;

        public function BootstrapConfiguration(){
            super();
            var _loc_1:ApplicationDomain;
            var _loc_2:Class;
            _is3D = testWhether3D();
            _loc_1 = ApplicationDomain.currentDomain;
            if (_loc_1.hasDefinition(NATIVE_APPLICATION_NAME)){
                _loc_2 = (_loc_1.getDefinition(NATIVE_APPLICATION_NAME) as Class);
                this.nativeApplication = _loc_2["nativeApplication"];
            };
        }
        public static function getInstance():BootstrapConfiguration{
            if (BootstrapConfiguration.instance == null){
                BootstrapConfiguration.instance = new (BootstrapConfiguration)();
            };
            return (BootstrapConfiguration.instance);
        }
        private static function getPlayerMajorVersion():int{
            var _loc_1:Object;
            _loc_1 = /(\w+)\s*(\d+),(\d+),(\d+),(\d+)/.exec(Capabilities.version);
            if (_loc_1){
                return (int(_loc_1[2]));
            };
            return (0);
        }
        public static function encodeNamedClassUsage(param1:String):String{
            var _loc_2:ApplicationDomain;
            var _loc_3:Array;
            var _loc_4:String;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:String;
            var _loc_8:int;
            _loc_2 = ApplicationDomain.currentDomain;
            _loc_3 = param1.split(",");
            _loc_4 = "";
            _loc_5 = 0;
            _loc_6 = 0;
            while (_loc_6 < _loc_3.length) {
                _loc_7 = ("com.mapplus.maps." + _loc_3[_loc_6].replace("/", "."));
                _loc_8 = (_loc_6 % 5);
                if (_loc_2.hasDefinition(_loc_7)){
                    _loc_5 = (_loc_5 | (1 << _loc_8));
                };
                if (_loc_8 != 4){
                };
                if (_loc_6 == (_loc_3.length - 1)){
                    _loc_4 = (_loc_4 + String.fromCharCode(((_loc_5 >= 10)) ? ((_loc_5 - 10) + "a".charCodeAt()) : (_loc_5 + "0".charCodeAt())));
                    _loc_5 = 0;
                };
                _loc_6 = (_loc_6 + 1);
            };
            return (_loc_4);
        }

        public function get isSsl():Boolean{
            return ((ssl == "true"));
        }
        public function get channel():String{
            return (this._channel);
        }
        private function get hl():String{
            return (this.language);
        }
        public function set channel(param1:String):void{
            checkLocked(this._channel, param1);
            this._channel = param1;
        }
        public function get ssl():String{
            return (_ssl);
        }
        private function testWhether3D():Boolean{
            var _loc_1:ApplicationDomain;
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:String;
            _loc_1 = ApplicationDomain.currentDomain;
            _loc_2 = BootstrapConfiguration.MAP_3D_CLASSES;
            _loc_3 = 0;
            while (_loc_3 != _loc_2.length) {
                _loc_4 = _loc_2[_loc_3];
                if (_loc_1.hasDefinition(_loc_4)){
                    return (true);
                };
                _loc_3 = (_loc_3 + 1);
            };
            return (false);
        }
        public function set client(param1:String):void{
            checkLocked(this._client, param1);
            this._client = param1;
        }
        public function getBootstrapUrl():String{
            var _loc_1:String;
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:String;
            var _loc_5:String;
            var _loc_6:Date;
            var _loc_7:int;
            var _loc_8:int;
            _loc_1 = ((isSsl) ? PREFIX_HTTPS : PREFIX_HTTP + "//");
            _loc_1 = (_loc_1 + (isSsl) ? Release.mfeHostHttps : Release.mfeHost);
            _loc_1 = (_loc_1 + BootstrapConfiguration.BOOTSTRAP_PATH);
            _loc_2 = BootstrapConfiguration.BOOTSTRAP_PARAMS;
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length) {
                _loc_4 = _loc_2[_loc_3];
                _loc_5 = this[_loc_4];
                if (_loc_5 != null){
                    _loc_1 = (_loc_1 + ((("&" + _loc_4) + "=") + encodeURIComponent(_loc_5)));
                };
                _loc_3 = (_loc_3 + 1);
            };
            if (isSsl){
                _loc_6 = new Date();
                _loc_7 = int((Math.random() * (1 << 24)));
                _loc_1 = (_loc_1 + "&nocache=");
                _loc_8 = "a".charCodeAt(0);
                _loc_3 = 0;
                while (_loc_3 < 6) {
                    _loc_1 = (_loc_1 + String.fromCharCode((_loc_8 + (_loc_7 & 15))));
                    _loc_7 = (_loc_7 >> 4);
                    _loc_3 = (_loc_3 + 1);
                };
            };
            return (BootstrapConfiguration.BOOTSTRAP_PATH);
        }
        public function get languages():String{
            return (this._languages);
        }
        public function isFlash10Map():Boolean{
            var _loc_1:Boolean;
            if (getPlayerMajorVersion() < 10){
                return (false);
            };
            _loc_1 = _stage.hasOwnProperty("z");
            return (_loc_1);
        }
        public function initialize(param1:LoaderInfo, param2:DisplayObject):void{
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:String;
            var _loc_6:String;
            if (this._locked){
                return;
            };
            _loc_3 = BootstrapConfiguration.HTML_PARAMS;
            _loc_4 = 0;
            while (_loc_4 != _loc_3.length) {
                _loc_5 = _loc_3[_loc_4];
                _loc_6 = ClientUtil.getFlashVar(param1, _loc_5);
                if (_loc_6){
                    this[_loc_5] = _loc_6;
                };
                _loc_4 = (_loc_4 + 1);
            };
            this._stage = param2;
            if (this.isAir()){
                this._hash = SHA1.hashBytes(param1["bytes"]);
            } else {
                this._url = param1.url;
            };
            this._clientConfiguration = getClientConfiguration();
        }
        public function is3D():Boolean{
            return (_is3D);
        }
        public function get countryCode():String{
            return (this._countryCode);
        }
        public function set ssl(param1:String):void{
            checkLocked(_ssl, param1);
            _ssl = param1;
        }
        public function lock(param1:Boolean=true):void{
            if (this._locked != param1){
                if (param1){
                    checkIsReady();
                };
                this._locked = param1;
            };
        }
        public function get flcl():String{
            return (encodeNamedClassUsage(ClassVector.CLASS_NAMES));
        }
        private function getClientConfiguration():String{
            var _loc_1:String;
            _loc_1 = "";
            _loc_1 = (_loc_1 + "x");
            if (isAir()){
                _loc_1 = (_loc_1 + "a");
            };
            if (is3D()){
                _loc_1 = (_loc_1 + "3");
            };
            if (isFlash10Map()){
                _loc_1 = (_loc_1 + "t");
            };
            if (isSsl){
                _loc_1 = (_loc_1 + "s");
            };
            return (_loc_1);
        }
        public function set languages(param1:String):void{
            var _loc_2:Array;
            var _loc_3:String;
            var _loc_4:Number = NaN;
            var _loc_5:int;
            this._languages = param1;
            if (param1.search(/\d/) >= 0){
                this._acceptLanguageHeader = param1.toLowerCase();
            } else {
                _loc_2 = param1.split(",");
                _loc_3 = _loc_2[0];
                _loc_4 = 0.8;
                _loc_5 = 1;
                while (_loc_5 < _loc_2.length) {
                    _loc_3 = (_loc_3 + ((("," + _loc_2[_loc_5]) + ";q=") + _loc_4));
                    _loc_4 = Math.max(0.1, _loc_4);
                    _loc_4 = (_loc_4 - 0.1);
                    _loc_5 = (_loc_5 + 1);
                };
                this._acceptLanguageHeader = _loc_3.toLowerCase();
            };
        }
        public function set key(key:String):void{
            this._key = key;
        }
        public function set language(language:String):void{
            checkLocked(this._language, language);
            this._language = language;
        }
        private function checkLocked(param1:String, param2:String):void{
            if (((this._locked) && (!((param1 == param2))))){
                throw (new Error("Configuration parameters can no longer be changed"));
            };
        }
        public function set countryCode(param1:String):void{
            checkLocked(this._countryCode, param1);
            this._countryCode = param1;
        }
        public function isAir():Boolean{
            return (!((this.nativeApplication == null)));
        }
        public function get sensor():String{
            return (this._sensor);
        }
        public function get client():String{
            return (this._client);
        }
        private function get vlib():String{
            return (this.version);
        }
        public function getClientVersion():String{
            return (Release.version);
        }
        public function set version(param1:String):void{
            checkLocked(this._version, param1);
            this._version = param1;
        }
        public function set url(param1:String):void{
            if (isAir()){
                this._url = param1;
            };
        }
        public function get key():String{
            return (this._key);
        }
        public function get flh():String{
            return (this._hash);
        }
        public function getMfeRequestParams():String{
            var _loc_1:String;
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            if (((!((this._mfeRequestParams == null))) && (!(this._locked)))){
                _loc_1 = "";
                _loc_2 = BootstrapConfiguration.MFE_REQUEST_PARAMS;
                _loc_3 = 0;
                while (_loc_3 != _loc_2.length) {
                    _loc_4 = _loc_2[_loc_3];
                    if (this[_loc_4] != null){
                        _loc_1 = (_loc_1 + ((("&" + _loc_4) + "=") + encodeURIComponent(this[_loc_4])));
                    };
                    _loc_3 = (_loc_3 + 1);
                };
                if (this._locked){
                    this._mfeRequestParams = _loc_1;
                };
                return (_loc_1);
            };
            return (this._mfeRequestParams);
        }
        public function get language():String{
            return (this._language);
        }
        public function loadAddingAcceptLanguageHeaderIfAir(param1:Loader, param2:URLRequest, param3:LoaderContext):void{
            var _loc_4:Array;
            if (((isAir()) && (this._acceptLanguageHeader))){
                _loc_4 = [new URLRequestHeader("Accept-Language", this._acceptLanguageHeader)];
                if (param2.requestHeaders){
                    _loc_4 = param2.requestHeaders.concat(_loc_4);
                };
                param2.requestHeaders = _loc_4;
                param1.load(param2, param3);
                return;
            };
            param1.load(param2, param3);
        }
        public function get fliburl():String{
            return (null);
        }
        public function get flc():String{
            return (this._clientConfiguration);
        }
        public function get url():String{
            if (this._url == null){
                return (null);
            };
            if (this._url.search("file://") != 0){
            };
            if (this._url.search(/https?:\/\/localhost(:\d+)?\//) == 0){
                return (DEFAULT_LOCAL_URL);
            };
            return (this._url);
        }
        public function get version():String{
            return (this._version);
        }
        private function checkIsReady():void{
        }
        private function get v():String{
            return (((MAJOR_VERSION_DEFAULT + ".") + Release.version));
        }
        public function get flpub():String{
            if (this.nativeApplication != null){
                return (this.nativeApplication["publisherID"]);
            };
            return (null);
        }
        public function set sensor(sensor:String):void{
            checkLocked(this._sensor, sensor);
            this._sensor = sensor;
        }
        public function get stage():DisplayObject{
            return (this._stage);
        }

    }
}//package com.mapplus.maps 
