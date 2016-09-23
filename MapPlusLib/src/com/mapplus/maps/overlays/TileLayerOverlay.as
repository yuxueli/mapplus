//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.core.*;
    import flash.events.*;
    import com.mapplus.maps.*;
    import flash.geom.*;

    public class TileLayerOverlay extends Overlay implements ITileLayerOverlay {

        private var _tileSize:int;
        private var tilePane:TilePane;
        private var tilesLoadedPending:Boolean;
        private var loadScheduler:LoadScheduler;
        private var _tileLayer:ITileLayer;
        private var _projection:IProjection;

        public function TileLayerOverlay(param1:ITileLayer, param2:int=0x0100, param3:IProjection=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            this._tileLayer = param1;
            this._tileSize = param2;
            this._projection = (param3) ? param3 : Bootstrap.getBootstrap().getMercatorProjection();
            if ((param1 is ITileLayerAsync)){
                this.loadScheduler = new LoadScheduler();
                this.loadScheduler.addEventListener(Event.COMPLETE, this.onLoadSchedulerComplete);
            };
        }
        override public function getDefaultPane(param1:IMap):IPane{
            return (IMapBase2(param1).getPane(PaneId.PANE_MAP));
        }
        private function onLoadSchedulerComplete(event:Event):void{
            if (((((this.tilesLoadedPending) && (this.tilePane))) && ((this.tilePane.loadedProportion() >= Util.ALL_TILES_LOADED)))){
                dispatchEvent(new MapEvent(MapEvent.TILES_LOADED, this));
                this.tilesLoadedPending = false;
            };
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            this.createTilePane();
        }
        public function get projection():IProjection{
            return (this._projection);
        }
        private function createTilePane():void{
            this.clearOldTilePane();
            if (!(map)){
                return;
            };
            this.tilePane = new TilePane(_foreground, this.tileLayer, this.tileSize, this.projection, true, this.loadScheduler);
            if (!(this.loadScheduler)){
                foreground.addEventListener(Event.ENTER_FRAME, this.onLoadSchedulerComplete);
            };
        }
        public function get tileLayer():ITileLayer{
            return (this._tileLayer);
        }
        public function get tileSize():int{
            return (this._tileSize);
        }
        override protected function onRemovedFromPane():void{
            this.clearOldTilePane();
            super.onRemovedFromPane();
        }
        public function refresh():void{
            this.createTilePane();
            this.positionOverlay(true);
        }
        override public function positionOverlay(param1:Boolean):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Rectangle;
            var _loc_6:Point;
            var _loc_7:Boolean;
            var _loc_8:Number = NaN;
            if (!(map)){
                return;
            };
            _loc_2 = map.getZoom();
            _loc_3 = Math.floor(_loc_2);
            _loc_4 = (_loc_2 - _loc_3);
            _loc_5 = pane.getViewportBounds();
            _loc_6 = map.getSize();
            if (this.loadScheduler){
                this.loadScheduler.clear();
            };
            _loc_7 = this.tilePane.update(map.getCenter(), map.getFocus(), _loc_3, _loc_6);
            _loc_8 = Math.pow(camera.base, _loc_4);
            _foreground.x = (((_loc_6.x * (1 - _loc_8)) / 2) + _loc_5.x);
            _foreground.y = (((_loc_6.y * (1 - _loc_8)) / 2) + _loc_5.y);
            _foreground.scaleX = _loc_8;
            _foreground.scaleY = _loc_8;
            if (this.loadScheduler){
                this.loadScheduler.start();
            };
            if (_loc_7){
                dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING, this));
                this.tilesLoadedPending = true;
            };
            this.onLoadSchedulerComplete(null);
        }
        private function clearOldTilePane():void{
            if (!(this.loadScheduler)){
                foreground.removeEventListener(Event.ENTER_FRAME, this.onLoadSchedulerComplete);
            };
            if (this.tilePane){
                this.tilePane.clear();
                this.tilePane = null;
            };
        }

    }
}//package com.mapplus.maps.overlays 
