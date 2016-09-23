//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.*;

    public class Route {

        var _endGeocode:Placemark;
        var _endLatLng:LatLng;
        var _distance:Number;
        var _distanceHtml:String;
        var _startGeocode:Placemark;
        var _steps:Array;
        var _summaryHtml:String;
        var _duration:Number;
        var _endPolylineIndex:uint;
        var _durationHtml:String;

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
            return (_distanceHtml);
        }
        public function get numSteps():uint{
            return (_steps.length);
        }
        public function get endLatLng():LatLng{
            return (_endLatLng);
        }
        public function getStep(param1:uint):Step{
            return (_steps[param1]);
        }
        public function get duration():Number{
            return (_duration);
        }
        public function get endGeocode():Placemark{
            return (_endGeocode);
        }
        public function get durationHtml():String{
            return (_durationHtml);
        }
        public function get summaryHtml():String{
            return (_summaryHtml);
        }
        public function get distance():Number{
            return (_distance);
        }
        public function get startGeocode():Placemark{
            return (_startGeocode);
        }

    }
}//package com.mapplus.maps.services 
