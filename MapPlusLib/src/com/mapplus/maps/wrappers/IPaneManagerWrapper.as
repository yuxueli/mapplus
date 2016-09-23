//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import com.mapplus.maps.interfaces.*;

    public class IPaneManagerWrapper extends WrapperBase implements IPaneManager {

        public function IPaneManagerWrapper(){
            super();
        }
        public function createPane(param1:int=1):IPane{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPane(this.instance.createPane(param1)));
        }
        override public function get interfaceChain():Array{
            return (["IPaneManager"]);
        }
        public function removePane(param1:IPane):void{
            Wrapper.checkValid(this.instance);
            this.instance.removePane(this.extWrapper.wrapIPane(param1));
        }
        public function getPaneById(param1:int):IPane{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPane(this.instance.getPaneById(param1)));
        }
        public function getPaneIndex(param1:IPane):int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getPaneIndex(this.extWrapper.wrapIPane(param1)));
        }
        public function get paneCount():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.paneCount);
        }
        public function get map():IMap{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMap(this.instance.map));
        }
        public function removeAllPanes():void{
            Wrapper.checkValid(this.instance);
            this.instance.removeAllPanes();
        }
        public function placePaneAt(param1:IPane, param2:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.placePaneAt(this.extWrapper.wrapIPane(param1), param2);
        }
        public function containsPane(param1:IPane):Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.containsPane(this.extWrapper.wrapIPane(param1)));
        }
        public function clearOverlays():void{
            Wrapper.checkValid(this.instance);
            this.instance.clearOverlays();
        }
        public function getPaneAt(param1:int):IPane{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPane(this.instance.getPaneAt(param1)));
        }

    }
}//package com.mapplus.maps.wrappers 
