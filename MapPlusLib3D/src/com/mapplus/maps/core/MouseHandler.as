//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public class MouseHandler {

        private static var mouse:IMouse = new StandardMouseImpl();

        public function MouseHandler(){
            super();
        }
        public static function setHandler(param1:IMouse=null):void{
            if (param1){
                mouse = param1;
            } else {
                mouse = new StandardMouseImpl();
            };
        }
        public static function instance():IMouse{
            return (mouse);
        }

    }
}//package com.mapplus.maps.core 
