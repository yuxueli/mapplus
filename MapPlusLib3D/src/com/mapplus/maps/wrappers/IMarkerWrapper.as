//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.*;

    public class IMarkerWrapper extends IOverlayWrapper implements IMarker {

        public function IMarkerWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IMarker", "IOverlay"]);
        }
        public function getOptions():MarkerOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMarkerOptions(this.instance.getOptions()));
        }
        public function hide():void{
            Wrapper.checkValid(this.instance);
            this.instance.hide();
        }
        public function show():void{
            Wrapper.checkValid(this.instance);
            this.instance.show();
        }
        public function setLatLng(param1:LatLng):void{
            Wrapper.checkValid(this.instance);
            this.instance.setLatLng(this.extWrapper.wrapLatLng(param1));
        }
        public function setOptions(param1:MarkerOptions):void{
            Wrapper.checkValid(this.instance);
            this.instance.setOptions(this.extWrapper.wrapMarkerOptions(param1));
        }
        public function isHidden():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isHidden());
        }
        public function openInfoWindow(param1:InfoWindowOptions=null, param2:Boolean=false):IInfoWindow{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIInfoWindow(this.instance.openInfoWindow(this.extWrapper.wrapInfoWindowOptions(param1), param2)));
        }
        public function closeInfoWindow():void{
            Wrapper.checkValid(this.instance);
            this.instance.closeInfoWindow();
        }
        public function getLatLng():LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getLatLng()));
        }

    }
}//package com.mapplus.maps.wrappers 
