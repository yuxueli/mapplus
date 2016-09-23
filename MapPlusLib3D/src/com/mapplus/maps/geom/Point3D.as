//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {

    public final class Point3D {

        private var zValue:Number;
        private var yValue:Number;
        private var xValue:Number;

        public function Point3D(param1:Number, param2:Number, param3:Number){
            super();
            xValue = param1;
            yValue = param2;
            zValue = param3;
        }
        public static function fromObject(param1:Object):Point3D{
            return (((param1)!=null) ? new Point3D(param1.x, param1.y, param1.z) : null);
        }

        public function get y():Number{
            return (yValue);
        }
        public function get z():Number{
            return (zValue);
        }
        public function toString():String{
            return ((((((("(x=" + xValue) + ", y=") + yValue) + ", z=") + zValue) + ")"));
        }
        public function get x():Number{
            return (xValue);
        }

    }
}//package com.mapplus.maps.geom 
