//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class ICopyrightCollectionWrapper extends EventDispatcherWrapper implements ICopyrightCollection {

        public function ICopyrightCollectionWrapper(){
            super();
        }
        public function getCopyrightNotice(param1:LatLngBounds, param2:Number):CopyrightNotice{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapCopyrightNotice(this.instance.getCopyrightNotice(this.extWrapper.wrapLatLngBounds(param1), param2)));
        }
        public function getCopyrights(param1:LatLngBounds, param2:Number):Array{
            Wrapper.checkValid(this.instance);
            return (this.instance.getCopyrights(this.extWrapper.wrapLatLngBounds(param1), param2));
        }
        public function addCopyright(copyright:Copyright):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.addCopyright(this.extWrapper.wrapCopyright(copyright)));
        }
        override public function get interfaceChain():Array{
            return (["ICopyrightCollection"]);
        }
        public function getCopyrightsAtLatLng(latLng:LatLng):Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapCopyrightArray(this.instance.getCopyrightsAtLatLng(this.extWrapper.wrapLatLng(latLng))));
        }

    }
}//package com.mapplus.maps.wrappers 
