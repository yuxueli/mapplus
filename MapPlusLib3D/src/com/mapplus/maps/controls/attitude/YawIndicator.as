//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.attitude {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public final class YawIndicator {

        private var container:Sprite;
		[Embed(source="/assets/images/YawIndicator_YawIndicator.png")]
        private var YawIndicatorBackground:Class;
        private var radius:Number;
        private var image:Sprite;
        private var map:IMapBase;
        private var yawAngle:Number;
        private var dragAngleDelta:Number;
        private var yawDial:Sprite;

        public function YawIndicator(param1:Sprite, param2:Number){
            super();
            //YawIndicatorBackground = YawIndicator_YawIndicatorBackground;
            dragAngleDelta = NaN;
            this.container = param1;
            this.radius = param2;
        }
        private function draw(param1:Number):void{
            var _loc_2:Matrix;
            this.yawAngle = param1;
            _loc_2 = new Matrix();
            _loc_2.rotate(((-(Math.PI) * param1) / 180));
            this.image.transform.matrix = _loc_2;
        }
        private function onButtonPress(event:MouseEvent):void{
            var _loc_2:IMouse;
            var _loc_3:Point;
            _loc_2 = MouseHandler.instance();
            _loc_2.addGlobalMouseMoveListener(this.onButtonDragged);
            _loc_2.addGlobalMouseUpListener(this.onButtonUp);
            _loc_3 = getLocalMouseCoords(event);
            this.dragAngleDelta = (this.yawAngle - ((180 * Math.atan2(_loc_3.x, _loc_3.y)) / Math.PI));
        }
        public function setMap(param1:IMapBase):void{
            var _loc_2:DisplayObject;
            var _loc_3:IMouse;
            if (param1 == null){
                removeFromMap();
                this.map = null;
                return;
            };
            this.map = param1;
            _loc_2 = new YawIndicatorBackground();
            _loc_2.x = (-(_loc_2.width) / 2);
            _loc_2.y = (-(_loc_2.height) / 2);
            this.image = Bootstrap.createChildSprite(this.container);
            this.image.addChild(_loc_2);
            this.yawDial = Bootstrap.createChildSprite(this.container);
            Render.setStroke(yawDial.graphics, Render.EMPTY_STROKE);
            Render.beginFill(yawDial.graphics, Render.EMPTY_FILL);
            Render.drawEllipse(yawDial.graphics, new Point(0, 0), new Point(radius, radius));
            Render.endFill(yawDial.graphics);
            param1.addEventListener(MapAttitudeEvent.ATTITUDE_CHANGE_STEP, onMapAttitudeChanged);
            _loc_3 = MouseHandler.instance();
            _loc_3.addListener(this.yawDial, MouseEvent.MOUSE_DOWN, this.onButtonPress);
            draw(getMapYaw());
        }
        private function onButtonDragged(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:Point;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_3 = getLocalMouseCoords(param2);
            _loc_4 = ((-180 * Math.atan2(_loc_3.x, _loc_3.y)) / Math.PI);
            _loc_5 = MapUtil.wrap((this.dragAngleDelta - _loc_4), -180, 180);
            setYaw(_loc_5);
            draw(_loc_5);
        }
        private function getMapYaw():Number{
            if (!map.getAttitude()){
                return (0);
            };
            return (map.getAttitude().yaw);
        }
        private function onButtonUp(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:IMouse;
            _loc_3 = MouseHandler.instance();
            _loc_3.removeGlobalMouseMoveListener(this.onButtonDragged);
            _loc_3.removeGlobalMouseUpListener(this.onButtonUp);
            this.dragAngleDelta = NaN;
        }
        private function setYaw(param1:Number):void{
            var _loc_2:Attitude;
            _loc_2 = map.getAttitude();
            map.setAttitude(new Attitude(param1, (_loc_2) ? _loc_2.pitch : 0, (_loc_2) ? _loc_2.roll : 0));
        }
        private function removeFromMap():void{
            var _loc_1:IMouse;
            var _loc_2:ISpriteFactory;
            map.removeEventListener(MapAttitudeEvent.ATTITUDE_CHANGE_STEP, onMapAttitudeChanged);
            _loc_1 = MouseHandler.instance();
            _loc_1.removeListener(this.yawDial, MouseEvent.MOUSE_DOWN, this.onButtonPress);
            _loc_2 = Bootstrap.getSpriteFactory();
            if (this.image != null){
                _loc_2.removeChild(this.container, this.image);
            };
        }
        private function onMapAttitudeChanged(event:MapAttitudeEvent):void{
            if (!isNaN(this.dragAngleDelta)){
                return;
            };
            draw(event.attitude.yaw);
        }
        private function getLocalMouseCoords(event:MouseEvent):Point{
            return (container.globalToLocal(new Point(event.stageX, event.stageY)));
        }

    }
}//package com.mapplus.maps.controls.attitude 
