//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class StandardMouseImpl implements IMouse {

        private var upListeners:Array;
        private var isMouseDown:Boolean;
        private var moveListeners:Array;

        public function StandardMouseImpl(){
            super();
            this.isMouseDown = false;
            this.upListeners = [];
            this.moveListeners = [];
        }
        private function dispatchMouseMove(event:MouseEvent):void{
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:Function;
            if (this.isMouseDown != event.buttonDown){
                if (this.isMouseDown == true){
                    this.dispatchMouseUp(false, event);
                };
                this.isMouseDown = event.buttonDown;
            };
            _loc_2 = this.moveListeners.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2) {
                _loc_4 = this.moveListeners[_loc_3];
                _loc_4(event.buttonDown, event);
                _loc_3++;
            };
        }
        private function dispatchMouseUp(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:Function;
            _loc_3 = this.upListeners;
            this.upListeners = [];
            _loc_4 = _loc_3.length;
            _loc_5 = 0;
            while (_loc_5 < _loc_4) {
                _loc_6 = _loc_3[_loc_5];
                _loc_6(param1, param2);
                _loc_5++;
            };
            this.isMouseDown = false;
        }
        public function reportMouseEvent(event:MouseEvent):void{
            if (event.type == MouseEvent.MOUSE_DOWN){
                this.isMouseDown = true;
            } else {
                if (event.type == MouseEvent.MOUSE_UP){
                    this.dispatchMouseUp(true, event);
                } else {
                    if (event.type == MouseEvent.MOUSE_MOVE){
                        this.dispatchMouseMove(event);
                    };
                };
            };
        }
        public function stopDrag(param1:Sprite):void{
            param1.stopDrag();
        }
        public function removeListener(param1:DisplayObject, param2:String, param3:Function, param4:Boolean=false):void{
            param1.removeEventListener(param2, param3, param4);
        }
        public function removeGlobalMouseMoveListener(param1:Function):Boolean{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = this.moveListeners.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2) {
                if (this.moveListeners[_loc_3] == param1){
                    this.moveListeners.splice(_loc_3, 1);
                    return (true);
                };
                _loc_3++;
            };
            return (false);
        }
        public function addGlobalMouseMoveListener(param1:Function):void{
            this.moveListeners.push(param1);
        }
        public function removeGlobalMouseUpListener(param1:Function):Boolean{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = this.upListeners.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_2) {
                if (this.upListeners[_loc_3] == param1){
                    this.upListeners.splice(_loc_3, 1);
                    return (true);
                };
                _loc_3++;
            };
            return (false);
        }
        public function addGlobalMouseUpListener(param1:Function):void{
            this.upListeners.push(param1);
        }
        public function addListener(param1:DisplayObject, param2:String, param3:Function, param4:Boolean=false):void{
            param1.addEventListener(param2, param3, param4);
        }
        public function startDrag(param1:Sprite, param2:Boolean=false, param3:Rectangle=null):void{
            param1.startDrag(param2, param3);
        }

    }
}//package com.mapplus.maps.core 
