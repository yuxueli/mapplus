//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.*;

    public class Step {

        var _polylineIndex:uint;
        var _durationHtml:String;
        var _descriptionHtml:String;
        var _distance:Number;
        var _latLng:LatLng;
        var _distanceHtml:String;
        var _duration:Number;

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
            return (this._distanceHtml);
        }
        public function get latLng():LatLng{
            return (this._latLng);
        }
        public function get descriptionHtml():String{
            return (this._descriptionHtml);
        }
        public function get duration():Number{
            return (this._duration);
        }
        public function get durationHtml():String{
            return (this._durationHtml);
        }
        public function get polylineIndex():uint{
            return (this._polylineIndex);
        }
        public function get distance():Number{
            return (this._distance);
        }

    }
}//package com.mapplus.maps.services 
