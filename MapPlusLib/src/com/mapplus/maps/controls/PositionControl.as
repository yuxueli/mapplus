﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.geom.*;
    import com.mapplus.maps.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.controls.common.*;
    import flash.display.*;
    import com.mapplus.maps.styles.*;

    public class PositionControl extends MultiButtonControlBase implements IPositionControl {

        private static const HINT_ID_SOUTH:String = "pan_down";
        private static const HINT_ID_EAST:String = "pan_right";
        private static const HINT_ID_SAVED_POSITION:String = "last_result";
        private static const HINT_ID_NORTH:String = "pan_up";
        private static const HINT_ID_WEST:String = "pan_left";

        private static var defaultOptions:PositionControlOptions = createInitialDefaultOptions();
		
        private var options:PositionControlOptions;
		[Embed(source="/assets/images/PositionControl_EastIcon.png")]
        private var EastIcon:Class;
		[Embed(source="/assets/images/PositionControl_SouthIcon.png")]
        private var SouthIcon:Class;
		[Embed(source="/assets/images/PositionControl_WestIcon.png")]
        private var WestIcon:Class;
		[Embed(source="/assets/images/PositionControl_NorthIcon.png")]
        private var NorthIcon:Class;
		[Embed(source="/assets/images/PositionControl_CenterIcon.png")]
		private var CenterIcon:Class;

        public function PositionControl(param1:PositionControlOptions=null){
            super();
//            this.NorthIcon = PositionControl_NorthIcon;
//            this.SouthIcon = PositionControl_SouthIcon;
//            this.WestIcon = PositionControl_WestIcon;
//            this.EastIcon = PositionControl_EastIcon;
//            this.CenterIcon = PositionControl_CenterIcon;
            this.options = PositionControlOptions.merge([defaultOptions, param1]);
        }
        private static function createInitialDefaultOptions():PositionControlOptions{
            return (new PositionControlOptions({
                buttonSize:new Point(17, 17),
                buttonStyle:Util.getDefaultButtonStyle(),
                buttonSpacing:new Point(4, 4),
                position:new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 10)
            }));
        }

        private function getButtonSpacing():Point{
            return ((this.options.buttonSpacing as Point));
        }
        override public function get interfaceChain():Array{
            return (["IPositionControl", "IControl"]);
        }
        function initControlWithMapInternal(param1:IControllableMap):void{
            setMap(param1);
        }
        override protected function action(param1:String):void{
            var _loc_2:Point;
            switch (param1){
                case HINT_ID_NORTH:
                    _loc_2 = new Point(0, -(PConstants.DEFAULT_PANNING_DISTANCE));
                    this.map.panBy(_loc_2);
                    break;
                case HINT_ID_SOUTH:
                    _loc_2 = new Point(0, PConstants.DEFAULT_PANNING_DISTANCE);
                    this.map.panBy(_loc_2);
                    break;
                case HINT_ID_WEST:
                    _loc_2 = new Point(-(PConstants.DEFAULT_PANNING_DISTANCE), 0);
                    this.map.panBy(_loc_2);
                    break;
                case HINT_ID_EAST:
                    _loc_2 = new Point(PConstants.DEFAULT_PANNING_DISTANCE, 0);
                    this.map.panBy(_loc_2);
                    break;
                case HINT_ID_SAVED_POSITION:
                    this.map.returnToSavedPosition();
                    break;
            };
        }
        public function initControlWithMap(param1:IMap):void{
            this.initControlWithMapInternal((param1 as IControllableMap));
        }
        private function createControlButton(param1:String, param2:Number, param3:Number, param4:DisplayObject):void{
            var _loc_5:IconButton;
            _loc_5 = new IconButton(createButtonSprite());
            _loc_5.x = (param2 * (this.getButtonSize().x + this.getButtonSpacing().x));
            _loc_5.y = (param3 * (this.getButtonSize().y + this.getButtonSpacing().y));
            _loc_5.initialize(param1, this.getButtonSize(), this.getButtonStyle());
            _loc_5.setIcon(param4);
            _loc_5.setHintText(this.map.loadResourceString(param1));
            addButton(_loc_5);
        }
        public function getDefaultPosition():ControlPosition{
            return (new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, 10));
        }
        private function getButtonSize():Point{
            return ((this.options.buttonSize as Point));
        }
        override protected function createButtons():void{
            this.createControlButton(HINT_ID_NORTH, 1, 0, new this.NorthIcon());
            this.createControlButton(HINT_ID_SOUTH, 1, 2, new this.SouthIcon());
            this.createControlButton(HINT_ID_EAST, 2, 1, new this.EastIcon());
            this.createControlButton(HINT_ID_WEST, 0, 1, new this.WestIcon());
            this.createControlButton(HINT_ID_SAVED_POSITION, 1, 1, new this.CenterIcon());
        }
        private function getButtonStyle():ButtonStyle{
            return ((this.options.buttonStyle as ButtonStyle));
        }
        public function setControlPosition(param1:ControlPosition):void{
            this.options.position = param1;
            if (this.map){
                this.map.placeControl(this, this.getControlPosition());
            };
        }
        public function getControlPosition():ControlPosition{
            return (this.options.position);
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }

    }
}//package com.mapplus.maps.controls 
