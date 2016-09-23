//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.controls.common.*;
    import flash.utils.*;

    public class NavigationPosition extends MultiButtonControlBase {

        private static const DOWN_RECT:Rectangle = new Rectangle(-8, 8, 16, 16);
        private static const RIGHT_RECT:Rectangle = new Rectangle(8, -8, 16, 16);
        private static const UP_RECT:Rectangle = new Rectangle(-8, -24, 16, 16);
        private static const LEFT_RECT:Rectangle = new Rectangle(-24, -8, 16, 16);
        private static const HINT_ID_SAVED_POSITION:String = "last_result";
        private static const HINT_ID_LEFT:String = "pan_left";
        private static const CENTER_RECT:Rectangle = new Rectangle(-8, -8, 16, 16);
        private static const HINT_ID_RIGHT:String = "pan_right";
        private static const ICON_CENTER:Point = new Point(26, 26);
        private static const HINT_ID_DOWN:String = "pan_down";
        private static const HINT_ID_UP:String = "pan_up";
		[Embed(source="/assets/images/NavigationPosition_PositionIcon.png")]
        private var PositionIcon:Class;
        private var heldButtonId:String;
        private var heldButtonTimer:int;

        public function NavigationPosition(param1:Sprite){
            super();
            //PositionIcon = NavigationPosition_PositionIcon;
            legacyInitialize(param1, param1);
            heldButtonTimer = getTimer();
        }
        private function get continuousMove():Boolean{
            return (map.getCamera().is3D);
        }
        override protected function pressed(param1:String):void{
            heldButtonId = param1;
            heldButtonTimer = getTimer();
        }
        override protected function createButtons():void{
            var _loc_1:DisplayObject;
            _loc_1 = new PositionIcon();
            buttonsContainer.addChild(_loc_1);
            createControlButton(HINT_ID_UP, UP_RECT);
            createControlButton(HINT_ID_DOWN, DOWN_RECT);
            createControlButton(HINT_ID_RIGHT, RIGHT_RECT);
            createControlButton(HINT_ID_LEFT, LEFT_RECT);
            createControlButton(HINT_ID_SAVED_POSITION, CENTER_RECT);
        }
        public function getDisplayObject():DisplayObject{
            return (container);
        }
        private function onEnterFrame(event:Event):void{
            var _loc_2:int;
            var _loc_3:Number = NaN;
            _loc_2 = getTimer();
            if (((heldButtonId) && (continuousMove))){
                _loc_3 = Math.min(((5 * (_loc_2 - heldButtonTimer)) / 1000), 1);
                panMap(heldButtonId, _loc_3, false);
            };
            heldButtonTimer = _loc_2;
        }
        private function createControlButton(param1:String, param2:Rectangle):void{
            var _loc_3:Sprite;
            var _loc_4:ButtonBase;
            _loc_3 = createButtonSprite();
            _loc_3.x = ICON_CENTER.x;
            _loc_3.y = ICON_CENTER.y;
            Render.drawRect(_loc_3, param2, Color.WHITE, Alpha.UNSEEN, Color.WHITE, Alpha.UNSEEN);
            _loc_4 = new ButtonBase(_loc_3);
            _loc_4.setButtonId(param1);
            _loc_4.setHintText(map.loadResourceString(param1));
            addButton(_loc_4);
        }
        override protected function action(param1:String):void{
            if (param1 == HINT_ID_SAVED_POSITION){
                map.returnToSavedPosition();
            } else {
                if (!continuousMove){
                    panMap(param1, 1, true);
                };
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
        private function panMap(param1:String, param2:Number, param3:Boolean):void{
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            _loc_5 = (PConstants.DEFAULT_PANNING_DISTANCE * param2);
            switch (param1){
                case HINT_ID_UP:
                    _loc_4 = new Point(0, -(_loc_5));
                    break;
                case HINT_ID_DOWN:
                    _loc_4 = new Point(0, _loc_5);
                    break;
                case HINT_ID_LEFT:
                    _loc_4 = new Point(-(_loc_5), 0);
                    break;
                case HINT_ID_RIGHT:
                    _loc_4 = new Point(_loc_5, 0);
                    break;
            };
            if (_loc_4){
                map.panBy(_loc_4, param3);
            };
        }

    }
}//package com.mapplus.maps.controls 
