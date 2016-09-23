//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.interfaces.*;

    public class IPolygonWrapper extends IOverlayWrapper implements IPolygon {

        public function IPolygonWrapper(){
            super();
        }
        public function isHidden():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isHidden());
        }
        override public function get interfaceChain():Array{
            return (["IPolygon", "IOverlay"]);
        }
        public function getInnerVertexCount(param1:int):int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getInnerVertexCount(param1));
        }
        public function hide():void{
            Wrapper.checkValid(this.instance);
            this.instance.hide();
        }
        public function getVertexCount(param1:int):int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getVertexCount(param1));
        }
        public function removePolyline(param1:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.removePolyline(param1);
        }
        public function getVertex(param1:int, param2:int):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getVertex(param1, param2)));
        }
        public function setPolyline(param1:int, param2:Array):void{
            Wrapper.checkValid(this.instance);
            this.instance.setPolyline(param1, this.extWrapper.wrapLatLngArray(param2));
        }
        public function getOuterVertex(param1:int):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getOuterVertex(param1)));
        }
        public function getOuterVertexCount():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getOuterVertexCount());
        }
        public function getLatLngBounds():LatLngBounds{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLngBounds(this.instance.getLatLngBounds()));
        }
        public function setOptions(param1:PolygonOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapPolygonOptions(param1));
        }
        public function setPolylineFromEncoded(param1:int, param2:EncodedPolylineData):void{
            Wrapper.checkValid(this.instance);
            this.instance.setPolylineFromEncoded(param1, this.extWrapper.wrapEncodedPolylineData(param2));
        }
        public function getInnerPolylineCount():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getInnerPolylineCount());
        }
        public function getOptions():PolygonOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapPolygonOptions(this.instance.getOptions()));
        }
        public function getPolylineCount():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getPolylineCount());
        }
        public function getInnerVertex(param1:int, param2:int):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getInnerVertex(param1, param2)));
        }
        public function show():void{
            Wrapper.checkValid(this.instance);
            this.instance.show();
        }

    }
}//package com.mapplus.maps.wrappers 
