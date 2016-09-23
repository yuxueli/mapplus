//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.services.*;
    import com.mapplus.maps.interfaces.*;

    public class IClientGeocoderWrapper extends EventDispatcherWrapper implements IClientGeocoder {

        public function IClientGeocoderWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IClientGeocoder"]);
        }
        public function getBaseCountryCode():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getBaseCountryCode());
        }
        public function setBaseCountryCode(param1:String):void{
            Wrapper.checkValid(this.instance);
            this.instance.setBaseCountryCode(param1);
        }
        public function geocode(param1:String):void{
            Wrapper.checkValid(this.instance);
            this.instance.geocode(param1);
        }
        public function setViewport(param1:LatLngBounds):void{
            Wrapper.checkValid(this.instance);
            this.instance.setViewport(this.extWrapper.wrapLatLngBounds(param1));
        }
        public function getViewport():LatLngBounds{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLngBounds(this.instance.getViewport()));
        }
        public function getOptions():ClientGeocoderOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapClientGeocoderOptions(this.instance.getOptions()));
        }
        public function resetCache():void{
            Wrapper.checkValid(this.instance);
            this.instance.resetCache();
        }
        public function reverseGeocode(param1:LatLng):void{
            Wrapper.checkValid(this.instance);
            this.instance.reverseGeocode(this.extWrapper.wrapLatLng(param1));
        }
        public function setOptions(param1:ClientGeocoderOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapClientGeocoderOptions(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
