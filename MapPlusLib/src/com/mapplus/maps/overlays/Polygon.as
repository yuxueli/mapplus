//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class Polygon extends Overlay implements IPolygon {

        private static const DEFAULT_FILL_COLOR:Number = 22015;
        private static const INVALID_VERTEX_INDEX:String = "Invalid polyline vertex";
        private static const DEFAULT_STROKE_COLOR:Number = 0xFF;
        private static const INVALID_POLYLINE_INDEX:String = "Invalid polyline index";

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
        private var _mc:Sprite;
        private var _latLngBounds:LatLngBounds;
        private var _linesProjected:Array;
        private var pointsProjection:IProjection;
        private var options:PolygonOptions;
        private var worldBounds:Rectangle;

        public function Polygon(param1:Array, param2:PolygonOptions=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            if (param1){
                this._lines = [param1.slice()];
                ensureClosed(this._lines[0]);
                this._latLngBounds = calculateLatLngBounds(this._lines);
            } else {
                this._lines = [];
            };
            this._mc = Bootstrap.createChildSprite(_foreground);
            this.options = PolygonOptions.merge([Polygon.defaultOptions, param2]);
        }
        public static function calculateLatLngBounds(param1:Array):LatLngBounds{
            var _loc_2:LatLngBounds;
            var _loc_3:Array;
            var _loc_4:LatLngBounds;
            _loc_2 = new LatLngBounds();
            for each (_loc_3 in param1) {
                _loc_4 = MapUtil.calculateLatLngBounds(_loc_3);
                if (!(_loc_4)){
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
            if (!(_loc_2)){
                return;
            };
            if (!(param1[0].equals(param1[(_loc_2 - 1)]))){
                param1.push(param1[0].clone());
            };
        }
        public static function getDefaultOptions():PolygonOptions{
            return (Polygon.defaultOptions);
        }
        public static function setDefaultOptions(param1:PolygonOptions):void{
            Polygon.defaultOptions = PolygonOptions.merge([Polygon.defaultOptions, param1]);
        }

        private function getDrawingTolerance_():Number{
            return (0);
        }
        public function getInnerVertexCount(param1:int):int{
            if ((((param1 < 0)) || (((param1 + 1) >= this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            return (this._lines[(param1 + 1)].length);
        }
        private function onIconMouseOver(event:MouseEvent):void{
            var _loc_2:String;
            _loc_2 = this.getTooltip();
            if (((_loc_2) && ((_loc_2.length > 0)))){
                map.displayHint(_loc_2);
            };
        }
        override public function get interfaceChain():Array{
            return (["IPolygon", "IOverlay"]);
        }
        private function projectVertices():void{
            var _loc_1:int;
            this._linesProjected = new Array(this._lines.length);
            _loc_1 = 0;
            while (_loc_1 < this._lines.length) {
                this._linesProjected[_loc_1] = this.projectPoints(this._lines[_loc_1]);
                _loc_1++;
            };
        }
        override protected function onAddedToPane():void{
            var _loc_1:IMouse;
            super.onAddedToPane();
            this.projectVertices();
            this.pointsProjection = getProjection();
            this.worldBounds = this.getWorldBounds();
            _loc_1 = MouseHandler.instance();
            _loc_1.addListener(this._mc, MouseEvent.ROLL_OVER, this.onIconMouseOver);
            _loc_1.addListener(this._mc, MouseEvent.ROLL_OUT, this.onIconMouseOut);
            this.redraw();
        }
        public function setPolyline(param1:int, param2:Array):void{
            if ((((param1 < 0)) || ((param1 > this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            this.setPolylineVertices(param1, param2);
        }
        private function setPolylineVertices(param1:int, param2:Array):void{
            var _loc_3:int;
            _loc_3 = ((param1 == this._lines.length)) ? 0 : 1;
            this._lines.splice(param1, _loc_3, param2);
            ensureClosed(this._lines[param1]);
            if (this._linesProjected){
                this._linesProjected.splice(param1, _loc_3, null);
            };
            this._latLngBounds = calculateLatLngBounds(this._lines);
            if (pane){
                if (this._linesProjected){
                    this._linesProjected[param1] = this.projectPoints(this._lines[param1]);
                };
                this.worldBounds = this.getWorldBounds();
                this.redraw();
            };
        }
        public function setPolylineFromEncoded(param1:int, param2:EncodedPolylineData):void{
            var _loc_3:Array;
            if ((((param1 < 0)) || ((param1 > this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            _loc_3 = getPolylineVertices(Polyline.fromEncoded(param2.points, param2.zoomFactor, param2.levels, param2.numLevels));
            this.setPolylineVertices(param1, _loc_3);
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
        public function getInnerVertex(param1:int, param2:int):LatLng{
            if ((((param1 < 0)) || (((param1 + 1) >= this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            if ((((param2 < 0)) || ((param2 >= this._lines[(param1 + 1)].length)))){
                throw (new ArgumentError(INVALID_VERTEX_INDEX));
            };
            return (this._lines[(param1 + 1)][param2]);
        }
        public function getOptions():PolygonOptions{
            return (this.options);
        }
        public function getInnerPolylineCount():int{
            return (Math.max((this._lines.length - 1), 0));
        }
        private function onIconMouseOut(event:MouseEvent):void{
            map.displayHint("");
        }
        public function getPolylineCount():int{
            return (this._lines.length);
        }
        public function getVertexCount(param1:int):int{
            if ((((param1 < 0)) || ((param1 >= this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            return (this._lines[param1].length);
        }
        public function removePolyline(param1:int):void{
            if ((((param1 < 0)) || ((param1 >= this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            this._lines.splice(param1, 1);
            this._linesProjected.splice(param1, 1);
            this._latLngBounds = calculateLatLngBounds(this._lines);
            if (pane){
                this.worldBounds = this.getWorldBounds();
                this.redraw();
            };
        }
        public function getVertex(param1:int, param2:int):LatLng{
            if ((((param1 < 0)) || ((param1 >= this._lines.length)))){
                throw (new ArgumentError(INVALID_POLYLINE_INDEX));
            };
            if ((((param2 < 0)) || ((param2 >= this._lines[param1].length)))){
                throw (new ArgumentError(INVALID_VERTEX_INDEX));
            };
            return (this._lines[param1][param2]);
        }
        public function getWorldBounds():Rectangle{
            var _loc_1:Point;
            var _loc_2:Point;
            if (((!(this._latLngBounds)) || (this._latLngBounds.isEmpty()))){
                return (new Rectangle());
            };
            _loc_1 = camera.latLngToWorld(new LatLng(this._latLngBounds.getNorth(), this._latLngBounds.getWest(), true));
            _loc_2 = camera.latLngToWorld(new LatLng(this._latLngBounds.getSouth(), this._latLngBounds.getEast(), true));
            return (Util.rectFromExtents(_loc_1.x, _loc_1.y, _loc_2.x, _loc_2.y));
        }
        public function getFakeVecIndices(param1:int):Array{
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            _loc_2 = this._lines[param1].length;
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
        private function drawPolygonWithinClipPoly(param1:Array, param2:Point, param3:Number):void{
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:int;
            Render.setStroke(this._mc.graphics, this.options.strokeStyle);
            Render.beginFill(this._mc.graphics, this.options.fillStyle);
            _loc_6 = 0;
            while (_loc_6 < this._lines.length) {
                _loc_4 = this.getFakeVecIndices(_loc_6);
                VectorGraphics.clipToPolyIndexed(this._linesProjected[_loc_6], _loc_4, param1);
                this.drawVecIndices(this._linesProjected[_loc_6], _loc_4, param2, param3);
                VectorGraphics.removeAllButNElements(this._linesProjected[_loc_6], this._lines[_loc_6].length);
                _loc_6++;
            };
            this._mc.graphics.endFill();
        }
        public function getOuterVertexCount():int{
            return (((this._lines.length > 0)) ? this._lines[0].length : 0);
        }
        public function getOuterVertex(param1:int):LatLng{
            if ((((((this._lines.length == 0)) || ((param1 < 0)))) || ((param1 >= this._lines[0].length)))){
                return (null);
            };
            return (this._lines[0][param1]);
        }
        override protected function onRemovedFromPane():void{
            var _loc_1:IMouse;
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(this._mc, MouseEvent.ROLL_OVER, this.onIconMouseOver);
            _loc_1.removeListener(this._mc, MouseEvent.ROLL_OUT, this.onIconMouseOut);
            super.onRemovedFromPane();
        }
        private function getTooltip():String{
            return (this.options.tooltip);
        }
        public function setOptions(param1:PolygonOptions):void{
            this.options = PolygonOptions.merge([this.options, param1]);
            this.redraw();
        }
        public function getLatLngBounds():LatLngBounds{
            return ((this._latLngBounds.isEmpty()) ? null : this._latLngBounds);
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
            this._mc.graphics.moveTo(_loc_6.x, _loc_6.y);
            _loc_5 = (_loc_5 + 2);
            while (_loc_5 < param2.length) {
                _loc_7 = param2[_loc_5];
                _loc_8 = param2[(_loc_5 + 1)];
                if ((((_loc_7 < 0)) || ((_loc_8 < 0)))){
                } else {
                    worldPointToPane(param3, param4, param1[_loc_7], _loc_6);
                    this._mc.graphics.lineTo(_loc_6.x, _loc_6.y);
                    worldPointToPane(param3, param4, param1[_loc_8], _loc_6);
                    this._mc.graphics.lineTo(_loc_6.x, _loc_6.y);
                };
                _loc_5 = (_loc_5 + 2);
            };
        }
        override public function positionOverlay(param1:Boolean):void{
            var _loc_2:IProjection;
            _loc_2 = getProjection();
            if (_loc_2 != this.pointsProjection){
                this.projectVertices();
                this.worldBounds = this.getWorldBounds();
                this.pointsProjection = _loc_2;
            };
            this.redraw();
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
            this._mc.graphics.clear();
            _loc_1 = new Point(0, 0);
            _loc_2 = camera.zoomScale;
            _loc_3 = getWorldClipPoly(isSingleWorld);
            if (!(is3DView())){
                _loc_4 = camera.viewportToWorld(new Point(0, 0));
                _loc_1.x = -(_loc_4.x);
                _loc_1.y = -(_loc_4.y);
            };
            if (isSingleWorld){
                _loc_5 = 0;
                _loc_6 = (camera.getWorldCenter().x - 128);
                _loc_7 = Math.floor(((this.worldBounds.left - _loc_6) / 0x0100));
                _loc_8 = Math.floor(((this.worldBounds.right - _loc_6) / 0x0100));
                _loc_9 = _loc_7;
                while (_loc_9 <= _loc_8) {
                    _loc_10 = (_loc_9 - _loc_5);
                    _loc_5 = _loc_9;
                    _loc_1.offset((-256 * _loc_10), 0);
                    offsetPoly(_loc_3, (0x0100 * _loc_10), 0);
                    this.drawPolygonWithinClipPoly(_loc_3, _loc_1, _loc_2);
                    _loc_9 = (_loc_9 + 1);
                };
            } else {
                if (this._latLngBounds){
                    _loc_11 = getWorldWrapOffset(Util.rectCenter(this.worldBounds));
                    _loc_1.offset(_loc_11, 0);
                    offsetPoly(_loc_3, -(_loc_11), 0);
                };
                this.drawPolygonWithinClipPoly(_loc_3, _loc_1, _loc_2);
            };
        }

    }
}//package com.mapplus.maps.overlays 
