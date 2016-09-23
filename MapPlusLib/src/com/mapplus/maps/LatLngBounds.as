//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class LatLngBounds {

        private static const PI:Number = 3.14159;

        private var lng_:S1Interval;
        private var lat_:R1Interval;

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
                this.lat_ = new R1Interval(_loc_3, _loc_4);
                _loc_5 = param1.lngRadians();
                _loc_6 = param2.lngRadians();
                if ((_loc_6 - _loc_5) >= (PI * 2)){
                    this.lng_ = new S1Interval(-(PI), PI);
                } else {
                    _loc_5 = MapUtil.wrap(_loc_5, -(PI), PI);
                    _loc_6 = MapUtil.wrap(_loc_6, -(PI), PI);
                    this.lng_ = new S1Interval(_loc_5, _loc_6);
                };
            } else {
                this.lat_ = new R1Interval(1, -1);
                this.lng_ = new S1Interval(PI, -(PI));
            };
        }
        public static function fromObject(param1:Object):LatLngBounds{
            if (param1 == null){
                return (null);
            };
            return (new LatLngBounds(LatLng.fromObject(param1.getSouthWest()), LatLng.fromObject(param1.getNorthEast())));
        }

        public function getNorthEast():LatLng{
            return (LatLng.fromRadians(this.lat_.hi, this.lng_.hi));
        }
        public function containsLatLng(param1:LatLng):Boolean{
            return (((this.lat_.contains(param1.latRadians())) && (this.lng_.contains(param1.lngRadians()))));
        }
        public function isFullLat():Boolean{
            return ((((this.lat_.hi >= (PI / 2))) && ((this.lat_.lo <= (-(PI) / 2)))));
        }
        public function isEmpty():Boolean{
            return (((this.lat_.isEmpty()) || (this.lng_.isEmpty())));
        }
        public function getCenter():LatLng{
            return (LatLng.fromRadians(this.lat_.center(), this.lng_.center()));
        }
        public function intersects(param1:LatLngBounds):Boolean{
            return (((this.lat_.intersects(param1.lat_)) && (this.lng_.intersects(param1.lng_))));
        }
        public function isFullLng():Boolean{
            return (this.lng_.isFull());
        }
        public function union(param1:LatLngBounds):void{
            this.extend(param1.getSouthWest());
            this.extend(param1.getNorthEast());
        }
        public function getSouth():Number{
            return (MapUtil.radiansToDegrees(this.lat_.lo));
        }
        public function clone():LatLngBounds{
            return (new LatLngBounds(this.getSouthWest(), this.getNorthEast()));
        }
        public function getNorthWest():LatLng{
            return (LatLng.fromRadians(this.lat_.hi, this.lng_.lo));
        }
        public function extend(param1:LatLng):void{
            this.lat_.extend(param1.latRadians());
            this.lng_.extend(param1.lngRadians());
        }
        public function isLargerThan(param1:LatLngBounds):Boolean{
            var _loc_2:LatLng;
            var _loc_3:LatLng;
            _loc_2 = this.toSpan();
            _loc_3 = param1.toSpan();
            return ((((_loc_2.lat() > _loc_3.lat())) && ((_loc_2.lng() > _loc_3.lng()))));
        }
        public function getWest():Number{
            return (MapUtil.radiansToDegrees(this.lng_.lo));
        }
        public function getSouthWest():LatLng{
            return (LatLng.fromRadians(this.lat_.lo, this.lng_.lo));
        }
        public function getNorth():Number{
            return (MapUtil.radiansToDegrees(this.lat_.hi));
        }
        public function toString():String{
            return ((((("(" + this.getSouthWest()) + ", ") + this.getNorthEast()) + ")"));
        }
        public function getEast():Number{
            return (MapUtil.radiansToDegrees(this.lng_.hi));
        }
        public function containsBounds(param1:LatLngBounds):Boolean{
            return (((this.lat_.containsInterval(param1.lat_)) && (this.lng_.containsInterval(param1.lng_))));
        }
        public function getSouthEast():LatLng{
            return (LatLng.fromRadians(this.lat_.lo, this.lng_.hi));
        }
        public function toSpan():LatLng{
            return (LatLng.fromRadians(this.lat_.span(), this.lng_.span(), true));
        }
        public function equals(param1:LatLngBounds):Boolean{
            return (((this.lat_.equals(param1.lat_)) && (this.lng_.equals(param1.lng_))));
        }

    }
}//package com.mapplus.maps 
