//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.geom.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;

    interface IPaneInternal extends IPane {

        function setMapInstance(param1:IMapBase2):void;
        function getMapInstance():IMapBase2;
        function getCamera():Camera;
        function getBackground():Sprite;
        function getForeground():Sprite;

    }
}//package com.mapplus.maps.overlays 
