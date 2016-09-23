//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class PaneManager extends WrapperBase implements IPaneManager, IPaneManagerInternal {

        private const FIRST_USER_PANE_ID:int = 0x0100;

        private var factory:ISpriteFactory;
        private var _panes:Array;
        private var _nextPaneId:int;
        private var isDragging:Boolean;
        private var _map:IMapBase2;
        private var currentCenter:LatLng;
        private var _mc:Sprite;
        private var currentAttitude:Attitude;
        private var shouldUpdate:Boolean;
        private var currentZoom:Number;
        private var currentMapType:IMapType;
        private var _panesById:Object;

        public function PaneManager(param1:IMapBase2, param2:Sprite, param3:ISpriteFactory){
            super();
            this._map = param1;
            this._mc = param2;
            this.factory = param3;
            _panes = [];
            _panesById = {};
            _nextPaneId = FIRST_USER_PANE_ID;
            _map.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapReadyInternal);
            _map.addEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            _map.addEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            _map.addEventListener(MapEvent.MAPTYPE_CHANGED, onInitialize);
            _map.addEventListener(MapMouseEvent.DRAG_START, onDragStart);
            _map.addEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            _map.addEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            _map.addEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            _map.addEventListener(MapZoomEvent.ZOOM_CHANGED, invalidate);
            _map.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        public function destroy():void{
            clearOverlays();
            removeAllPanes();
            _map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReadyInternal);
            _map.removeEventListener(MapEvent.VIEW_CHANGED, onInitialize);
            _map.removeEventListener(MapEvent.SIZE_CHANGED, onInitialize);
            _map.removeEventListener(MapEvent.MAPTYPE_CHANGED, onInitialize);
            _map.removeEventListener(MapMouseEvent.DRAG_START, onDragStart);
            _map.removeEventListener(MapMouseEvent.DRAG_END, onDragEnd);
            _map.removeEventListener(MapMoveEvent.MOVE_STEP, invalidate);
            _map.removeEventListener(MapZoomEvent.CONTINUOUS_ZOOM_STEP, invalidate);
            _map.removeEventListener(MapZoomEvent.ZOOM_CHANGED, invalidate);
            _map.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        private function onMapReadyInternal(event:Event):void{
            createDefaultPanes();
            _map.removeEventListener(MapEvent.MAP_READY_INTERNAL, onMapReadyInternal);
        }
        public function createPane(param1:int=-1):IPane{
            return (createPaneWithId(_nextPaneId, param1));
        }
        public function get paneCount():int{
            return (_panes.length);
        }
        public function removeAllPanes():void{
            var _loc_1:int;
            _loc_1 = 0;
            while (_loc_1 < _panes.length) {
                if (!removePaneIndex(_loc_1)){
                    _loc_1++;
                };
            };
        }
        public function placePaneShadow(param1:IPane, param2:IPane):void{
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            if (((!((param1.paneManager == this))) || (!((param2.paneManager == this))))){
                return;
            };
            _mc.removeChild(getPaneBackground(param1));
            _loc_3 = _mc.getChildIndex(getPaneForeground(param1));
            _loc_4 = _mc.getChildIndex(getPaneForeground(param2));
            _loc_5 = Math.min(_loc_3, _loc_4);
            _mc.addChildAt(getPaneBackground(param1), _loc_5);
        }
        public function clearOverlays():void{
            var _loc_1:IPaneInternal;
            for each (_loc_1 in _panes) {
                _loc_1.clear();
            };
        }
        private function insertPaneIndex(param1:IPaneInternal, param2:int):void{
            var _loc_3:int;
            var _loc_4:IPane;
            var _loc_5:DisplayObject;
            if ((((param2 < 0)) || ((param2 > _panes.length)))){
                param2 = _panes.length;
            };
            _loc_3 = 0;
            if (param2 != 0){
                _loc_4 = _panes[(param2 - 1)];
                _loc_5 = getPaneForeground(_loc_4);
                _loc_3 = (_mc.getChildIndex(_loc_5) + 1);
            };
            factory.addChildAt(_mc, getPaneBackground(param1), _loc_3);
            factory.addChildAt(_mc, getPaneForeground(param1), (_loc_3 + 1));
            _panes.splice(param2, 0, param1);
            _panesById[param1.id] = param1;
            if (param1.paneManager != this){
                param1.setMapInstance(_map);
                param1.updatePosition();
            };
        }
        public function updatePosition():void{
            var _loc_1:IPaneInternal;
            currentCenter = camera.center;
            currentMapType = map.getCurrentMapType();
            currentZoom = camera.zoom;
            currentAttitude = camera.attitude;
            for each (_loc_1 in _panes) {
                _loc_1.updatePosition();
            };
            shouldUpdate = false;
        }
        public function removePane(param1:IPane):void{
            if (!param1){
                return;
            };
            removePaneIndex(getPaneIndex(param1));
        }
        public function getPaneIndex(param1:IPane):int{
            var _loc_2:int;
            _loc_2 = 0;
            while (_loc_2 < _panes.length) {
                if (_panes[_loc_2] == param1){
                    return (_loc_2);
                };
                _loc_2++;
            };
            return (-1);
        }
        public function placePaneAt(param1:IPane, param2:int):void{
            var _loc_3:int;
            if (param1.id < FIRST_USER_PANE_ID){
                return;
            };
            if (((param1.paneManager) && (!((param1.paneManager == this))))){
                param1.paneManager.removePane(param1);
            };
            _loc_3 = getPaneIndex(param1);
            if (_loc_3 == param2){
                return;
            };
            if (_loc_3 >= 0){
                removePaneIndex(_loc_3, false);
            };
            insertPaneIndex(IPaneInternal(param1), param2);
        }
        private function createPaneWithId(param1:int, param2:int=-1):IPane{
            var _loc_3:IPaneInternal;
            var _loc_4:IPane;
            var _loc_5:int;
            if (param2 < 0){
                _loc_4 = getPaneById(PaneId.PANE_FLOAT);
                _loc_5 = getPaneIndex(_loc_4);
                if (_loc_5 >= 0){
                    param2 = _loc_5;
                };
            };
            _loc_3 = new Pane(param1, factory);
            insertPaneIndex(_loc_3, param2);
            if (_nextPaneId <= param1){
                _nextPaneId = (param1 + 1);
            };
            return (_loc_3);
        }
        public function containsPane(param1:IPane):Boolean{
            return ((getPaneIndex(param1) >= 0));
        }
        private function onDragEnd(event:Event):void{
            isDragging = false;
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.pane;
            if (_loc_2){
                _loc_2.removeOverlay(param1);
            };
        }
        public function showPanes(param1:Boolean):void{
            _mc.visible = true;
        }
        public function getPaneAt(param1:int):IPane{
            if ((((param1 < 0)) || ((param1 >= _panes.length)))){
                return (null);
            };
            return (_panes[param1]);
        }
        private function onEnterFrame(event:Event):void{
            if (shouldUpdate){
                updatePosition();
            };
        }
        private function invalidate(event:Event):void{
            if (((((((camera.center.equals(currentCenter)) && ((camera.zoom == currentZoom)))) && (Util.attitudeEquals(camera.attitude, currentAttitude)))) && ((map.getCurrentMapType() == currentMapType)))){
                return;
            };
            if (isDragging){
                shouldUpdate = true;
            } else {
                updatePosition();
            };
        }
        private function get camera():Camera{
            return ((_map as MapImpl).getCamera());
        }
        private function removePaneIndex(param1:int, param2:Boolean=true):Boolean{
            var _loc_3:IPaneInternal;
            if ((((param1 < 0)) || ((param1 >= _panes.length)))){
                return (false);
            };
            _loc_3 = _panes[param1];
            if (_loc_3.id < FIRST_USER_PANE_ID){
                return (false);
            };
            _mc.removeChild(getPaneForeground(_loc_3));
            _mc.removeChild(getPaneBackground(_loc_3));
            _panes.splice(param1, 1);
            delete _panesById[_loc_3.id];
            if (param2){
                _loc_3.clear();
                _loc_3.setMapInstance(null);
            };
            return (true);
        }
        private function getPaneForeground(param1:IPane):DisplayObject{
            return (IPaneInternal(param1).getForeground());
        }
        private function getPaneBackground(param1:IPane):DisplayObject{
            return (IPaneInternal(param1).getBackground());
        }
        private function onInitialize(event:Event):void{
            updatePosition();
        }
        public function getPaneById(param1:int):IPane{
            return (_panesById[param1]);
        }
        public function getMapInstance():IMapBase2{
            return (_map);
        }
        public function createDefaultPanes():void{
            createPaneWithId(PaneId.PANE_MAP);
            createPaneWithId(PaneId.PANE_OVERLAYS);
            createPaneWithId(PaneId.PANE_MARKER);
            createPaneWithId(PaneId.PANE_FLOAT);
        }
        public function removePanes():void{
            while (_panes.length > 1) {
                removePane(_panes[1]);
            };
        }
        public function hidePanes():void{
            _mc.visible = false;
        }
        public function get map():IMap{
            return (IMap(getMapInstance()));
        }
        private function onDragStart(event:Event):void{
            isDragging = true;
        }

    }
}//package com.mapplus.maps.overlays 
