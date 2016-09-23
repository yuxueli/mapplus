//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;

    public class Step {

        var _latLng:LatLng;
        var _descriptionHtml:String;
        var _durationHtml:String;
        var _polylineIndex:uint;
        var _distance:Number;
        var _duration:Number;
        var _distanceHtml:String;

        public function Step(){
            super();
        }
        public static function fromObject(param1:Object):Step{
            var _loc_2:Step;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (Step)();
            _loc_2._latLng = LatLng.fromObject(param1._latLng);
            _loc_2._descriptionHtml = param1._descriptionHtml;
            _loc_2._distanceHtml = param1._distanceHtml;
            _loc_2._durationHtml = param1._durationHtml;
            _loc_2._distance = param1._distance;
            _loc_2._duration = param1._duration;
            _loc_2._polylineIndex = param1._polylineIndex;
            return (_loc_2);
        }

        public function get distanceHtml():String{
            return (_distanceHtml);
        }
        public function get distance():Number{
            return (_distance);
        }
        public function get descriptionHtml():String{
            return (_descriptionHtml);
        }
        public function get latLng():LatLng{
            return (_latLng);
        }
        public function get durationHtml():String{
            return (_durationHtml);
        }
        public function get polylineIndex():uint{
            return (_polylineIndex);
        }
        public function get duration():Number{
            return (_duration);
        }

    }
}//package com.mapplus.maps.services 
