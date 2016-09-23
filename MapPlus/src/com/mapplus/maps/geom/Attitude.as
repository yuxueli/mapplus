//Created by yuxueli 2011.6.6
package com.mapplus.maps.geom {

    public final class Attitude {

        private var roll_:Number;
        private var pitch_:Number;
        private var yaw_:Number;

        public function Attitude(param1:Number, param2:Number, param3:Number){
            super();
            roll_ = param3;
            pitch_ = param2;
            yaw_ = param1;
        }
        public static function fromObject(param1:Object):Attitude{
            return ((!((param1 == null))) ? new Attitude(param1.yaw, param1.pitch, param1.roll) : null);
        }

        public function get pitch():Number{
            return (pitch_);
        }
        public function toString():String{
            return ((((((("(" + yaw_) + ", ") + pitch_) + ", ") + roll_) + ")"));
        }
        public function get yaw():Number{
            return (yaw_);
        }
        public function get roll():Number{
            return (roll_);
        }
        public function equals(param1:Attitude):Boolean{
            if (param1){
            };
            if (yaw == param1.yaw){
            };
            if (pitch == param1.pitch){
            };
            return ((roll == param1.roll));
        }

    }
}//package com.mapplus.maps.geom 
