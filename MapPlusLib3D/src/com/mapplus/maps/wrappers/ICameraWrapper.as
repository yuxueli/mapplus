//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class ICameraWrapper extends EventDispatcherWrapper implements ICamera {

        public function ICameraWrapper(){
            super();
        }
        public function get maxRoll():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.maxRoll);
        }
        public function worldToViewport(param1:Point):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.worldToViewport(param1));
        }
        public function getLatLngClosestToCenter(param1:LatLng):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getLatLngClosestToCenter(this.extWrapper.wrapLatLng(param1))));
        }
        public function get shadowMatrix():Matrix{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMatrix(this.instance.shadowMatrix));
        }
        public function getTransformationGeometry():TransformationGeometry{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapTransformationGeometry(this.instance.getTransformationGeometry()));
        }
        public function worldToLatLng(param1:Point):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.worldToLatLng(param1)));
        }
        public function get minPitch():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.minPitch);
        }
        override public function get interfaceChain():Array{
            return (["ICamera"]);
        }
        public function get is3D():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.is3D);
        }
        public function get viewport():Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.viewport);
        }
        public function viewportToLatLng(param1:Point):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.viewportToLatLng(param1)));
        }
        public function get attitude():Attitude{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapAttitude(this.instance.attitude));
        }
        public function get focalLength():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.focalLength);
        }
        public function isAhead(param1:LatLng):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isAhead(this.extWrapper.wrapLatLng(param1)));
        }
        public function worldDistance(param1:Point):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.worldDistance(param1));
        }
        public function get maxPitch():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.maxPitch);
        }
        public function get minYaw():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.minYaw);
        }
        public function get zoomScale():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.zoomScale);
        }
        public function viewportToWorld(param1:Point):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.viewportToWorld(param1));
        }
        public function get center():LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.center));
        }
        public function get zoom():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.zoom);
        }
        public function getWorldViewPolygon():Array{
            Wrapper.checkValid(this.instance);
            return (this.instance.getWorldViewPolygon());
        }
        public function latLngToViewport(param1:LatLng):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.latLngToViewport(this.extWrapper.wrapLatLng(param1)));
        }
        public function get maxYaw():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.maxYaw);
        }
        public function latLngToWorld(param1:LatLng):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.latLngToWorld(this.extWrapper.wrapLatLng(param1)));
        }
        public function isOnMap(param1:Point):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isOnMap(param1));
        }
        public function get minRoll():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.minRoll);
        }
        public function getTransformationCoefficients():Array{
            Wrapper.checkValid(this.instance);
            return (this.instance.getTransformationCoefficients());
        }

    }
}//package com.mapplus.maps.wrappers 
