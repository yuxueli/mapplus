//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;

    public final class ScaleControl extends IScaleControlWrapper implements IControl {

        public function ScaleControl(param1:ScaleControlOptions=null){
            var bootstrap:* = null;
            var self:* = null;
            var options:* = undefined;
            var param1 = param1;
            super();
            self = this;
            options = param1;
            bootstrap = ClientBootstrap.getInstance();
            bootstrap.delayInitialize(function ():void{
                var _loc_1:IMapsFactory;
                var _loc_2:Object;
                _loc_1 = bootstrap.getMapsFactory();
                _loc_2 = _loc_1.createScaleControl2(options);
                Wrapper.instance().wrap(_loc_2, self, IScaleControl, ScaleControl);
            });
        }
    }
}//package com.mapplus.maps.controls 
