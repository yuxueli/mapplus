//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.utils.*;
    import flash.events.*;
    import flash.system.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.net.*;

    public class ClientBootstrap extends EventDispatcher {

        public static const INIT_COMPLETE:String = "initcomplete";
        public static const LIBRARY_LOADED:String = "libraryloaded";
        public static const BOOTSTRAP_FAILED:String = "bootstrapfailed";
        private static const LIBMODULE_FULL_10_3D:String = "_10_3d";
        private static const LIBMODULE_FULL_3D:String = "3D";

        private static var libraryUrlPrefix:String;
        private static var libraryUrlExtension:String;
        private static var instance:ClientBootstrap;

        private var container:ClientBootstrapSprite;
        private var timer:Timer;
        private var factory:IMapsFactory;
        private var bootstrapLoader:Loader;
        private var isInitialized:Boolean;
        private var registeredObjects:Dictionary;
        private var delayInitializers:Array;
        private var intranetLoader:URLLoader;
        private var librarySwfLoader:Loader;
        private var nextFrameCalls:Array;

        public function ClientBootstrap(){
            super();
            this.bootstrapLoader = null;
            this.librarySwfLoader = null;
            this.factory = null;
            this.isInitialized = false;
            this.delayInitializers = [];
            this.container = null;
            this.registeredObjects = new Dictionary(true);
        }
        private static function extractLibraryUrlPrefixAndExtension(param1:String):void{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = param1.lastIndexOf(".");
            if (_loc_2 >= 1){
                _loc_3 = param1.lastIndexOf("/", (_loc_2 - 1));
                if ((((_loc_3 >= 1)) && (!((param1.charAt((_loc_3 - 1)) == "/"))))){
                    libraryUrlPrefix = param1.substring(0, _loc_2);
                    libraryUrlExtension = param1.substring(_loc_2);
                    return;
                };
                if (_loc_3 == -1){
                    libraryUrlPrefix = param1.substring(0, _loc_2);
                    libraryUrlExtension = param1.substring(_loc_2);
                    return;
                };
            };
            libraryUrlPrefix = param1;
            libraryUrlExtension = "";
        }
        public static function getInstance():ClientBootstrap{
            if (!(ClientBootstrap.instance)){
                ClientBootstrap.instance = new (ClientBootstrap)();
            };
            return (ClientBootstrap.instance);
        }
        private static function getLibModuleName(param1:String):String{
            return (((libraryUrlPrefix + param1) + libraryUrlExtension));
        }

        public function isAir():Boolean{
            return (BootstrapConfiguration.getInstance().isAir());
        }
        public function delayInitialize(param1:Function):void{
            if (!(isReady())){
                delayInitializers.push(param1);
            } else {
                param1();
            };
        }
        private function onBootstrapLoaded(event:Event):void{
            if (isAir()){
            };
        }
        private function callSetUrl():void{
            this.setUrl(BootstrapConfiguration.getInstance().getBootstrapUrl());
        }
        private function executeNextFrameCalls(event:Event):void{
            var _loc_2:Array;
            var _loc_3:Function;
            this.timer.removeEventListener(TimerEvent.TIMER, executeNextFrameCalls);
            this.timer = null;
            _loc_2 = this.nextFrameCalls;
            this.nextFrameCalls = null;
            if (_loc_2 != null){
                for	each (_loc_3 in _loc_2) {
                    _loc_3();
                };
            };
        }
        private function allowLibraryDomain(param1:String):void{
            var _loc_2:Number = NaN;
            _loc_2 = param1.lastIndexOf("/");
            if (_loc_2 >= 0){
                param1 = param1.substring(0, _loc_2);
            };
            Security.allowDomain(param1);
        }
        private function onLibrarySwfLoaded(event:Event):void{
            scheduleForNextFrame(createFactory);
        }
        public function isReady():Boolean{
            return (!((this.factory == null)));
        }
        public function registerObject(param1:Object):void{
            this.registeredObjects[param1] = true;
        }
        private function loadUrl(param1:Loader, param2:String):Loader{
            var _loc_3:LoaderContext;
            var _loc_4:URLRequest;
            var _loc_5:RegExp;
            Log.log0(("ClientBootstrap - loading: " + param2));
            this.container.addChild(param1);
            if (!(isAir())){
                _loc_5 = /:\d+/;
                allowLibraryDomain(param2.replace(_loc_5, ""));
            };
            _loc_3 = new LoaderContext(false, new ApplicationDomain());
            _loc_4 = new URLRequest(param2);
            BootstrapConfiguration.getInstance().loadAddingAcceptLanguageHeaderIfAir(param1, _loc_4, _loc_3);
            return (param1);
        }
        public function unregisterObject(param1:Object):void{
            var _loc_2:Object;
			delete this.registeredObjects[param1];
            for (_loc_2 in this.registeredObjects) {
                if (_loc_2 != null){
                    return;
                };
            };
            unloadBootstrap();
        }
        private function onBootstrapFailed(event:Event):void{
            this.dispatchEvent(new Event(ClientBootstrap.BOOTSTRAP_FAILED));
        }
        private function setUrl(param1:String):void{
            var _loc_2:BootstrapConfiguration;
            var _loc_3:Loader;
            extractLibraryUrlPrefixAndExtension(param1);
            _loc_2 = BootstrapConfiguration.getInstance();
            if (BootstrapConfiguration.getInstance().is3D()){
                param1 = getLibModuleName((_loc_2.isFlash10Map()) ? LIBMODULE_FULL_3D : LIBMODULE_FULL_10_3D);
            };
            _loc_3 = new Loader();
            _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLibrarySwfLoaded);
            _loc_3.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onBootstrapFailed);
            this.librarySwfLoader = loadUrl(_loc_3, param1);
        }
        private function createFactory():void{
            var _loc_6:*;
            var _loc_1:Object;
            var _loc_2:BootstrapConfiguration;
            var _loc_3:Object;
            var _loc_4:int;
            var _loc_5:DisplayObject;
            _loc_1 = (this.librarySwfLoader.content as Object);
            _loc_2 = BootstrapConfiguration.getInstance();
            if (((isAir()) && (!((_loc_1 == null))))){
                _loc_1.configure(_loc_2, this.bootstrapLoader);
            };
            _loc_3 = _loc_1.getWrapper();
            Wrapper.instance().setAlienWrapper(_loc_3);
            this.factory = Wrapper.instance().wrapIMapsFactory3D(_loc_1.getFactory());
            this.factory.setClientFactory(new ClientFactory());
            this.dispatchEvent(new Event(ClientBootstrap.LIBRARY_LOADED));
            _loc_4 = 0;
            while (_loc_4 < delayInitializers.length) {
                _loc_6 = delayInitializers;
                var _local7 = _loc_6.delayInitializers;
                _local7[_loc_4]();
                _loc_4 = (_loc_4 + 1);
            };
            delayInitializers = [];
            _loc_5 = _loc_2.stage;
            _loc_5.addEventListener(MouseEvent.MOUSE_UP, this.factory.reportMouseEvent);
            _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.factory.reportMouseEvent);
            _loc_5.addEventListener(MouseEvent.MOUSE_MOVE, this.factory.reportMouseEvent);
            this.dispatchEvent(new Event(ClientBootstrap.INIT_COMPLETE));
        }
        public function loadBootstrap():void{
            if (this.isInitialized){
                return;
            };
            this.isInitialized = true;
            scheduleForNextFrame(internalLoadBootstrap);
        }
        private function destroyFactory():void{
            var _loc_1:BootstrapConfiguration;
            var _loc_2:DisplayObject;
            var _loc_3:Object;
            if (this.librarySwfLoader != null){
                _loc_3 = (this.librarySwfLoader.content as Object);
                if (((!((_loc_3 == null))) && (_loc_3.hasOwnProperty("release")))){
                    _loc_3.release();
                };
            };
            _loc_1 = BootstrapConfiguration.getInstance();
            _loc_2 = _loc_1.stage;
            if (_loc_2 != null){
                _loc_2.removeEventListener(MouseEvent.MOUSE_UP, this.factory.reportMouseEvent);
                _loc_2.removeEventListener(MouseEvent.MOUSE_DOWN, this.factory.reportMouseEvent);
                _loc_2.removeEventListener(MouseEvent.MOUSE_MOVE, this.factory.reportMouseEvent);
            };
            this.factory = null;
            Wrapper.instance().clear();
        }
        private function internalLoadBootstrap():void{
            var _loc_1:BootstrapConfiguration;
            var _loc_2:Loader;
            _loc_1 = BootstrapConfiguration.getInstance();
            if (!(container)){
                container = new ClientBootstrapSprite();
            };
            _loc_2 = new Loader();
            _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onBootstrapLoaded);
            _loc_2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onBootstrapFailed);
            this.bootstrapLoader = loadUrl(_loc_2, _loc_1.getBootstrapUrl());
            this.container.setBootstrapLoader(this.bootstrapLoader);
            this.container.setUrlCallback(this.setUrl);
            this.setUrl(container.getLibUrl());
        }
        private function scheduleForNextFrame(param1:Function):void{
            if (!(this.nextFrameCalls)){
                this.nextFrameCalls = [];
            };
            this.nextFrameCalls.push(param1);
            if (!(this.timer)){
                this.timer = new Timer(1, 1);
                this.timer.addEventListener(TimerEvent.TIMER, executeNextFrameCalls);
                this.timer.start();
            };
        }
        public function getMapsFactory():IMapsFactory{
            return (this.factory);
        }
        private function unloadBootstrap():void{
            destroyFactory();
            if (this.container != null){
                this.container.release();
                this.container = null;
            };
            if (this.bootstrapLoader != null){
                this.bootstrapLoader.unload();
                this.bootstrapLoader = null;
            };
            if (this.librarySwfLoader != null){
                this.librarySwfLoader.unload();
                this.librarySwfLoader = null;
            };
            this.delayInitializers = [];
            this.dispatchEvent(new Event(ClientBootstrap.BOOTSTRAP_FAILED));
            BootstrapConfiguration.getInstance().lock(false);
            this.isInitialized = false;
        }

    }
}//package com.mapplus.maps 
