//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;

    public final class TransformationGeometry {

        private var cameraPositionValue:Point3D;
        private var focalLengthValue:Number;
        private var viewportSizeValue:Point;
        private var cameraZAxisValue:Point3D;
        private var cameraYAxisValue:Point3D;
        private var cameraXAxisValue:Point3D;

        public function TransformationGeometry(param1:Point3D, param2:Point3D, param3:Point3D, param4:Point3D, param5:Point, param6:Number){
            super();
            cameraPositionValue = param1;
            cameraXAxisValue = param2;
            cameraYAxisValue = param3;
            cameraZAxisValue = param4;
            viewportSizeValue = param5.clone();
            focalLengthValue = param6;
        }
        public static function fromObject(param1:Object):TransformationGeometry{
            return ((!((param1 == null))) ? new TransformationGeometry(Point3D.fromObject(param1.cameraPosition), Point3D.fromObject(param1.cameraXAxis), Point3D.fromObject(param1.cameraYAxis), Point3D.fromObject(param1.cameraZAxis), new Point(param1.viewportSize.x, param1.viewportSize.y), param1.focalLength) : null);
        }

        public function get cameraXAxis():Point3D{
            return (cameraXAxisValue);
        }
        public function get cameraZAxis():Point3D{
            return (cameraZAxisValue);
        }
        public function get viewportSize():Point{
            return (viewportSizeValue.clone());
        }
        public function get focalLength():Number{
            return (focalLengthValue);
        }
        public function get cameraPosition():Point3D{
            return (cameraPositionValue);
        }
        public function get cameraYAxis():Point3D{
            return (cameraYAxisValue);
        }

    }
}//package com.mapplus.maps.geom 
