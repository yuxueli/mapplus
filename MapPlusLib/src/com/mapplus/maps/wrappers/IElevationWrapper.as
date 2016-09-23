//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.interfaces.*;

    public class IElevationWrapper extends EventDispatcherWrapper implements IElevation {

        public function IElevationWrapper(){
            super();
        }
        public function loadElevationForEncodedLocations(param1:EncodedPolylineData):void{
            Wrapper.checkValid(this.instance);
            this.instance.loadElevationForEncodedLocations(this.extWrapper.wrapEncodedPolylineData(param1));
        }
        override public function get interfaceChain():Array{
            return (["IElevation"]);
        }
        public function loadElevationAlongPath(param1:Array, param2:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.loadElevationAlongPath(this.extWrapper.wrapLatLngArray(param1), param2);
        }
        public function loadElevationForLocations(param1:Array):void{
            Wrapper.checkValid(this.instance);
            this.instance.loadElevationForLocations(this.extWrapper.wrapLatLngArray(param1));
        }
        public function loadElevationAlongEncodedPath(param1:EncodedPolylineData, param2:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.loadElevationAlongEncodedPath(this.extWrapper.wrapEncodedPolylineData(param1), param2);
        }

    }
}//package com.mapplus.maps.wrappers 
