//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;
    import flash.geom.*;
    import com.mapplus.maps.core.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.events.*;

    public class Pane extends WrappableEventDispatcher implements IPane, IPaneInternal {

        private var isInvalidating:Boolean;
        private var factory:ISpriteFactory;
        private var overlays:Array;
        private var background:Sprite;
        private var prevZoom:Number;
        private var owner:IMapBase2;
        private var _id:uint;
        private var foreground:Sprite;
        private var isLocked:Boolean;
        private var isVisible:Boolean;

        public function Pane(param1:uint, param2:ISpriteFactory){
            super();
            this._id = param1;
            this.factory = param2;
            this.background = param2.createComponent().getSprite();
            this.foreground = param2.createComponent().getSprite();
            this.background.mouseEnabled = false;
            this.background.mouseChildren = false;
            this.isInvalidating = false;
            this.isVisible = true;
            this.isLocked = false;
            this.overlays = [];
            this.prevZoom = NaN;
        }
        override public function get interfaceChain():Array{
            return (["IPane"]);
        }
        public function fromLatLngToPaneCoords(param1:LatLng, param2:Boolean=false):Point{
            if (!(this.getCamera())){
                return (null);
            };
            return (this.getCamera().latLngToViewport((param2) ? this.getLatLngClosestToCenter(param1) : param1));
        }
        public function show():void{
            this.visible = true;
        }
        public function shouldDepthSort():Boolean{
            return (false);
        }
        public function updatePosition(param1:Boolean=false):void{
            var _loc_2:Number = NaN;
            var _loc_3:Boolean;
            var _loc_4:Boolean;
            var _loc_5:int;
            if (((!(this.visible)) || (!(this.owner)))){
                return;
            };
            _loc_2 = this.getCamera().zoom;
            _loc_3 = !((_loc_2 == this.prevZoom));
            _loc_4 = ((param1) || (_loc_3));
            _loc_5 = 0;
            while (_loc_5 < this.overlays.length) {
                this.overlays[_loc_5].positionOverlay(_loc_4);
                _loc_5++;
            };
            this.prevZoom = _loc_2;
        }
        public function fromProjectionPointToPaneCoords(param1:Point):Point{
            var _loc_2:Camera;
            var _loc_3:Number = NaN;
            _loc_2 = this.getCamera();
            if (!(_loc_2)){
                return (null);
            };
            _loc_3 = _loc_2.zoomScale;
            return (_loc_2.worldToViewport(new Point((param1.x / _loc_3), (param1.y / _loc_3))));
        }
        public function getCamera():Camera{
            return (this.getMapInstance().getCamera());
        }
        public function getLatLngClosestToCenter(param1:LatLng):LatLng{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = this.getCamera().center.lng();
            _loc_3 = (param1.lng() - _loc_2);
            return (new LatLng(param1.lat(), (_loc_2 + MapUtil.wrap(_loc_3, -180, 180)), true));
        }
        public function getBackground():Sprite{
            return (this.background);
        }
        public function get paneManager():IPaneManager{
            return ((this.owner) ? this.owner.getPaneManager() : null);
        }
        public function lock():void{
            this.isLocked = true;
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            var _loc_4:DisplayObject;
            if (param1.pane != this){
                return;
            };
            this.dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_BEFORE_REMOVED, param1));
            _loc_2 = 0;
            while (_loc_2 < this.overlays.length) {
                if (this.overlays[_loc_2] == param1){
                    this.overlays.splice(_loc_2, 1);
                    break;
                };
                _loc_2++;
            };
            _loc_3 = param1.foreground;
            _loc_4 = param1.shadow;
            this.factory.removeChild(this.foreground, _loc_3);
            if (_loc_4){
                this.factory.removeChild(this.background, _loc_4);
            };
            param1.pane = null;
            this.dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_REMOVED, param1));
        }
        public function getForeground():Sprite{
            return (this.foreground);
        }
        public function invalidate():void{
            if (!(this.isInvalidating)){
                this.isInvalidating = true;
                this.foreground.addEventListener(Event.ENTER_FRAME, this.onInvalidate);
            };
        }
        public function getMap():IMap{
            return (this.map);
        }
        public function unlock():void{
            this.isLocked = false;
        }
        public function fromPaneCoordsToLatLng(param1:Point, param2:Boolean=false):LatLng{
            var _loc_3:LatLng;
            if (!(this.getCamera())){
                return (null);
            };
            _loc_3 = this.getCamera().viewportToLatLng(param1);
            if (!(param2)){
                return (LatLng.wrapLatLng(_loc_3));
            };
            return (_loc_3);
        }
        public function hide():void{
            this.visible = false;
        }
        private function dispatchOverlayEvent(param1:IOverlay, param2:Event):void{
            param1.dispatchEvent(param2.clone());
            dispatchEvent(param2.clone());
            if (this.getMapInstance()){
                this.getMapInstance().dispatchEvent(param2.clone());
            };
        }
        public function setMapInstance(param1:IMapBase2):void{
            this.owner = param1;
        }
        private function is3DView():Boolean{
            return (this.getCamera().is3D);
        }
        public function get id():uint{
            return (this._id);
        }
        public function getMapInstance():IMapBase2{
            return (this.owner);
        }
        public function clear():void{
            while (this.overlays.length > 0) {
                this.removeOverlay(this.overlays[0]);
            };
        }
        public function get map():IMap{
            return (IMap(this.owner));
        }
        public function getViewportBounds():Rectangle{
            var _loc_1:Point;
            _loc_1 = this.getCamera().viewport;
            return (new Rectangle(0, 0, _loc_1.x, _loc_1.y));
        }
        public function get visible():Boolean{
            return (this.isVisible);
        }
        public function set visible(param1:Boolean):void{
            if (this.isVisible == param1){
                return;
            };
            this.isVisible = param1;
            this.foreground.visible = param1;
            this.background.visible = param1;
            this.updatePosition();
        }
        public function addOverlay(param1:IOverlay):void{
            var _loc_2:DisplayObject;
            var _loc_3:DisplayObject;
            if (param1.pane){
                param1.pane.removeOverlay(param1);
            };
            _loc_2 = param1.foreground;
            _loc_3 = param1.shadow;
            param1.pane = this;
            this.factory.addChild(this.foreground, _loc_2);
            if (_loc_3){
                this.factory.addChild(this.background, _loc_3);
            };
            this.overlays.push(param1);
            this.dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_ADDED, param1));
            param1.positionOverlay(true);
        }
        public function bringToTop(param1:IOverlay):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            if (((!((param1.pane == this))) || ((((param1 as Marker)) && (this.shouldDepthSort()))))){
                return;
            };
            _loc_2 = this.overlays.indexOf(param1);
            if (_loc_2 < 0){
                return;
            };
            _loc_3 = param1.foreground;
            this.foreground.setChildIndex(_loc_3, (this.foreground.numChildren - 1));
        }
        private function onInvalidate(event:Event):void{
            this.foreground.removeEventListener(Event.ENTER_FRAME, this.onInvalidate);
            this.isInvalidating = false;
            this.updatePosition(true);
        }
        public function fromPaneCoordsToProjectionPoint(param1:Point):Point{
            var _loc_2:Camera;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            _loc_2 = this.getCamera();
            if (!(_loc_2)){
                return (null);
            };
            _loc_3 = _loc_2.zoomScale;
            _loc_4 = _loc_2.viewportToWorld(param1);
            Util.scalePoint(_loc_4, _loc_3);
            return (_loc_4);
        }

    }
}//package com.mapplus.maps.overlays 
