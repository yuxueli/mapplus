//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public interface IMap3D extends IMap {

        function getAttitude():Attitude;
        function cancelFlyTo():void;
        function get camera():ICamera;
        function get dragMode():int;
        function get viewMode():int;
        function setAttitude(param1:Attitude):void;
        function set dragMode(param1:int):void;
        function flyTo(param1:LatLng, param2:Number=NaN, param3:Attitude=null, param4:Number=1):void;
        function set viewMode(param1:int):void;

    }
}//package com.mapplus.maps.interfaces 
