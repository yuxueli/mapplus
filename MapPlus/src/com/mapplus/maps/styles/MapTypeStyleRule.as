//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {

    public class MapTypeStyleRule {

        public function MapTypeStyleRule(){
            super();
        }
        public static function saturation(param1:Number):Object{
            return ({saturation:param1});
        }
        public static function visibility(param1:String):Object{
            return ({visibility:param1});
        }
        public static function invert_lightness(param1:Boolean):Object{
            return ({invert_lightness:param1});
        }
        public static function gamma(param1:Number):Object{
            return ({gamma:param1});
        }
        public static function hue(param1:uint):Object{
            return ({hue:param1});
        }
        public static function lightness(param1:Number):Object{
            return ({lightness:param1});
        }

    }
}//package com.mapplus.maps.styles 
