//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class ScaleControl extends IWrappableSpriteWrapper implements IScaleControl {

        private static var defaultOptions:ScaleControlOptions = createInitialDefaultOptions();

        private var upperTextField:TextField;
        private var lowerTextField:TextField;
        private var upperBarLength:Number;
        private var map:IControllableMap;
        private var options:ScaleControlOptions;
        private var lowerBarLength:Number;
        private var upperBarParameters:ScaleControlParameters;
        private var lowerBarParameters:ScaleControlParameters;
        private var canvas:Sprite;

        public function ScaleControl(param1:ScaleControlOptions=null){
            super();
            this.options = ScaleControlOptions.merge([defaultOptions, param1]);
        }
        private static function createInitialDefaultOptions():ScaleControlOptions{
            var _loc_1:TextFormat;
            _loc_1 = new TextFormat();
            _loc_1.align = TextFormatAlign.LEFT;
            _loc_1.size = 11;
            _loc_1.font = "_sans";
            return (new ScaleControlOptions({
                position:new ControlPosition(ControlPosition.ANCHOR_BOTTOM_LEFT, 70, 5),
                units:ScaleControlOptions.UNITS_BOTH,
                maxWidth:125,
                lineThickness:1,
                labelFormat:_loc_1
            }));
        }

        private function drawControl(param1:Graphics, param2:Number, param3:Number, param4:Number):void{
            param1.moveTo(0, -(param4));
            param1.lineTo(0, 0);
            param1.lineTo(param2, 0);
            param1.lineTo(param2, -(param4));
            if (param3 > 0){
                param1.moveTo(0, param4);
                param1.lineTo(0, 0);
                param1.lineTo(param3, 0);
                param1.lineTo(param3, param4);
            };
        }
        private function updateScale(param1:Boolean):void{
            var _loc_2:LatLng;
            var _loc_3:Camera;
            var _loc_4:Point;
            var _loc_5:Point;
            var _loc_6:LatLng;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Graphics;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Rectangle;
            if (this.map == null){
                return;
            };
            _loc_2 = map.getCenter();
            _loc_3 = map.getCamera();
            _loc_4 = _loc_3.latLngToViewport(_loc_2);
            _loc_5 = new Point((_loc_4.x + 1), _loc_4.y);
            _loc_6 = _loc_3.viewportToLatLng(_loc_5);
            _loc_7 = _loc_2.distanceFrom(_loc_6, this.map.getCurrentMapType().getRadius());
            _loc_8 = upperBarParameters.calculateDisplayInfo(_loc_7, this.getMaxWidth(), this.upperTextField);
            _loc_9 = 0;
            if (lowerBarParameters != null){
                _loc_9 = lowerBarParameters.calculateDisplayInfo(_loc_7, this.getMaxWidth(), this.lowerTextField);
            };
            if (((((!(param1)) && ((_loc_8 == this.upperBarLength)))) && ((_loc_9 == this.lowerBarLength)))){
                return;
            };
            this.upperBarLength = _loc_8;
            this.lowerBarLength = _loc_9;
            _loc_10 = this.canvas.graphics;
            _loc_11 = getLineThickness();
            _loc_12 = (_loc_11 / 2);
            _loc_13 = this.upperTextField.textHeight;
            _loc_14 = ((this.upperTextField.height - _loc_13) / 2);
            _loc_15 = Math.round((_loc_13 * 0.75));
            _loc_10.clear();
            _loc_10.lineStyle((_loc_11 + 2), 0xFFFFFF, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            drawControl(_loc_10, _loc_8, _loc_9, _loc_15);
            _loc_10.lineStyle(_loc_11, 0, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
            drawControl(_loc_10, _loc_8, _loc_9, _loc_15);
            this.upperTextField.x = (_loc_12 + 2);
            this.upperTextField.y = (((-(_loc_13) - _loc_14) - _loc_12) - 1);
            this.lowerTextField.x = (_loc_12 + 2);
            this.lowerTextField.y = ((-(_loc_14) + _loc_12) + 1);
            _loc_16 = this.canvas.getBounds(this.canvas);
            this.canvas.x = -(_loc_16.left);
            this.canvas.y = -(_loc_16.top);
            this.map.placeControl(this, this.getControlPosition());
        }
        private function getMaxWidth():Number{
            return ((this.options.maxWidth as int));
        }
        public function initControlWithMap(param1:IMap):void{
            initControlWithMapInternal((param1 as IControllableMap));
        }
        private function createControlTextField():TextField{
            var _loc_1:TextField;
            _loc_1 = new TextField();
            _loc_1.multiline = false;
            _loc_1.autoSize = TextFieldAutoSize.LEFT;
            _loc_1.wordWrap = true;
            _loc_1.background = false;
            _loc_1.type = TextFieldType.DYNAMIC;
            _loc_1.selectable = false;
            updateTextFormat(_loc_1);
            return (_loc_1);
        }
        private function onUpdateColours(event:Event=null):void{
            updateColours();
        }
        override public function get interfaceChain():Array{
            return (["IScaleControl", "IControl"]);
        }
        public function getControlPosition():ControlPosition{
            return ((this.options.position as ControlPosition));
        }
        private function getBootstrapPrefersMetric():Boolean{
            var _loc_1:Object;
            _loc_1 = Bootstrap.getBootstrap().getSettings();
            return ((((((_loc_1 == null)) || ((_loc_1.preferences == null)))) || (!((_loc_1.preferences.metric_scale == false)))));
        }
        private function createMetricParameters():ScaleControlParameters{
            return (new ScaleControlParameters(Bootstrap.getBootstrap().getMessage("kilometers_abbreviated"), 0.001, Bootstrap.getBootstrap().getMessage("meters_abbreviated"), 1));
        }
        private function createImperialParameters():ScaleControlParameters{
            return (new ScaleControlParameters(Bootstrap.getBootstrap().getMessage("miles_abbreviated"), 0.000621371, Bootstrap.getBootstrap().getMessage("feet_abbreviated"), 3.28084));
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, getControlPosition());
            };
        }
        private function updateColours():void{
            if (this.map == null){
                return;
            };
            updateTextFormat(this.upperTextField);
            updateTextFormat(this.lowerTextField);
            updateScale(true);
        }
        function initControlWithMapInternal(param1:IControllableMap):void{
            var _loc_2:ISpriteFactory;
            if (this.map){
                removeFromMap();
            };
            this.map = param1;
            if (param1){
                if (this.canvas == null){
                    _loc_2 = Bootstrap.getSpriteFactory();
                    this.canvas = Bootstrap.createChildSprite(this.getSprite());
                    this.canvas.x = 0;
                    this.canvas.y = 0;
                    this.upperTextField = createControlTextField();
                    _loc_2.addChild(this.canvas, this.upperTextField);
                    this.lowerTextField = createControlTextField();
                    _loc_2.addChild(this.canvas, this.lowerTextField);
                };
                param1.addEventListener(MapEvent.MAPTYPE_CHANGED, onUpdateColours);
                param1.addEventListener(MapMoveEvent.MOVE_END, onUpdateScale);
                param1.addEventListener(MapZoomEvent.ZOOM_CHANGED, onUpdateScale);
                calculateControlParameters();
                updateColours();
            };
        }
        private function calculateControlParameters():void{
            var _loc_1:Boolean;
            var _loc_2:int;
            var _loc_3:Boolean;
            var _loc_4:Boolean;
            _loc_1 = getBootstrapPrefersMetric();
            _loc_2 = getUnits();
            _loc_3 = (((((_loc_2 == ScaleControlOptions.UNITS_BOTH_PREFER_IMPERIAL)) || ((_loc_2 == ScaleControlOptions.UNITS_IMPERIAL_ONLY)))) || (((!(_loc_1)) && ((((_loc_2 == ScaleControlOptions.UNITS_BOTH)) || ((_loc_2 == ScaleControlOptions.UNITS_SINGLE)))))));
            this.upperBarParameters = (_loc_3) ? createImperialParameters() : createMetricParameters();
            _loc_4 = (((((_loc_2 == ScaleControlOptions.UNITS_SINGLE)) || ((_loc_2 == ScaleControlOptions.UNITS_METRIC_ONLY)))) || ((_loc_2 == ScaleControlOptions.UNITS_IMPERIAL_ONLY)));
            this.lowerBarParameters = (_loc_4) ? null : (_loc_3) ? createMetricParameters() : createImperialParameters();
            if (lowerTextField != null){
                lowerTextField.visible = !(_loc_4);
            };
        }
        private function onUpdateScale(event:Event=null):void{
            updateScale(false);
        }
        private function getLineThickness():int{
            return ((this.options.lineThickness as int));
        }
        private function updateTextFormat(param1:TextField):void{
            var _loc_2:IMapType;
            var _loc_3:TextFormat;
            _loc_2 = this.map.getCurrentMapType();
            _loc_3 = options.labelFormat;
            _loc_3.color = (_loc_2) ? _loc_2.getTextColor() : 0;
            param1.defaultTextFormat = _loc_3;
        }
        public function getDisplayObject():DisplayObject{
            return (this.getSprite());
        }
        public function removeFromMap():void{
            if (this.map != null){
                this.map.removeEventListener(MapEvent.MAPTYPE_CHANGED, updateColours);
                this.map.removeEventListener(MapMoveEvent.MOVE_END, updateScale);
                this.map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, updateScale);
            };
        }
        private function getUnits():int{
            return ((this.options.units as int));
        }
        public function getSize():Point{
            return (((this.canvas)!=null) ? new Point(this.canvas.width, this.canvas.height) : new Point(0, 0));
        }

    }
}//package com.mapplus.maps.controls 

import flash.text.*;

class ScaleControlParameters {

    public var smallUnitsName:String;
    public var smallUnitsFactor:Number;
    public var largeUnitsFactor:Number;
    public var largeUnitsName:String;

    public function ScaleControlParameters(param1:String, param2:Number, param3:String, param4:Number){
        super();
        this.largeUnitsName = param1;
        this.smallUnitsName = param3;
        this.largeUnitsFactor = param2;
        this.smallUnitsFactor = param4;
    }
    public function calculateDisplayInfo(param1:Number, param2:Number, param3:TextField):Number{
        var _loc_4:Number = NaN;
        var _loc_5:String;
        var _loc_6:Number = NaN;
        _loc_4 = (param1 * this.largeUnitsFactor);
        _loc_5 = this.largeUnitsName;
        if ((_loc_4 * param2) < 1){
            _loc_4 = (param1 * this.smallUnitsFactor);
            _loc_5 = this.smallUnitsName;
        };
        _loc_6 = round125((_loc_4 * param2));
        if (param3 != null){
            param3.htmlText = ((String(_loc_6) + " ") + _loc_5);
        };
        return (Math.round((_loc_6 / _loc_4)));
    }
    private function round125(param1:Number):Number{
        var _loc_2:Number = NaN;
        _loc_2 = 1;
        while (param1 >= (_loc_2 * 10)) {
            _loc_2 = (_loc_2 * 10);
        };
        if (param1 >= (_loc_2 * 5)){
            _loc_2 = (_loc_2 * 5);
        };
        if (param1 >= (_loc_2 * 2)){
            _loc_2 = (_loc_2 * 2);
        };
        return (_loc_2);
    }

}
