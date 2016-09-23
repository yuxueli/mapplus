//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.geom.*;

    public interface ITileLayer extends IWrappable {

        function loadTile(_arg1:Point, _arg2:Number):DisplayObject;
        function getAlpha():Number;
        function getMinResolution():Number;
        function getMaxResolution():Number;
        function setMapType(Number:IMapType):void;
        function getCopyrightCollection():ICopyrightCollection;

    }
}//package com.mapplus.maps.interfaces 
