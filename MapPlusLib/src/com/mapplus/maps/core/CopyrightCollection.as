//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.interfaces.*;

    public class CopyrightCollection extends WrappableEventDispatcher implements ICopyrightCollection {

        private var copyrights:Object;
        private var prefix:String;
        private var zoomLevels:Array;

        public function CopyrightCollection(param1:String=null){
            super();
            this.zoomLevels = [];
            this.copyrights = {};
            this.prefix = (!((param1 == null))) ? param1 : "";
        }
        private static function isInZoomRange(param1:Copyright, param2:Number):Boolean{
            var _loc_3:Number = NaN;
            if (param2 < param1.getMinZoom()){
                return (false);
            };
            _loc_3 = param1.getMaxZoom();
            return (((isNaN(_loc_3)) || ((param2 <= _loc_3))));
        }
        private static function fullyCoversRegion(param1:Copyright, param2:LatLngBounds, param3:Number):Boolean{
            return (((((isInZoomRange(param1, param3)) && (param1.getBounds().containsBounds(param2)))) && (!(param1.isSupplemental()))));
        }
        private static function appliesToRegion(param1:Copyright, param2:LatLngBounds, param3:Number):Boolean{
            return (((isInZoomRange(param1, param3)) && (param1.getBounds().intersects(param2))));
        }
        private static function appliesToLatLng(param1:Copyright, param2:LatLng):Boolean{
            return (param1.getBounds().containsLatLng(param2));
        }

        public function getCopyrightsAtLatLng(param1:LatLng):Array{
            var _loc_2:Array;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Copyright;
            _loc_2 = [];
            _loc_3 = 0;
            while (_loc_3 < this.zoomLevels.length) {
                _loc_4 = 0;
                while (_loc_4 < this.zoomLevels[_loc_3].length) {
                    _loc_5 = this.zoomLevels[_loc_3][_loc_4];
                    if (appliesToLatLng(_loc_5, param1)){
                        _loc_2.push(_loc_5);
                    };
                    _loc_4 = (_loc_4 + 1);
                };
                _loc_3 = (_loc_3 + 1);
            };
            return (_loc_2);
        }
        override public function get interfaceChain():Array{
            return (["ICopyrightCollection", "IWrappableEventDispatcher"]);
        }
        public function getCopyrights(param1:LatLngBounds, param2:Number):Array{
            var _loc_3:Object;
            var _loc_4:Array;
            var _loc_5:Number = NaN;
            var _loc_6:Array;
            var _loc_7:Boolean;
            var _loc_8:Number = NaN;
            var _loc_9:Copyright;
            var _loc_10:String;
            _loc_3 = {};
            _loc_4 = [];
            _loc_5 = Math.min(param2, (this.zoomLevels.length - 1));
            while (_loc_5 >= 0) {
                _loc_6 = this.zoomLevels[_loc_5];
                if (!(_loc_6)){
                } else {
                    _loc_7 = false;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_6.length) {
                        _loc_9 = _loc_6[_loc_8];
                        if (appliesToRegion(_loc_9, param1, param2)){
                            _loc_10 = _loc_9.getText();
                            if (((_loc_10) && (!(_loc_3[_loc_10])))){
                                _loc_4.push(_loc_10);
                                _loc_3[_loc_10] = 1;
                            };
                            if (fullyCoversRegion(_loc_9, param1, param2)){
                                _loc_7 = true;
                            };
                        };
                        _loc_8 = (_loc_8 + 1);
                    };
                    if (_loc_7){
                        break;
                    };
                };
                _loc_5 = (_loc_5 - 1);
            };
            return (_loc_4);
        }
        public function getCopyrightNotice(param1:LatLngBounds, param2:Number):CopyrightNotice{
            var _loc_3:Array;
            _loc_3 = this.getCopyrights(param1, param2);
            if (_loc_3.length > 0){
                return (new CopyrightNotice(this.prefix, _loc_3));
            };
            return (undefined);
        }
        public function addCopyrightArray(param1:Array):Boolean{
            var _loc_2:Boolean;
            var _loc_3:int;
            _loc_2 = false;
            _loc_3 = 0;
            while (_loc_3 < param1.length) {
                if (this.addCopyrightImpl(param1[_loc_3])){
                    _loc_2 = true;
                };
                _loc_3++;
            };
            if (_loc_2){
                dispatchEvent(new MapEvent(MapEvent.COPYRIGHTS_UPDATED, this));
            };
            return (_loc_2);
        }
        private function addCopyrightImpl(param1:Copyright):Boolean{
            var _loc_2:String;
            var _loc_3:Number = NaN;
            var _loc_4:Array;
            _loc_2 = param1.getId();
            if (this.copyrights[_loc_2]){
                return (false);
            };
            _loc_3 = param1.getMinZoom();
            while (this.zoomLevels.length <= _loc_3) {
                _loc_4 = [];
                this.zoomLevels.push(_loc_4);
            };
            this.zoomLevels[_loc_3].push(param1);
            this.copyrights[_loc_2] = true;
            return (true);
        }
        public function addCopyright(param1:Copyright):Boolean{
            var _loc_2:Boolean;
            _loc_2 = this.addCopyrightImpl(param1);
            if (_loc_2){
                dispatchEvent(new MapEvent(MapEvent.COPYRIGHTS_UPDATED, this));
            };
            return (_loc_2);
        }

    }
}//package com.mapplus.maps.core 
