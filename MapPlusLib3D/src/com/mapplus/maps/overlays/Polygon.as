//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class Polygon extends Overlay implements IPolygon {

        private static const DEFAULT_FILL_COLOR:Number = 22015;
        private static const DEFAULT_STROKE_COLOR:Number = 0xFF;
        private static const INVALID_POLYLINE_INDEX:String = "Invalid polyline index";
        private static const INVALID_VERTEX_INDEX:String = "Invalid polyline vertex";

        private static var defaultOptions:PolygonOptions = new PolygonOptions({
            fillStyle:{
                color:DEFAULT_FILL_COLOR,
                alpha:0.25
            },
            strokeStyle:{
                color:DEFAULT_STROKE_COLOR,
                alpha:0.45,
                thickness:2,
                pixelHinting:false
            }
        });

        private var _lines:Array;
        private var pointsProjection:IProjection;
        private var options:PolygonOptions;
        private var _mc:Sprite;
        private var _latLngBounds:LatLngBounds;
        private var _linesProjected:Array;
        private var worldBounds:Rectangle;

        public function Polygon(param1:Array, param2:PolygonOptions=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            if (param1){
                _lines = [param1.slice()];
                ensureClosed(_lines[0]);
                _latLngBounds = calculateLatLngBounds(_lines);
            } else {
                _lines = [];
            };
            _mc = Bootstrap.createChildSprite(_foreground);
            this.options = PolygonOptions.merge([Polygon.defaultOptions, param2]);
        }
        static function calculateLatLngBounds(param1:Array):LatLngBounds{
            var _loc_2:LatLngBounds;
            var _loc_3:Array;
            var _loc_4:LatLngBounds;
            _loc_2 = new LatLngBounds();
            for each (_loc_3 in param1) {
                _loc_4 = MapUtil.calculateLatLngBounds(_loc_3);
                if (!_loc_4){
                } else {
                    _loc_2.extend(new LatLng(_loc_4.getSouth(), _loc_4.getWest(), true));
                    _loc_2.extend(new LatLng(_loc_4.getNorth(), _loc_4.getEast(), true));
                };
            };
            return (_loc_2);
        }
        public static function fromEncoded(param1:Array, param2:PolygonOptions=null):Polygon{
            var _loc_3:Polygon;
            var _loc_4:Number = NaN;
            var _loc_5:int;
            var _loc_6:EncodedPolylineData;
            var _loc_7:PolylineOptions;
            var _loc_8:Polyline;
            _loc_3 = new Polygon(null, param2);
            _loc_4 = param1.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4) {
                _loc_6 = EncodedPolylineData.fromObject(param1[_loc_5]);
                _loc_7 = PolylineOptions.fromObject(param2);
                _loc_8 = Polyline.fromEncoded(_loc_6.points, _loc_6.zoomFactor, _loc_6.levels, _loc_6.numLevels, _loc_7);
                _loc_3._lines.push(getPolylineVertices(_loc_8));
                _loc_5++;
            };
            _loc_3._latLngBounds = calculateLatLngBounds(_loc_3._lines);
            return (_loc_3);
        }
        public static function setDefaultOptions(param1:PolygonOptions):void{
            Polygon.defaultOptions = PolygonOptions.merge([Polygon.defaultOptions, param1]);
        }
        private static function getPolylineVertices(param1:Polyline):Array{
            var _loc_2:Array;
            var _loc_3:int;
            var _loc_4:int;
            _loc_2 = [];
            _loc_3 = 0;
            _loc_4 = param1.getVertexCount();
            while (_loc_3 < _loc_4) {
                _loc_2[_loc_3] = param1.getVertex(_loc_3);
                _loc_3++;
            };
            return (_loc_2);
        }
        private static function ensureClosed(param1:Array):void{
            var _loc_2:int;
            _loc_2 = param1.length;
            if (!_loc_2){
                return;
            };
            if (!param1[0].equals(param1[(_loc_2 - 1)])){
                param1.push(param1[0].clone());
            };
        }
        public static function getDefaultOptions():PolygonOptions{
            return (Polygon.defaultOptions);
        }

        private function onIconMouseOver(event:MouseEvent):void{
            var _loc_2:String;
            _loc_2 = getTooltip();
            if (((_loc_2) && ((_loc_2.length > 0)))){
                map.displayHint(_loc_2);
            };
        }
        override public function get interfaceChain():Array{
            return (["IPolygon", "IOverlay"]);
        }
        private function onIconMouseOut(event:MouseEvent):void{
            map.displayHint("");
        }
        public function getPolylineCount():int{
            return (_lines.length);
        }
        public function getInnerVertexCount(param1:int):int{
            if ((((param1 < 0)) || (((param1 + 1) >= _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            return (_lines[(param1 + 1)].length);
        }
        public function getVertexCount(param1:int):int{
            if ((((param1 < 0)) || ((param1 >= _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            return (_lines[param1].length);
        }
        public function getVertex(param1:int, param2:int):LatLng{
            if ((((param1 < 0)) || ((param1 >= _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            if ((((param2 < 0)) || ((param2 >= _lines[param1].length)))){
                throw (new ArgumentError(INVALID_VERTEX_INDEX));
            };
            return (_lines[param1][param2]);
        }
        function getFakeVecIndices(param1:int):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            _loc_2 = _lines[param1].length;
            if (_loc_2 < 2){
                return ([]);
            };
            _loc_3 = new Array(((_loc_2 - 1) * 2));
            _loc_4 = 0;
            while (_loc_4 < (_loc_2 - 1)) {
                _loc_3[(_loc_4 * 2)] = _loc_4;
                _loc_3[((_loc_4 * 2) + 1)] = (_loc_4 + 1);
                _loc_4++;
            };
            return (_loc_3);
        }
        function getWorldBounds():Rectangle{
            var _loc_1:Point;
            var _loc_2:Point;
            if (((!(_latLngBounds)) || (_latLngBounds.isEmpty()))){
                return (new Rectangle());
            };
            _loc_1 = camera.latLngToWorld(new LatLng(_latLngBounds.getNorth(), _latLngBounds.getWest(), true));
            _loc_2 = camera.latLngToWorld(new LatLng(_latLngBounds.getSouth(), _latLngBounds.getEast(), true));
            return (Util.rectFromExtents(_loc_1.x, _loc_1.y, _loc_2.x, _loc_2.y));
        }
        private function projectVertices():void{
            var _loc_1:int;
            _linesProjected = new Array(_lines.length);
            _loc_1 = 0;
            while (_loc_1 < _lines.length) {
                _linesProjected[_loc_1] = projectPoints(_lines[_loc_1]);
                _loc_1++;
            };
        }
        private function drawPolygonWithinClipPoly(param1:Array, param2:Point, param3:Number):void{
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:int;
            Render.setStroke(_mc.graphics, options.strokeStyle);
            Render.beginFill(_mc.graphics, options.fillStyle);
            _loc_6 = 0;
            while (_loc_6 < _lines.length) {
                _loc_4 = getFakeVecIndices(_loc_6);
                VectorGraphics.clipToPolyIndexed(_linesProjected[_loc_6], _loc_4, param1);
                drawVecIndices(_linesProjected[_loc_6], _loc_4, param2, param3);
                VectorGraphics.removeAllButNElements(_linesProjected[_loc_6], _lines[_loc_6].length);
                _loc_6++;
            };
            _mc.graphics.endFill();
        }
        override protected function onAddedToPane():void{
            var _loc_1:IMouse;
            super.onAddedToPane();
            projectVertices();
            pointsProjection = getProjection();
            worldBounds = getWorldBounds();
            _loc_1 = MouseHandler.instance();
            _loc_1.addListener(_mc, MouseEvent.ROLL_OVER, onIconMouseOver);
            _loc_1.addListener(_mc, MouseEvent.ROLL_OUT, onIconMouseOut);
            redraw();
        }
        public function getOuterVertexCount():int{
            return (((_lines.length > 0)) ? _lines[0].length : 0);
        }
        public function setPolyline(param1:int, param2:Array):void{
            if ((((param1 < 0)) || ((param1 > _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            setPolylineVertices(param1, param2);
        }
        public function getOuterVertex(param1:int):LatLng{
            if ((((((_lines.length == 0)) || ((param1 < 0)))) || ((param1 >= _lines[0].length)))){
                return (null);
            };
            return (_lines[0][param1]);
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:IMouse;
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(_mc, MouseEvent.ROLL_OVER, onIconMouseOver);
            _loc_1.removeListener(_mc, MouseEvent.ROLL_OUT, onIconMouseOut);
            super.onRemovedFromPane();
        }
        private function getTooltip():String{
            return (options.tooltip);
        }
        private function drawVecIndices(param1:Array, param2:Array, param3:Point, param4:Number):void{
            var _loc_5:int;
            var _loc_6:Point;
            var _loc_7:int;
            var _loc_8:int;
            _loc_5 = 0;
            while (_loc_5 < param2.length) {
                if (param2[_loc_5] >= 0){
                    break;
                };
                _loc_5 = (_loc_5 + 2);
            };
            if (_loc_5 >= param2.length){
                return;
            };
            _loc_6 = new Point();
            worldPointToPane(param3, param4, param1[param2[_loc_5]], _loc_6);
            _mc.graphics.moveTo(_loc_6.x, _loc_6.y);
            _loc_5 = (_loc_5 + 2);
            while (_loc_5 < param2.length) {
                _loc_7 = param2[_loc_5];
                _loc_8 = param2[(_loc_5 + 1)];
                if ((((_loc_7 < 0)) || ((_loc_8 < 0)))){
                } else {
                    worldPointToPane(param3, param4, param1[_loc_7], _loc_6);
                    _mc.graphics.lineTo(_loc_6.x, _loc_6.y);
                    worldPointToPane(param3, param4, param1[_loc_8], _loc_6);
                    _mc.graphics.lineTo(_loc_6.x, _loc_6.y);
                };
                _loc_5 = (_loc_5 + 2);
            };
        }
        private function setPolylineVertices(param1:int, param2:Array):void{
            var _loc_3:int;
            _loc_3 = ((param1 == _lines.length)) ? 0 : 1;
            _lines.splice(param1, _loc_3, param2);
            ensureClosed(_lines[param1]);
            if (_linesProjected){
                _linesProjected.splice(param1, _loc_3, null);
            };
            _latLngBounds = calculateLatLngBounds(_lines);
            if (pane){
                if (_linesProjected){
                    _linesProjected[param1] = projectPoints(_lines[param1]);
                };
                worldBounds = getWorldBounds();
                redraw();
            };
        }
        private function projectPoints(param1:Array):Array{
            var _loc_2:Array;
            var _loc_3:int;
            _loc_2 = new Array(param1.length);
            _loc_3 = 0;
            while (_loc_3 < param1.length) {
                _loc_2[_loc_3] = latLngToWorld(param1[_loc_3]);
                _loc_3++;
            };
            return (_loc_2);
        }
        public function getLatLngBounds():LatLngBounds{
            return ((_latLngBounds.isEmpty()) ? null : _latLngBounds);
        }
        public function setPolylineFromEncoded(param1:int, param2:EncodedPolylineData):void{
            var _loc_3:Array;
            if ((((param1 < 0)) || ((param1 > _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            _loc_3 = getPolylineVertices(Polyline.fromEncoded(param2.points, param2.zoomFactor, param2.levels, param2.numLevels));
            setPolylineVertices(param1, _loc_3);
        }
        public function setOptions(param1:PolygonOptions):void{
            options = PolygonOptions.merge([options, param1]);
            redraw();
        }
        public function getOptions():PolygonOptions{
            return (options);
        }
        public function removePolyline(param1:int):void{
            if ((((param1 < 0)) || ((param1 >= _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            _lines.splice(param1, 1);
            _linesProjected.splice(param1, 1);
            _latLngBounds = calculateLatLngBounds(_lines);
            if (pane){
                worldBounds = getWorldBounds();
                redraw();
            };
        }
        override public function positionOverlay(param1:Boolean):void{
            var _loc_2:IProjection;
            _loc_2 = getProjection();
            if (_loc_2 != pointsProjection){
                projectVertices();
                worldBounds = getWorldBounds();
                pointsProjection = _loc_2;
            };
            redraw();
        }
        public function getInnerVertex(param1:int, param2:int):LatLng{
            if ((((param1 < 0)) || (((param1 + 1) >= _lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            if ((((param2 < 0)) || ((param2 >= _lines[(param1 + 1)].length)))){
                throw (new ArgumentError(INVALID_VERTEX_INDEX));
            };
            return (_lines[(param1 + 1)][param2]);
        }
        public function getInnerPolylineCount():int{
            return (Math.max((_lines.length - 1), 0));
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
            if (((!(camera)) || (!(visible)))){
                return;
            };
            _mc.graphics.clear();
            _loc_1 = new Point(0, 0);
            _loc_2 = camera.zoomScale;
            _loc_3 = getWorldClipPoly(isSingleWorld);
            if (!is3DView()){
                _loc_4 = camera.viewportToWorld(new Point(0, 0));
                _loc_1.x = -(_loc_4.x);
                _loc_1.y = -(_loc_4.y);
            };
            if (isSingleWorld){
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
                    drawPolygonWithinClipPoly(_loc_3, _loc_1, _loc_2);
                    _loc_9 = (_loc_9 + 1);
                };
            } else {
                if (_latLngBounds){
                    _loc_11 = getWorldWrapOffset(Util.rectCenter(worldBounds));
                    _loc_1.offset(_loc_11, 0);
                    offsetPoly(_loc_3, -(_loc_11), 0);
                };
                drawPolygonWithinClipPoly(_loc_3, _loc_1, _loc_2);
            };
        }
        private function getDrawingTolerance_():Number{
            return (0);
        }

    }
}//package com.mapplus.maps.overlays 
