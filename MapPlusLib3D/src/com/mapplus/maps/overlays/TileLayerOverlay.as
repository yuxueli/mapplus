//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;

    public class TileLayerOverlay extends Overlay implements ITileLayerOverlay {

        private var enumerator:TileEnumerator;
        private var tilesLoadedPending:Boolean;
        private var perspectiveTilePane:PerspectiveTilePane;
        private var _tileLayer:ITileLayer;
        private var _tileSize:int;
        private var loadScheduler:LoadScheduler;
        private var tilePane:TilePane;
        private var _projection:IProjection;

        public function TileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            this._tileLayer = param1;
            this._tileSize = param2;
            this._projection = (param3) ? param3 : Bootstrap.getBootstrap().getMercatorProjection();
            if ((param1 is ITileLayerAsync)){
                loadScheduler = new LoadScheduler();
                loadScheduler.addEventListener(Event.COMPLETE, onLoadSchedulerComplete);
            };
        }
        public function get tileLayer():ITileLayer{
            return (_tileLayer);
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            createTilePane();
        }
        public function get projection():IProjection{
            return (_projection);
        }
        private function createTilePane():void{
            var _loc_1:IMapType;
            var _loc_2:Number = NaN;
            clearOldTilePane();
            if (!map){
                return;
            };
            if (is3DView()){
                _loc_1 = map.getCurrentMapType();
                _loc_2 = ((PerspectiveConstants.AREA_RATIO_THRESHOLD * tileSize) * tileSize);
                enumerator = new TileEnumerator(tileSize, _loc_2, PerspectiveConstants.BREADTH_THRESHOLD, _loc_1.getMaximumResolution());
                perspectiveTilePane = new PerspectiveTilePane(_foreground, tileLayer, enumerator, loadScheduler);
                return;
            };
            tilePane = new TilePane(_foreground, tileLayer, tileSize, projection, true, loadScheduler);
            if (!loadScheduler){
                foreground.addEventListener(Event.ENTER_FRAME, onLoadSchedulerComplete);
            };
        }
        override public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_MAP));
        }
        public function refresh():void{
            createTilePane();
            positionOverlay(true);
        }
        public function get tileSize():int{
            return (_tileSize);
        }
        override protected function onRemovedFromPane():void{
            clearOldTilePane();
            super.onRemovedFromPane();
        }
        private function onLoadSchedulerComplete(event:Event):void{
            if (((((tilesLoadedPending) && (tilePane))) && ((tilePane.loadedProportion() >= Util.ALL_TILES_LOADED)))){
                dispatchEvent(new MapEvent(MapEvent.TILES_LOADED, this));
                tilesLoadedPending = false;
            };
        }
        private function clearOldTilePane():void{
            if (!loadScheduler){
                foreground.removeEventListener(Event.ENTER_FRAME, onLoadSchedulerComplete);
            };
            if (tilePane){
                tilePane.clear();
                tilePane = null;
            };
            if (perspectiveTilePane){
                perspectiveTilePane.clear();
                perspectiveTilePane = null;
            };
        }
        override public function positionOverlay(param1:Boolean):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Rectangle;
            var _loc_6:Point;
            var _loc_7:Boolean;
            var _loc_8:Number = NaN;
            if (!map){
                return;
            };
            _loc_2 = map.getZoom();
            _loc_3 = Math.floor(_loc_2);
            _loc_4 = (_loc_2 - _loc_3);
            _loc_5 = pane.getViewportBounds();
            _loc_6 = map.getSize();
            if (loadScheduler){
                loadScheduler.clear();
            };
            if (perspectiveTilePane){
                perspectiveTilePane.configure(camera);
            } else {
                _loc_7 = tilePane.update(map.getCenter(), map.getFocus(), _loc_3, _loc_6);
                _loc_8 = Math.pow(camera.base, _loc_4);
                _foreground.x = (((_loc_6.x * (1 - _loc_8)) / 2) + _loc_5.x);
                _foreground.y = (((_loc_6.y * (1 - _loc_8)) / 2) + _loc_5.y);
                _foreground.scaleX = _loc_8;
                _foreground.scaleY = _loc_8;
            };
            if (loadScheduler){
                loadScheduler.start();
            };
            if (_loc_7){
                dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING, this));
                tilesLoadedPending = true;
            };
            onLoadSchedulerComplete(null);
        }

    }
}//package com.mapplus.maps.overlays 
