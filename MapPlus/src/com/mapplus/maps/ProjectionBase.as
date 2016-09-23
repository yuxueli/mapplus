//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.errors.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;

    public class ProjectionBase extends WrapperBase implements IProjection {

        public function ProjectionBase(){
            super();
        }
        public function fromPixelToLatLng(param1:Point, param2:Number, param3:Boolean=false):LatLng{
            throw (new IllegalOperationError(PConstants.UNIMPLEMENTED_METHOD));
        }
        public function getWrapWidth(param1:Number):Number{
            throw (new IllegalOperationError(PConstants.UNIMPLEMENTED_METHOD));
        }
        override public function get interfaceChain():Array{
            return (["IProjection"]);
        }
        public function tileCheckRange(param1:Point, param2:Number, param3:Number):Boolean{
            throw (new IllegalOperationError(PConstants.UNIMPLEMENTED_METHOD));
        }
        public function fromLatLngToPixel(param1:LatLng, param2:Number):Point{
            throw (new IllegalOperationError(PConstants.UNIMPLEMENTED_METHOD));
        }

    }
}//package com.mapplus.maps 
