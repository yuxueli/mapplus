//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.*;
    import flash.utils.*;

    public class PerspectiveTilePane implements ITilePane {

        private static const MAX_CACHED_TILES:Number = 100;
        private static const MAX_CHILD_DEPTH:int = 1;

        private var optimalSet:Array;
        private var worldClip:Rectangle;
        private var lastPurgeTime:int;
        private var camera:Camera;
        private var optimalLoaded:int;
        private var lastRenderTime:int;
        private var tileLayer:ITileLayer;
        private var enumerator:TileEnumerator;
        private var renderTileFn:Function;
        private var tileStore:TileStore;
        private var lastPurgeSize:int;
        private var lastTileLoadTime:int;
        private var canvas:Sprite;
        private var profilingTimer:Timer;
        private var renderSet:Array;
        private var fragmentSet:Array;
        private var loadScheduler:LoadScheduler;

        public function PerspectiveTilePane(param1:Sprite, param2:ITileLayer, param3:TileEnumerator, param4:LoadScheduler){
            super();
            renderTileFn = renderTile;
            this.canvas = param1;
            this.canvas.alpha = param2.getAlpha();
            this.tileLayer = param2;
            this.enumerator = param3;
            this.loadScheduler = param4;
            clear();
            lastRenderTime = 0;
            lastPurgeTime = 0;
            lastPurgeSize = 0;
        }
        private static function rectInFrontCamera(param1:Rectangle, param2:Homography):int{
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Boolean;
            var _loc_9:Boolean;
            var _loc_10:Boolean;
            var _loc_11:Boolean;
            _loc_3 = param2.contents;
            _loc_4 = param1.left;
            _loc_5 = param1.right;
            _loc_6 = param1.top;
            _loc_7 = param1.bottom;
            _loc_8 = ((((_loc_4 * _loc_3[6]) + (_loc_6 * _loc_3[7])) + _loc_3[8]) < 0);
            _loc_9 = ((((_loc_4 * _loc_3[6]) + (_loc_7 * _loc_3[7])) + _loc_3[8]) < 0);
            _loc_10 = ((((_loc_5 * _loc_3[6]) + (_loc_6 * _loc_3[7])) + _loc_3[8]) < 0);
            _loc_11 = ((((_loc_5 * _loc_3[6]) + (_loc_7 * _loc_3[7])) + _loc_3[8]) < 0);
            if (((((((_loc_8) && (_loc_9))) && (_loc_10))) && (_loc_11))){
                return (1);
            };
            if (((((((_loc_8) || (_loc_9))) || (_loc_10))) || (_loc_11))){
                return (0);
            };
            return (-1);
        }
        private static function removeAllChildren(param1:DisplayObjectContainer):void{
            while (param1.numChildren) {
                param1.removeChildAt(0);
            };
        }
        private static function getBitmapData(param1:HTile, param2:Rectangle):BitmapData{
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:BitmapData;
            _loc_3 = param2.width;
            _loc_4 = param2.height;
            if ((((_loc_3 <= 0)) || ((_loc_4 <= 0)))){
                return (null);
            };
            _loc_5 = new BitmapData(_loc_3, _loc_4, true, 0);
            if (!param1.bitmapData){
                return (null);
            };
            _loc_5.copyPixels(param1.bitmapData, param2, new Point(0, 0));
            return (_loc_5);
        }

        function getBitmapRectOfRelation(param1:HTile, param2:TileCoord):Rectangle{
            var _loc_3:Rectangle;
            var _loc_4:DisplayObject;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            _loc_3 = param2.getWorldBounds();
            _loc_4 = param1.tileDisplayObject;
            _loc_5 = (_loc_4.width / param1.bounds.width);
            _loc_6 = (_loc_4.height / param1.bounds.height);
            return (new Rectangle(MapUtil.wrapHalfOpen(((_loc_3.left - param1.bounds.left) * _loc_5), 0, _loc_4.width), MapUtil.wrapHalfOpen(((_loc_3.top - param1.bounds.top) * _loc_6), 0, _loc_4.height), (_loc_3.width * _loc_5), (_loc_3.height * _loc_6)));
        }
        public function onTileCreated(param1:TileLoader, param2:Object):void{
            var _loc_3:Number = NaN;
            var _loc_4:TileCoord;
            var _loc_5:HTile;
            _loc_3 = enumerator.tileSize;
            _loc_4 = new TileCoord(param1.x, param1.y, param1.zoom, _loc_3);
            _loc_5 = tileStore.lookup(_loc_4);
            if (_loc_5){
                _loc_5.setTile(param2, onTileContentLoaded);
            };
        }
        public function getTileLayer():ITileLayer{
            return (tileLayer);
        }
        private function render():Boolean{
            var _loc_1:Point;
            var _loc_2:Number = NaN;
            var _loc_3:Boolean;
            var _loc_4:int;
            tileStore.removePreLoadTiles();
            tileStore.clearTileCallbacks();
            if (!camera){
                return (false);
            };
            _loc_1 = camera.latLngToWorld(camera.center);
            _loc_2 = enumerator.tileSize;
            worldClip = new TileCoord(0, 0, 0, _loc_2).getWorldBounds();
            worldClip.offset((_loc_1.x - (_loc_2 * 0.5)), 0);
            _loc_3 = computeOptimalSet(worldClip);
            computeRenderSet();
            canvas.graphics.clear();
            _loc_4 = 0;
            while (_loc_4 < renderSet.length) {
                renderTileFn(renderSet[_loc_4], fragmentSet[_loc_4]);
                _loc_4++;
            };
            lastRenderTime = getTimer();
            return (_loc_3);
        }
        private function computeOptimalSet(param1:Rectangle):Boolean{
            var _loc_12:*;
            var _loc_2:Boolean;
            var _loc_3:Rectangle;
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:TileCoord;
            var _loc_7:HTile;
            var _loc_8:int;
            var _loc_9:TileLoader;
            var _loc_10:HTile;
            _loc_2 = false;
            _loc_3 = new Rectangle(0, 0, camera.viewport.x, camera.viewport.y);
            _loc_4 = enumerator.enumerateTiles(_loc_3, param1, camera);
            optimalSet = new Array(_loc_4.length);
            optimalLoaded = 0;
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length) {
                _loc_6 = _loc_4[_loc_5];
                _loc_7 = tileStore.lookup(_loc_6);
                if (!_loc_7){
                    tileStore.add(new HTile(_loc_6));
                    _loc_8 = 0;
                    _loc_9 = new TileLoader(this, _loc_8);
                    _loc_9.loadTile(_loc_6.x, _loc_6.wrappedX, _loc_6.y, _loc_6.zoom);
                    _loc_2 = true;
                    _loc_7 = tileStore.lookup(_loc_6);
                    if (((_loc_7) && (_loc_7.tileDisplayObject))){
                        _loc_12 = (optimalLoaded + 1);
                        optimalLoaded = _loc_12;
                    };
                } else {
                    if (((_loc_7.loadPending) || (!(_loc_7.tileDisplayObject)))){
                        _loc_10 = new HTile(_loc_6);
                        _loc_7.addLoadCompleteCallback(_loc_10, onTileContentLoaded);
                        _loc_2 = true;
                    } else {
                        _loc_12 = (optimalLoaded + 1);
                        optimalLoaded = _loc_12;
                    };
                };
                optimalSet[_loc_5] = _loc_6;
                _loc_5++;
            };
            return (_loc_2);
        }
        private function onProfileTimer(event:TimerEvent):void{
            Log.log2((((renderSet.length + " tiles on screen, ") + tileStore.size()) + " tiles in cache"));
        }
        function purgeCache():void{
            var _loc_1:int;
            var _loc_2:TileCoord;
            var _loc_3:Object;
            var _loc_4:String;
            var _loc_5:int;
            _loc_3 = {};
            for each (_loc_2 in renderSet) {
                _loc_3[_loc_2.getQuadTreePath()] = true;
            };
            for each (_loc_2 in optimalSet) {
                _loc_4 = _loc_2.getQuadTreePath();
                _loc_3[_loc_4] = true;
                _loc_5 = _loc_4.length;
                if (_loc_5 > 2){
                    _loc_3[_loc_4.substring(0, (_loc_5 - 1))] = true;
                };
                _loc_3[(_loc_4 + "q")] = true;
                _loc_3[(_loc_4 + "r")] = true;
                _loc_3[(_loc_4 + "s")] = true;
                _loc_3[(_loc_4 + "t")] = true;
            };
            tileStore.purge(_loc_3);
            lastPurgeTime = getTimer();
            lastPurgeSize = tileStore.size();
        }
        function getBitmapRect(param1:HTile):Rectangle{
            var _loc_2:DisplayObject;
            _loc_2 = param1.tileDisplayObject;
            return (new Rectangle(0, 0, _loc_2.width, _loc_2.height));
        }
        function findAncestor(param1:TileCoord):HTile{
            var _loc_2:String;
            var _loc_3:int;
            var _loc_4:HTile;
            _loc_2 = param1.getQuadTreePath();
            _loc_3 = _loc_2.length;
            while (_loc_3 > 0) {
                _loc_4 = tileStore.lookupById(_loc_2.substr(0, _loc_3));
                if (((_loc_4) && (_loc_4.tileDisplayObject))){
                    return (_loc_4);
                };
                _loc_3--;
            };
            return (null);
        }
        function onTileContentLoaded(param1:HTile):void{
            var _loc_8:*;
            var _loc_2:TileCoord;
            var _loc_3:TileCoord;
            var _loc_4:Number = NaN;
            _loc_2 = param1.coord;
            for each (_loc_3 in optimalSet) {
                if (_loc_3.equals(_loc_2)){
                    _loc_4 = enumerator.tileSize;
                    renderTileFn(_loc_2, new Rectangle(0, 0, _loc_4, _loc_4));
                    _loc_8 = (optimalLoaded + 1);
                    optimalLoaded = _loc_8;
                    return;
                };
            };
        }
        public function getLoadScheduler():LoadScheduler{
            return (loadScheduler);
        }
        public function clear():void{
            removeAllChildren(canvas);
            canvas.graphics.clear();
            if (tileStore){
                tileStore.clearTileCallbacks();
            };
            tileStore = new TileStore();
            optimalSet = [];
            renderSet = [];
            fragmentSet = [];
        }
        public function configure(param1:Camera):Boolean{
            var _loc_2:Boolean;
            var _loc_3:int;
            this.camera = param1;
            _loc_2 = render();
            _loc_3 = getTimer();
            if ((((_loc_3 >= (lastPurgeTime + 1000))) && ((tileStore.size() > (lastPurgeSize * 2))))){
                purgeCache();
            };
            return (_loc_2);
        }
        function findChildren(param1:TileCoord, param2:Number, param3:Array):Number{
            var _loc_4:HTile;
            var _loc_5:Number = NaN;
            _loc_4 = tileStore.lookup(param1);
            if (((_loc_4) && (_loc_4.tileDisplayObject))){
                param3.push(_loc_4);
                return (1);
            };
            if (param1.zoom < param2){
                _loc_5 = (((findChildren(param1.getChild(0, 0), param2, param3) + findChildren(param1.getChild(0, 1), param2, param3)) + findChildren(param1.getChild(1, 0), param2, param3)) + findChildren(param1.getChild(1, 1), param2, param3));
                return ((_loc_5 / 4));
            };
            return (0);
        }
        public function getDisplayObject():DisplayObject{
            return (canvas);
        }
        private function renderTile(param1:TileCoord, param2:Rectangle):void{
            var _loc_3:HTile;
            var _loc_4:DisplayObject;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Rectangle;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Homography;
            var _loc_11:int;
            var _loc_12:int;
            var _loc_13:BitmapData;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            _loc_3 = tileStore.lookup(param1);
            if (((!(_loc_3)) || (!(_loc_3.tileDisplayObject)))){
                return;
            };
            _loc_4 = _loc_3.tileDisplayObject;
            _loc_5 = _loc_4.width;
            _loc_6 = _loc_4.height;
            _loc_7 = param1.getWorldBounds();
            _loc_8 = (_loc_7.width / _loc_5);
            _loc_9 = (_loc_7.height / _loc_6);
            _loc_10 = Homography.multiply(camera.mapWorldToViewport, new Homography([_loc_8, 0, _loc_7.x, 0, _loc_9, _loc_7.y, 0, 0, 1]));
            _loc_11 = rectInFrontCamera(param2, _loc_10);
            if (_loc_11 < 0){
                return;
            };
            if (_loc_11 == 0){
                _loc_14 = param2.left;
                _loc_15 = param2.top;
                _loc_16 = (0.5 * param2.width);
                _loc_17 = (0.5 * param2.height);
                if ((((_loc_16 >= 32)) && ((_loc_17 >= 32)))){
                    renderTile(param1, new Rectangle(_loc_14, _loc_15, _loc_16, _loc_17));
                    renderTile(param1, new Rectangle((_loc_14 + _loc_16), _loc_15, _loc_16, _loc_17));
                    renderTile(param1, new Rectangle(_loc_14, (_loc_15 + _loc_17), _loc_16, _loc_17));
                    renderTile(param1, new Rectangle((_loc_14 + _loc_16), (_loc_15 + _loc_17), _loc_16, _loc_17));
                };
                return;
            };
            if ((((_loc_7.right < worldClip.left)) || ((_loc_7.left > worldClip.right)))){
                return;
            };
            if ((((_loc_7.left < worldClip.left)) || ((_loc_7.right > worldClip.right)))){
                _loc_18 = Math.max(param2.left, ((worldClip.left / _loc_8) - (param1.x * _loc_5)));
                _loc_19 = Math.min(param2.right, ((worldClip.right / _loc_8) - (param1.x * _loc_5)));
                param2 = new Rectangle(_loc_18, param2.top, (_loc_19 - _loc_18), param2.height);
            };
            _loc_12 = enumerator.tileSize;
            if (((((((!((param2.left == 0))) || (!((param2.right == _loc_12))))) || (!((param2.top == 0))))) || (!((param2.bottom == _loc_12))))){
                _loc_13 = getBitmapData(_loc_3, param2);
                if (!_loc_13){
                    return;
                };
                _loc_10.postMultiply(new Homography([1, 0, param2.left, 0, 1, param2.top, 0, 0, 1]));
                param2.offset(-(param2.left), -(param2.top));
            };
            if (!_loc_13){
                _loc_13 = _loc_3.bitmapData;
            };
            if (_loc_13){
                ImageTransformRenderer.render(_loc_13, param2, _loc_10.projectEuclidean, canvas.graphics, camera.viewport, 2);
            };
        }
        public function destroy():void{
            clear();
        }
        private function computeRenderSet():void{
            var _loc_1:TileCoord;
            var _loc_2:HTile;
            var _loc_3:Array;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:HTile;
            var _loc_7:HTile;
            renderSet = [];
            fragmentSet = [];
            for each (_loc_1 in optimalSet) {
                _loc_2 = tileStore.lookup(_loc_1);
                if (!_loc_2){
                } else {
                    if (!_loc_2.tileDisplayObject){
                        _loc_3 = [];
                        _loc_4 = (_loc_1.zoom + MAX_CHILD_DEPTH);
                        _loc_5 = findChildren(_loc_1, _loc_4, _loc_3);
                        if (_loc_5 < 0.999999){
                            _loc_7 = findAncestor(_loc_1);
                            if (_loc_7){
                                renderSet.push(_loc_7.coord.wrapToSameWorld(_loc_1));
                                fragmentSet.push(getBitmapRectOfRelation(_loc_7, _loc_1));
                            };
                        };
                        for each (_loc_6 in _loc_3) {
                            renderSet.push(_loc_6.coord.wrapToSameWorld(_loc_1));
                            fragmentSet.push(getBitmapRect(_loc_6));
                        };
                    } else {
                        renderSet.push(_loc_1);
                        fragmentSet.push(getBitmapRect(_loc_2));
                    };
                };
            };
        }
        public function loadedProportion():Number{
            if (((!(optimalSet)) || ((optimalSet.length == 0)))){
                return (0);
            };
            return ((optimalLoaded / optimalSet.length));
        }

    }
}//package com.mapplus.maps.core 
