//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;

    interface IPaneInternal extends IPane {

        function getMapInstance():IMapBase2;
        function getBackground():Sprite;
        function getForeground():Sprite;
        function getCamera():Camera;
        function setMapInstance( param1:IMapBase2):void;

    }
}//package com.mapplus.maps.overlays 
