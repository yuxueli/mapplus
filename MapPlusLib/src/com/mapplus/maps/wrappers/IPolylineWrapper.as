﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.interfaces.*;

    public class IPolylineWrapper extends IOverlayWrapper implements IPolyline {

        public function IPolylineWrapper(){
            super();
        }
        public function isHidden():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isHidden());
        }
        override public function get interfaceChain():Array{
            return (["IPolyline", "IOverlay"]);
        }
        public function setOptions(param1:PolylineOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapPolylineOptions(param1));
        }
        public function getVertexCount():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getVertexCount());
        }
        public function getVertex(param1:Number):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getVertex(param1)));
        }
        public function hide():void{
            Wrapper.checkValid(this.instance);
            this.instance.hide();
        }
        public function getLatLngBounds():LatLngBounds{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLngBounds(this.instance.getLatLngBounds()));
        }
        public function getLength(param1:Number=6378137):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getLength(param1));
        }
        public function getOptions():PolylineOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapPolylineOptions(this.instance.getOptions()));
        }
        public function show():void{
            Wrapper.checkValid(this.instance);
            this.instance.show();
        }

    }
}//package com.mapplus.maps.wrappers 
