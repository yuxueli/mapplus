//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.interfaces.*;

    public class Camera {

        public static const MAX_PITCH:Number = 85;
        public static const MIN_YAW:Number = -180;
        public static const FOCAL_LENGTH_3D:Number = 500;
        public static const MIN_ROLL:Number = 0;
        public static const MIN_PITCH:Number = 0;
        public static const MAX_YAW:Number = 180;
        public static const FOCAL_LENGTH_ORTHOGONAL:Number = 24000000000;
        public static const MAX_ROLL:Number = 0;

        private var focalLength_:Number;
        private var zoomScale_:Number;
        private var baseValue:Number;
        private var proj_:IProjection;
        private var center_:LatLng;
        private var zoom_:Number;
        private var attitude_:Attitude;
        private var viewport_:Point;

        public function Camera(param1:Number, param2:IProjection){
            super();
            this.focalLength_ = param1;
            this.proj_ = param2;
            this.baseValue = findProjectionBase(param2);
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

        public function get maxRoll():Number{
            return (MAX_ROLL);
        }
        public function getLatLngClosestToCenter(param1:LatLng):LatLng{
            var _loc_2:Number = NaN;
            _loc_2 = this.center_.lng();
            return (new LatLng(param1.lat(), MapUtil.wrap(param1.lng(), (_loc_2 - 180), (_loc_2 + 180)), true));
        }
        public function get minPitch():Number{
            return (MIN_PITCH);
        }
        public function getTransformationGeometry():TransformationGeometry{
            var _loc_1:Point;
            _loc_1 = this.latLngToWorld(this.center_);
            return (new TransformationGeometry(new Point3D(_loc_1.x, _loc_1.y, (this.focalLength_ / this.zoomScale_)), new Point3D(1, 0, 0), new Point3D(0, 1, 0), new Point3D(0, 0, 1), this.viewport_, this.focalLength));
        }
        public function worldToLatLng(param1:Point):LatLng{
            return (this.proj_.fromPixelToLatLng(param1, 0, true));
        }
        public function get shadowMatrix():Matrix{
            return (Camera.create2DShadowMatrix());
        }
        public function get is3D():Boolean{
            return (!((this.attitude_ == null)));
        }
        public function get2DLatLngBounds():LatLngBounds{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:LatLng;
            var _loc_5:LatLng;
            _loc_1 = Math.round(this.zoom_);
            _loc_2 = this.proj_.fromLatLngToPixel(this.center_, _loc_1);
            _loc_3 = new Point((this.viewport_.x / 2), (-(this.viewport_.y) / 2));
            _loc_4 = this.proj_.fromPixelToLatLng(_loc_2.add(_loc_3), _loc_1);
            _loc_5 = this.proj_.fromPixelToLatLng(_loc_2.subtract(_loc_3), _loc_1);
            if (_loc_4.lat() > _loc_5.lat()){
                return (new LatLngBounds(_loc_5, _loc_4));
            };
            return (new LatLngBounds(_loc_4, _loc_5));
        }
        public function get viewport():Point{
            return (this.viewport_.clone());
        }
        public function viewportToLatLng(param1:Point):LatLng{
            return (this.worldToLatLng(this.viewportToWorld(param1)));
        }
        public function get attitude():Attitude{
            return (this.attitude_);
        }
        public function get focalLength():Number{
            return (this.focalLength_);
        }
        public function getWorldClosestToCenter(param1:Point):Point{
            var _loc_2:Point;
            _loc_2 = this.latLngToWorld(this.center_);
            return (new Point(MapUtil.wrap(param1.x, (_loc_2.x - 128), (_loc_2.x + 128)), param1.y));
        }
        public function get zoomScale():Number{
            return (this.zoomScale_);
        }
        public function get maxPitch():Number{
            return (MAX_PITCH);
        }
        public function get minYaw():Number{
            return (MIN_YAW);
        }
        public function isAhead(param1:LatLng):Boolean{
            return (true);
        }
        function get projection():IProjection{
            return (this.proj_);
        }
        public function computeWorldCenter():Point{
            return (this.proj_.fromLatLngToPixel(this.center_, 0));
        }
        public function viewportToWorld(param1:Point):Point{
            var _loc_2:Point;
            var _loc_3:Point;
            _loc_2 = new Point((param1.x - (this.viewport.x / 2)), (param1.y - (this.viewport.y / 2)));
            _loc_3 = new Point((_loc_2.x / this.zoomScale_), (_loc_2.y / this.zoomScale_));
            return (_loc_3.add(this.computeWorldCenter()));
        }
        public function get zoom():Number{
            return (this.zoom_);
        }
        public function get center():LatLng{
            return (this.center_);
        }
        public function get base():Number{
            return (this.baseValue);
        }
        public function clone():Camera{
            var _loc_1:Camera;
            _loc_1 = new Camera(this.focalLength_, this.proj_);
            _loc_1.center_ = this.center_.clone();
            _loc_1.attitude_ = this.attitude_;
            _loc_1.zoom_ = this.zoom_;
            _loc_1.zoomScale_ = this.zoomScale_;
            _loc_1.viewport_ = this.viewport_.clone();
            return (_loc_1);
        }
        public function getWorldCenter():Point{
            return (this.viewportToWorld(new Point((this.viewport_.x / 2), (this.viewport_.y / 2))));
        }
        public function configure(param1:LatLng, param2:Number, param3:Point):void{
            this.center_ = param1;
            this.zoom_ = param2;
            this.zoomScale_ = Math.pow(this.baseValue, param2);
            this.viewport_ = param3;
        }
        public function latLngToViewport(param1:LatLng):Point{
            return (this.worldToViewport(this.latLngToWorld(param1)));
        }
        public function getLatLngBounds():LatLngBounds{
            var _loc_1:Point;
            var _loc_2:Point;
            var _loc_3:LatLng;
            var _loc_4:LatLng;
            if (!(this.is3D)){
                _loc_1 = new Point(this.viewport_.x, 0);
                _loc_2 = new Point(0, this.viewport_.y);
                _loc_3 = this.viewportToLatLng(_loc_1);
                _loc_4 = this.viewportToLatLng(_loc_2);
                if (_loc_3.lat() > _loc_4.lat()){
                    return (new LatLngBounds(_loc_4, _loc_3));
                };
                return (new LatLngBounds(_loc_3, _loc_4));
            };
            return (null);
        }
        private function getTopLeftPoint():Point{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Point;
            _loc_1 = Math.floor(this.zoom_);
            _loc_2 = Util.getFracZoom(this.zoom_, this.baseValue);
            _loc_3 = this.proj_.fromLatLngToPixel(this.center_, _loc_1);
            _loc_3 = new Point((_loc_3.x * _loc_2), (_loc_3.y * _loc_2));
            return (new Point((_loc_3.x - (this.viewport_.x / 2)), (_loc_3.y - (this.viewport_.y / 2))));
        }
        public function get maxYaw():Number{
            return (MAX_YAW);
        }
        public function get minRoll():Number{
            return (MIN_ROLL);
        }
        public function worldToViewport(param1:Point):Point{
            var _loc_2:Point;
            var _loc_3:Point;
            _loc_2 = param1.subtract(this.computeWorldCenter());
            _loc_3 = new Point((_loc_2.x * this.zoomScale_), (_loc_2.y * this.zoomScale_));
            return (new Point(((this.viewport.x / 2) + _loc_3.x), ((this.viewport.y / 2) + _loc_3.y)));
        }
        public function latLngToWorld(param1:LatLng):Point{
            return (this.proj_.fromLatLngToPixel(param1, 0));
        }
        public function isOnMap(param1:Point):Boolean{
            return (true);
        }
        public function getTransformationCoefficients():Array{
            var _loc_1:TransformationGeometry;
            _loc_1 = this.getTransformationGeometry();
            return ([_loc_1.cameraPosition.x, _loc_1.cameraPosition.y, _loc_1.cameraPosition.z, -(_loc_1.cameraXAxis.x), -(_loc_1.cameraXAxis.y), -(_loc_1.cameraXAxis.z), -(_loc_1.cameraYAxis.x), -(_loc_1.cameraYAxis.y), -(_loc_1.cameraYAxis.z), _loc_1.cameraZAxis.x, _loc_1.cameraZAxis.y, _loc_1.cameraZAxis.z, _loc_1.viewportSize.x, _loc_1.viewportSize.y, _loc_1.focalLength]);
        }

    }
}//package com.mapplus.maps.geom 
