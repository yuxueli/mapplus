//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.services.*;

    public class IDirectionsWrapper extends EventDispatcherWrapper implements IDirections {

        public function IDirectionsWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IDirections"]);
        }
        public function setOptions(param1:DirectionsOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapDirectionsOptions(param1));
        }
        public function get duration():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.duration);
        }
        public function get numGeocodes():uint{
            Wrapper.checkValid(this.instance);
            return (this.instance.numGeocodes);
        }
        public function getGeocode(param1:uint):Placemark{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapPlacemark(this.instance.getGeocode(param1)));
        }
        public function getRoute(param1:uint):Route{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapRoute(this.instance.getRoute(param1)));
        }
        public function get encodedPolylineData():EncodedPolylineData{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapEncodedPolylineData(this.instance.encodedPolylineData));
        }
        public function get bounds():LatLngBounds{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLngBounds(this.instance.bounds));
        }
        public function get distanceHtml():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.distanceHtml);
        }
        public function get copyrightsHtml():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.copyrightsHtml);
        }
        public function clear():void{
            Wrapper.checkValid(this.instance);
            this.instance.clear();
        }
        public function get durationHtml():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.durationHtml);
        }
        public function load(param1:String):void{
            Wrapper.checkValid(this.instance);
            this.instance.load(param1);
        }
        public function getOptions():DirectionsOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapDirectionsOptions(this.instance.getOptions()));
        }
        public function createPolyline(param1:PolylineOptions=null):IPolyline{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPolyline(this.instance.createPolyline(this.extWrapper.wrapPolylineOptions(param1))));
        }
        public function get numRoutes():uint{
            Wrapper.checkValid(this.instance);
            return (this.instance.numRoutes);
        }
        public function get distance():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.distance);
        }
        public function get summaryHtml():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.summaryHtml);
        }
        public function get status():uint{
            Wrapper.checkValid(this.instance);
            return (this.instance.status);
        }

    }
}//package com.mapplus.maps.wrappers 
