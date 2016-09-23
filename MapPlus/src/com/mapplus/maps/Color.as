//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public final class Color {

        public static const GRAY10:Number = 0xA0A0A0;
        public static const GRAY11:Number = 0xB0B0B0;
        public static const GRAY13:Number = 0xD0D0D0;
        public static const GRAY15:Number = 0xF0F0F0;
        public static const MAGENTA:Number = 0xFF00FF;
        public static const GRAY12:Number = 0xC0C0C0;
        public static const YELLOW:Number = 0xFFFF00;
        public static const WHITE:Number = 0xFFFFFF;
        public static const BLUE:Number = 0xFF;
        public static const DEFAULTLINK:Number = 7829452;
        public static const BLACK:Number = 0;
        public static const GREEN:Number = 0xFF00;
        public static const CYAN:Number = 0xFFFF;
        public static const GRAY1:Number = 0x101010;
        public static const GRAY2:Number = 0x202020;
        public static const GRAY3:Number = 0x303030;
        public static const RED:Number = 0xFF0000;
        public static const GRAY5:Number = 0x505050;
        public static const GRAY6:Number = 0x606060;
        public static const GRAY7:Number = 0x707070;
        public static const GRAY8:Number = 0x808080;
        public static const GRAY4:Number = 0x404040;
        public static const GRAY9:Number = 0x909090;
        public static const GRAY14:Number = 0xE0E0E0;

        private var _b:Number;
        private var _g:Number;
        private var _r:Number;

        public function Color(param1:Number){
            super();
            _r = (param1 >> 16);
            _g = ((param1 & 0xFF00) >> 8);
            _b = (param1 & 0xFF);
        }
        public static function fromObject(param1:Object):Color{
            return ((!((param1 == null))) ? new Color(param1.rgb) : null);
        }
        public static function toHtml(param1:Number):String{
            var _loc_2:String;
            var _loc_3:Number = NaN;
            var _loc_4:String;
            if ("number" == "number"){
            };
            if (isNaN(param1)){
                param1 = 0;
            };
            _loc_2 = "#000000";
            _loc_3 = Math.floor(MapUtil.bound(param1, 0, 0xFFFFFF));
            _loc_4 = _loc_3.toString(16);
            return ((_loc_2.substr(0, (7 - _loc_4.length)) + _loc_4));
        }

        public function get b():Number{
            return (Math.round(_b));
        }
        public function set r(param1:Number):void{
            _r = ((param1 > 0xFF)) ? 0xFF : ((param1 < 0)) ? 0 : param1;
        }
        public function get g():Number{
            return (Math.round(_g));
        }
        public function set b(param1:Number):void{
            _b = ((param1 > 0xFF)) ? 0xFF : ((param1 < 0)) ? 0 : param1;
        }
        public function toString():String{
            return (((((("R:" + r) + "/G:") + g) + "/B:") + b));
        }
        public function set g(param1:Number):void{
            _g = ((param1 > 0xFF)) ? 0xFF : ((param1 < 0)) ? 0 : param1;
        }
        public function incRGB(param1:Number, param2:Number, param3:Number):void{
            r = (_r + param1);
            g = (_g + param2);
            b = (_b + param3);
        }
        public function get r():Number{
            return (Math.round(_r));
        }
        public function get rgb():Number{
            return ((((r << 16) + (g << 8)) + b));
        }
        public function setRGB(param1:Number, param2:Number, param3:Number):void{
            r = param1;
            g = param2;
            b = param3;
        }

    }
}//package com.mapplus.maps 
