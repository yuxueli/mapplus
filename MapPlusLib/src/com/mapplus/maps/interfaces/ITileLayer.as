//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.geom.*;

    public interface ITileLayer extends IWrappable {

        function getMinResolution():Number;
        function getAlpha():Number;
        function loadTile(param1:Point, param2:Number):DisplayObject;
        function getCopyrightCollection():ICopyrightCollection;
        function getMaxResolution():Number;
        function setMapType(param1:IMapType):void;

    }
}//package com.mapplus.maps.interfaces 
