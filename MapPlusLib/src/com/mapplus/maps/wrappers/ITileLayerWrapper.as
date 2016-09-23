//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.geom.*;

    public class ITileLayerWrapper extends WrapperBase implements ITileLayer {

        public function ITileLayerWrapper(){
            super();
        }
        public function setMapType(param1:IMapType):void{
            Wrapper.checkValid(this.instance);
            this.instance.setMapType(this.extWrapper.wrapIMapType(param1));
        }
        override public function get interfaceChain():Array{
            return (["ITileLayer"]);
        }
        public function getCopyrightCollection():ICopyrightCollection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapICopyrightCollection(this.instance.getCopyrightCollection()));
        }
        public function getMinResolution():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMinResolution());
        }
        public function getAlpha():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getAlpha());
        }
        public function getMaxResolution():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMaxResolution());
        }
        public function loadTile(param1:Point, param2:Number):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.loadTile(param1, param2));
        }

    }
}//package com.mapplus.maps.wrappers 
