//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {

    public final class Point3D {

        private var zValue:Number;
        private var yValue:Number;
        private var xValue:Number;

        public function Point3D(param1:Number, param2:Number, param3:Number){
            super();
            this.xValue = param1;
            this.yValue = param2;
            this.zValue = param3;
        }
        public static function fromObject(param1:Object):Point3D{
            return ((!((param1 == null))) ? new Point3D(param1.x, param1.y, param1.z) : null);
        }

        public function get y():Number{
            return (this.yValue);
        }
        public function toString():String{
            return ((((((("(x=" + this.xValue) + ", y=") + this.yValue) + ", z=") + this.zValue) + ")"));
        }
        public function get z():Number{
            return (this.zValue);
        }
        public function get x():Number{
            return (this.xValue);
        }

    }
}//package com.mapplus.maps.geom 
