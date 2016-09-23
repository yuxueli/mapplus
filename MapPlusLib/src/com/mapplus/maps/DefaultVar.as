//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class DefaultVar {

        public function DefaultVar(){
            super();
        }
        public static function getBoolean(param1, param2:String, param3:Boolean):Boolean{
            return ((((param1) && ((param1[param2] is Boolean)))) ? param1[param2] : param3);
        }
        public static function getArray(param1, param2:String, param3:Array=null):Array{
            return ((((param1) && ((param1[param2] is Array)))) ? param1[param2] : param3);
        }
        public static function getObject(param1:Class, param2, param3:String, param4:Object=null):Object{
            return ((((param2) && ((param2[param3] is param1)))) ? param2[param3] : param4);
        }
        public static function getString(param1, param2:String, param3:String=null):String{
            return ((((param1) && ((param1[param2] is String)))) ? param1[param2] : param3);
        }
        public static function cloneArray(param1:Array, param2:Array=null):Array{
            var _loc_3:Array;
            _loc_3 = [];
            if (param1 != null){
                MapUtil.copyObject(_loc_3, param1);
            } else {
                if (param2 != null){
                    MapUtil.copyObject(_loc_3, param2);
                };
            };
            return (_loc_3);
        }
        public static function cloneObject(param1:Object):Object{
            var _loc_2:Object;
            _loc_2 = {};
            if (param1 != null){
                MapUtil.copyObject(_loc_2, param1);
            };
            return (_loc_2);
        }
        public static function getNumber(param1, param2:String, param3:Number=NaN):Number{
            return ((((param1) && ((param1[param2] is Number)))) ? param1[param2] : param3);
        }

    }
}//package com.mapplus.maps 
