//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;
    import flash.filters.*;

    public class Render {

        private static const POINT_COUNT_FACTOR:Number = 0.0138889;
        private static const DEGREES_TO_RADIANS_FACTOR:Number = 0.0174533;
        public static const EMPTY_STROKE:StrokeStyle = new StrokeStyle({
            thickness:1,
            color:0,
            alpha:0,
            pixelHinting:false
        });
        public static const EMPTY_FILL:FillStyle = new FillStyle({
            alpha:0,
            color:0
        });

        public function Render(){
            super();
        }
        public static function setColor(param1:Sprite, param2:Number):void{
            var _loc_3:ColorTransform;
            var _loc_4:Transform;
            _loc_3 = new ColorTransform();
            _loc_3.color = param2;
            _loc_4 = new Transform(param1);
            _loc_4.colorTransform = _loc_3;
        }
        public static function endFill(param1:Graphics):void{
            param1.endFill();
        }
        public static function drawRect(param1:Sprite, param2:Rectangle, param3:Number=NaN, param4:Number=1, param5:Number=NaN, param6:Number=0):void{
            if (isNaN(param3)){
                param3 = Color.BLACK;
            };
            if (isNaN(param5)){
                param5 = Color.BLACK;
            };
            param1.graphics.lineStyle(1, param5, param6, false, "normal", "square", "miter");
            param1.graphics.beginFill(param3, param4);
            param1.graphics.drawRect(param2.left, param2.top, param2.width, param2.height);
            param1.graphics.endFill();
        }
        public static function setStroke(param1:Graphics, param2:StrokeStyle):void{
            param1.lineStyle(Number(param2.thickness), Number(param2.color), Number(param2.alpha), Boolean(param2.pixelHinting));
        }
        public static function beginFill(param1:Graphics, param2:FillStyle):void{
            var _loc_3:GradientStyle;
            _loc_3 = param2.gradient;
            if (_loc_3 != null){
                param1.beginGradientFill(_loc_3.type, _loc_3.colors, _loc_3.alphas, _loc_3.ratios, _loc_3.matrix, _loc_3.spreadMethod, _loc_3.interpolationMethod, _loc_3.focalPointRatio);
            } else {
                param1.beginFill(Number(param2.color), Number(param2.alpha));
            };
        }
        private static function getEllipsePoint(param1:Point, param2:Point, param3:Number):Point{
            var _loc_4:Number = NaN;
            _loc_4 = (param3 * DEGREES_TO_RADIANS_FACTOR);
            return (new Point((param1.x + (param2.x * Math.cos(_loc_4))), (param1.y + (param2.y * Math.sin(_loc_4)))));
        }
        public static function drawEllipse(param1:Graphics, param2:Point, param3:Point, param4:StrokeStyle=null, param5:FillStyle=null, param6:Number=0, param7:Number=360, param8:Boolean=true):void{
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:Point;
            var _loc_13:Number = NaN;
            if (param4 != null){
                setStroke(param1, param4);
            };
            if (param5 != null){
                beginFill(param1, param5);
            };
            _loc_9 = Math.floor(((POINT_COUNT_FACTOR * Math.max(param3.x, param3.y)) * Math.abs((param7 - param6))));
            _loc_10 = 0;
            if (param8){
                _loc_12 = getEllipsePoint(param2, param3, param6);
                param1.moveTo(_loc_12.x, _loc_12.y);
                _loc_10 = 1;
            };
            _loc_11 = _loc_10;
            while (_loc_11 < _loc_9) {
                _loc_13 = (param6 + ((_loc_11 * (param7 - param6)) / _loc_9));
                _loc_12 = getEllipsePoint(param2, param3, _loc_13);
                param1.lineTo(_loc_12.x, _loc_12.y);
                _loc_11++;
            };
            _loc_12 = getEllipsePoint(param2, param3, param7);
            param1.lineTo(_loc_12.x, _loc_12.y);
            if (param5 != null){
                endFill(param1);
            };
        }
        public static function drawBitmapTriangle(param1:Graphics, param2:BitmapData, param3:Matrix, param4:Point, param5:Point, param6:Point):void{
            param1.lineStyle();
            param1.beginBitmapFill(param2, param3, false, true);
            param1.moveTo(param4.x, param4.y);
            param1.lineTo(param5.x, param5.y);
            param1.lineTo(param6.x, param6.y);
            param1.endFill();
        }
        public static function createBevelFilters(param1:BevelStyle):Array{
            var _loc_2:BevelFilter;
            if (param1 == null){
                return ([]);
            };
            switch (Number(param1.bevelStyle)){
                case BevelStyle.BEVEL_NONE:
                    return ([]);
                case BevelStyle.BEVEL_LOWERED:
                case BevelStyle.BEVEL_RAISED:
                    _loc_2 = new BevelFilter();
                    _loc_2.highlightAlpha = Number(param1.bevelAlpha);
                    _loc_2.shadowAlpha = Number(param1.bevelAlpha);
                    _loc_2.distance = Number(param1.bevelThickness);
                    _loc_2.blurX = Number(param1.bevelThickness);
                    _loc_2.blurY = Number(param1.bevelThickness);
                    _loc_2.quality = BitmapFilterQuality.HIGH;
                    if (param1.bevelStyle == BevelStyle.BEVEL_RAISED){
                        _loc_2.shadowColor = Number(param1.shadowColor);
                        _loc_2.highlightColor = Number(param1.highlightColor);
                    } else {
                        _loc_2.highlightColor = Number(param1.shadowColor);
                        _loc_2.shadowColor = Number(param1.highlightColor);
                    };
                    return ([_loc_2]);
            };
            return ([]);
        }
        public static function drawRectOutlineStyle(param1:Graphics, param2:Rectangle, param3:StrokeStyle, param4:FillStyle, param5:Boolean=false):void{
            var _loc_6:Number = NaN;
            _loc_6 = Number(param3.thickness);
            param1.lineStyle(undefined);
            param1.beginFill(Number(param3.color), Number(param3.alpha));
            if (!param5){
                param1.moveTo(param2.left, param2.top);
                param1.lineTo(param2.right, param2.top);
                param1.lineTo(param2.right, param2.bottom);
                param1.lineTo(param2.left, param2.bottom);
                param1.lineTo(param2.left, param2.top);
                param1.moveTo((param2.left + _loc_6), (param2.top + _loc_6));
                param1.lineTo((param2.right - _loc_6), (param2.top + _loc_6));
                param1.lineTo((param2.right - _loc_6), (param2.bottom - _loc_6));
                param1.lineTo((param2.left + _loc_6), (param2.bottom - _loc_6));
                param1.lineTo((param2.left + _loc_6), (param2.top + _loc_6));
            } else {
                param1.drawRect(param2.left, (param2.top + _loc_6), _loc_6, Math.max(0, (param2.height - (2 * _loc_6))));
                param1.drawRect((param2.left + _loc_6), param2.top, Math.max(0, (param2.width - (2 * _loc_6))), _loc_6);
                param1.drawRect((param2.right - _loc_6), (param2.top + _loc_6), _loc_6, Math.max(0, (param2.height - (2 * _loc_6))));
                param1.drawRect((param2.left + _loc_6), (param2.bottom - _loc_6), Math.max(0, (param2.width - (2 * _loc_6))), _loc_6);
            };
            param1.endFill();
            beginFill(param1, param4);
            param1.moveTo((param2.left + _loc_6), (param2.top + _loc_6));
            param1.lineTo((param2.right - _loc_6), (param2.top + _loc_6));
            param1.lineTo((param2.right - _loc_6), (param2.bottom - _loc_6));
            param1.lineTo((param2.left + _loc_6), (param2.bottom - _loc_6));
            param1.lineTo((param2.left + _loc_6), (param2.top + _loc_6));
            param1.endFill();
        }

    }
}//package com.mapplus.maps 
