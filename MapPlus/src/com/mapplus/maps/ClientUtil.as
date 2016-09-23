//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import flash.display.*;

    public class ClientUtil {

        public function ClientUtil(){
            super();
        }
        public static function getFlashVar(loaderInfo:LoaderInfo, strVar:String):String{
            var _loc_3:Object;
            var _loc_4:String;
            _loc_3 = loaderInfo.parameters;
            _loc_4 = null;
            if (_loc_3 == null){
                return (null);
            };
            return ((_loc_3[strVar] as String));
        }

    }
}//package com.mapplus.maps 
