//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class IMapTypeWrapper extends EventDispatcherWrapper implements IMapType {

        public function IMapTypeWrapper(){
            super();
        }
        public function getTextColor():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getTextColor());
        }
        public function getName(param1:Boolean=false):String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getName(param1));
        }
        public function getProjection():IProjection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIProjection(this.instance.getProjection()));
        }
        public function getTileLayers():Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapITileLayerArray(this.instance.getTileLayers()));
        }
        override public function get interfaceChain():Array{
            return (["IMapType"]);
        }
        public function getCopyrights(param1:LatLngBounds, param2:Number):Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapCopyrightNoticeArray(this.instance.getCopyrights(this.extWrapper.wrapLatLngBounds(param1), param2)));
        }
        public function getTileSize():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getTileSize());
        }
        public function getBoundsZoomLevel(param1:LatLngBounds, param2:Point):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getBoundsZoomLevel(this.extWrapper.wrapLatLngBounds(param1), param2));
        }
        public function getRadius():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getRadius());
        }
        public function getSpanZoomLevel(param1:LatLng, param2:LatLng, param3:Point):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getSpanZoomLevel(this.extWrapper.wrapLatLng(param1), this.extWrapper.wrapLatLng(param2), param3));
        }
        public function getLinkColor():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getLinkColor());
        }
        public function getErrorMessage():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getErrorMessage());
        }
        public function setMaxResolutionOverride(param1:Number):void{
            Wrapper.checkValid(this.instance);
            this.instance.setMaxResolutionOverride(param1);
        }
        public function getMinimumResolution(param1:LatLng=null):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMinimumResolution(this.extWrapper.wrapLatLng(param1)));
        }
        public function getMaxResolutionOverride():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMaxResolutionOverride());
        }
        public function getUrlArg():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getUrlArg());
        }
        public function getMaximumResolution(param1:LatLng=null):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMaximumResolution(this.extWrapper.wrapLatLng(param1)));
        }
        public function getAlt():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getAlt());
        }

    }
}//package com.mapplus.maps.wrappers 
