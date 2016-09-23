//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.events.*;
    import flash.display.*;
    import com.mapplus.maps.core.*;

    public class ButtonBase extends EventDispatcher {

        private var eventsSet:Boolean;
        private var _isSticky:Boolean;
        private var id:String;
        private var _mc:Sprite;
        private var isEnabled:Boolean;
        private var internalState:int;
        private var hintText:String;

        public function ButtonBase(param1:Sprite, param2:Boolean=false){
            super();
            this._mc = param1;
            this._isSticky = param2;
            this.isEnabled = true;
            this.eventsSet = false;
            this.setState(ButtonConstants.STATE_UP);
            if (this.mc.stage != null){
                this.onAddedToStage(null);
            };
            this.mc.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.mc.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }
        public function enableButton():void{
            this.isEnabled = true;
            this.mc.buttonMode = true;
        }
        public function get mc():Sprite{
            return (this._mc);
        }
        private function onButtonOut(event:MouseEvent):void{
            if (!(this.isEnabled)){
                return;
            };
            if (event.buttonDown){
                if (this.internalState == ButtonConstants.STATE_PRESSED){
                    this.mouseTransitionState(ButtonConstants.STATE_DRAG_OUT);
                };
            } else {
                this.mouseTransitionState(ButtonConstants.STATE_UP);
            };
            dispatchEvent(new Event(ButtonConstants.EVENT_HIDE_HINT));
            dispatchEvent(new Event(ButtonConstants.EVENT_OUT));
        }
        private function onAddedToStage(event:Event=null):void{
            var _loc_2:IMouse;
            if (this.eventsSet){
                return;
            };
            _loc_2 = MouseHandler.instance();
            _loc_2.addListener(this.mc, MouseEvent.MOUSE_DOWN, this.onButtonPress);
            _loc_2.addListener(this.mc, MouseEvent.MOUSE_OVER, this.onButtonOver);
            _loc_2.addListener(this.mc, MouseEvent.MOUSE_OUT, this.onButtonOut);
            this.updateButton();
            this.eventsSet = true;
        }
        public function get height():Number{
            return (this.mc.height);
        }
        public function get isSticky():Boolean{
            return (this._isSticky);
        }
        public function disableButton():void{
            this.isEnabled = false;
            this.mc.buttonMode = false;
            this.setState(ButtonConstants.STATE_UP);
        }
        public function get width():Number{
            return (this.mc.width);
        }
        public function getHintText():String{
            return (this.hintText);
        }
        public function setState(param1:int):void{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = this.getState();
            this.internalState = param1;
            _loc_3 = this.getState();
            if (_loc_2 != _loc_3){
                dispatchEvent(new Event(ButtonConstants.EVENT_STATE_CHANGED));
            };
        }
        private function onButtonPress(event:MouseEvent):void{
            if (!(this.isEnabled)){
                return;
            };
            if ((((this.internalState == ButtonConstants.STATE_UP)) || ((this.internalState == ButtonConstants.STATE_OVER)))){
                this.mouseTransitionState(ButtonConstants.STATE_PRESSED);
                dispatchEvent(new Event(ButtonConstants.EVENT_PRESSED));
                dispatchEvent(new Event(ButtonConstants.EVENT_HIDE_HINT));
                MouseHandler.instance().addGlobalMouseUpListener(this.onButtonRelease);
            };
        }
        private function onButtonRelease(param1:Boolean, param2:MouseEvent):void{
            if (!(this.isEnabled)){
                return;
            };
            if ((((((this.internalState == ButtonConstants.STATE_PRESSED)) || ((this.internalState == ButtonConstants.STATE_DOWN)))) && (param1))){
                this.mouseTransitionState(ButtonConstants.STATE_OVER);
                dispatchEvent(new Event(ButtonConstants.EVENT_RELEASED));
                dispatchEvent(new Event(ButtonConstants.EVENT_DISPLAY_HINT));
            } else {
                this.mouseTransitionState(ButtonConstants.STATE_UP);
                dispatchEvent(new Event(ButtonConstants.EVENT_RELEASEDOUTSIDE));
            };
            MouseHandler.instance().removeGlobalMouseUpListener(this.onButtonRelease);
        }
        private function mouseTransitionState(param1:int):void{
            if (this.isSticky){
                if (this.internalState == ButtonConstants.STATE_DOWN){
                    return;
                };
                if ((((this.internalState == ButtonConstants.STATE_PRESSED)) && ((param1 == ButtonConstants.STATE_OVER)))){
                    param1 = ButtonConstants.STATE_DOWN;
                };
            };
            this.setState(param1);
        }
        protected function updateButton():void{
            this.setState(this.internalState);
        }
        public function setHintText(param1:String):void{
            this.hintText = param1;
        }
        public function getState():int{
            switch (this.internalState){
                case ButtonConstants.STATE_PRESSED:
                    return (ButtonConstants.STATE_DOWN);
                case ButtonConstants.STATE_DRAG_OUT:
                    return (ButtonConstants.STATE_UP);
            };
            return (this.internalState);
        }
        private function onButtonOver(event:MouseEvent):void{
            if (!(this.isEnabled)){
                return;
            };
            if (event.buttonDown){
                if (this.internalState == ButtonConstants.STATE_DRAG_OUT){
                    this.mouseTransitionState(ButtonConstants.STATE_PRESSED);
                };
            } else {
                this.mouseTransitionState(ButtonConstants.STATE_OVER);
                dispatchEvent(new Event(ButtonConstants.EVENT_DISPLAY_HINT));
            };
            dispatchEvent(new Event(ButtonConstants.EVENT_OVER));
        }
        public function setButtonId(param1:String):void{
            this.id = param1;
        }
        public function set x(param1:Number):void{
            this.mc.x = param1;
        }
        public function set y(param1:Number):void{
            this.mc.y = param1;
        }
        private function onRemovedFromStage(event:Event):void{
            var _loc_2:IMouse;
            if (!(this.eventsSet)){
                return;
            };
            this.setState(ButtonConstants.STATE_UP);
            _loc_2 = MouseHandler.instance();
            _loc_2.removeListener(this.mc, MouseEvent.MOUSE_DOWN, this.onButtonPress);
            _loc_2.removeListener(this.mc, MouseEvent.MOUSE_OVER, this.onButtonOver);
            _loc_2.removeListener(this.mc, MouseEvent.MOUSE_OUT, this.onButtonOut);
            MouseHandler.instance().removeGlobalMouseUpListener(this.onButtonRelease);
            this.eventsSet = false;
        }
        public function get x():Number{
            return (this.mc.x);
        }
        public function get y():Number{
            return (this.mc.y);
        }
        public function getButtonId():String{
            return (this.id);
        }

    }
}//package com.mapplus.maps.controls.common 
