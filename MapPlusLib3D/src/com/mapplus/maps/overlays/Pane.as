//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class Pane extends WrappableEventDispatcher implements IPane, IPaneInternal {

        private var isInvalidating:Boolean;
        private var factory:ISpriteFactory;
        private var overlays:Array;
        private var prevZoom:Number;
        private var background:Sprite;
        private var _id:uint;
        private var foreground:Sprite;
        private var owner:IMapBase2;
        private var isLocked:Boolean;
        private var isVisible:Boolean;

        public function Pane(param1:uint, param2:ISpriteFactory){
            super();
            this._id = param1;
            this.factory = param2;
            background = param2.createComponent().getSprite();
            foreground = param2.createComponent().getSprite();
            background.mouseEnabled = false;
            background.mouseChildren = false;
            isInvalidating = false;
            isVisible = true;
            isLocked = false;
            overlays = [];
            prevZoom = NaN;
        }
        public function fromPaneCoordsToLatLng(param1:Point, param2:Boolean=false):LatLng{
            var _loc_3:LatLng;
            if (!getCamera()){
                return (null);
            };
            _loc_3 = getCamera().viewportToLatLng(param1);
            if (!param2){
                return (LatLng.wrapLatLng(_loc_3));
            };
            return (_loc_3);
        }
        override public function get interfaceChain():Array{
            return (["IPane"]);
        }
        public function show():void{
            visible = true;
        }
        public function getLatLngClosestToCenter(param1:LatLng):LatLng{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = getCamera().center.lng();
            _loc_3 = (param1.lng() - _loc_2);
            return (new LatLng(param1.lat(), (_loc_2 + MapUtil.wrap(_loc_3, -180, 180)), true));
        }
        public function shouldDepthSort():Boolean{
            return (((is3DView()) && ((getCamera().attitude.pitch > 1E-10))));
        }
        public function updatePosition(param1:Boolean=false):void{
            var _loc_2:Number = NaN;
            var _loc_3:Boolean;
            var _loc_4:Boolean;
            var _loc_5:int;
            if (((!(visible)) || (!(owner)))){
                return;
            };
            _loc_2 = getCamera().zoom;
            _loc_3 = !((_loc_2 == prevZoom));
            _loc_4 = ((param1) || (_loc_3));
            _loc_5 = 0;
            while (_loc_5 < overlays.length) {
                overlays[_loc_5].positionOverlay(_loc_4);
                _loc_5++;
            };
            if (shouldDepthSort()){
                orderMarkersByDepth();
            };
            prevZoom = _loc_2;
        }
        public function fromLatLngToPaneCoords(param1:LatLng, param2:Boolean=false):Point{
            if (!getCamera()){
                return (null);
            };
            return (getCamera().latLngToViewport((param2) ? getLatLngClosestToCenter(param1) : param1));
        }
        public function fromProjectionPointToPaneCoords(param1:Point):Point{
            var _loc_2:Camera;
            var _loc_3:Number = NaN;
            _loc_2 = getCamera();
            if (!_loc_2){
                return (null);
            };
            _loc_3 = _loc_2.zoomScale;
            return (_loc_2.worldToViewport(new Point((param1.x / _loc_3), (param1.y / _loc_3))));
        }
        public function getCamera():Camera{
            return (getMapInstance().getCamera());
        }
        public function getBackground():Sprite{
            return (background);
        }
        public function get paneManager():IPaneManager{
            return ((owner) ? owner.getPaneManager() : null);
        }
        public function getMap():IMap{
            return (map);
        }
        public function lock():void{
            isLocked = true;
        }
        private function onMarkerMoved(event:MapEvent):void{
            if (shouldDepthSort()){
                orderMarkersByDepth();
            };
        }
        public function invalidate():void{
            if (!isInvalidating){
                isInvalidating = true;
                foreground.addEventListener(Event.ENTER_FRAME, onInvalidate);
            };
        }
        public function get id():uint{
            return (_id);
        }
        public function getForeground():Sprite{
            return (foreground);
        }
        public function hide():void{
            visible = false;
        }
        public function unlock():void{
            isLocked = false;
            if (shouldDepthSort()){
                orderMarkersByDepth();
            };
        }
        public function clear():void{
            while (overlays.length > 0) {
                removeOverlay(overlays[0]);
            };
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            var _loc_4:DisplayObject;
            if (param1.pane != this){
                return;
            };
            dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_BEFORE_REMOVED, param1));
            if ((param1 is IMarker)){
                param1.removeEventListener(MapEvent.OVERLAY_MOVED, onMarkerMoved);
            };
            _loc_2 = 0;
            while (_loc_2 < overlays.length) {
                if (overlays[_loc_2] == param1){
                    overlays.splice(_loc_2, 1);
                    break;
                };
                _loc_2++;
            };
            _loc_3 = param1.foreground;
            _loc_4 = param1.shadow;
            factory.removeChild(foreground, _loc_3);
            if (_loc_4){
                factory.removeChild(background, _loc_4);
            };
            param1.pane = null;
            dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_REMOVED, param1));
        }
        public function setMapInstance(param1:IMapBase2):void{
            owner = param1;
        }
        private function dispatchOverlayEvent(param1:IOverlay, param2:Event):void{
            param1.dispatchEvent(param2.clone());
            dispatchEvent(param2.clone());
            if (getMapInstance()){
                getMapInstance().dispatchEvent(param2.clone());
            };
        }
        public function getMapInstance():IMapBase2{
            return (owner);
        }
        private function is3DView():Boolean{
            return (getCamera().is3D);
        }
        private function orderMarkersByDepth():void{
            var _loc_1:Array;
            var _loc_2:Camera;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:IDepthSortable;
            var _loc_6:LatLng;
            var _loc_7:Point;
            var _loc_8:IOverlay;
            var _loc_9:IOverlay;
            _loc_1 = [];
            _loc_2 = getCamera();
            _loc_3 = 0;
            while (_loc_3 < overlays.length) {
                _loc_5 = (overlays[_loc_3] as IDepthSortable);
                if (!_loc_5){
                } else {
                    _loc_6 = getLatLngClosestToCenter(_loc_5.getLatLng());
                    _loc_7 = _loc_2.latLngToWorld(_loc_6);
                    _loc_1.push({
                        index:_loc_3,
                        z:_loc_2.worldToViewportDistance(_loc_7)
                    });
                };
                _loc_3++;
            };
            _loc_1.sortOn("z", Array.NUMERIC);
            _loc_4 = (foreground.numChildren - 1);
            _loc_3 = 0;
            while (_loc_3 < _loc_1.length) {
                _loc_8 = overlays[_loc_1[_loc_3].index];
                if (Object(_loc_8).hasOwnProperty("infoWindow")){
                    _loc_9 = (Object(_loc_8).infoWindow as IOverlay);
                    if (((_loc_9) && ((_loc_9.foreground.parent == foreground)))){
                        var _temp1 = _loc_4;
                        _loc_4 = (_loc_4 - 1);
                        foreground.setChildIndex(_loc_9.foreground, _temp1);
                    };
                };
                var _temp2 = _loc_4;
                _loc_4 = (_loc_4 - 1);
                foreground.setChildIndex(_loc_8.foreground, _temp2);
                _loc_3++;
            };
        }
        public function get map():IMap{
            return (IMap(owner));
        }
        public function set visible(param1:Boolean):void{
            if (isVisible == param1){
                return;
            };
            isVisible = param1;
            foreground.visible = param1;
            background.visible = param1;
            updatePosition();
        }
        public function bringToTop(param1:IOverlay):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            if (((!((param1.pane == this))) || ((((param1 as Marker)) && (shouldDepthSort()))))){
                return;
            };
            _loc_2 = overlays.indexOf(param1);
            if (_loc_2 < 0){
                return;
            };
            _loc_3 = param1.foreground;
            foreground.setChildIndex(_loc_3, (foreground.numChildren - 1));
        }
        public function getViewportBounds():Rectangle{
            var _loc_1:Point;
            _loc_1 = getCamera().viewport;
            return (new Rectangle(0, 0, _loc_1.x, _loc_1.y));
        }
        public function get visible():Boolean{
            return (isVisible);
        }
        public function fromPaneCoordsToProjectionPoint(param1:Point):Point{
            var _loc_2:Camera;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            _loc_2 = getCamera();
            if (!_loc_2){
                return (null);
            };
            _loc_3 = _loc_2.zoomScale;
            _loc_4 = _loc_2.viewportToWorld(param1);
            Util.scalePoint(_loc_4, _loc_3);
            return (_loc_4);
        }
        private function onInvalidate(event:Event):void{
            foreground.removeEventListener(Event.ENTER_FRAME, onInvalidate);
            isInvalidating = false;
            updatePosition(true);
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
            factory.addChild(foreground, _loc_2);
            if (_loc_3){
                factory.addChild(background, _loc_3);
            };
            overlays.push(param1);
            dispatchOverlayEvent(param1, new MapEvent(MapEvent.OVERLAY_ADDED, param1));
            param1.positionOverlay(true);
            if ((param1 is IMarker)){
                param1.addEventListener(MapEvent.OVERLAY_MOVED, onMarkerMoved);
            };
            if (((shouldDepthSort()) && (!(isLocked)))){
                orderMarkersByDepth();
            };
        }

    }
}//package com.mapplus.maps.overlays 
