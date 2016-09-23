//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public class Siner {

        private var initTicks:Number;
        private var ticks:Number;
        private var tick:Number;

        public function Siner(param1:Number){
            super();
            this.initTicks = param1;
            this.ticks = param1;
            this.tick = 0;
        }
        public function next():Number{
            this.tick = (this.tick + 1);
            return (this.fract());
        }
        public function extend():void{
            this.ticks = (this.tick + this.initTicks);
        }
        public function fract():Number{
            var _loc_1:Number = NaN;
            _loc_1 = (Math.PI * ((this.tick / this.ticks) - 0.5));
            return (((Math.sin(_loc_1) + 1) / 2));
        }
        public function reset():void{
            this.tick = 0;
        }
        public function more():Boolean{
            return ((this.tick < this.ticks));
        }

    }
}//package com.mapplus.maps.core 
