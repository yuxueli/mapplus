//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public final class TransformationGeometry {

        private var cameraPositionValue:Point3D;
        private var viewportSizeValue:Point;
        private var focalLengthValue:Number;
        private var cameraZAxisValue:Point3D;
        private var cameraYAxisValue:Point3D;
        private var cameraXAxisValue:Point3D;

        public function TransformationGeometry(param1:Point3D, param2:Point3D, param3:Point3D, param4:Point3D, param5:Point, param6:Number){
            super();
            this.cameraPositionValue = param1;
            this.cameraXAxisValue = param2;
            this.cameraYAxisValue = param3;
            this.cameraZAxisValue = param4;
            this.viewportSizeValue = param5.clone();
            this.focalLengthValue = param6;
        }
        public static function fromObject(param1:Object):TransformationGeometry{
            return ((!((param1 == null))) ? new TransformationGeometry(Point3D.fromObject(param1.cameraPosition), Point3D.fromObject(param1.cameraXAxis), Point3D.fromObject(param1.cameraYAxis), Point3D.fromObject(param1.cameraZAxis), new Point(param1.viewportSize.x, param1.viewportSize.y), param1.focalLength) : null);
        }

        public function get cameraZAxis():Point3D{
            return (this.cameraZAxisValue);
        }
        public function get cameraXAxis():Point3D{
            return (this.cameraXAxisValue);
        }
        public function get focalLength():Number{
            return (this.focalLengthValue);
        }
        public function get cameraPosition():Point3D{
            return (this.cameraPositionValue);
        }
        public function get cameraYAxis():Point3D{
            return (this.cameraYAxisValue);
        }
        public function get viewportSize():Point{
            return (this.viewportSizeValue.clone());
        }

    }
}//package com.mapplus.maps.geom 
