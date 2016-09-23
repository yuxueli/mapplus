//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;

    public final class MapTypeControl extends IMapTypeControlWrapper implements IControl {

        public function MapTypeControl(options:MapTypeControlOptions=null){
            var bootstrap:* = null;
            var self:* = null;
            var options = options;
            super();
            self = this;
            bootstrap = ClientBootstrap.getInstance();
            bootstrap.delayInitialize(function ():void{
                var _loc_1:IMapsFactory;
                var _loc_2:Object;
                _loc_1 = bootstrap.getMapsFactory();
                _loc_2 = _loc_1.createMapTypeControl2(options);
                Wrapper.instance().wrap(_loc_2, self, IMapTypeControl, MapTypeControl);
            });
        }
    }
}//package com.mapplus.maps.controls 
