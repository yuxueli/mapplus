//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class Polyline extends Overlay implements IPolyline {

        static const POLYLINE_BASE_TOLERANCE:Number = 3;
        private static const DEFAULT_STROKE_COLOR:Number = 0xFF;
        static const POLYLINE_DRAWING_TOLERANCE:Number = 1;
        static const POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL:int = 17;

        private static var llBoundsArray:Array = null;
        private static var numLevelsBoundsArray:int = -1;
        private static var boundsBoundsArray:LatLngBounds = null;
        private static var defaultOptions:PolylineOptions = new PolylineOptions({
            strokeStyle:{
                color:DEFAULT_STROKE_COLOR,
                alpha:0.45,
                thickness:5,
                pixelHinting:false
            },
            geodesic:false
        });

        private var nextHigherPoint_:Array;
        private var pointsProjection:IProjection;
        private var zoomFactor_:Number;
        private var options:PolylineOptions;
        private var baseTolerance_:Number;
        private var clientNextPointIndexAtLevel_:Boolean;
        private var _mc:Sprite;
        private var _latLngBounds:LatLngBounds;
        private var projectedPoints_:Array;
        private var levels_:Array;
        private var wrap_:int;
        private var points_:Array;
        private var worldBounds:Rectangle;
        private var numLevels_:int;
        private var tolerantBoundsByZoom_:Array;

        public function Polyline(param1:Array, param2:PolylineOptions=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            levels_ = null;
            numLevels_ = 0;
            nextHigherPoint_ = [];
            baseTolerance_ = POLYLINE_BASE_TOLERANCE;
            zoomFactor_ = POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL;
            wrap_ = 0;
            clientNextPointIndexAtLevel_ = false;
            tolerantBoundsByZoom_ = [];
            if (param1){
                points_ = DefaultVar.cloneArray(param1);
                createNextPointIndexAtLevel_();
            };
            _latLngBounds = MapUtil.calculateLatLngBounds(points_);
            this.options = PolylineOptions.merge([Polyline.defaultOptions, param2]);
            _mc = Bootstrap.createChildSprite(_foreground);
        }
        public static function fromEncoded(param1:String, param2:Number, param3:String, param4:Number, param5:PolylineOptions=null):Polyline{
            var _loc_6:Polyline;
            var _loc_7:Number = NaN;
            _loc_6 = new Polyline([], param5);
            _loc_6.zoomFactor_ = param2;
            if (_loc_6.zoomFactor_ == 16){
                _loc_6.baseTolerance_ = POLYLINE_BASE_TOLERANCE;
            };
            _loc_7 = param3.length;
            if (_loc_7){
                _loc_6.points_ = PolylineCodec.decodeLine(param1, _loc_7);
                _loc_6.levels_ = PolylineCodec.decodeLevels(param3, _loc_7);
                _loc_6.numLevels_ = param4;
                _loc_6.nextHigherPoint_ = PolylineCodec.indexLevels(_loc_6.levels_, _loc_6.numLevels_);
            } else {
                _loc_6.points_ = [];
                _loc_6.levels_ = [];
                _loc_6.numLevels_ = 0;
                _loc_6.nextHigherPoint_ = [];
            };
            _loc_6._latLngBounds = MapUtil.calculateLatLngBounds(_loc_6.points_);
            return (_loc_6);
        }
        private static function wrapX(param1:Point, param2:Point):Point{
            var _loc_3:Number = NaN;
            _loc_3 = param2.x;
            return (new Point(MapUtil.wrapPeriod(param1.x, (_loc_3 - 128), (_loc_3 + 128), 0x0100), param2.y));
        }
        private static function getOptionStrokeThickness(param1:PolylineOptions):Number{
            if (((((param1) && (param1.strokeStyle))) && (param1.strokeStyle.thickness))){
                return ((param1.strokeStyle.thickness as Number));
            };
            return (1);
        }
        public static function getDefaultOptions():PolylineOptions{
            return (Polyline.defaultOptions);
        }
        private static function wrapLng(param1:LatLng, param2:LatLng):LatLng{
            var _loc_3:Number = NaN;
            _loc_3 = param2.lng();
            return (new LatLng(param1.lat(), MapUtil.wrapPeriod(param1.lng(), (_loc_3 - 180), (_loc_3 + 180), 360), true));
        }
        public static function setDefaultOptions(param1:PolylineOptions):void{
            Polyline.defaultOptions = PolylineOptions.merge([Polyline.defaultOptions, param1]);
        }

        private function getVecIndicesHelper(param1:Array, param2:int, param3:int, param4:int, param5:int, param6:Array):void{
            var _loc_7:int;
            var _loc_8:LatLng;
            var _loc_9:int;
            var _loc_10:LatLng;
            var _loc_11:LatLngBounds;
            _loc_7 = param2;
            _loc_8 = points_[_loc_7];
            _loc_9 = findNextPointIndex_(_loc_7, param4);
            while (_loc_9 <= param3) {
                _loc_10 = points_[_loc_9];
                if ((((param1 == null)) || (param1[param4].containsLatLng(_loc_8)))){
                    if (param4 > param5){
                        getVecIndicesHelper(param1, _loc_7, _loc_9, (param4 - 1), param5, param6);
                    } else {
                        param6.push(_loc_7);
                        param6.push(_loc_9);
                    };
                } else {
                    if (options.geodesic){
                        _loc_11 = Geodesic.geodesicBounds(_loc_8, _loc_10);
                    } else {
                        _loc_11 = new LatLngBounds(_loc_8);
                        _loc_11.extend(_loc_10);
                    };
                    if ((((param1 == null)) || (param1[param4].intersects(_loc_11)))){
                        if (param4 > param5){
                            getVecIndicesHelper(param1, _loc_7, _loc_9, (param4 - 1), param5, param6);
                        } else {
                            param6.push(_loc_7);
                            param6.push(_loc_9);
                        };
                    };
                };
                _loc_8 = _loc_10;
                _loc_7 = _loc_9;
                if (param4){
                    _loc_9 = findNextPointIndex_(_loc_7, param4);
                } else {
                    _loc_9++;
                };
            };
        }
        public function setOptions(param1:PolylineOptions):void{
            options = PolylineOptions.merge([options, param1]);
            redraw();
        }
        public function getVertexCount():Number{
            return (points_.length);
        }
        override public function get interfaceChain():Array{
            return (["IPolyline", "IOverlay"]);
        }
        private function findNextPointIndex_(param1:int, param2:int):int{
            var _loc_3:Array;
            var _loc_4:Array;
            var _loc_5:int;
            _loc_3 = levels_;
            _loc_4 = nextHigherPoint_;
            _loc_5 = (param1 + 1);
            while ((((_loc_5 < _loc_3.length)) && ((_loc_3[_loc_5] < param2)))) {
                _loc_5 = _loc_4[_loc_5];
            };
            return (_loc_5);
        }
        override protected function redraw():void{
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Array;
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            if ((((map == null)) || (!(visible)))){
                return;
            };
            _mc.graphics.clear();
            Render.setStroke(_mc.graphics, options.strokeStyle);
            _loc_1 = new Point(0, 0);
            _loc_2 = camera.zoomScale;
            _loc_3 = getWorldClipPoly(((isSingleWorld) || (options.geodesic)));
            if (!is3DView()){
                _loc_4 = camera.viewportToWorld(new Point(0, 0));
                _loc_1.x = -(_loc_4.x);
                _loc_1.y = -(_loc_4.y);
            };
            if (((isSingleWorld) || (options.geodesic))){
                _loc_5 = 0;
                _loc_6 = (camera.getWorldCenter().x - 128);
                _loc_7 = Math.floor(((worldBounds.left - _loc_6) / 0x0100));
                _loc_8 = Math.floor(((worldBounds.right - _loc_6) / 0x0100));
                _loc_9 = _loc_7;
                while (_loc_9 <= _loc_8) {
                    _loc_10 = (_loc_9 - _loc_5);
                    _loc_5 = _loc_9;
                    _loc_1.offset((-256 * _loc_10), 0);
                    offsetPoly(_loc_3, (0x0100 * _loc_10), 0);
                    drawLineWithinClipPoly(_loc_3, _loc_1, _loc_2);
                    _loc_9 = (_loc_9 + 1);
                };
            } else {
                _loc_11 = getWorldWrapOffset(Util.rectCenter(worldBounds));
                _loc_1.offset(_loc_11, 0);
                offsetPoly(_loc_3, -(_loc_11), 0);
                drawLineWithinClipPoly(_loc_3, _loc_1, _loc_2);
            };
        }
        public function getVertex(param1:Number):LatLng{
            return (points_[param1].clone());
        }
        private function updateBoundsArray(param1:IProjection, param2:LatLngBounds, param3:int):void{
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:int;
            var _loc_7:Number = NaN;
            var _loc_8:Point;
            var _loc_9:Point;
            var _loc_10:LatLng;
            var _loc_11:LatLng;
            if ((((param3 == numLevelsBoundsArray)) && (param2.equals(boundsBoundsArray)))){
                return;
            };
            numLevelsBoundsArray = param3;
            boundsBoundsArray = param2.clone();
            llBoundsArray = [];
            _loc_4 = param1.fromLatLngToPixel(param2.getSouthWest(), POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL);
            _loc_5 = param1.fromLatLngToPixel(param2.getNorthEast(), POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL);
            _loc_6 = 0;
            while (_loc_6 < param3) {
                _loc_7 = (baseTolerance_ * Math.pow(zoomFactor_, _loc_6));
                _loc_8 = new Point((_loc_4.x - _loc_7), (_loc_4.y + _loc_7));
                _loc_9 = new Point((_loc_5.x + _loc_7), (_loc_5.y - _loc_7));
                _loc_10 = param1.fromPixelToLatLng(_loc_8, POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL, true);
                _loc_11 = param1.fromPixelToLatLng(_loc_9, POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL, true);
                llBoundsArray.push(new LatLngBounds(_loc_10, _loc_11));
                _loc_6++;
            };
        }
        private function createNextPointIndexAtLevel_():void{
            var _loc_1:int;
            var _loc_2:int;
            _loc_2 = points_.length;
            if (_loc_2){
                clientNextPointIndexAtLevel_ = true;
                levels_ = new Array(_loc_2);
                _loc_1 = 0;
                while (_loc_1 < _loc_2) {
                    levels_[_loc_1] = 0;
                    _loc_1++;
                };
                numLevels_ = 1;
                nextHigherPoint_ = PolylineCodec.indexLevels(levels_, numLevels_);
            } else {
                levels_ = [];
                numLevels_ = 0;
                nextHigherPoint_ = [];
            };
            if ((((_loc_2 > 0)) && (points_[0].equals(points_[(_loc_2 - 1)])))){
                wrap_ = wraplng_(points_);
            };
        }
        private function wraplng_(param1:Array):int{
            var _loc_2:Number = NaN;
            var _loc_3:int;
            var _loc_4:int;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_3 < (param1.length - 1)) {
                _loc_2 = (_loc_2 + MapUtil.wrap((param1[(_loc_3 + 1)].lng() - param1[_loc_3].lng()), -180, 180));
                _loc_3++;
            };
            _loc_4 = Math.round((_loc_2 / 360));
            return (_loc_4);
        }
        private function drawLineWithinClipPoly(param1:Array, param2:Point, param3:Number):void{
            var _loc_4:Array;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Point;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            _loc_4 = getVecIndices(getPaneLatLngBounds(), getDrawingTolerance_());
            if (!_loc_4){
                return;
            };
            VectorGraphics.clipLineToPolyIndexed(projectedPoints_, _loc_4, param1);
            _loc_5 = 1E20;
            _loc_6 = 1E20;
            _loc_7 = (0.2 / param3);
            _loc_8 = new Point();
            _loc_9 = 0;
            while (_loc_9 < _loc_4.length) {
                _loc_10 = _loc_4[_loc_9];
                if (_loc_10 < 0){
                } else {
                    worldPointToPane(param2, param3, projectedPoints_[_loc_10], _loc_8);
                    _loc_11 = _loc_8.x;
                    _loc_12 = _loc_8.y;
                    _loc_13 = (_loc_11 - _loc_5);
                    _loc_14 = (_loc_12 - _loc_6);
                    if ((((((((_loc_13 > 0.2)) || ((_loc_13 < -0.2)))) || ((_loc_14 > 0.2)))) || ((_loc_14 < -0.2)))){
                        _mc.graphics.moveTo(_loc_11, _loc_12);
                        _loc_5 = _loc_11;
                        _loc_6 = _loc_12;
                    };
                    worldPointToPane(param2, param3, projectedPoints_[_loc_4[(_loc_9 + 1)]], _loc_8);
                    _loc_11 = _loc_8.x;
                    _loc_12 = _loc_8.y;
                    _loc_13 = (_loc_11 - _loc_5);
                    _loc_14 = (_loc_12 - _loc_6);
                    if ((((((((_loc_13 > 0.2)) || ((_loc_13 < -0.2)))) || ((_loc_14 > 0.2)))) || ((_loc_14 < -0.2)))){
                        _mc.graphics.lineTo(_loc_11, _loc_12);
                        _loc_5 = _loc_11;
                        _loc_6 = _loc_12;
                    };
                };
                _loc_9 = (_loc_9 + 2);
            };
            VectorGraphics.removeAllButNElements(projectedPoints_, points_.length);
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            projectedPoints_ = projectPoints(points_);
            pointsProjection = getProjection();
            redraw();
        }
        public function getLatLngBounds():LatLngBounds{
            return (_latLngBounds);
        }
        private function getPaneLatLngBounds():LatLngBounds{
            var _loc_1:LatLng;
            var _loc_2:LatLng;
            var _loc_3:LatLng;
            var _loc_4:LatLng;
            var _loc_5:LatLngBounds;
            if (is3DView()){
                return (null);
            };
            _loc_1 = camera.viewportToLatLng(new Point(0, 0));
            _loc_2 = camera.viewportToLatLng(map.getSize());
            _loc_3 = new LatLng(Math.min(_loc_1.lat(), _loc_2.lat()), Math.min(_loc_1.lng(), _loc_2.lng()), true);
            _loc_4 = new LatLng(Math.max(_loc_1.lat(), _loc_2.lat()), Math.max(_loc_1.lng(), _loc_2.lng()), true);
            _loc_5 = new LatLngBounds(_loc_3, _loc_4);
            return (_loc_5);
        }
        public function createSimplifiedPolyline(param1:int):Polyline{
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:Array;
            var _loc_7:int;
            _loc_2 = 0;
            _loc_3 = 3;
            if (getVertexCount() < param1){
                return (clone());
            };
            _loc_4 = [];
            _loc_5 = (_loc_2 + 1);
            while (_loc_5 <= _loc_3) {
                _loc_6 = getVecIndices(null, _loc_5);
                _loc_7 = ((_loc_6.length / 2) + 1);
                if (_loc_7 < param1){
                    _loc_5 = 0;
                    while (_loc_5 < _loc_6.length) {
                        _loc_4.push(points_[_loc_6[_loc_5]]);
                        _loc_5 = (_loc_5 + 2);
                    };
                    _loc_4.push(points_[_loc_6[(_loc_6.length - 1)]]);
                    return (new Polyline(_loc_4));
                };
                _loc_5++;
            };
            return (null);
        }
        public function clone():Polyline{
            var _loc_1:Polyline;
            _loc_1 = new Polyline(null);
            _loc_1.levels_ = this.levels_;
            _loc_1.numLevels_ = this.numLevels_;
            _loc_1.nextHigherPoint_ = this.nextHigherPoint_;
            _loc_1.baseTolerance_ = this.baseTolerance_;
            _loc_1.zoomFactor_ = this.zoomFactor_;
            _loc_1.wrap_ = this.wrap_;
            _loc_1.clientNextPointIndexAtLevel_ = this.clientNextPointIndexAtLevel_;
            _loc_1.tolerantBoundsByZoom_ = this.tolerantBoundsByZoom_;
            _loc_1.points_ = this.points_.slice();
            return (_loc_1);
        }
        private function getRoundedMapZoom():Number{
            return (Math.round(map.getZoom()));
        }
        public function getOptions():PolylineOptions{
            return (options);
        }
        private function getVecIndices(param1:LatLngBounds, param2:int):Array{
            var vecIndices:* = null;
            var proj:* = null;
            var zoom:* = NaN;
            var projector:* = null;
            var origLength:* = 0;
            var tolerance:* = NaN;
            var previous:* = null;
            var i:* = 0;
            var from:* = null;
            var to:* = null;
            var geodesicSegment:* = null;
            var baseLength:* = 0;
            var segmentLength:* = 0;
            var q:* = 0;
            var j:* = 0;
            var param1:* = param1;
            var param2:* = param2;
            var llBounds:* = param1;
            var detailLevel:* = param2;
            proj = getProjection();
            if (llBounds){
                updateBoundsArray(proj, llBounds, numLevels_);
            };
            getVecIndicesHelper(llBoundsArray, 0, (points_.length - 1), (numLevels_ - 1), detailLevel, vecIndices);
            if (options.geodesic){
                zoom = getRoundedMapZoom();
                projector = function (param1:LatLng):Point{
                    return (proj.fromLatLngToPixel(param1, 0));
                };
                origLength = vecIndices.length;
                tolerance = (Math.max(1, (getOptionStrokeThickness(options) * 0.33)) / camera.zoomScale);
                previous = points_[vecIndices[0]];
                while (i < origLength) {
                    from = wrapLng(points_[vecIndices[i]], previous);
                    to = wrapLng(points_[vecIndices[(i + 1)]], from);
                    previous = to;
                    geodesicSegment = Geodesic.arcToGeodesic(from, to, projector, tolerance, llBounds);
                    vecIndices[i] = -1;
                    baseLength = projectedPoints_.length;
                    segmentLength = geodesicSegment.length;
                    while (q < segmentLength) {
                        projectedPoints_.push(geodesicSegment[q]);
                        q = (q + 1);
                    };
                    while (j < (segmentLength - 1)) {
                        vecIndices.push((baseLength + j));
                        vecIndices.push(((baseLength + j) + 1));
                        j = (j + 1);
                    };
                    i = (i + 2);
                };
            };
            return (vecIndices);
        }
        private function projectPoints(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:int;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Point;
            _loc_2 = param1.length;
            _loc_3 = new Array(_loc_2);
            _loc_4 = int.MAX_VALUE;
            _loc_5 = int.MIN_VALUE;
            _loc_6 = int.MAX_VALUE;
            _loc_7 = int.MIN_VALUE;
            _loc_8 = 0;
            while (_loc_8 < _loc_2) {
                _loc_9 = super.latLngToWorld(param1[_loc_8]);
                _loc_3[_loc_8] = _loc_9;
                if (_loc_9.x < _loc_4){
                    _loc_4 = _loc_9.x;
                };
                if (_loc_9.x > _loc_5){
                    _loc_5 = _loc_9.x;
                };
                if (_loc_9.y < _loc_6){
                    _loc_6 = _loc_9.y;
                };
                if (_loc_9.y > _loc_7){
                    _loc_7 = _loc_9.y;
                };
                _loc_8++;
            };
            if (options.geodesic){
                if (_loc_2 < 2){
                    worldBounds = null;
                } else {
                    _loc_10 = _loc_3[0];
                    worldBounds = new Rectangle(_loc_10.x, _loc_10.y);
                    _loc_8 = 1;
                    while (_loc_8 < _loc_2) {
                        _loc_11 = wrapX(_loc_3[_loc_8], _loc_10);
                        Util.rectangleExtend(worldBounds, _loc_11);
                        _loc_10 = _loc_11;
                        _loc_8++;
                    };
                };
            } else {
                worldBounds = new Rectangle(_loc_4, _loc_6, (_loc_5 - _loc_4), (_loc_7 - _loc_6));
            };
            return (_loc_3);
        }
        override public function positionOverlay(param1:Boolean):void{
            var _loc_2:IProjection;
            _loc_2 = getProjection();
            if (_loc_2 != pointsProjection){
                projectedPoints_ = projectPoints(points_);
                pointsProjection = _loc_2;
            };
            redraw();
        }
        private function getDrawingTolerance_():Number{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:int;
            if (clientNextPointIndexAtLevel_){
                return (0);
            };
            _loc_1 = (POLYLINE_BASE_TOLERANCE_ZOOM_LEVEL - getRoundedMapZoom());
            _loc_2 = (baseTolerance_ * Math.pow(camera.base, -(_loc_1)));
            _loc_3 = 0;
            do  {
                _loc_3++;
                _loc_2 = (_loc_2 * zoomFactor_);
            } while ((((_loc_3 < numLevels_)) && ((_loc_2 <= POLYLINE_DRAWING_TOLERANCE))));
            return ((_loc_3 - 1));
        }
        public function getLength(param1:Number=6378137):Number{
            var _loc_2:Number = NaN;
            var _loc_3:int;
            var _loc_4:int;
            _loc_2 = 0;
            _loc_3 = 0;
            _loc_4 = points_.length;
            while (_loc_3 < (_loc_4 - 1)) {
                _loc_2 = (_loc_2 + points_[_loc_3].distanceFrom(points_[(_loc_3 + 1)], param1));
                _loc_3++;
            };
            return (_loc_2);
        }

    }
}//package com.mapplus.maps.overlays 
