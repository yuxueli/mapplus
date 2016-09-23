//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class IProjectionWrapper extends WrapperBase implements IProjection {

        public function IProjectionWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IProjection"]);
        }
        public function fromLatLngToPixel(param1:LatLng, param2:Number):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromLatLngToPixel(this.extWrapper.wrapLatLng(param1), param2));
        }
        public function getWrapWidth(param1:Number):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getWrapWidth(param1));
        }
        public function tileCheckRange(param1:Point, param2:Number, param3:Number):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.tileCheckRange(param1, param2, param3));
        }
        public function fromPixelToLatLng(param1:Point, param2:Number, param3:Boolean=false):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.fromPixelToLatLng(param1, param2, param3)));
        }

    }
}//package com.mapplus.maps.wrappers 
