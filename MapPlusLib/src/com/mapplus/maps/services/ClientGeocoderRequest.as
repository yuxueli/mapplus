//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import flash.display.*;
    import flash.events.*;
    import com.mapplus.maps.*;
    import flash.net.*;

    final class ClientGeocoderRequest extends EventDispatcher {

        static const REQUEST_COMPLETED:String = "request_completed";
        static const REQUEST_FAILED:String = "request_failed";

        var address:String;
        var loader:Loader;

        public function ClientGeocoderRequest(param1:Loader, param2:String){
            super();
            this.loader = param1;
            this.address = param2;
        }
        private function onRequestCompleted(event:Event):void{
            dispatchEvent(new Event(ClientGeocoderRequest.REQUEST_COMPLETED));
            this.removeEventListeners();
            this.loader.unload();
            this.loader = null;
        }
        private function removeEventListeners():void{
            this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onRequestCompleted);
            this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onRequestFailed);
            this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRequestFailed);
        }
        private function onRequestFailed(event:Event):void{
            dispatchEvent(new Event(ClientGeocoderRequest.REQUEST_FAILED));
            this.removeEventListeners();
            this.loader = null;
        }
        private function get contentLoaderInfo():IEventDispatcher{
            if (!(this.loader)){
                return (null);
            };
            return (this.loader.contentLoaderInfo);
        }
        public function sendRequest(param1:String):void{
            this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onRequestCompleted);
            this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onRequestFailed);
            this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRequestFailed);
            Util.loadAddingAcceptLanguageHeaderIfAir(this.loader, new URLRequest(param1));
        }

    }
}//package com.mapplus.maps.services 
