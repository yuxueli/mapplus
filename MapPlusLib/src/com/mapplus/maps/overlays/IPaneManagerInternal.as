﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;

    public interface IPaneManagerInternal extends IPaneManager {

        function destroy():void;
        function getMapInstance():IMapBase2;
        function placePaneShadow(param1:IPane, param2:IPane):void;

    }
}//package com.mapplus.maps.overlays 
