//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class Directions extends WrappableEventDispatcher implements IDirections {

        private static var haveSentDisclaimer:Boolean = false;

        private var options:DirectionsOptions;
        private var _loader:Loader;
        private var response:DirectionsResponse;
        private var testLoader:Boolean;
        private var currentRequest:DirectionsRequestData;
        private var _bounds:LatLngBounds;

        public function Directions(param1:DirectionsOptions=null){
            super();
            this.options = DirectionsOptions.merge([DirectionsOptions.DEFAULT_OPTIONS, param1]);
            this.testLoader = false;
            this.currentRequest = null;
        }
        private static function isWalkingRequest(param1:Object):Boolean{
            var _loc_2:String;
            _loc_2 = param1[SConstants.URL_ARG_DIRECTIONS_INPUT];
            if (!(_loc_2)){
                return (false);
            };
            return ((_loc_2.indexOf(SConstants.URL_ARGVAL_DIRFLG_WALKING) >= 0));
        }
        private static function parseRoute(param1:Object):Route{
            var _loc_2:Route;
            _loc_2 = new Route();
            _loc_2._distance = DefaultVar.getNumber(param1[SConstants.PROP_DISTANCE], SConstants.PROP_METERS);
            _loc_2._duration = DefaultVar.getNumber(param1[SConstants.PROP_DURATION], SConstants.PROP_SECONDS);
            _loc_2._distanceHtml = DefaultVar.getString(param1[SConstants.PROP_DISTANCE], SConstants.PROP_HTML);
            _loc_2._durationHtml = DefaultVar.getString(param1[SConstants.PROP_DURATION], SConstants.PROP_HTML);
            _loc_2._summaryHtml = param1[SConstants.PROP_SUMMARY_HTML];
            _loc_2._endPolylineIndex = param1[SConstants.PROP_POLYLINE_END_INDEX];
            _loc_2._endLatLng = ServiceUtil.parsePoint(DefaultVar.getObject(Object, param1, SConstants.PROP_END, {}));
            _loc_2._steps = [];
            return (_loc_2);
        }
        private static function parseDirections(param1:Object):DirectionsResponse{
            var _loc_2:DirectionsResponse;
            _loc_2 = new DirectionsResponse();
            if (param1 != null){
                _loc_2.copyrightsHtml = param1[SConstants.PROP_COPYRIGHTS_HTML];
                _loc_2.summaryHtml = param1[SConstants.PROP_SUMMARY_HTML];
                _loc_2.distance = DefaultVar.getNumber(param1[SConstants.PROP_DISTANCE], SConstants.PROP_METERS);
                _loc_2.duration = DefaultVar.getNumber(param1[SConstants.PROP_DURATION], SConstants.PROP_SECONDS);
                _loc_2.distanceHtml = DefaultVar.getString(param1[SConstants.PROP_DISTANCE], SConstants.PROP_HTML);
                _loc_2.durationHtml = DefaultVar.getString(param1[SConstants.PROP_DURATION], SConstants.PROP_HTML);
                _loc_2.encodedPolyline = ServiceUtil.parseEncodedPolyline(param1[SConstants.PROP_POLYLINE]);
                _loc_2.routes = [];
            };
            return (_loc_2);
        }
        private static function simplifyHtmlChars(param1:String):String{
            var _loc_2:RegExp;
            if (!(param1)){
                return (new String());
            };
            _loc_2 = /&(mdash|ndash|shy|minus);/g;
            return (param1.replace(_loc_2, "-"));
        }
        private static function parseStep(param1:Object):Step{
            var _loc_2:Step;
            _loc_2 = new Step();
            _loc_2._distance = DefaultVar.getNumber(param1[SConstants.PROP_DISTANCE], SConstants.PROP_METERS);
            _loc_2._duration = DefaultVar.getNumber(param1[SConstants.PROP_DURATION], SConstants.PROP_SECONDS);
            _loc_2._distanceHtml = DefaultVar.getString(param1[SConstants.PROP_DISTANCE], SConstants.PROP_HTML);
            _loc_2._durationHtml = DefaultVar.getString(param1[SConstants.PROP_DURATION], SConstants.PROP_HTML);
            _loc_2._descriptionHtml = param1[SConstants.PROP_DESCRIPTION_HTML];
            _loc_2._polylineIndex = param1[SConstants.PROP_POLYLINE_INDEX];
            _loc_2._latLng = ServiceUtil.parsePoint(param1[SConstants.PROP_POINT]);
            return (_loc_2);
        }

        private function isSuccess():Boolean{
            return (((!((this.response == null))) && ((this.response.status == ServiceStatus.GEO_SUCCESS))));
        }
        private function getUrlParameters(param1:String):Object{
            var _loc_2:Object;
            var _loc_3:Object;
            var _loc_4:String;
            _loc_2 = {};
            ServiceUtil.initializeCommonParameters(_loc_2);
            _loc_2[SConstants.URL_ARG_OUTPUT] = SConstants.URL_ARGVAL_OUTPUT;
            _loc_2[SConstants.URL_ARG_OUTPUT_ENCODING] = SConstants.URL_ARGVAL_OUTPUT_ENCODING;
            _loc_3 = Bootstrap.getBootstrap().getClientConfiguration();
            if (this.options.language){
                _loc_2[SConstants.URL_ARG_LANGUAGE] = this.options.language;
            } else {
                if (((_loc_3) && (_loc_3.language))){
                    _loc_2[SConstants.URL_ARG_LANGUAGE] = _loc_3.language;
                };
            };
            if (this.options.countryCode){
                _loc_2[SConstants.URL_ARG_COUNTRY_CODE] = this.options.countryCode;
            } else {
                if (((((_loc_3) && (_loc_3.hasOwnProperty("countryCode")))) && (_loc_3.countryCode))){
                    _loc_2[SConstants.URL_ARG_COUNTRY_CODE] = _loc_3.countryCode;
                };
            };
            _loc_2[SConstants.URL_ARG_DIRECTIONS_OUTPUT] = (SConstants.URL_ARGVAL_DIRECTIONS_OUTPUT_POLYLINE + SConstants.URL_ARGVAL_DIRECTIONS_OUTPUT_TEXT);
            _loc_4 = "";
            switch (this.options.travelMode){
                case DirectionsOptions.TRAVEL_MODE_WALKING:
                    _loc_4 = (_loc_4 + SConstants.URL_ARGVAL_DIRFLG_WALKING);
                    break;
                default:
                    _loc_4 = (_loc_4 + SConstants.URL_ARGVAL_DIRFLG_DRIVING);
            };
            if (this.options.avoidHighways){
                _loc_4 = (_loc_4 + SConstants.URL_ARGVAL_DIRFLG_AVOID_HIGHWAYS);
            };
            if (_loc_4){
                _loc_2[SConstants.URL_ARG_DIRECTIONS_INPUT] = _loc_4;
            };
            _loc_2[SConstants.URL_ARG_QUERY] = param1;
            return (_loc_2);
        }
        override public function get interfaceChain():Array{
            return (["IDirections"]);
        }
        private function onLoadFailed(param1:Number, param2:String):void{
            var _loc_3:DirectionsEvent;
            this.clearCurrentRequest();
            _loc_3 = new DirectionsEvent(DirectionsEvent.DIRECTIONS_FAILURE, this);
            _loc_3.name = param2;
            _loc_3.status = param1;
            _loc_3.request = SConstants.PROP_REQUEST_VALUE_DIRECTIONS;
            this.dispatchEvent(_loc_3);
        }
        private function clearCurrentRequest():void{
            if (!(this.currentRequest)){
                return;
            };
            if (this.contentLoaderInfo){
                this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.currentRequest.successListener);
                this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.currentRequest.failureListener);
                this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.currentRequest.failureListener);
            };
            this.currentRequest = null;
        }
        public function get duration():Number{
            return ((this.isSuccess()) ? this.response.duration : 0);
        }
        public function get numGeocodes():uint{
            return ((this.isSuccess()) ? this.response.placemarks.length : 0);
        }
        private function createAbortEvent(param1:String):DirectionsEvent{
            var _loc_2:DirectionsEvent;
            _loc_2 = new DirectionsEvent(DirectionsEvent.DIRECTIONS_ABORTED, this);
            _loc_2.name = param1;
            _loc_2.request = SConstants.PROP_REQUEST_VALUE_DIRECTIONS;
            _loc_2.status = ServiceStatus.GEO_ABORTED_REQUEST;
            return (_loc_2);
        }
        public function getGeocode(param1:uint):Placemark{
            return ((this.isSuccess()) ? this.response.placemarks[param1] : null);
        }
        public function getRoute(param1:uint):Route{
            return ((this.isSuccess()) ? this.response.routes[param1] : null);
        }
        public function setOptions(param1:DirectionsOptions):void{
            this.options = DirectionsOptions.merge([DirectionsOptions.DEFAULT_OPTIONS, param1]);
        }
        public function get bounds():LatLngBounds{
            return (this._bounds);
        }
        public function get encodedPolylineData():EncodedPolylineData{
            return ((this.isSuccess()) ? this.response.encodedPolyline : null);
        }
        private function get contentLoaderInfo():IEventDispatcher{
            if (!(this._loader)){
                return (null);
            };
            return (this._loader.contentLoaderInfo);
        }
        private function processReply(param1:Object, param2:String, param3:Object):void{
            var _loc_4:DirectionsEvent;
            this.clearCurrentRequest();
            this._loader.unload();
            this.parseDirectionsResponse(param1);
            _loc_4 = null;
            if (this.response.status == ServiceStatus.GEO_SUCCESS){
                _loc_4 = new DirectionsEvent(DirectionsEvent.DIRECTIONS_SUCCESS, this);
                if (isWalkingRequest(param3)){
                    this.sendWalkingDisclaimer();
                };
            } else {
                _loc_4 = new DirectionsEvent(DirectionsEvent.DIRECTIONS_FAILURE, this);
            };
            _loc_4.status = this.response.status;
            _loc_4.name = (!((this.response.name == null))) ? this.response.name : param2;
            _loc_4.request = DefaultVar.getString(param1[SConstants.PROP_STATUS], SConstants.PROP_REQUEST, SConstants.PROP_REQUEST_VALUE_DIRECTIONS);
            this.dispatchEvent(_loc_4);
        }
        public function loadFromWaypoints(param1:Array):void{
            var _loc_2:String;
            var _loc_3:uint;
            _loc_2 = "";
            if (param1.length >= 2){
                _loc_2 = ("from:" + ServiceUtil.waypointToString(param1[0]));
                _loc_3 = 1;
                while (_loc_3 < param1.length) {
                    _loc_2 = (_loc_2 + (" to:" + ServiceUtil.waypointToString(param1[_loc_3])));
                    _loc_3 = (_loc_3 + 1);
                };
            };
            this.load(_loc_2);
        }
        private function parseDirectionsResponse(param1:Object):void{
            var _loc_2:Object;
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:Route;
            var _loc_6:uint;
            var _loc_7:Route;
            var _loc_8:Array;
            var _loc_9:Number = NaN;
            var _loc_10:uint;
            var _loc_11:Step;
            _loc_2 = DefaultVar.getObject(Object, param1, SConstants.PROP_DIRECTIONS, null);
            this.response = parseDirections(_loc_2);
            this.response.name = param1[SConstants.PROP_NAME];
            this.response.placemarks = ServiceUtil.parsePlacemarks(DefaultVar.getArray(param1, SConstants.PROP_PLACEMARK, []));
            this.response.status = DefaultVar.getNumber(param1[SConstants.PROP_STATUS], SConstants.PROP_CODE, ServiceStatus.GEO_SERVER_ERROR);
            if (this.response.status != ServiceStatus.GEO_SUCCESS){
                return;
            };
            this._bounds = new LatLngBounds();
            _loc_3 = DefaultVar.getArray(_loc_2, SConstants.PROP_ROUTES, []);
            _loc_4 = (_loc_3) ? _loc_3.length : 0;
            _loc_5 = new Route();
            _loc_6 = 0;
            while (_loc_6 < _loc_4) {
                _loc_7 = parseRoute(_loc_3[_loc_6]);
                _loc_7._startGeocode = this.response.placemarks[_loc_6];
                _loc_5._endGeocode = _loc_7._startGeocode;
                _loc_5 = _loc_7;
                _loc_8 = DefaultVar.getArray(_loc_3[_loc_6], SConstants.PROP_STEPS, []);
                _loc_9 = (_loc_8) ? _loc_8.length : 0;
                _loc_10 = 0;
                while (_loc_10 < _loc_9) {
                    _loc_11 = parseStep(_loc_8[_loc_10]);
                    this._bounds.extend(_loc_11._latLng);
                    _loc_7._steps.push(_loc_11);
                    _loc_10 = (_loc_10 + 1);
                };
                this._bounds.extend(_loc_7._endLatLng);
                this.response.routes.push(_loc_7);
                _loc_6 = (_loc_6 + 1);
            };
            _loc_5._endGeocode = this.response.placemarks[_loc_4];
        }
        public function get distanceHtml():String{
            return ((this.isSuccess()) ? this.response.distanceHtml : "");
        }
        private function sendWalkingDisclaimer():void{
            var messages:* = null;
            var msg:* = null;
            if (haveSentDisclaimer){
                return;
            };
            try {
                messages = Bootstrap.getBootstrap().getSettings().messages;
                msg = (((((("<p>" + "<b>") + simplifyHtmlChars(messages.walking_directions_beta)) + "</b>") + "<br/>") + simplifyHtmlChars(messages.walking_directions_do_not_know_sidewalks)) + "</p>");
                Bootstrap.getBootstrap().dispatchEvent(new MapEvent(MapEvent.DISPLAY_MESSAGE, msg));
                haveSentDisclaimer = true;
            } catch(ex) {
                Log.log0("Error: Unable to send walking directions disclaimer.");
            };
        }
        public function get copyrightsHtml():String{
            return ((this.isSuccess()) ? this.response.copyrightsHtml : "");
        }
        public function clear():void{
            if (this.currentRequest){
                this.dispatchEvent(this.createAbortEvent(this.currentRequest.query));
                this.clearCurrentRequest();
            };
            if (this._loader){
                this._loader.unload();
            };
            this.response = null;
            this._bounds = null;
        }
        public function get durationHtml():String{
            return ((this.isSuccess()) ? this.response.durationHtml : "");
        }
        public function load(param1:String):void{
            var mapsHost:* = null;
            var params:* = null;
            var requestUrl:* = null;
            var me:* = null;
            var processReplyAndParams:* = null;
            var loadCompleted:* = null;
            var loadFailed:* = null;
            var query:* = undefined;
            var param1:* = param1;
            query = param1;
            mapsHost = Bootstrap.getBootstrap().getMapsHost();
            if (!(mapsHost)){
                return;
            };
            if (((!(query)) || ((query.length == 0)))){
                throw (new ArgumentError((("Invalid query: \"" + query) + "\".")));
            };
            this.clear();
            if (!(this.testLoader)){
                this._loader = new Loader();
            };
            params = this.getUrlParameters(query);
            requestUrl = (((((Util.isSsl()) ? "https://" : "http://" + mapsHost) + SConstants.DIRECTIONS_MAPS_API_PATH) + "?") + Util.paramsToUrlString(params));
            processReplyAndParams = function (param1:Object, param2:String):void{
                me.processReply(param1, param2, params);
            };
            loadCompleted = function (event:Event):void{
                ServiceUtil.onLoadCompleted(me._loader.content, query, processReplyAndParams, me.onLoadFailed);
            };
            loadFailed = function (event:Event):void{
                me.onLoadFailed(ServiceStatus.GEO_SERVER_ERROR, query);
            };
            this.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleted);
            this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailed);
            this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailed);
            this.currentRequest = new DirectionsRequestData(query, loadCompleted, loadFailed);
            Util.loadAddingAcceptLanguageHeaderIfAir(this._loader, new URLRequest(requestUrl));
        }
        private function isLoaded():Boolean{
            return (!((this.response == null)));
        }
        public function getOptions():DirectionsOptions{
            return (this.options);
        }
        public function get numRoutes():uint{
            return ((this.isSuccess()) ? this.response.routes.length : 0);
        }
        public function get summaryHtml():String{
            return ((this.isSuccess()) ? this.response.summaryHtml : "");
        }
        public function get status():uint{
            return ((this.isLoaded()) ? this.response.status : 500);
        }
        public function get distance():Number{
            return ((this.isSuccess()) ? this.response.distance : 0);
        }
        public function createPolyline(param1:PolylineOptions=null):IPolyline{
            var _loc_2:EncodedPolylineData;
            if (!(this.isLoaded())){
                return (null);
            };
            _loc_2 = this.response.encodedPolyline;
            return (Polyline.fromEncoded(_loc_2.points, _loc_2.zoomFactor, _loc_2.levels, _loc_2.numLevels, param1));
        }

    }
}//package com.mapplus.maps.services 

class DirectionsRequestData {

    public var successListener:Function;
    public var query:String;
    public var failureListener:Function;

    public function DirectionsRequestData(param1:String, param2:Function, param3:Function){
        super();
        this.query = param1;
        this.successListener = param2;
        this.failureListener = param3;
    }
}
