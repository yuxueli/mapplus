//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    public class IWrappableSpriteWrapper extends EventDispatcherWrapper implements IWrappableSprite {

        public function IWrappableSpriteWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IWrappableSprite"]);
        }
        public function getSprite():Sprite{
            Wrapper.checkValid(this.instance);
            return (this.instance.getSprite());
        }

    }
}//package com.mapplus.maps.wrappers 
