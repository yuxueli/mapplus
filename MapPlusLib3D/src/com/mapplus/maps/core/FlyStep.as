//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.geom.*;

    public class FlyStep {

        public var zoom:Number;
        public var center:Point;
        public var attitude:Attitude;

        public function FlyStep(param1:Point, param2:Number, param3:Attitude){
            super();
            this.center = param1;
            this.zoom = param2;
            this.attitude = param3;
        }
        public static function fromCoeffs(param1:Array):FlyStep{
            return (new FlyStep(new Point(param1[0], param1[1]), param1[2], new Attitude(param1[3], param1[4], 0)));
        }

        public function toCoeffs():Array{
            return ([center.x, center.y, zoom, attitude.yaw, attitude.pitch]);
        }

    }
}//package com.mapplus.maps.core 
