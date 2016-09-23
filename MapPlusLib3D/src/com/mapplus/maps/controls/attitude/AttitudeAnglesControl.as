//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.attitude {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;
    import flash.utils.*;

    public class AttitudeAnglesControl extends MultiButtonControlBase {

        private static const YAW_STEP:int = 10;
        private static const HINT_ID_PITCH_UP:String = "pitch_up";
        private static const RIGHT_RECT:Rectangle = new Rectangle(8, -8, 16, 16);
        private static const UP_RECT:Rectangle = new Rectangle(-8, -24, 16, 16);
        private static const PITCH_STEP:int = 6;
        private static const HINT_ID_PITCH_DOWN:String = "pitch_down";
        private static const ROLL_STEP:int = 5;
        public static const ANGLES_CAMERA_TILT:int = 2;
        private static const ICON_CENTER:Point = new Point(26, 26);
        private static const HINT_ID_ROLL_LEFT:String = "roll_left";
        private static const HINT_ID_YAW_RIGHT:String = "yaw_right";
        private static const DOWN_RECT:Rectangle = new Rectangle(-8, 8, 16, 16);
        private static const HINT_ID_EYE_RIGHT:String = "eye_right";
        private static const LEFT_RECT:Rectangle = new Rectangle(-24, -8, 16, 16);
        private static const HINT_ID_ROLL_RIGHT:String = "roll_right";
        private static const HINT_ID_EYE_LEFT:String = "eye_left";
        private static const HINT_ID_YAW_LEFT:String = "yaw_left";
        public static const ANGLES_YAW_PITCH:int = 1;
        private static const HINT_ID_EYE_UP:String = "eye_up";
        private static const HINT_ID_EYE_DOWN:String = "eye_down";
        public static const ANGLES_ROLL_PITCH:int = 0;

        private var heldButtonId:String;
        private var anglesMode:int;
		[Embed(source="/assets/images/AttitudeAnglesControl_RollPitch.png")]
        private var RollPitchIcon:Class;
        private var heldButtonTimer:int;

        public function AttitudeAnglesControl(param1:Sprite, param2:int){
            super();
            //RollPitchIcon = AttitudeAnglesControl_RollPitchIcon;
            this.container = param1;
            this.anglesMode = param2;
            heldButtonTimer = getTimer();
        }
        private function get continuousMove():Boolean{
            return (true);
        }
        override protected function createButtons():void{
            var _loc_1:DisplayObject;
            _loc_1 = new RollPitchIcon();
            _loc_1.x = -(ICON_CENTER.x);
            _loc_1.y = -(ICON_CENTER.y);
            buttonsContainer.addChild(_loc_1);
            switch (anglesMode){
                case ANGLES_ROLL_PITCH:
                    createControlButton(HINT_ID_PITCH_UP, UP_RECT);
                    createControlButton(HINT_ID_PITCH_DOWN, DOWN_RECT);
                    createControlButton(HINT_ID_ROLL_LEFT, LEFT_RECT);
                    createControlButton(HINT_ID_ROLL_RIGHT, RIGHT_RECT);
                    break;
                case ANGLES_YAW_PITCH:
                    createControlButton(HINT_ID_PITCH_UP, UP_RECT);
                    createControlButton(HINT_ID_PITCH_DOWN, DOWN_RECT);
                    createControlButton(HINT_ID_YAW_LEFT, LEFT_RECT);
                    createControlButton(HINT_ID_YAW_RIGHT, RIGHT_RECT);
                    break;
                case ANGLES_CAMERA_TILT:
                    createControlButton(HINT_ID_EYE_UP, UP_RECT);
                    createControlButton(HINT_ID_EYE_DOWN, DOWN_RECT);
                    createControlButton(HINT_ID_EYE_LEFT, LEFT_RECT);
                    createControlButton(HINT_ID_EYE_RIGHT, RIGHT_RECT);
                    break;
            };
        }
        override protected function pressed(param1:String):void{
            heldButtonId = param1;
            heldButtonTimer = getTimer();
        }
        private function onEnterFrame(event:Event):void{
            var _loc_2:int;
            var _loc_3:Number = NaN;
            _loc_2 = getTimer();
            if (((heldButtonId) && (continuousMove))){
                _loc_3 = Math.min(((3 * (_loc_2 - heldButtonTimer)) / 1000), 1);
                tiltMap(heldButtonId, _loc_3, false);
            };
            heldButtonTimer = _loc_2;
        }
        private function createControlButton(param1:String, param2:Rectangle):void{
            var _loc_3:Sprite;
            var _loc_4:ButtonBase;
            _loc_3 = createButtonSprite();
            Render.drawRect(_loc_3, param2, Color.WHITE, Alpha.UNSEEN, Color.WHITE, Alpha.UNSEEN);
            _loc_4 = new ButtonBase(_loc_3);
            _loc_4.setButtonId(param1);
            _loc_4.setHintText(map.loadResourceString(param1));
            addButton(_loc_4);
        }
        override protected function action(param1:String):void{
            if (!continuousMove){
                tiltMap(param1, 1, true);
            };
        }
        override public function setMap(param1:IControllableMap):void{
            if (this.map){
                this.map.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            };
            super.setMap(param1);
            if (param1){
                param1.addEventListener(Event.ENTER_FRAME, onEnterFrame);
            };
            heldButtonId = null;
        }
        override protected function released(param1:String):void{
            heldButtonId = null;
            heldButtonTimer = getTimer();
        }
        private function tiltMap(param1:String, param2:Number, param3:Boolean):void{
            var _loc_4:IMap3D;
            var _loc_5:Attitude;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Camera;
            var _loc_10:Attitude;
            var _loc_11:Point;
            var _loc_12:Attitude;
            var _loc_13:Number = NaN;
            var _loc_14:Camera;
            _loc_4 = (map as IMap3D);
            if (!_loc_4){
                return;
            };
            _loc_5 = _loc_4.getAttitude();
            _loc_6 = _loc_5.yaw;
            _loc_7 = _loc_5.pitch;
            _loc_8 = _loc_5.roll;
            switch (param1){
                case HINT_ID_PITCH_UP:
                case HINT_ID_EYE_UP:
                    _loc_7 = (_loc_7 + (PITCH_STEP * param2));
                    break;
                case HINT_ID_PITCH_DOWN:
                case HINT_ID_EYE_DOWN:
                    _loc_7 = (_loc_7 - (PITCH_STEP * param2));
                    break;
                case HINT_ID_ROLL_LEFT:
                    _loc_8 = (_loc_8 + (ROLL_STEP * param2));
                    break;
                case HINT_ID_ROLL_RIGHT:
                    _loc_8 = (_loc_8 - (ROLL_STEP * param2));
                    break;
                case HINT_ID_YAW_LEFT:
                case HINT_ID_EYE_LEFT:
                    _loc_6 = (_loc_6 - (YAW_STEP * param2));
                    break;
                case HINT_ID_YAW_RIGHT:
                case HINT_ID_EYE_RIGHT:
                    _loc_6 = (_loc_6 + (YAW_STEP * param2));
                    break;
            };
            _loc_9 = map.getCamera();
            _loc_10 = new Attitude(MapUtil.wrap(_loc_6, _loc_9.minYaw, _loc_9.maxYaw), Util.bound(_loc_7, _loc_9.minPitch, _loc_9.maxPitch), Util.bound(_loc_8, _loc_9.minRoll, _loc_9.maxRoll));
            _loc_11 = new Point(0, 0);
            _loc_12 = new Attitude(0, 0, 0);
            _loc_13 = (param3) ? 1 : 0;
            if ((((((((param1 == HINT_ID_EYE_UP)) || ((param1 == HINT_ID_EYE_DOWN)))) || ((param1 == HINT_ID_EYE_LEFT)))) || ((param1 == HINT_ID_EYE_RIGHT)))){
                _loc_12 = new Attitude((_loc_10.yaw - _loc_5.yaw), (_loc_5.pitch - _loc_10.pitch), 0);
                _loc_14 = _loc_9.tiltCamera(new Attitude((_loc_10.yaw - _loc_5.yaw), (_loc_10.pitch - _loc_5.pitch), 0));
                _loc_4.flyTo(_loc_14.center, _loc_14.zoom, _loc_14.attitude, _loc_13);
            } else {
                _loc_4.flyTo(_loc_9.center, _loc_9.zoom, _loc_10, _loc_13);
            };
        }

    }
}//package com.mapplus.maps.controls.attitude 
