//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.adobe.serialization.json.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;

    public class Bootstrap extends EventDispatcher {

        public static const FLASH_MAPS_CROSSDOMAIN_XML:String = "/svn/crossdomain.xml";

        private static var instance:Bootstrap;

        private var spriteFactory:ISpriteFactory;
        private var clientFactoryVersion:int;
        private var settings:Object;
        private var bootstrapConfiguration:Object;
        private var clientMinor:Number = -1;
        private var apiSiteUrl:String;
        private var clientFactory:IClientFactory;
        private var defaultMapTypes:Array;
        private var clientSubminor:String;
        private var physicalMapType:IMapType;
        private var normalMapType:IMapType;
        private var hybridMapType:IMapType;
        private var satelliteMapType:IMapType;
        private var bingMapType:IMapType;
        private var mapabcMapType:IMapType;
        private var qqMapType:IMapType;
        private var normalMapCopyrights:CopyrightCollection;
        private var satelliteMapCopyrights:CopyrightCollection;
        private var physicalMapCopyrights:CopyrightCollection;
        private var bingMapCopyrights:CopyrightCollection;
        private var mapabcMapCopyrights:CopyrightCollection;
        private var qqMapCopyrights:CopyrightCollection;
        private var mercatorProjection:IProjection;
        private var plateCarreeProjection:IProjection;
        private var baiduProjection:IProjection;

        public function Bootstrap(){
            super();
            this.clientMinor = -1;
            this.settings = null;
            this.apiSiteUrl = null;
        }
        private static function convertUrlArrayToGoogleDotCom(param1:Array):Array{
            var _loc_2:Array;
            var _loc_3:RegExp;
            var _loc_4:RegExp;
            var _loc_5:int;
            var _loc_6:Object;
            var _loc_7:String;
            var _loc_8:int;
            _loc_2 = [];
            _loc_3 = new RegExp("(.*//)([^/]+)(/.*)");
            _loc_4 = /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/;
            _loc_5 = 0;
            while (_loc_5 < param1.length) {
                _loc_6 = _loc_3.exec(param1[_loc_5]);
                if (_loc_6){
                    _loc_7 = _loc_6[2];
                    _loc_8 = _loc_7.indexOf(".");
                    if (((!(_loc_4.test(_loc_7))) && ((_loc_8 >= 0)))){
                        _loc_2.push((((_loc_6[1] + _loc_7.substring(0, _loc_8)) + ".google.com") + _loc_6[3]));
                    } else {
                        _loc_2.push(param1[_loc_5]);
                    };
                } else {
                    _loc_2.push(param1[_loc_5]);
                };
                _loc_5++;
            };
            return (_loc_2);
        }
        public static function drawBitmapData(param1:BitmapData, param2:IBitmapDrawable, param3:Matrix=null, param4:ColorTransform=null, param5:String=null, param6:Rectangle=null, param7:Boolean=false):Boolean{
            var bootstrap:* = null;
            var param1:* = param1;
            var param2:* = param2;
            var param3 = param3;
            var param4 = param4;
            var param5 = param5;
            var param6 = param6;
            var param7:Boolean = param7;
            var bitmapData:* = param1;
            var source:* = param2;
            var matrix:* = param3;
            var colorTransform:* = param4;
            var blendMode:* = param5;
            var clipRect:* = param6;
            var smoothing:* = param7;
            bootstrap = Bootstrap.getBootstrap();
            if (bootstrap.clientFactoryVersion >= 3){
                bootstrap.getClientFactory().drawBitmapData(bitmapData, source, matrix, colorTransform, blendMode, clipRect, smoothing);
                return (true);
                var _slot1:* = error;
            } else {
                Wrapper.drawBitmapData(bitmapData, source, matrix, colorTransform, blendMode, clipRect, smoothing);
                return (true);
            };
            return (false);
        }
        public static function createChildSprite(param1:DisplayObjectContainer, param2:int=-1):Sprite{
            var _loc_3:ISpriteFactory;
            var _loc_4:IWrappableSprite;
            _loc_3 = Bootstrap.getSpriteFactory();
            _loc_4 = _loc_3.createSprite();
            if (param2 >= 0){
                _loc_3.addChildAt(param1, _loc_4.getSprite(), param2);
            } else {
                _loc_3.addChild(param1, _loc_4.getSprite());
            };
            return (_loc_4.getSprite());
        }
        public static function getLoaderInfoContent(param1:LoaderInfo):DisplayObject{
            var bootstrap:* = null;
            var param1:* = param1;
            var loaderInfo:* = param1;
            bootstrap = Bootstrap.getBootstrap();
            if (bootstrap.clientFactoryVersion >= 3){
                return (bootstrap.getClientFactory().getLoaderInfoContent(loaderInfo));
                var _slot1:* = error;
            } else {
                return (Wrapper.getLoaderInfoContent(loaderInfo));
            };
            return (null);
        }
        private static function getNamedLayers(param1:Object, param2:String):Array{
            var _loc_3:Array;
            var _loc_4:Array;
            var _loc_5:String;
            _loc_3 = [];
            if (param2){
                _loc_4 = param2.split(",");
                for each (_loc_5 in _loc_4) {
                    if (param1.hasOwnProperty(_loc_5)){
                        _loc_3.push(param1[_loc_5]);
                    };
                };
            };
            return (_loc_3);
        }
        public static function getSpriteFactory():ISpriteFactory{
            var _loc_1:Bootstrap;
            _loc_1 = Bootstrap.getBootstrap();
            if (_loc_1.spriteFactory){
                return (_loc_1.spriteFactory);
            };
            if (_loc_1.clientFactoryVersion >= 2){
                _loc_1.spriteFactory = _loc_1.clientFactory.getSpriteFactory();
            } else {
                _loc_1.spriteFactory = new SpriteFactory();
            };
            return (_loc_1.spriteFactory);
        }
        public static function getLoaderContent(param1:Loader):DisplayObject{
            var bootstrap:* = null;
            var param1:* = param1;
            var loader:* = param1;
            bootstrap = Bootstrap.getBootstrap();
            if (bootstrap.clientFactoryVersion >= 3){
                return (bootstrap.getClientFactory().getLoaderContent(loader));
                var _slot1:* = error;
            } else {
                return (Wrapper.getLoaderContent(loader));
            };
            return (null);
        }
        private static function extractConfigFromUrlArray(param1:Array):Object{
            var _loc_2:int;
            _loc_2 = 0;
            while (_loc_2 < param1.length) {
                if ((((param1[_loc_2] is Object)) && (!((param1[_loc_2] is String))))){
                    return (param1.splice(_loc_2, 1)[0]);
                };
                _loc_2++;
            };
            return (null);
        }
        public static function getBootstrap():Bootstrap{
            if (!(Bootstrap.instance)){
                Bootstrap.instance = new (Bootstrap)();
            };
            return (Bootstrap.instance);
        }
        public static function parseJson(param1:String):Object{
            var jsonFixer:* = null;
            var fixedJson:* = null;
            var decoder:* = null;
            var param1:* = param1;
            var json:* = param1;
            jsonFixer = /\\x([0-9a-fA-F][0-9a-fA-F])/g;
            fixedJson = json.replace(jsonFixer, "\\u00$1");
            
			decoder = new JSONDecoder(fixedJson, true);
			
            return (decoder.getValue());
            var _slot1:* = e;
            Log.log(((((((_slot1.name + ":") + _slot1.message) + ":") + _slot1.at) + ":") + _slot1.text));
            return ({});
        }
        public static function createChildComponent(param1:DisplayObjectContainer, param2:int=-1, param3:Boolean=false):Sprite{
            var _loc_4:ISpriteFactory;
            var _loc_5:IWrappableSprite;
            var _loc_6:IMapFocusableComponent;
            var _loc_7:Sprite;
            _loc_4 = Bootstrap.getSpriteFactory();
            _loc_5 = _loc_4.createComponent();
            _loc_6 = (_loc_5 as IMapFocusableComponent);
            if (_loc_6){
                _loc_6.focusable = param3;
            };
            _loc_7 = _loc_5.getSprite();
            if (param2 >= 0){
                _loc_4.addChildAt(param1, _loc_7, param2);
            } else {
                _loc_4.addChild(param1, _loc_7);
            };
            return (_loc_7);
        }
        private static function mergeObject(param1:Object, param2:Object):void{
            var _loc_3:Object;
            if (((!(param1)) || (!(param2)))){
                return;
            };
            for (_loc_3 in param1) {
                param2[_loc_3] = param1[_loc_3];
            };
        }
        public static function copyToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):DisplayObject{
            var bootstrap:* = null;
            var param1:* = param1;
            var param2:* = param2;
            var param3:* = param3;
            var mc:* = param1;
            var size:* = param2;
            var matrix:* = param3;
            bootstrap = Bootstrap.getBootstrap();
            if (bootstrap.clientFactoryVersion >= 2){
                return (bootstrap.getClientFactory().copyToBitmap(mc, size, matrix));
                var _slot1:* = error;
            } else {
                return (Wrapper.copyPixelsToBitmap(mc, size, matrix));
            };
            return (null);
        }

        public function getClientFactory():IClientFactory{
            return (this.clientFactory);
        }
        public function release():void{
            this.bootstrapConfiguration = null;
            this.settings = null;
            this.clientFactory = null;
            this.spriteFactory = null;
            this.mercatorProjection = null;
            this.plateCarreeProjection = null;
            this.baiduProjection = null;
            this.normalMapCopyrights = null;
            this.satelliteMapCopyrights = null;
            this.physicalMapCopyrights = null;
            this.bingMapCopyrights = null;
            this.mapabcMapCopyrights = null;
            this.qqMapCopyrights = null;
            this.normalMapType = null;
            this.satelliteMapType = null;
            this.hybridMapType = null;
            this.physicalMapType = null;
            this.bingMapType = null;
            this.mapabcMapType = null;
            this.qqMapType = null;
            this.defaultMapTypes = null;
            this.apiSiteUrl = null;
            Bootstrap.instance = null;
            DelayHandler.release();
        }
        public function getCopyrightPrefix(param1:String):String{
            var _loc_2:Object;
            _loc_2 = this.getSettings();
            return ((((_loc_2) && (_loc_2.copyrights))) ? _loc_2.copyrights[param1] : null);
        }
        public function configureFromObject(param1:Object, param2:Object):void{
            var _loc_3:RegExp;
            var _loc_4:String;
            var _loc_5:String;
            var _loc_6:String;
            var _loc_7:RegExp;
            var _loc_8:Object;
            var _loc_9:String;
            var _loc_10:String;
            if (this.bootstrapConfiguration){
                return;
            };
            this.bootstrapConfiguration = param1;
            _loc_3 = /:\d+/;
            _loc_4 = this.getMapsHost();
            if (_loc_4){
                _loc_5 = _loc_4.replace(_loc_3, "");
                _loc_6 = (param1.hasOwnProperty("loadedLibraryUrl")) ? param1.loadedLibraryUrl : "";
                _loc_7 = /^https?:\/\/([^\/:]+)/;
                _loc_8 = _loc_7.exec(_loc_6);
                if (_loc_8){
                    _loc_9 = _loc_8[1];
                } else {
                    _loc_6 = "http://*/library.swf";
                    _loc_9 = "*";
                };
                Log.log0(("mfeDomain: " + _loc_5));
                Log.log0(("libDomain: " + _loc_9));
                if (_loc_5 != _loc_9){
                    _loc_10 = (("http://" + _loc_4) + FLASH_MAPS_CROSSDOMAIN_XML);
                    Security.loadPolicyFile(_loc_10);
                };
            };
            this.applyBootstrapSettings(param2);
        }
        public function getSettings():Object{
            return (this.settings);
        }
        public function getApiSiteUrl():String{
            return (this.apiSiteUrl);
        }
        public function getClientFactoryVersion():int{
            return (this.clientFactoryVersion);
        }
        public function getLibraryDomain():String{
            var _loc_1:String;
            var _loc_2:RegExp;
            var _loc_3:Object;
            var _loc_4:String;
            _loc_1 = (this.bootstrapConfiguration.hasOwnProperty("loadedLibraryUrl")) ? this.bootstrapConfiguration.loadedLibraryUrl : "";
            _loc_2 = /^https?:\/\/([^\/:]+)/;
            _loc_3 = _loc_2.exec(_loc_1);
            _loc_4 = (_loc_3) ? _loc_3[1] : "*";
            return (_loc_4);
        }
        public function getDefaultMapType(param1:String):IMapType{
            switch (param1){
                case PConstants.NORMAL_MAP_TYPE_NAME:
                    return (this.getNormalMapType());
                case PConstants.SATELLITE_MAP_TYPE_NAME:
                    return (this.getSatelliteMapType());
                case PConstants.HYBRID_MAP_TYPE_NAME:
                    return (this.getHybridMapType());
                case PConstants.PHYSICAL_MAP_TYPE_NAME:
                    return (this.getPhysicalMapType());
                case PConstants.BING_MAP_TYPE_NAME:
                    return (this.getBingMapType());
                case PConstants.MAPABC_MAP_TYPE_NAME:
                    return (this.getMapabcMapType());
                case PConstants.QQ_MAP_TYPE_NAME:
                    return (this.getQQMapType());
                default:
                    return (null);
            };
        }
        public function getPlateCarreeProjection():IProjection{
            if (!(this.plateCarreeProjection)){
                this.plateCarreeProjection = new PlateCarreeProjection(PConstants.ZOOM_LEVEL_LIMIT);
            };
            return (this.plateCarreeProjection);
        }
        public function getBaiduProjection():IProjection{
            if (!(this.baiduProjection)){
                this.baiduProjection = new BaiduProjection(PConstants.ZOOM_LEVEL_LIMIT);
            };
            return (this.baiduProjection);
        }
        public function getDefaultMapTypes():Array{
            return (this.defaultMapTypes);
        }
        private function setApiSiteUrl(param1:String):void{
            if (((param1) && (!(this.apiSiteUrl)))){
                this.apiSiteUrl = param1;
            };
        }
        public function getNormalMapType():IMapType{
            return (this.normalMapType);
        }
        public function getClientConfiguration():Object{
            return (this.bootstrapConfiguration);
        }
        public function getPhysicalMapType():IMapType{
            return (this.physicalMapType);
        }
        public function getBingMapType():IMapType{
            return (this.bingMapType);
        }
        public function getMapabcMapType():IMapType{
            return (this.mapabcMapType);
        }
        public function getQQMapType():IMapType{
            return (this.qqMapType);
        }
        public function getNamedProjection(param1:String):IProjection{
            if (param1 == "platecarree"){
                return (this.getPlateCarreeProjection());
            };
            if (param1 == "baidu"){
                return (this.getBaiduProjection());
            };
            return (this.getMercatorProjection());
        }
        public function isClientVersionAfter(param1:Number, param2:String=null):Boolean{
            var _loc_3:Object;
            var _loc_4:String;
            var _loc_5:RegExp;
            var _loc_6:Object;
            if (this.clientMinor < 0){
                _loc_3 = this.getClientConfiguration();
                _loc_4 = _loc_3.getClientVersion();
                _loc_5 = /(\d+)(\w*)/;
                _loc_6 = _loc_5.exec(_loc_4);
                this.clientMinor = Number(_loc_6[1]);
                this.clientSubminor = (_loc_6[2]) ? _loc_6[2] : "";
            };
            if (this.clientMinor > param1){
                return (true);
            };
            if (this.clientMinor == param1){
                if (((!(param2)) || ((param2.length == 0)))){
                    return (((this.clientSubminor) && (!((this.clientSubminor.length == 0)))));
                };
                return ((this.clientSubminor > param2));
            };
            return (false);
        }
        public function initializeDefaultMapTypes():void{
            var _loc_1:Object;
            var _loc_2:Object;
            var _loc_3:Object;
            var _loc_4:String;
            var _loc_5:Object;
            var _loc_6:Object;
            var _loc_7:String;
            var _loc_8:String;
            var _loc_9:Array;
            var _loc_10:Object;
            var _loc_11:Object;
            var _loc_12:MapTypeOptions;
            var _loc_13:Array;
            if (!(this.normalMapCopyrights)){
                this.normalMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.MAP_COPYRIGHT_PREFIX_ID));
            };
            if (!(this.satelliteMapCopyrights)){
                this.satelliteMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.SATELLITE_COPYRIGHT_PREFIX_ID));
            };
            if (!(this.physicalMapCopyrights)){
                this.physicalMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.MAP_COPYRIGHT_PREFIX_ID));
            };
            if (!(this.bingMapCopyrights)){
                this.bingMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.BING_COPYRIGHT_PREFIX_ID));
                this.bingMapCopyrights.addCopyright(new Copyright(PConstants.MAPABC_COPYRIGHT_PREFIX_ID, new LatLngBounds(new LatLng(-90, -180), new LatLng(90, 180)), 0, "BING"));
            };
            if (!(this.mapabcMapCopyrights)){
                this.mapabcMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.MAPABC_COPYRIGHT_PREFIX_ID));
                this.mapabcMapCopyrights.addCopyright(new Copyright(PConstants.MAPABC_COPYRIGHT_PREFIX_ID, new LatLngBounds(new LatLng(-90, -180), new LatLng(90, 180)), 0, "MapABC"));
            };
            if (!(this.qqMapCopyrights)){
                this.qqMapCopyrights = new CopyrightCollection(this.getCopyrightPrefix(PConstants.QQ_COPYRIGHT_PREFIX_ID));
                this.qqMapCopyrights.addCopyright(new Copyright(PConstants.QQ_COPYRIGHT_PREFIX_ID, new LatLngBounds(new LatLng(-90, -180), new LatLng(90, 180)), 0, "QQ"));
            };
            _loc_1 = this.getSettings();
            _loc_2 = DefaultVar.getObject(Object, _loc_1, "tile_urls");
            _loc_3 = {};
            for (_loc_4 in _loc_2) {
                _loc_9 = _loc_2[_loc_4];
                _loc_10 = extractConfigFromUrlArray(_loc_9);
                if (_loc_4 == "map_urls"){
                    _loc_3[_loc_4] = new MapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.normalMapCopyrights, PConstants.DEFAULT_RESOLUTION_MAP);
                } else {
                    if (_loc_4 == "satellite_urls"){
                        _loc_9 = convertUrlArrayToGoogleDotCom(_loc_9);
                        _loc_3[_loc_4] = new MapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.satelliteMapCopyrights, PConstants.DEFAULT_RESOLUTION_SATELLITE);
                    } else {
                        if (_loc_4 == "hybrid_urls"){
                            _loc_3[_loc_4] = new MapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.normalMapCopyrights, PConstants.DEFAULT_RESOLUTION_MAP);
                        } else {
                            if (_loc_4 == "physical_urls"){
                                _loc_3[_loc_4] = new MapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.physicalMapCopyrights, PConstants.DEFAULT_RESOLUTION_PHYSICAL);
                            } else {
                                if (_loc_4 == "bingmap_urls"){
                                    _loc_3[_loc_4] = new BingMapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.bingMapCopyrights, PConstants.DEFAULT_RESOLUTION_PHYSICAL);
                                } else {
                                    if (_loc_4 == "mapabc_urls"){
                                        _loc_3[_loc_4] = new MapTileLayer(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.mapabcMapCopyrights, PConstants.DEFAULT_RESOLUTION_PHYSICAL);
                                    } else {
                                        if (_loc_4 == "qqmap_urls"){
                                            _loc_3[_loc_4] = new QQMap(MapTypeImpl.DEFAULT_TILE_SIZE, _loc_9, this.qqMapCopyrights, PConstants.DEFAULT_RESOLUTION_PHYSICAL);
                                        } else {
                                            if (_loc_10){
                                                _loc_3[_loc_4] = new MapTileLayer(_loc_10.tile_size, _loc_9, null, _loc_10.max_resolution);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _loc_5 = this.getStandardMapTypes();
            mergeObject(_loc_1.map_types, _loc_5);
            _loc_6 = {};
            for (_loc_7 in _loc_5) {
                _loc_11 = _loc_5[_loc_7];
                _loc_12 = new MapTypeOptions({
                    shortName:_loc_11.shortName,
                    urlArg:_loc_11.urlArg,
                    textColor:_loc_11.textColor,
                    linkColor:_loc_11.linkColor,
                    errorMessage:_loc_11.errorMessage,
                    alt:_loc_11.alt,
                    tileSize:_loc_11.tileSize,
                    radius:LatLng.EARTH_RADIUS
                });
                _loc_13 = getNamedLayers(_loc_3, _loc_11.layers);
                if (_loc_13.length > 0){
                    _loc_6[_loc_7] = new MapTypeImpl(_loc_13, this.getNamedProjection(_loc_11.projection), _loc_11.name, _loc_12);
                };
            };
            this.defaultMapTypes = [];
            this.normalMapType = this.moveToDefaultMapTypes("map", _loc_6);
            this.satelliteMapType = this.moveToDefaultMapTypes("satellite", _loc_6);
            this.hybridMapType = this.moveToDefaultMapTypes("hybrid", _loc_6);
            this.physicalMapType = this.moveToDefaultMapTypes("physical", _loc_6);
            this.bingMapType = this.moveToDefaultMapTypes("bingmap", _loc_6);
            this.mapabcMapType = this.moveToDefaultMapTypes("mapabc", _loc_6);
            this.qqMapType = this.moveToDefaultMapTypes("qqmap", _loc_6);
            for (_loc_8 in _loc_6) {
                this.moveToDefaultMapTypes(_loc_8, _loc_6);
            };
        }
        public function getMercatorProjection():IProjection{
            if (!(this.mercatorProjection)){
                this.mercatorProjection = new MercatorProjection(PConstants.ZOOM_LEVEL_LIMIT);
            };
            return (this.mercatorProjection);
        }
        private function moveToDefaultMapTypes(param1:String, param2:Object):IMapType{
            var _loc_3:IMapType;
            if (param2.hasOwnProperty(param1)){
                _loc_3 = param2[param1];
                this.defaultMapTypes.push(_loc_3);
                delete param2[param1];
                return (_loc_3);
            };
            return (null);
        }
        private function getStandardMapTypes():Object{
            var _loc_1:Object;
            _loc_1 = {
                map:{
                    name:this.getMessage(PConstants.NORMAL_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.NORMAL_MAP_ABBR_ID),
                    layers:"map_urls",
                    urlArg:"m",
                    errorMessage:this.getMessage(PConstants.NORMAL_MAP_ERROR_ID),
                    alt:this.getMessage("show_street_map"),
                    tileSize:MapTypeImpl.DEFAULT_TILE_SIZE
                },
                satellite:{
                    name:this.getMessage(PConstants.SATELLITE_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.SATELLITE_MAP_ABBR_ID),
                    layers:"satellite_urls",
                    urlArg:"k",
                    textColor:Color.WHITE,
                    linkColor:Color.WHITE,
                    errorMessage:this.getMessage(PConstants.SATELLITE_MAP_ERROR_ID),
                    alt:this.getMessage("show_satellite_imagery"),
                    tileSize:String(MapTypeImpl.DEFAULT_TILE_SIZE)
                },
                hybrid:{
                    name:this.getMessage(PConstants.HYBRID_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.HYBRID_MAP_ABBR_ID),
                    layers:"satellite_urls,hybrid_urls",
                    urlArg:"h",
                    textColor:Color.WHITE,
                    linkColor:Color.WHITE,
                    errorMessage:this.getMessage(PConstants.SATELLITE_MAP_ERROR_ID),
                    alt:this.getMessage("show_imagery_with_street_names"),
                    tileSize:String(MapTypeImpl.DEFAULT_TILE_SIZE)
                },
                physical:{
                    name:this.getMessage(PConstants.PHYSICAL_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.PHYSICAL_MAP_ABBR_ID),
                    layers:"physical_urls",
                    urlArg:"p",
                    errorMessage:this.getMessage(PConstants.NORMAL_MAP_ERROR_ID),
                    alt:this.getMessage(PConstants.PHYSICAL_MAP_ALT_ID),
                    tileSize:String(MapTypeImpl.DEFAULT_TILE_SIZE)
                },
                bingmap:{
                    name:this.getMessage(PConstants.BING_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.BING_MAP_ABBR_ID),
                    layers:"bingmap_urls",
                    urlArg:"m",
                    errorMessage:this.getMessage(PConstants.BING_MAP_ERROR_ID),
                    alt:this.getMessage("show_bing_map"),
                    tileSize:MapTypeImpl.DEFAULT_TILE_SIZE
                },
                mapabc:{
                    name:this.getMessage(PConstants.MAPABC_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.MAPABC_MAP_ABBR_ID),
                    layers:"mapabc_urls",
                    urlArg:"m",
                    errorMessage:this.getMessage(PConstants.MAPABC_MAP_ERROR_ID),
                    alt:this.getMessage("show_mapabc_map"),
                    tileSize:MapTypeImpl.DEFAULT_TILE_SIZE
                },
                qqmap:{
                    name:this.getMessage(PConstants.QQ_MAP_NAME_ID),
                    shortName:this.getMessage(PConstants.QQ_MAP_ABBR_ID),
                    layers:"qqmap_urls",
                    urlArg:"m",
                    errorMessage:this.getMessage(PConstants.QQ_MAP_ERROR_ID),
                    alt:this.getMessage("show_qq_map"),
                    tileSize:MapTypeImpl.DEFAULT_TILE_SIZE
                }
            };
            return (_loc_1);
        }
        public function getMessage(param1:String):String{
            return ((((this.settings) && (this.settings.messages))) ? this.settings.messages[param1] : "");
        }
        public function getHybridMapType():IMapType{
            return (this.hybridMapType);
        }
        public function configure(param1:Object, param2:Loader):void{
            this.configureFromObject(param1, getJson(param2));//getJson(param2)parseJson(
			return;
        }
		//2011.6.8 修改  by 于学利
		private function getJson(param1:DisplayObjectContainer) : Object
		{
			var _loc_2:* = param1;
			var _loc_3:Object = null;
			while (_loc_2)
			{
				
				if (_loc_2.name == PConstants.MASTER_NAME)
				{
					_loc_3 = Object(_loc_2).getConfigData();
					return _loc_3;
				}
				_loc_2 = _loc_2.parent;
			}
			return _loc_3;
		}
        private function applyBootstrapSettings(param1:Object):void{
            this.settings = param1;
            this.setApiSiteUrl(this.settings.request_domain);
            this.initializeDefaultMapTypes();
        }
        public function useSwfResponse():Boolean{
            return (!((this.getMapsHost() == Bootstrap.getBootstrap().getLibraryDomain())));
        }
        public function getMapsHost():String{
            if (((this.bootstrapConfiguration.hasOwnProperty("mfeHost")) && (!((this.bootstrapConfiguration.mfeHost == null))))){
                return (this.bootstrapConfiguration.mfeHost);
            };
            return ((Util.isSsl()) ? Release.mfeHostHttps : Release.mfeHost);
        }
        public function addCopyrightData(param1:String):void{
            var _loc_2:Object;
            var _loc_3:Object;
            var _loc_4:int;
            var _loc_5:String;
            var _loc_6:* = undefined;
            var _loc_7:String;
            var _loc_8:Number = NaN;
            var _loc_9:String;
            var _loc_10:String;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Boolean;
            var _loc_18:LatLngBounds;
            var _loc_19:Copyright;
            var _loc_20:Array;
            if (!(param1)){
                return;
            };
            _loc_2 = parseJson(param1);
            if (((!(_loc_2)) || (!(_loc_2.hasOwnProperty("copyrights"))))){
                return;
            };
            _loc_3 = {};
            _loc_4 = 0;
            while (_loc_4 < _loc_2.copyrights.length) {
                _loc_6 = _loc_2.copyrights[_loc_4];
                _loc_7 = DefaultVar.getString(_loc_6, "id", null);
                _loc_8 = DefaultVar.getNumber(_loc_6, "id", NaN);
                _loc_9 = DefaultVar.getString(_loc_6, "type", null);
                _loc_10 = DefaultVar.getString(_loc_6, "copyright", null);
                _loc_11 = DefaultVar.getNumber(_loc_6, "lat_lo", NaN);
                _loc_12 = DefaultVar.getNumber(_loc_6, "lng_lo", NaN);
                _loc_13 = DefaultVar.getNumber(_loc_6, "lat_hi", NaN);
                _loc_14 = DefaultVar.getNumber(_loc_6, "lng_hi", NaN);
                _loc_15 = DefaultVar.getNumber(_loc_6, "min_zoom", NaN);
                _loc_16 = DefaultVar.getNumber(_loc_6, "max_zoom", NaN);
                _loc_17 = DefaultVar.getBoolean(_loc_6, "continue_searching", false);
                if (!(isNaN(_loc_8))){
                    _loc_7 = _loc_8.toString();
                };
                if (((((((((((((((!(_loc_7)) || (!(_loc_9)))) || (isNaN(_loc_11)))) || (isNaN(_loc_12)))) || (isNaN(_loc_13)))) || (isNaN(_loc_14)))) || (isNaN(_loc_15)))) || ((_loc_15 < 0)))){
                    Log.log2(((("Invalid copyright information entry#" + _loc_4) + " data: ") + param1));
                } else {
                    _loc_10 = _loc_10.split("&trade;").join("?");
                    if (_loc_16 < 0){
                        _loc_16 = NaN;
                    };
                    _loc_18 = new LatLngBounds(new LatLng(_loc_11, _loc_12), new LatLng(_loc_13, _loc_14));
                    _loc_19 = new Copyright(_loc_7, _loc_18, _loc_15, _loc_10, _loc_16, _loc_17);
                    if (!(_loc_3[_loc_9])){
                        _loc_3[_loc_9] = [];
                    };
                    _loc_3[_loc_9].push(_loc_19);
                };
                _loc_4++;
            };
            for (_loc_5 in _loc_3) {
                _loc_20 = _loc_3[_loc_5];
                if (_loc_5 == "m"){
                    this.normalMapCopyrights.addCopyrightArray(_loc_20);
                } else {
                    if (_loc_5 == "k"){
                        this.satelliteMapCopyrights.addCopyrightArray(_loc_20);
                    } else {
                        if (_loc_5 == "p"){
                            this.physicalMapCopyrights.addCopyrightArray(_loc_20);
                        };
                    };
                };
            };
        }
        public function getSatelliteMapType():IMapType{
            return (this.satelliteMapType);
        }
        public function setClientFactory(param1:IClientFactory, param2:int=0):void{
            this.clientFactory = param1;
            if (param2 != 0){
                this.clientFactoryVersion = param2;
            } else {
                this.clientFactoryVersion = param1.getVersion();
            };
        }

    }
}//package com.mapplus.maps.core 
