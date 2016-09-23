//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class PolygonShape extends Polygon implements IPolygonShape {

        public function PolygonShape(point:LatLng, r1:Number, r2:Number, r3:Number, r4:Number, rotation:Number, vertexCount:Number, opts:PolygonOptions=null, tilt:Boolean=false){
            var I1:int;
            var r1a:Number;
            var r2a:Number;
            var y:Number;
            var x:Number;
            var lng:Number;
            var lat:Number;
            var rot:Number = ((-(rotation) * Math.PI) / 180);
            var points:Array = new Array();
            var latConv:Number = (point.distanceFrom(new LatLng((point.lat() + 0.1), point.lng())) * 10);
            var lngConv:Number = (point.distanceFrom(new LatLng(point.lat(), (point.lng() + 0.1))) * 10);
            var step:int = (((360 / vertexCount)) || (10));
            var flop:Number = -1;
            if (tilt){
                I1 = (180 / vertexCount);
            } else {
                I1 = 0;
            };
            var i:int = I1;
            while (i <= (360.001 + I1)) {
                r1a = (flop) ? r1 : r3;
                r2a = (flop) ? r2 : r4;
                flop = (-1 - flop);
                y = (r1a * Math.cos(((i * Math.PI) / 180)));
                x = (r2a * Math.sin(((i * Math.PI) / 180)));
                lng = (((x * Math.cos(rot)) - (y * Math.sin(rot))) / lngConv);
                lat = (((y * Math.cos(rot)) + (x * Math.sin(rot))) / latConv);
                points.push(new LatLng((point.lat() + lat), (point.lng() + lng)));
                i = (i + step);
            };
            super(points, opts);
        }
    }
}//package com.mapplus.maps.overlays 
