//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class ITileLayerWrapper extends WrapperBase implements ITileLayer {

        public function ITileLayerWrapper(){
            super();
        }
        public function loadTile(param1:Point, param2:Number):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.loadTile(param1, param2));
        }
        public function getMinResolution():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMinResolution());
        }
        override public function get interfaceChain():Array{
            return (["ITileLayer"]);
        }
        public function setMapType(param1:IMapType):void{
            Wrapper.checkValid(this.instance);
            this.instance.setMapType(this.extWrapper.wrapIMapType(param1));
        }
        public function getAlpha():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getAlpha());
        }
        public function getMaxResolution():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMaxResolution());
        }
        public function getCopyrightCollection():ICopyrightCollection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapICopyrightCollection(this.instance.getCopyrightCollection()));
        }

    }
}//package com.mapplus.maps.wrappers 
