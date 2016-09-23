//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class LatLngBounds {

        private static const PI:Number = 3.14159;

        private var lat_:R1Interval;
        private var lng_:S1Interval;

        public function LatLngBounds(param1:LatLng=null, param2:LatLng=null){
            super();
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            if (((param1) && (!(param2)))){
                param2 = param1;
            };
            if (param1){
                _loc_3 = MapUtil.bound(param1.latRadians(), (-(PI) / 2), (PI / 2));
                _loc_4 = MapUtil.bound(param2.latRadians(), (-(PI) / 2), (PI / 2));
                lat_ = new R1Interval(_loc_3, _loc_4);
                _loc_5 = param1.lngRadians();
                _loc_6 = param2.lngRadians();
                if ((_loc_6 - _loc_5) >= (PI * 2)){
                    lng_ = new S1Interval(-(PI), PI);
                } else {
                    _loc_5 = MapUtil.wrap(_loc_5, -(PI), PI);
                    _loc_6 = MapUtil.wrap(_loc_6, -(PI), PI);
                    lng_ = new S1Interval(_loc_5, _loc_6);
                };
            } else {
                lat_ = new R1Interval(1, -1);
                lng_ = new S1Interval(PI, -(PI));
            };
        }
        public static function fromObject(param1:Object):LatLngBounds{
            if (param1 == null){
                return (null);
            };
            return (new LatLngBounds(LatLng.fromObject(param1.getSouthWest()), LatLng.fromObject(param1.getNorthEast())));
        }

        public function getEast():Number{
            return (MapUtil.radiansToDegrees(lng_.hi));
        }
        public function isEmpty():Boolean{
            return (((lat_.isEmpty()) || (lng_.isEmpty())));
        }
        public function containsLatLng(param1:LatLng):Boolean{
            return (((lat_.contains(param1.latRadians())) && (lng_.contains(param1.lngRadians()))));
        }
        public function isFullLat():Boolean{
            return ((((lat_.hi >= (PI / 2))) && ((lat_.lo <= (-(PI) / 2)))));
        }
        public function getCenter():LatLng{
            return (LatLng.fromRadians(lat_.center(), lng_.center()));
        }
        public function isFullLng():Boolean{
            return (lng_.isFull());
        }
        public function union(param1:LatLngBounds):void{
            extend(param1.getSouthWest());
            extend(param1.getNorthEast());
        }
        public function getNorth():Number{
            return (MapUtil.radiansToDegrees(lat_.hi));
        }
        public function getSouth():Number{
            return (MapUtil.radiansToDegrees(lat_.lo));
        }
        public function extend(param1:LatLng):void{
            lat_.extend(param1.latRadians());
            lng_.extend(param1.lngRadians());
        }
        public function clone():LatLngBounds{
            return (new LatLngBounds(getSouthWest(), getNorthEast()));
        }
        public function getNorthWest():LatLng{
            return (LatLng.fromRadians(lat_.hi, lng_.lo));
        }
        public function getSouthEast():LatLng{
            return (LatLng.fromRadians(lat_.lo, lng_.hi));
        }
        public function isLargerThan(param1:LatLngBounds):Boolean{
            var _loc_2:LatLng;
            var _loc_3:LatLng;
            _loc_2 = toSpan();
            _loc_3 = param1.toSpan();
            return ((((_loc_2.lat() > _loc_3.lat())) && ((_loc_2.lng() > _loc_3.lng()))));
        }
        public function getWest():Number{
            return (MapUtil.radiansToDegrees(lng_.lo));
        }
        public function getSouthWest():LatLng{
            return (LatLng.fromRadians(lat_.lo, lng_.lo));
        }
        public function getNorthEast():LatLng{
            return (LatLng.fromRadians(lat_.hi, lng_.hi));
        }
        public function toString():String{
            return ((((("(" + getSouthWest()) + ", ") + getNorthEast()) + ")"));
        }
        public function containsBounds(param1:LatLngBounds):Boolean{
            return (((lat_.containsInterval(param1.lat_)) && (lng_.containsInterval(param1.lng_))));
        }
        public function intersects(param1:LatLngBounds):Boolean{
            return (((lat_.intersects(param1.lat_)) && (lng_.intersects(param1.lng_))));
        }
        public function toSpan():LatLng{
            return (LatLng.fromRadians(lat_.span(), lng_.span(), true));
        }
        public function equals(param1:LatLngBounds):Boolean{
            return (((lat_.equals(param1.lat_)) && (lng_.equals(param1.lng_))));
        }

    }
}//package com.mapplus.maps 
