//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.errors.*;
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.wrappers.*;

    public class TileLayerBase extends WrapperBase implements ITileLayer {

        private var copyrightCollection:ICopyrightCollection;
        private var minResolution:Number;
        private var alpha:Number;
        private var maxResolution:Number;
        private var mapType:IMapType;

        public function TileLayerBase(copyrightCollection:ICopyrightCollection, minResolution:Number=NaN, maxResolution:Number=NaN, alpha:Number=1){
            super();
            if (copyrightCollection == null){
                throw (new IllegalOperationError("Copyright collection must be provided"));
            };
            this.copyrightCollection = copyrightCollection;
            this.alpha = alpha;
            this.minResolution = (isNaN(minResolution)) ? 0 : minResolution;
            this.maxResolution = (isNaN(maxResolution)) ? this.minResolution : maxResolution;
            this.mapType = null;
        }
        public function getMinResolution():Number{
            return (this.minResolution);
        }
        public function getMapType():IMapType{
            return (this.mapType);
        }
        override public function get interfaceChain():Array{
            return (["ITileLayer"]);
        }
        public function getCopyrightCollection():ICopyrightCollection{
            return (this.copyrightCollection);
        }
        public function getAlpha():Number{
            return (this.alpha);
        }
        public function loadTile(param1:Point, param2:Number):DisplayObject{
            throw (new IllegalOperationError(PConstants.UNIMPLEMENTED_METHOD));
        }
        public function getMaxResolution():Number{
            return (this.maxResolution);
        }
        public function setMapType(param1:IMapType):void{
            this.mapType = param1;
        }

    }
}//package com.mapplus.maps 
