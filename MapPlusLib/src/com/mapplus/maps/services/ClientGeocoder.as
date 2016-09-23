//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    public final class ClientGeocoder extends WrappableEventDispatcher implements IClientGeocoder {

        private static var _cache:GeocodeCache;

        private var options:ClientGeocoderOptions;

        public function ClientGeocoder(param1:String=null, param2:LatLngBounds=null, param3:ClientGeocoderOptions=null){
            super();
            this.options = ClientGeocoderOptions.merge([ClientGeocoderOptions.DEFAULT_OPTIONS, (param3) ? param3 : {
    countryCode:param1,
    viewport:param2
}]);
        }
        private static function parseGeocodingResponse(param1:Object):GeocodingResponse{
            var _loc_2:GeocodingResponse;
            _loc_2 = new GeocodingResponse();
            _loc_2.placemarks = ServiceUtil.parsePlacemarks(DefaultVar.getArray(param1, SConstants.PROP_PLACEMARK));
            _loc_2.name = DefaultVar.getString(param1, SConstants.PROP_NAME);
            Wrapper.copyObject(_loc_2, param1);
            return (_loc_2);
        }

        private function get cache():GeocodeCache{
            if (ClientGeocoder._cache == null){
                ClientGeocoder._cache = new FactualGeocodeCache();
            };
            return (ClientGeocoder._cache);
        }
        override public function get interfaceChain():Array{
            return (["IClientGeocoder"]);
        }
        private function onRequestCompleted(event:Event):void{
            var _loc_2:ClientGeocoderRequest;
            _loc_2 = ClientGeocoderRequest(event.target);
            ServiceUtil.onLoadCompleted(_loc_2.loader.content, _loc_2.address, this.processReply, this.processFailure);
            _loc_2.removeEventListener(ClientGeocoderRequest.REQUEST_COMPLETED, this.onRequestCompleted);
            _loc_2.removeEventListener(ClientGeocoderRequest.REQUEST_FAILED, this.onRequestFailed);
        }
        private function onRequestFailed(event:Event):void{
            var _loc_2:ClientGeocoderRequest;
            _loc_2 = ClientGeocoderRequest(event.target);
            this.processFailure(ServiceStatus.GEO_SERVER_ERROR, _loc_2.address);
            _loc_2.removeEventListener(ClientGeocoderRequest.REQUEST_COMPLETED, this.onRequestCompleted);
            _loc_2.removeEventListener(ClientGeocoderRequest.REQUEST_FAILED, this.onRequestFailed);
        }
        private function put(param1:String, param2:Object):void{
            this.cache.put(param1, param2);
        }
        private function processFailure(param1:Number, param2:String):void{
            var _loc_3:GeocodingEvent;
            _loc_3 = new GeocodingEvent(GeocodingEvent.GEOCODING_FAILURE);
            _loc_3.name = param2;
            _loc_3.status = param1;
            _loc_3.request = SConstants.PROP_REQUEST_VALUE_GEOCODE;
            this.dispatchEvent(_loc_3);
        }
        public function getViewport():LatLngBounds{
            return (this.options.viewport);
        }
        public function setViewport(param1:LatLngBounds):void{
            this.options.viewport = param1;
        }
        private function processReply(param1:Object, param2:String):void{
            var _loc_3:GeocodingResponse;
            var _loc_4:Number = NaN;
            var _loc_5:GeocodingEvent;
            this.put(param2, param1);
            _loc_3 = parseGeocodingResponse(param1);
            _loc_4 = DefaultVar.getNumber(_loc_3[SConstants.PROP_STATUS], SConstants.PROP_CODE, ServiceStatus.GEO_SERVER_ERROR);
            _loc_5 = null;
            if (_loc_4 == ServiceStatus.GEO_SUCCESS){
                _loc_5 = new GeocodingEvent(GeocodingEvent.GEOCODING_SUCCESS);
                _loc_5.response = _loc_3;
            } else {
                _loc_5 = new GeocodingEvent(GeocodingEvent.GEOCODING_FAILURE);
            };
            _loc_5.status = _loc_4;
            _loc_5.name = DefaultVar.getString(_loc_3, SConstants.PROP_NAME, param2);
            _loc_5.request = DefaultVar.getString(_loc_3[SConstants.PROP_STATUS], SConstants.PROP_REQUEST, SConstants.PROP_REQUEST_VALUE_GEOCODE);
            this.dispatchEvent(_loc_5);
        }
        public function geocode(param1:String):void{
            var self:* = null;
            var cached:* = null;
            var params:* = null;
            var address:* = undefined;
            var param1:* = param1;
            address = param1;
            if (((!(address)) || ((address.length == 0)))){
                throw (new ArgumentError((("Invalid address: \"" + address) + "\".")));
            };
            cached = this.get(address);
            if (cached){
                DelayHandler.delayCall(function ():void{
                    self.processReply(cached, address);
                });
                return;
            };
            params[SConstants.URL_ARG_QUERY] = address;
            if (this.options.viewport){
                params[SConstants.URL_ARG_CENTER] = this.options.viewport.getCenter().toUrlValue();
                params[SConstants.URL_ARG_SPAN] = this.options.viewport.toSpan().toUrlValue();
            };
            this.initiateGeocode(params);
        }
        public function setBaseCountryCode(param1:String):void{
            this.options.countryCode = param1;
        }
        private function get(param1:String):Object{
            return (this.cache.get(param1));
        }
        public function getBaseCountryCode():String{
            return (this.options.countryCode);
        }
        private function initiateGeocode(param1:Object):void{
            var _loc_2:Object;
            ServiceUtil.initializeCommonParameters(param1);
            param1[SConstants.URL_ARG_OUTPUT] = SConstants.URL_ARGVAL_OUTPUT;
            param1[SConstants.URL_ARG_OUTPUT_ENCODING] = SConstants.URL_ARGVAL_OUTPUT_ENCODING;
            _loc_2 = Bootstrap.getBootstrap().getClientConfiguration();
            if (this.options.language){
                param1[SConstants.URL_ARG_LANGUAGE] = this.options.language;
            } else {
                if (((_loc_2) && (_loc_2.language))){
                    param1[SConstants.URL_ARG_LANGUAGE] = _loc_2.language;
                };
            };
            if (this.options.countryCode){
                param1[SConstants.URL_ARG_COUNTRY_CODE] = this.options.countryCode;
            } else {
                if (((((_loc_2) && (_loc_2.hasOwnProperty("countryCode")))) && (_loc_2.countryCode))){
                    param1[SConstants.URL_ARG_COUNTRY_CODE] = _loc_2.countryCode;
                };
            };
            this.load(param1);
        }
        private function load(param1:Object):void{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:Loader;
            var _loc_5:String;
            var _loc_6:ClientGeocoderRequest;
            _loc_2 = Bootstrap.getBootstrap().getMapsHost();
            if (!(_loc_2)){
                return;
            };
            _loc_3 = (((((Util.isSsl()) ? "https://" : "http://" + _loc_2) + SConstants.GEOCODE_MAPS_API_PATH) + "?") + Util.paramsToUrlString(param1));
            _loc_4 = new Loader();
            _loc_5 = param1[SConstants.URL_ARG_QUERY];
            _loc_6 = new ClientGeocoderRequest(_loc_4, _loc_5);
            _loc_6.addEventListener(ClientGeocoderRequest.REQUEST_COMPLETED, this.onRequestCompleted);
            _loc_6.addEventListener(ClientGeocoderRequest.REQUEST_FAILED, this.onRequestFailed);
            _loc_6.sendRequest(_loc_3);
        }
        public function getOptions():ClientGeocoderOptions{
            return (this.options);
        }
        public function resetCache():void{
            this.cache.reset();
        }
        public function reverseGeocode(param1:LatLng):void{
            var _loc_2:Object;
            if (!(param1)){
                throw (new ArgumentError("Null LatLng."));
            };
            _loc_2 = {};
            _loc_2[SConstants.URL_ARG_CENTER] = param1.toUrlValue();
            this.initiateGeocode(_loc_2);
        }
        public function setOptions(param1:ClientGeocoderOptions):void{
            this.options = ClientGeocoderOptions.merge([ClientGeocoderOptions.DEFAULT_OPTIONS, param1]);
        }

    }
}//package com.mapplus.maps.services 
