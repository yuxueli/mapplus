//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.*;
    import flash.geom.*;

    public class ScrollTrackBase {

        private var _trackMc:DisplayObject;
        private var _levelHeight:Number;
        private var isDragging:Boolean;
        private var _minZoomLevel:Number;
        private var _scrollTrackBaseY:Number;
        private var mouseEventSet:Boolean;
        private var listener:IScrollTrackListener;
        private var _mc:Sprite;
        private var _scrollButton:ButtonBase;
        private var _maxZoomLevel:Number;
        private var hintText:String;
        private var _buttonBaseX:Number;
        private var _buttonBaseY:Number;
        private var _zoomLevel:Number;

        public function ScrollTrackBase(param1:Sprite){
            super();
            this._mc = param1;
            this._trackMc = null;
            this._scrollButton = null;
            this._scrollTrackBaseY = 0;
            this._buttonBaseX = 0;
            this._buttonBaseY = 0;
            this._levelHeight = 0;
            this._minZoomLevel = 0;
            this._maxZoomLevel = 0;
            this._zoomLevel = 0;
            this._mc.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            MouseHandler.instance().addListener(this._mc, MouseEvent.MOUSE_DOWN, this.stopMousePropagation);
        }
        public function get y():Number{
            return (this.mc.y);
        }
        private function stopDraggingButton():void{
            var _loc_1:IMouse;
            var _loc_2:Number = NaN;
            _loc_1 = MouseHandler.instance();
            _loc_1.removeGlobalMouseMoveListener(this.onMouseMove);
            if (!(this.isDragging)){
                return;
            };
            this.isDragging = false;
            MouseHandler.instance().stopDrag(this._scrollButton.mc);
            _loc_2 = this.getZoomLevelForScrollButton();
            this.zoomLevel = this.listener.changeZoomLevel(this, _loc_2, false);
        }
        private function stopMousePropagation(event:MouseEvent):void{
            event.stopPropagation();
        }
        public function setScrollTrackBackground(param1:DisplayObject, param2:Number, param3:Number):void{
            this._scrollTrackBaseY = param2;
            this._levelHeight = param3;
            this._trackMc = param1;
            Bootstrap.getSpriteFactory().addChildAt(this._mc, param1, 0);
            MouseHandler.instance().addListener(this._trackMc, MouseEvent.CLICK, this.onScrollTrackClick);
        }
        private function getZoomLevelForScrollButton():Number{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            _loc_1 = this._scrollButton.y;
            _loc_2 = (this._maxZoomLevel - ((_loc_1 - this._buttonBaseY) / this._levelHeight));
            return (Util.bound(_loc_2, this._minZoomLevel, this._maxZoomLevel));
        }
        public function get mc():Sprite{
            return (this._mc);
        }
        public function get buttonBase():Point{
            return (new Point(this._buttonBaseX, this._buttonBaseY));
        }
        public function get height():Number{
            return (this._trackMc.height);
        }
        public function getListener():IScrollTrackListener{
            return (this.listener);
        }
        private function getMouseEventXY(event:MouseEvent, param2:DisplayObject):Point{
            return (param2.globalToLocal(event.target.localToGlobal(new Point(event.localX, event.localY))));
        }
        private function onScrollTrackClick(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = this.getMouseEventXY(event, this.mc).y;
            _loc_3 = Util.bound((this._maxZoomLevel - ((_loc_2 - this._scrollTrackBaseY) / this._levelHeight)), this._minZoomLevel, this._maxZoomLevel);
            this._zoomLevel = this.listener.changeZoomLevel(this, _loc_3, true);
            this.updateControl();
        }
        public function setListener(param1:IScrollTrackListener):void{
            this.listener = param1;
        }
        public function get minZoomLevel():Number{
            return (this._minZoomLevel);
        }
        protected function draw():void{
        }
        public function get width():Number{
            return (this._trackMc.width);
        }
        public function get scrollTrackBaseY():Number{
            return (this._scrollTrackBaseY);
        }
        public function get levelHeight():Number{
            return (this._levelHeight);
        }
        public function onButtonReleased(event:Event):void{
            this.stopDraggingButton();
        }
        public function get scrollTrackBackground():DisplayObject{
            return (this._trackMc);
        }
        protected function updateControl():void{
            this.draw();
            if (this._scrollButton != null){
                this._scrollButton.x = this._buttonBaseX;
                this._scrollButton.y = (this._buttonBaseY + ((this._maxZoomLevel - this._zoomLevel) * this._levelHeight));
            };
        }
        public function setHintText(param1:String):void{
            this.hintText = param1;
        }
        public function get scrollButton():ButtonBase{
            return (this._scrollButton);
        }
        public function setScrollButton(param1:ButtonBase, param2:Point):void{
            this._scrollButton = param1;
            this._buttonBaseX = param2.x;
            this._buttonBaseY = param2.y;
            Bootstrap.getSpriteFactory().addChild(this._mc, param1.mc);
            this._scrollButton.addEventListener(ButtonConstants.EVENT_PRESSED, this.onButtonPressed);
            this._scrollButton.addEventListener(ButtonConstants.EVENT_RELEASED, this.onButtonReleased);
            this._scrollButton.addEventListener(ButtonConstants.EVENT_RELEASEDOUTSIDE, this.onButtonReleased);
        }
        public function set zoomLevel(param1:Number):void{
            if (this.isDragging){
                return;
            };
            this._zoomLevel = Util.bound(param1, this.minZoomLevel, this.maxZoomLevel);
            this.updateControl();
        }
        private function startDraggingButton():void{
            var _loc_1:Number = NaN;
            var _loc_2:IMouse;
            this.isDragging = true;
            _loc_1 = (this._levelHeight * (this._maxZoomLevel - this._minZoomLevel));
            _loc_2 = MouseHandler.instance();
            _loc_2.startDrag(this._scrollButton.mc, false, new Rectangle(this._buttonBaseX, this._buttonBaseY, 0, _loc_1));
            _loc_2.addGlobalMouseMoveListener(this.onMouseMove);
        }
        public function set maxZoomLevel(param1:Number):void{
            if (this.isDragging){
                return;
            };
            if (this._maxZoomLevel == param1){
                return;
            };
            this._maxZoomLevel = param1;
            this._zoomLevel = Math.min(this._zoomLevel, this._maxZoomLevel);
            this.updateControl();
        }
        public function get maxZoomLevel():Number{
            return (this._maxZoomLevel);
        }
        public function set x(param1:Number):void{
            this.mc.x = param1;
        }
        public function get zoomLevel():Number{
            return (this._zoomLevel);
        }
        public function onRemovedFromStage(event:Event):void{
            this.isDragging = false;
            MouseHandler.instance().removeGlobalMouseMoveListener(this.onMouseMove);
        }
        public function onMouseMove(param1:Boolean, param2:MouseEvent):void{
            var _loc_3:Number = NaN;
            if (!(this.isDragging)){
                return;
            };
            _loc_3 = Util.bound(this.getZoomLevelForScrollButton(), this.minZoomLevel, this.maxZoomLevel);
            this._zoomLevel = this.listener.changeZoomLevel(this, _loc_3, false);
        }
        public function onButtonPressed(event:Event):void{
            this.startDraggingButton();
        }
        public function set y(param1:Number):void{
            this.mc.y = param1;
        }
        protected function createScrollButton(param1:Sprite):ButtonBase{
            return (null);
        }
        public function set minZoomLevel(param1:Number):void{
            if (this.isDragging){
                return;
            };
            if (this._minZoomLevel == param1){
                return;
            };
            this._minZoomLevel = param1;
            this._zoomLevel = Math.max(this._zoomLevel, this._minZoomLevel);
            this.updateControl();
        }
        public function get x():Number{
            return (this.mc.x);
        }

    }
}//package com.mapplus.maps.controls.common 
