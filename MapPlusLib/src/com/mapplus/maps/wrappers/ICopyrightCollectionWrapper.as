//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class ICopyrightCollectionWrapper extends EventDispatcherWrapper implements ICopyrightCollection {

        public function ICopyrightCollectionWrapper(){
            super();
        }
        public function getCopyrightsAtLatLng(param1:LatLng):Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapCopyrightArray(this.instance.getCopyrightsAtLatLng(this.extWrapper.wrapLatLng(param1))));
        }
        override public function get interfaceChain():Array{
            return (["ICopyrightCollection"]);
        }
        public function getCopyrights(param1:LatLngBounds, param2:Number):Array{
            Wrapper.checkValid(this.instance);
            return (this.instance.getCopyrights(this.extWrapper.wrapLatLngBounds(param1), param2));
        }
        public function getCopyrightNotice(param1:LatLngBounds, param2:Number):CopyrightNotice{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapCopyrightNotice(this.instance.getCopyrightNotice(this.extWrapper.wrapLatLngBounds(param1), param2)));
        }
        public function addCopyright(param1:Copyright):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.addCopyright(this.extWrapper.wrapCopyright(param1)));
        }

    }
}//package com.mapplus.maps.wrappers 
