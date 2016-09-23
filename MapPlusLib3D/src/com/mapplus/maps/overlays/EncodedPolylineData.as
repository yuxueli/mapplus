//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {

    public class EncodedPolylineData {

        public var zoomFactor:Number;
        public var points:String;
        public var numLevels:Number;
        public var levels:String;

        public function EncodedPolylineData(param1:String, param2:Number, param3:String, param4:Number){
            super();
            this.points = param1;
            this.zoomFactor = param2;
            this.levels = param3;
            this.numLevels = param4;
        }
        public static function fromObject(param1:Object):EncodedPolylineData{
            if (param1 == null){
                return (null);
            };
            return (new EncodedPolylineData(param1.points, param1.zoomFactor, param1.levels, param1.numLevels));
        }

    }
}//package com.mapplus.maps.overlays 
