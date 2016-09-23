//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;
    import com.mapplus.maps.wrappers.*;

    public class Route {

        var _endLatLng:LatLng;
        var _durationHtml:String;
        var _endGeocode:Placemark;
        var _distance:Number;
        var _startGeocode:Placemark;
        var _distanceHtml:String;
        var _steps:Array;
        var _summaryHtml:String;
        var _duration:Number;
        var _endPolylineIndex:uint;

        public function Route(){
            super();
        }
        public static function fromObject(param1:Object):Route{
            var _loc_2:Route;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (Route)();
            _loc_2._endLatLng = LatLng.fromObject(param1._endLatLng);
            _loc_2._startGeocode = Placemark.fromObject(param1._startGeocode);
            _loc_2._endGeocode = Placemark.fromObject(param1._endGeocode);
            _loc_2._steps = Wrapper.instance().wrapStepArray(param1._steps);
            _loc_2._summaryHtml = param1._summaryHtml;
            _loc_2._distanceHtml = param1._distanceHtml;
            _loc_2._durationHtml = param1._durationHtml;
            _loc_2._distance = param1._distance;
            _loc_2._duration = param1._duration;
            _loc_2._endPolylineIndex = param1._endPolylineIndex;
            return (_loc_2);
        }

        public function get distanceHtml():String{
            return (this._distanceHtml);
        }
        public function get startGeocode():Placemark{
            return (this._startGeocode);
        }
        public function get numSteps():uint{
            return (this._steps.length);
        }
        public function get duration():Number{
            return (this._duration);
        }
        public function getStep(param1:uint):Step{
            return (this._steps[param1]);
        }
        public function get endLatLng():LatLng{
            return (this._endLatLng);
        }
        public function get endGeocode():Placemark{
            return (this._endGeocode);
        }
        public function get durationHtml():String{
            return (this._durationHtml);
        }
        public function get summaryHtml():String{
            return (this._summaryHtml);
        }
        public function get distance():Number{
            return (this._distance);
        }

    }
}//package com.mapplus.maps.services 
