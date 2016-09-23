//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.geom.*;
    import com.mapplus.maps.*;

    public interface IProjection extends IWrappable {

        function getWrapWidth(zoom:Number):Number;
        function tileCheckRange(tile:Point, zoom:Number, tilesize:Number):Boolean;
        function fromLatLngToPixel(latLng:LatLng, zoom:Number):Point;
        function fromPixelToLatLng(pixel:Point, zoom:Number, opt_nowrap:Boolean=false):LatLng;

    }
}//package com.mapplus.maps.interfaces 
