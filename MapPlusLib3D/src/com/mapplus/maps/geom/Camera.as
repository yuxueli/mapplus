//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class Camera extends WrappableEventDispatcher implements ICamera {

        public static const MAX_PITCH:Number = 85;
        public static const MIN_YAW:Number = -180;
        public static const MIN_ROLL:Number = 0;
        public static const FOCAL_LENGTH_3D:Number = 500;
        public static const MIN_PITCH:Number = 0;
        public static const FOCAL_LENGTH_ORTHOGONAL:Number = 24000000000;
        public static const MAX_YAW:Number = 180;
        public static const MAX_ROLL:Number = 0;

        private var attitude_:Attitude;
        private var zoomScale_:Number;
        private var focalLength_:Number;
        private var horizon_:HPoint;
        private var baseValue:Number;
        private var viewport_:Point;
        private var shadowMatrix_:Matrix;
        private var focalLine_:HPoint;
        private var forwardSign_:int;
        private var proj_:IProjection;
        private var center_:LatLng;
        private var mapViewportToWorld_:Homography;
        private var mapWorldToViewport_:Homography;
        private var cameraX:HPoint;
        private var cameraY:HPoint;
        private var cameraZ:HPoint;
        private var zoom_:Number;

        public function Camera(param1:Number, param2:IProjection){
            super();
            cameraX = new HPoint(0, 0, 0);
            cameraY = new HPoint(0, 0, 0);
            cameraZ = new HPoint(0, 0, 0);
            this.focalLength_ = param1;
            this.proj_ = param2;
            forwardSign_ = 1;
            baseValue = findProjectionBase(param2);
        }
        private static function create2DShadowMatrix():Matrix{
            return (new Matrix(1, 0, -0.2679, 0.5, 0, 0));
        }
        public static function findProjectionBase(param1:IProjection):Number{
            var _loc_2:LatLng;
            var _loc_3:LatLng;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:Point;
            var _loc_7:Point;
            _loc_2 = new LatLng(0, 0);
            _loc_3 = new LatLng(0, 90);
            _loc_4 = param1.fromLatLngToPixel(_loc_2, 0);
            _loc_5 = param1.fromLatLngToPixel(_loc_3, 0);
            _loc_6 = param1.fromLatLngToPixel(_loc_2, 1);
            _loc_7 = param1.fromLatLngToPixel(_loc_3, 1);
            return (((_loc_7.x - _loc_6.x) / (_loc_5.x - _loc_4.x)));
        }
        static function computeCoordVecs(param1:Attitude, param2:HPoint, param3:HPoint, param4:HPoint):void{
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:HPoint;
            _loc_5 = (param1) ? Util.degreesToRadians(param1.pitch) : 0;
            _loc_6 = (param1) ? Util.degreesToRadians(param1.yaw) : 0;
            _loc_7 = Math.sin(_loc_5);
            _loc_8 = Math.cos(_loc_5);
            _loc_9 = Math.sin(_loc_6);
            _loc_10 = Math.cos(_loc_6);
            param4.x = (-(_loc_9) * _loc_7);
            param4.y = (_loc_10 * _loc_7);
            param4.w = _loc_8;
            param3.x = (_loc_9 * _loc_8);
            param3.y = (-(_loc_10) * _loc_8);
            param3.w = _loc_7;
            _loc_11 = HPoint.crossProduct(param3, param4);
            param2.x = _loc_11.x;
            param2.y = _loc_11.y;
            param2.w = _loc_11.w;
        }

        public function get maxRoll():Number{
            return (MAX_ROLL);
        }
        public function get minPitch():Number{
            return (MIN_PITCH);
        }
        public function worldToLatLng(param1:Point):LatLng{
            return (proj_.fromPixelToLatLng(param1, 0, true));
        }
        override public function get interfaceChain():Array{
            return (["ICamera"]);
        }
        public function get is3D():Boolean{
            return (!((attitude_ == null)));
        }
        private function createShadowMatrix():Matrix{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Object;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            if (is3D){
                _loc_1 = ((attitude_.pitch * Math.PI) / 180);
                _loc_2 = Math.cos(_loc_1);
                _loc_3 = Math.sin(_loc_1);
                _loc_4 = {
                    x:1,
                    y:-1,
                    z:-1
                };
                _loc_5 = (-(_loc_3) / ((_loc_2 * _loc_4.z) + (_loc_3 * _loc_4.y)));
                _loc_6 = -(_loc_5);
                _loc_7 = (1 + (_loc_5 * _loc_4.y));
                return (new Matrix(1, 0, _loc_6, _loc_7, 0, 0));
            };
            return (Camera.create2DShadowMatrix());
        }
        public function get forwardSign():int{
            return (forwardSign_);
        }
        public function get shadowMatrix():Matrix{
            return (shadowMatrix_);
        }
        public function viewportToLatLng(param1:Point):LatLng{
            var _loc_2:Point;
            _loc_2 = mapViewportToWorld_.projectEuclidean(param1.x, param1.y);
            return (proj_.fromPixelToLatLng(_loc_2, 0, true));
        }
        public function get zoomScale():Number{
            return (zoomScale_);
        }
        public function get maxPitch():Number{
            return (MAX_PITCH);
        }
        public function tiltCamera(param1:Attitude):Camera{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Attitude;
            var _loc_7:Number = NaN;
            var _loc_8:HPoint;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Point;
            var _loc_15:Point;
            var _loc_16:Rectangle;
            var _loc_17:LatLng;
            var _loc_18:Number = NaN;
            var _loc_19:Camera;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            _loc_2 = (FOCAL_LENGTH_3D / focalLength);
            _loc_3 = MapUtil.wrapHalfOpen((attitude_.yaw + param1.yaw), -180, 180);
            _loc_4 = Util.bound((attitude_.pitch + param1.pitch), MIN_PITCH, MAX_PITCH);
            _loc_5 = Util.bound((attitude_.roll + param1.roll), MIN_ROLL, MAX_ROLL);
            _loc_6 = new Attitude(_loc_3, _loc_4, _loc_5);
            _loc_7 = (Math.PI / 180);
            _loc_8 = computeCameraPosition();
            _loc_9 = getWorldCenter();
            _loc_10 = new Point((_loc_9.x + ((_loc_8.x - _loc_9.x) * _loc_2)), (_loc_9.y + ((_loc_8.y - _loc_9.y) * _loc_2)));
            _loc_11 = _loc_8.w;
            _loc_12 = ((_loc_11 * _loc_2) * Math.tan((_loc_6.pitch * _loc_7)));
            _loc_13 = (_loc_6.yaw * _loc_7);
            _loc_14 = new Point((_loc_12 * Math.sin(_loc_13)), (-(_loc_12) * Math.cos(_loc_13)));
            _loc_15 = _loc_10.add(_loc_14);
            _loc_16 = new Rectangle((_loc_9.x - 128), 0, 0x0100, 0x0100);
            if (!_loc_16.containsPoint(_loc_15)){
                _loc_15 = new Point(Util.bound(_loc_15.x, _loc_16.left, _loc_16.right), Util.bound(_loc_15.y, _loc_16.top, _loc_16.bottom));
                _loc_14 = _loc_15.subtract(_loc_10);
                _loc_20 = (_loc_14.length / (_loc_11 * _loc_2));
                _loc_21 = (Math.atan(_loc_20) / _loc_7);
                _loc_6 = new Attitude(_loc_6.yaw, _loc_21, _loc_6.roll);
            };
            _loc_17 = proj_.fromPixelToLatLng(_loc_15, 0, true);
            _loc_18 = (zoom_ + Util.zoomFactorToOffset((worldDistance(_loc_9) / worldDistance(_loc_15)), baseValue));
            _loc_19 = new Camera(focalLength_, proj_);
            _loc_19.configure(_loc_17, _loc_18, viewport_, _loc_6);
            return (_loc_19);
        }
        function get projection():IProjection{
            return (proj_);
        }
        public function getWorldCenter():Point{
            return (viewportToWorld(new Point((viewport_.x / 2), (viewport_.y / 2))));
        }
        public function get center():LatLng{
            return (center_);
        }
        public function viewportToWorld(param1:Point):Point{
            return (mapViewportToWorld_.projectEuclidean(param1.x, param1.y));
        }
        public function getWorldViewPolygon():Array{
            var _loc_1:Rectangle;
            var _loc_2:HPolygon;
            var _loc_3:Number = NaN;
            var _loc_4:HPolygon;
            _loc_1 = new Rectangle((latLngToWorld(center).x - 128), 0, 0x0100, 0x0100);
            _loc_2 = HPolygon.fromRect(new Rectangle(0, 0, viewport.x, viewport.y));
            _loc_3 = PerspectiveConstants.Z_NEAR_DISTANCE;
            if (forwardSign == 1){
                _loc_2 = Geometry.clipBelow(_loc_2, horizon, _loc_3);
            } else {
                _loc_2 = Geometry.clipAbove(_loc_2, horizon, _loc_3);
            };
            _loc_4 = mapViewportToWorld.projectHPolygon(_loc_2);
            _loc_4 = Geometry.clipAgainstRect(_loc_4, _loc_1);
            return (HPoint.getCartesianArray(_loc_4.verts));
        }
        public function clone():Camera{
            var _loc_1:Camera;
            _loc_1 = new Camera(focalLength_, proj_);
            _loc_1.center_ = center_.clone();
            _loc_1.attitude_ = attitude_;
            _loc_1.zoom_ = zoom_;
            _loc_1.zoomScale_ = zoomScale_;
            _loc_1.viewport_ = viewport_.clone();
            _loc_1.mapWorldToViewport_ = mapWorldToViewport_.clone();
            _loc_1.mapViewportToWorld_ = mapViewportToWorld_.clone();
            _loc_1.horizon_ = horizon_.clone();
            _loc_1.focalLine_ = focalLine_.clone();
            _loc_1.forwardSign_ = forwardSign_;
            _loc_1.cameraX = cameraX.clone();
            _loc_1.cameraY = cameraY.clone();
            _loc_1.cameraZ = cameraZ.clone();
            return (_loc_1);
        }
        public function get mapViewportToWorld():Homography{
            return (mapViewportToWorld_);
        }
        public function get maxYaw():Number{
            return (MAX_YAW);
        }
        public function worldToViewport(param1:Point):Point{
            return (mapWorldToViewport_.projectEuclidean(param1.x, param1.y));
        }
        public function get mapWorldToViewport():Homography{
            return (mapWorldToViewport_);
        }
        public function getTransformationCoefficients():Array{
            var _loc_1:TransformationGeometry;
            _loc_1 = getTransformationGeometry();
            return ([_loc_1.cameraPosition.x, _loc_1.cameraPosition.y, _loc_1.cameraPosition.z, -(_loc_1.cameraXAxis.x), -(_loc_1.cameraXAxis.y), -(_loc_1.cameraXAxis.z), -(_loc_1.cameraYAxis.x), -(_loc_1.cameraYAxis.y), -(_loc_1.cameraYAxis.z), _loc_1.cameraZAxis.x, _loc_1.cameraZAxis.y, _loc_1.cameraZAxis.z, _loc_1.viewportSize.x, _loc_1.viewportSize.y, _loc_1.focalLength]);
        }
        private function computeCameraPosition():HPoint{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_1 = (focalLength_ / zoomScale_);
            _loc_2 = proj_.fromLatLngToPixel(center_, 0);
            _loc_3 = (_loc_2.x + (_loc_1 * cameraZ.x));
            _loc_4 = (_loc_2.y + (_loc_1 * cameraZ.y));
            _loc_5 = (_loc_1 * cameraZ.w);
            return (new HPoint(_loc_3, _loc_4, _loc_5));
        }
        public function worldToViewportDistance(param1:Point):Number{
            return (mapWorldToViewport_.orthogonalDistance(param1));
        }
        public function getLatLngClosestToCenter(param1:LatLng):LatLng{
            var _loc_2:Number = NaN;
            _loc_2 = center_.lng();
            return (new LatLng(param1.lat(), MapUtil.wrap(param1.lng(), (_loc_2 - 180), (_loc_2 + 180)), true));
        }
        public function getTransformationGeometry():TransformationGeometry{
            var _loc_1:HPoint;
            _loc_1 = computeCameraPosition();
            return (new TransformationGeometry(new Point3D(_loc_1.x, _loc_1.y, _loc_1.w), new Point3D(-(cameraX.x), -(cameraX.y), -(cameraX.w)), new Point3D(-(cameraY.x), -(cameraY.y), -(cameraY.w)), new Point3D(cameraZ.x, cameraZ.y, cameraZ.w), viewport_, focalLength));
        }
        public function get horizon():HPoint{
            return (horizon_);
        }
        public function get2DLatLngBounds():LatLngBounds{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:LatLng;
            var _loc_5:LatLng;
            _loc_1 = Math.round(zoom_);
            _loc_2 = proj_.fromLatLngToPixel(center_, _loc_1);
            _loc_3 = new Point((viewport_.x / 2), (-(viewport_.y) / 2));
            _loc_4 = proj_.fromPixelToLatLng(_loc_2.add(_loc_3), _loc_1);
            _loc_5 = proj_.fromPixelToLatLng(_loc_2.subtract(_loc_3), _loc_1);
            if (_loc_4.lat() > _loc_5.lat()){
                return (new LatLngBounds(_loc_5, _loc_4));
            };
            return (new LatLngBounds(_loc_4, _loc_5));
        }
        public function worldDistance(param1:Point):Number{
            var _loc_2:HPoint;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_2 = computeCameraPosition();
            _loc_3 = (_loc_2.x - param1.x);
            _loc_4 = (_loc_2.y - param1.y);
            _loc_5 = _loc_2.w;
            return (Math.sqrt((((_loc_3 * _loc_3) + (_loc_4 * _loc_4)) + (_loc_5 * _loc_5))));
        }
        public function get focalLength():Number{
            return (focalLength_);
        }
        public function getWorldClosestToCenter(param1:Point):Point{
            var _loc_2:Point;
            _loc_2 = latLngToWorld(center_);
            return (new Point(MapUtil.wrap(param1.x, (_loc_2.x - 128), (_loc_2.x + 128)), param1.y));
        }
        public function get viewport():Point{
            return (viewport_.clone());
        }
        public function getVisibleWorld():Rectangle{
            var _loc_1:Point;
            _loc_1 = getWorldCenter();
            return (new Rectangle((_loc_1.x - 128), 0, 0x0100, 0x0100));
        }
        public function isAhead(param1:LatLng):Boolean{
            var _loc_2:Point;
            var _loc_3:HPoint;
            _loc_2 = proj_.fromLatLngToPixel(param1, 0);
            _loc_3 = HPoint.fromEuclideanPoint(_loc_2);
            return ((Geometry.pointLineTest(_loc_3, focalLine_) == forwardSign_));
        }
        public function viewportToWorldHPoint(param1:Point):HPoint{
            return (mapViewportToWorld_.project(new HPoint(param1.x, param1.y, 1)));
        }
        public function get attitude():Attitude{
            return (attitude_);
        }
        public function get minYaw():Number{
            return (MIN_YAW);
        }
        public function get base():Number{
            return (baseValue);
        }
        public function getLatLngBounds():LatLngBounds{
            var _loc_1:Point;
            var _loc_2:Point;
            var _loc_3:LatLng;
            var _loc_4:LatLng;
			
			// by 于学利
            if (!is3D){
                _loc_1 = new Point(viewport_.x, 0);
                _loc_2 = new Point(0, viewport_.y);
                _loc_3 = viewportToLatLng(_loc_1);
                _loc_4 = viewportToLatLng(_loc_2);
                if (_loc_3.lat() > _loc_4.lat()){
                    return (new LatLngBounds(_loc_4, _loc_3));
                };
                return (new LatLngBounds(_loc_3, _loc_4));
            };
            return (null);
        }
        public function get zoom():Number{
            return (zoom_);
        }
        public function configure(param1:LatLng, param2:Number, param3:Point, param4:Attitude):void{
            this.center_ = param1;
            this.attitude_ = param4;
            this.zoom_ = param2;
            zoomScale_ = Math.pow(baseValue, param2);
            this.viewport_ = param3;
            mapWorldToViewport_ = computeTransform();
            mapViewportToWorld_ = mapWorldToViewport_.getInverse();
            horizon_ = mapWorldToViewport_.getVanishingLine();
            focalLine_ = mapViewportToWorld_.getVanishingLine();
            shadowMatrix_ = createShadowMatrix();
        }
        public function latLngToViewport(param1:LatLng):Point{
            var _loc_2:Point;
            _loc_2 = proj_.fromLatLngToPixel(param1, 0);
            return (worldToViewport(_loc_2));
        }
        public function get minRoll():Number{
            return (MIN_ROLL);
        }
        public function latLngToWorld(param1:LatLng):Point{
            return (proj_.fromLatLngToPixel(param1, 0));
        }
        public function isOnMap(param1:Point):Boolean{
            var _loc_2:HPoint;
            _loc_2 = HPoint.fromEuclideanPoint(param1);
            return ((Geometry.pointLineTest(_loc_2, horizon_) == forwardSign_));
        }
        private function computeTransform():Homography{
            var _loc_1:HPoint;
            var _loc_2:Array;
            var _loc_3:Array;
            computeCoordVecs(attitude_, cameraX, cameraY, cameraZ);
            _loc_1 = computeCameraPosition();
            _loc_2 = [[focalLength_, 0, (viewport_.x / 2)], [0, focalLength_, (viewport_.y / 2)], [0, 0, 1]];
            _loc_3 = [[cameraX.x, cameraX.y, -(HPoint.dotProduct(_loc_1, cameraX))], [cameraY.x, cameraY.y, -(HPoint.dotProduct(_loc_1, cameraY))], [cameraZ.x, cameraZ.y, -(HPoint.dotProduct(_loc_1, cameraZ))]];
            return (Homography.createFromRowArray(Geometry.getMatrixProduct(_loc_2, _loc_3)));
        }
        public function get focalLine():HPoint{
            return (focalLine_);
        }

    }
}//package com.mapplus.maps.geom 
