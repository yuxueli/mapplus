//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.core.*;
    import flash.events.*;
    import flash.display.*;
    import flash.system.*;

    public class LibraryClip extends Sprite {

        private var factory:MapsFactory;
        private var wrapper:Wrapper;

        public function LibraryClip(){
            super();
            this.wrapper = Wrapper.instance();
            this.factory = new MapsFactory();
            if (!(this.allowClientConfigure())){
                addEventListener(Event.ADDED, this.onAdded);
            };
        }
        public function release():void{
            var _loc_1:Bootstrap;
            _loc_1 = Bootstrap.getBootstrap();
            _loc_1.release();
            this.wrapper.clear();
            this.wrapper = null;
            this.factory = null;
        }
        public function getWrapper():Wrapper{
            return (this.wrapper);
        }
        public function onAdded(event:Event):void{
            var _loc_2:DisplayObjectContainer;
            var _loc_3:Object;
            var _loc_4:Object;
            var _loc_5:Loader;
            var _loc_6:Bootstrap;
            var _loc_7:String;
            var _loc_8:String;
            _loc_2 = parent;
            while (_loc_2) {
                if (_loc_2.name == PConstants.MASTER_NAME){
                    removeEventListener(Event.ADDED, this.onAdded);
                    _loc_3 = (_loc_2 as Object);
                    _loc_4 = _loc_3.getBootstrapConfiguration();
                    _loc_5 = _loc_3.getBootstrapLoader();
                    _loc_6 = Bootstrap.getBootstrap();
                    if (_loc_5){
                        _loc_6.configure(_loc_4, _loc_5);
                    } else {
                        _loc_6.configureFromObject(_loc_4, _loc_3.getConfigData());
                    };
                    _loc_7 = _loc_6.getApiSiteUrl();
                    _loc_8 = Util.extractDomainFromUrl(_loc_7);
                    Security.allowDomain(_loc_8);
                    return;
                };
                _loc_2 = _loc_2.parent;
            };
        }
        private function allowClientConfigure():Boolean{
            return ((this.loaderInfo.loaderURL.substr(0, 5) == "app:/"));
        }
        public function getFactory():MapsFactory{
            return (this.factory);
        }
        public function configure(param1:Object, param2:Loader):void{
            var _loc_3:Bootstrap;
            if (!(this.allowClientConfigure())){
                return;
            };
            _loc_3 = Bootstrap.getBootstrap();
            _loc_3.configure(param1, param2);
        }

    }
}//package com.mapplus.maps 
