//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;

    public class FlyController {

        private var interpolator:Interpolator;
        private var zoomScaleBaseValue:Number;
        private var destinations:Array;
        private var map:IMap3D;

        public function FlyController(param1:IMap3D){
            super();
            interpolator = new Interpolator(5);
            destinations = [];
            this.map = param1;
        }
        private function getCurrentMapStep():FlyStep{
            return (new FlyStep(map.camera.latLngToWorld(map.getCenter()), map.getZoom(), map.getAttitude()));
        }
        public function numSegments():int{
            return (interpolator.numSegments());
        }
        public function get zoomScaleBase():Number{
            return (zoomScaleBaseValue);
        }
        public function isActive():Boolean{
            return ((numSegments() > 0));
        }
        public function continueFrom(param1:int):void{
            var _loc_2:Array;
            var _loc_3:Destination;
            purgeDestinations(param1);
            _loc_2 = destinations;
            cancel();
            for each (_loc_3 in _loc_2) {
                addSegment(param1, _loc_3.flyStep, (_loc_3.time - param1));
            };
        }
        public function set zoomScaleBase(param1:Number):void{
            zoomScaleBaseValue = param1;
        }
        public function addSegment(param1:int, param2:FlyStep, param3:int):void{
            var _loc_4:int;
            var _loc_5:Array;
            var _loc_6:Array;
            var _loc_7:FlyStep;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:int;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:int;
            var _loc_23:Number = NaN;
            var _loc_24:Number = NaN;
            var _loc_25:Number = NaN;
            var _loc_26:Number = NaN;
            var _loc_27:Point;
            var _loc_28:Attitude;
            var _loc_29:FlyStep;
            purgeDestinations(param1);
            destinations.push(new Destination((param1 + param3), param2));
            _loc_5 = [];
            _loc_6 = [];
            if (!isActive()){
                _loc_4 = param1;
                _loc_5.push(param1);
                _loc_7 = getCurrentMapStep();
                _loc_6.push(_loc_7.toCoeffs());
            } else {
                _loc_4 = interpolator.getEndTime();
                _loc_7 = FlyStep.fromCoeffs(interpolator.evaluateAt(_loc_4));
            };
            _loc_8 = _loc_7.zoom;
            _loc_9 = _loc_7.center.x;
            _loc_10 = _loc_7.center.y;
            _loc_11 = _loc_7.attitude.yaw;
            _loc_12 = _loc_7.attitude.pitch;
            _loc_13 = (param2.zoom - _loc_8);
            _loc_14 = (param2.center.x - _loc_9);
            _loc_15 = (param2.center.y - _loc_10);
            _loc_16 = (param2.attitude.yaw - _loc_11);
            _loc_17 = (param2.attitude.pitch - _loc_12);
            _loc_18 = 1;
            _loc_19 = (int((_loc_13 / _loc_18)) + 1);
            _loc_20 = Math.pow(zoomScaleBase, -(_loc_8));
            _loc_21 = (Math.pow(zoomScaleBase, -(param2.zoom)) - _loc_20);
            _loc_22 = 1;
            while (_loc_22 < _loc_19) {
                _loc_23 = (_loc_22 / _loc_19);
                _loc_24 = (_loc_4 + (param3 * _loc_23));
                _loc_5.push(_loc_24);
                _loc_25 = (_loc_8 + (_loc_13 * _loc_23));
                _loc_26 = ((Math.pow(zoomScaleBase, -(_loc_25)) - _loc_20) / _loc_21);
                _loc_27 = new Point((_loc_9 + (_loc_14 * _loc_26)), (_loc_10 + (_loc_15 * _loc_26)));
                _loc_28 = new Attitude((_loc_11 + (_loc_16 * _loc_23)), (_loc_12 + (_loc_17 * _loc_23)), 0);
                _loc_29 = new FlyStep(_loc_27, _loc_25, _loc_28);
                _loc_6.push(_loc_29.toCoeffs());
                _loc_22++;
            };
            _loc_5.push((_loc_4 + param3));
            _loc_6.push(param2.toCoeffs());
            interpolator.appendSegmentsCubic(param1, _loc_5, _loc_6);
        }
        public function cancel():void{
            interpolator.clear();
            destinations = [];
        }
        public function advanceTo(param1:int):FlyStep{
            return (FlyStep.fromCoeffs(interpolator.evaluateAt(param1, true)));
        }
        private function purgeDestinations(param1:int):void{
            while (destinations.length > 0) {
                if (param1 < destinations[0].time){
                    break;
                };
                destinations.shift();
            };
        }

    }
}
import com.mapplus.maps.core.FlyStep;

//package com.mapplus.maps.core 

class Destination {

    public var time:Number;
    public var flyStep:FlyStep;

    public function Destination(param1:Number, param2:com.mapplus.maps.core.FlyStep){
        super();
        this.time = param1;
        this.flyStep = param2;
    }
}
