//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public interface IProjection extends IWrappable {

        function tileCheckRange(param1:Point, param2:Number, param3:Number):Boolean;
        function fromPixelToLatLng(param1:Point, param2:Number, param3:Boolean=false):LatLng;
        function fromLatLngToPixel(param1:LatLng, param2:Number):Point;
        function getWrapWidth(param1:Number):Number;

    }
}//package com.mapplus.maps.interfaces 
