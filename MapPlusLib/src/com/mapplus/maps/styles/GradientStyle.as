//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {
    import com.mapplus.maps.wrappers.*;
    import flash.geom.*;

    public class GradientStyle {

        public var interpolationMethod:String;
        public var matrix:Matrix;
        public var ratios:Array;
        public var colors:Array;
        public var alphas:Array;
        public var focalPointRatio:Number;
        public var type:String;
        public var spreadMethod:String;

        public function GradientStyle(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):GradientStyle{
            var _loc_2:GradientStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (GradientStyle)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function toString():String{
            return ((("GradientStyle { type: " + this.type) + " ... } "));
        }
        function copyFromObject(param1:Object):void{
            this.type = param1.type;
            this.colors = Wrapper.cloneArray(param1.colors);
            this.alphas = Wrapper.cloneArray(param1.alphas);
            this.ratios = Wrapper.cloneArray(param1.ratios);
            this.matrix = (param1.matrix) ? param1.matrix.clone() : null;
            this.spreadMethod = param1.spreadMethod;
            this.interpolationMethod = param1.interpolationMethod;
            this.focalPointRatio = param1.focalPointRatio;
        }

    }
}//package com.mapplus.maps.styles 
