//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public interface IProjection extends IWrappable {

        function tileCheckRange(_arg1:Point, _arg2:Number, _arg3:Number):Boolean;
        function fromPixelToLatLng(_arg1:Point, _arg2:Number, _arg3:Boolean=false):LatLng;
        function fromLatLngToPixel(_arg1:LatLng, _arg2:Number):Point;
        function getWrapWidth(_arg1:Number):Number;

    }
}//package com.mapplus.maps.interfaces 
