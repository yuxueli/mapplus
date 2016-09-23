//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IStyledMapTypeWrapper extends IMapTypeWrapper implements IStyledMapType {

        public function IStyledMapTypeWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IStyledMapType", "IMapType"]);
        }
        public function getStyle():Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMapTypeStyleArray(this.instance.getStyle()));
        }
        public function setStyle(param1:Array):void{
            Wrapper.checkValid(this.instance);
            this.instance.setStyle(this.extWrapper.wrapMapTypeStyleArray(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
