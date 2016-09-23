//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.wrappers.*;

    public class PaneManager extends WrapperBase implements IPaneManager, IPaneManagerInternal {

        private const FIRST_USER_PANE_ID:int = 0x0100;

        private var factory:ISpriteFactory;
        private var _panes:Array;
        private var isDragging:Boolean;
        private var _nextPaneId:int;
        private var _map:IMapBase2;
        private var currentCenter:LatLng;
        private var _mc:Sprite;
        private var shouldUpdate:Boolean;
        private var currentZoom:Number;
        private var currentMapType:IMapType;
        private var _panesById:Object;

        public function PaneManager(param1:IMapBase2, param2:Sprite, param3:ISpriteFactory){
            super();
            this._map = param1;
            this._mc = param2;
            this.factory = param3;
            this._panes = [];
            this._panesById = {};
            this._nextPaneId = this.FIRST_USER_PANE_ID;
            this._map.addEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReadyInternal);
            this._map.addEventListener(MapEvent.SIZE_CHANGED, this.onInitialize);
            this._map.addEventListener(MapEvent.MAPTYPE_CHANGED, this.onInitialize);
            this._map.addEventListener(MapMouseEvent.DRAG_START, this.onDragStart);
            this._map.addEventListener(MapMouseEvent.DRAG_END, this.onDragEnd);
            this._map.addEventListener(MapMoveEvent.MOVE_STEP, this.invalidate);
            this._map.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, this.invalidate);
            this._map.addEventListener(MapZoomEvent.ZOOM_CHANGED, this.invalidate);
            this._map.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
        private function onMapReadyInternal(event:Event):void{
            this.createDefaultPanes();
            this._map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReadyInternal);
        }
        public function createPane(param1:int=-1):IPane{
            return (this.createPaneWithId(this._nextPaneId, param1));
        }
        public function removeAllPanes():void{
            var _loc_1:int;
            _loc_1 = 0;
            while (_loc_1 < this._panes.length) {
                if (!(this.removePaneIndex(_loc_1))){
                    _loc_1++;
                };
            };
        }
        public function clearOverlays():void{
            var _loc_1:IPaneInternal;
            for each (_loc_1 in this._panes) {
                _loc_1.clear();
            };
        }
        private function insertPaneIndex(param1:IPaneInternal, param2:int):void{
            var _loc_3:int;
            var _loc_4:IPane;
            var _loc_5:DisplayObject;
            if ((((param2 < 0)) || ((param2 > this._panes.length)))){
                param2 = this._panes.length;
            };
            _loc_3 = 0;
            if (param2 != 0){
                _loc_4 = this._panes[(param2 - 1)];
                _loc_5 = this.getPaneForeground(_loc_4);
                _loc_3 = (this._mc.getChildIndex(_loc_5) + 1);
            };
            this.factory.addChildAt(this._mc, this.getPaneBackground(param1), _loc_3);
            this.factory.addChildAt(this._mc, this.getPaneForeground(param1), (_loc_3 + 1));
            this._panes.splice(param2, 0, param1);
            this._panesById[param1.id] = param1;
            if (param1.paneManager != this){
                param1.setMapInstance(this._map);
                param1.updatePosition();
            };
        }
        public function destroy():void{
            this.clearOverlays();
            this.removeAllPanes();
            this._map.removeEventListener(MapEvent.MAP_READY_INTERNAL, this.onMapReadyInternal);
            this._map.removeEventListener(MapEvent.SIZE_CHANGED, this.onInitialize);
            this._map.removeEventListener(MapEvent.MAPTYPE_CHANGED, this.onInitialize);
            this._map.removeEventListener(MapMouseEvent.DRAG_START, this.onDragStart);
            this._map.removeEventListener(MapMouseEvent.DRAG_END, this.onDragEnd);
            this._map.removeEventListener(MapMoveEvent.MOVE_STEP, this.invalidate);
            this._map.removeEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, this.invalidate);
            this._map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, this.invalidate);
            this._map.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
        public function placePaneShadow(param1:IPane, param2:IPane):void{
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            if (((!((param1.paneManager == this))) || (!((param2.paneManager == this))))){
                return;
            };
            this._mc.removeChild(this.getPaneBackground(param1));
            _loc_3 = this._mc.getChildIndex(this.getPaneForeground(param1));
            _loc_4 = this._mc.getChildIndex(this.getPaneForeground(param2));
            _loc_5 = Math.min(_loc_3, _loc_4);
            this._mc.addChildAt(this.getPaneBackground(param1), _loc_5);
        }
        public function removePane(param1:IPane):void{
            if (!(param1)){
                return;
            };
            this.removePaneIndex(this.getPaneIndex(param1));
        }
        public function updatePosition():void{
            var _loc_1:IPaneInternal;
            this.currentCenter = this.camera.center;
            this.currentMapType = this.map.getCurrentMapType();
            this.currentZoom = this.camera.zoom;
            for each (_loc_1 in this._panes) {
                _loc_1.updatePosition();
            };
            this.shouldUpdate = false;
        }
        public function placePaneAt(param1:IPane, param2:int):void{
            var _loc_3:int;
            if (param1.id < this.FIRST_USER_PANE_ID){
                return;
            };
            if (((param1.paneManager) && (!((param1.paneManager == this))))){
                param1.paneManager.removePane(param1);
            };
            _loc_3 = this.getPaneIndex(param1);
            if (_loc_3 == param2){
                return;
            };
            if (_loc_3 >= 0){
                this.removePaneIndex(_loc_3, false);
            };
            this.insertPaneIndex(IPaneInternal(param1), param2);
        }
        private function createPaneWithId(param1:int, param2:int=-1):IPane{
            var _loc_3:IPaneInternal;
            var _loc_4:IPane;
            var _loc_5:int;
            if (param2 < 0){
                _loc_4 = this.getPaneById(PaneId.PANE_FLOAT);
                _loc_5 = this.getPaneIndex(_loc_4);
                if (_loc_5 >= 0){
                    param2 = _loc_5;
                };
            };
            _loc_3 = new Pane(param1, this.factory);
            this.insertPaneIndex(_loc_3, param2);
            if (this._nextPaneId <= param1){
                this._nextPaneId = (param1 + 1);
            };
            return (_loc_3);
        }
        public function containsPane(param1:IPane):Boolean{
            return ((this.getPaneIndex(param1) >= 0));
        }
        private function onDragEnd(event:Event):void{
            this.isDragging = false;
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.pane;
            if (_loc_2){
                _loc_2.removeOverlay(param1);
            };
        }
        private function onEnterFrame(event:Event):void{
            if (this.shouldUpdate){
                this.updatePosition();
            };
        }
        public function getPaneIndex(param1:IPane):int{
            var _loc_2:int;
            _loc_2 = 0;
            while (_loc_2 < this._panes.length) {
                if (this._panes[_loc_2] == param1){
                    return (_loc_2);
                };
                _loc_2++;
            };
            return (-1);
        }
        public function showPanes(param1:Boolean):void{
            this._mc.visible = true;
        }
        private function get camera():Camera{
            return ((this._map as MapImpl).getCamera());
        }
        public function getPaneAt(param1:int):IPane{
            if ((((param1 < 0)) || ((param1 >= this._panes.length)))){
                return (null);
            };
            return (this._panes[param1]);
        }
        private function invalidate(event:Event):void{
            if (((((this.camera.center.equals(this.currentCenter)) && ((this.camera.zoom == this.currentZoom)))) && ((this.map.getCurrentMapType() == this.currentMapType)))){
                return;
            };
            if (this.isDragging){
                this.shouldUpdate = true;
            } else {
                this.updatePosition();
            };
        }
        private function getPaneBackground(param1:IPane):DisplayObject{
            return (IPaneInternal(param1).getBackground());
        }
        private function getPaneForeground(param1:IPane):DisplayObject{
            return (IPaneInternal(param1).getForeground());
        }
        public function get paneCount():int{
            return (this._panes.length);
        }
        private function onInitialize(event:Event):void{
            this.updatePosition();
        }
        public function getPaneById(param1:int):IPane{
            return (this._panesById[param1]);
        }
        private function removePaneIndex(param1:int, param2:Boolean=true):Boolean{
            var _loc_3:IPaneInternal;
            if ((((param1 < 0)) || ((param1 >= this._panes.length)))){
                return (false);
            };
            _loc_3 = this._panes[param1];
            if (_loc_3.id < this.FIRST_USER_PANE_ID){
                return (false);
            };
            this._mc.removeChild(this.getPaneForeground(_loc_3));
            this._mc.removeChild(this.getPaneBackground(_loc_3));
            this._panes.splice(param1, 1);
           	delete this._panesById[_loc_3.id];
            if (param2){
                _loc_3.clear();
                _loc_3.setMapInstance(null);
            };
            return (true);
        }
        public function getMapInstance():IMapBase2{
            return (this._map);
        }
        public function createDefaultPanes():void{
            this.createPaneWithId(PaneId.PANE_MAP);
            this.createPaneWithId(PaneId.PANE_OVERLAYS);
            this.createPaneWithId(PaneId.PANE_MARKER);
            this.createPaneWithId(PaneId.PANE_FLOAT);
        }
        public function removePanes():void{
            while (this._panes.length > 1) {
                this.removePane(this._panes[1]);
            };
        }
        public function hidePanes():void{
            this._mc.visible = false;
        }
        public function get map():IMap{
            return (IMap(this.getMapInstance()));
        }
        private function onDragStart(event:Event):void{
            this.isDragging = true;
        }

    }
}//package com.mapplus.maps.overlays 
