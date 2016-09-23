//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import flash.events.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.window.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.managers.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class MapImpl extends IWrappableSpriteWrapper implements IMap, IMapBase2, IControllableMap {

        public static const FLASH_MAPS_API_PATH:String = "/.mapplus.";
        private static const MOUSE_WHEEL_NULL_TIME:int = 80;
        private static const PAN_JUMP_ALLOW:int = 1;
        private static const CONTINUOUS_ZOOM_FRACTIONS:Number = 4;
        private static const DEFAULT_PANNING_DISTANCE:Number = 100;
        private static const PAN_JUMP_NONE:int = 0;
        private static const CENTER_CROSS_SIZE:Number = 10;
        private static const CENTER_CROSS_WIDTH:Number = 1;
        private static const MESSAGE_BOX_MIN_WIDTH:uint = 260;
        private static const TOOLTIP_COLOR:Number = 16777120;
        private static const PAN_JUMP_FORCE:int = 2;

        private static var copyrightPadL:Number = 2;
        private static var copyrightPadR:Number = 2;
        private static var viewer:MapImpl = null;
        private static var defaultOptions:MapOptions = new MapOptions({
            backgroundFillStyle:{
                alpha:Alpha.OPAQUE,
                color:Color.GRAY14
            },
            crosshairs:false,
            crosshairsStrokeStyle:{
                thickness:1,
                color:Color.BLACK,
                alpha:1,
                pixelHinting:false
            },
            controlByKeyboard:false,
            scrollWheelZoom:false,
            overlayRaising:true,
            doubleClickMode:MapAction.ACTION_PAN_ZOOM_IN,
            dragging:true,
            continuousZoom:false,
            mapType:null,
            mapTypes:null,
            center:new LatLng(0, 0),
            zoom:1,
            mouseClickRange:2
        });

        public var tooltip:TextField;
		[Embed(source="/assets/images/PoweredByLogo.png")]
        private var PoweredByLogo:Class;
        private var _controlByKeyboard:Boolean;
        private var isClickValid:Boolean;
        private var _doubleClickMode:Number;
        private var messageBox:MessageBox;
        private var _camera:Camera;
        private var zoomStart:Number;
        private var _dragged:Boolean;
        private var viewModeValue:int;
        private var usageType:String;
        private var mapTypes:Array;
        private var timedDoubleClick:TimedDoubleClick;
        private var container:Sprite;
        private var zoomRangeMin_:Number;
        private var _zoom:Number;
        private var mouseMoveStageCoords:Point;
        private var hlQueryParam:String;
        private var googleLogoPosition:ControlPosition;
        private var isMouseDown:Boolean;
        private var panSiner:Siner;
        private var _dragModeActive:int;
        private var _dragLocal:Point;
        private var tileManager:ITileManager;
        private var _loaded:Boolean;
        private var _overlayRaising:Boolean;
        private var controlByScrollWheel:Boolean;
        private var _center:LatLng;
        private var _mapType:IMapType;
        private var mcMaskPanes:Sprite;
        private var mc:Sprite;
        private var _backgroundFillStyle:FillStyle;
        private var focusBeforeContinuousZoom_:LatLng;
        private var savedCenter:LatLng;
        private var heldKeyboardEvent:KeyboardEvent;
        private var panStart:Point;
        private var viewportSize:Point;
        private var _crosshairsStrokeStyle:StrokeStyle;
        private var _moveVector:Point;
        private var _crosshairs:Boolean;
        private var _dragMode:int;
        private var usageTracker:UsageTracker;
        private var heldKeyboardTimer:int;
        private var controlsContainer:Sprite;
        private var spriteFactory:ISpriteFactory;
        private var focus_:LatLng;
        private var options:MapOptions;
        private var panesContainer:Sprite;
        private var timerMouseWheel:int;
        private var zoomTargetEnd:LatLng;
        private var savedZoom:Number;
        private var minZoomLevel_:Number;
        private var mcMaskTiles:Sprite;
        private var copyrightView:CopyrightView;
        private var zooming_:Boolean;
        private var tileSprite:Sprite;
        private var _dragCamera:Camera;
        private var paneManager:IPaneManagerInternal;
        private var panDestination:Point;
        private var zoomTarget:Number;
        private var clickValidRegion:Rectangle;
        private var mcFore:Sprite;
        private var zoomSiner:Siner;
        private var zoomTargetStart:LatLng;
        private var isDraggable:Boolean;
        private var googleLogo:DisplayObject;
        private var continuousZoom:Boolean;
        private var zoomBy:Number;
        private var maxZoomLevel_:Number;
        private var controlList:Array;
        private var mcBack:Sprite;
        private var isCopyrightSuppressed:Boolean;
        private var _isMovingY:Boolean;
        private var zoomRangeMax_:Number;
        private var _isMovingX:Boolean;
        private var _infoWindow:IInfoWindow;
        private var _configured:Boolean;
        private var _focusSprite:Sprite;

        public function MapImpl(param1:String=null, param2:MapOptions=null){
            super();
            //this.PoweredByLogo = MapImpl_PoweredByLogo;
            Log.log("Init...", 0);
            this.usageType = param1;
            this.options = MapOptions.merge([getDefaultOptions(), param2]);
            this._backgroundFillStyle = this.options.backgroundFillStyle;
            this._crosshairs = (this.options.crosshairs as Boolean);
            this._crosshairsStrokeStyle = this.options.crosshairsStrokeStyle;
            this._controlByKeyboard = (this.options.controlByKeyboard as Boolean);
            this.controlByScrollWheel = (this.options.scrollWheelZoom as Boolean);
            this._overlayRaising = (this.options.overlayRaising as Boolean);
            this._doubleClickMode = (this.options.doubleClickMode as Number);
            this.isDraggable = (this.options.dragging as Boolean);
            this.continuousZoom = (this.options.continuousZoom as Boolean);
            this.mapTypes = [];
            this._center = this.options.center;
            this._zoom = (this.options.zoom as Number);
            this.viewModeValue = 0;
            this._configured = false;
            this._loaded = false;
            this.viewportSize = new Point(0, 0);
            this.isMouseDown = false;
            this.spriteFactory = Bootstrap.getSpriteFactory();
            this.focus_ = null;
            this._camera = this.createCamera(this.MERCATOR_PROJECTION);
            this.minZoomLevel_ = 0;
            this.maxZoomLevel_ = Math.max(PConstants.MAX_RESOLUTION_MAP, PConstants.MAX_RESOLUTION_SATELLITE);
            this.zooming_ = false;
            this.zoomRangeMin_ = NaN;
            this.zoomRangeMax_ = NaN;
            this._moveVector = new Point(0, 0);
            this.timedDoubleClick = new TimedDoubleClick();
            this.isCopyrightSuppressed = false;
        }
        public static function getDefaultOptions():MapOptions{
            return (MapImpl.defaultOptions);
        }
        private static function maxResolutionZoomBound(param1:Number):Number{
            return (Util.bound(param1, 0, Math.max(PConstants.MAX_RESOLUTION_MAP, PConstants.MAX_RESOLUTION_SATELLITE)));
        }
        private static function matchesState(param1:Boolean, param2:int):Boolean{
            if (param2 == 0){
                return (true);
            };
            return (((param2 > 0)) ? param1 : !(param1));
        }
        private static function interpolateLatLngLinear(param1:LatLng, param2:LatLng, param3:Number):LatLng{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = (((1 - param3) * param1.lat()) + (param3 * param2.lat()));
            _loc_5 = (param3 * (param2.lng() - param1.lng()));
            _loc_5 = MapUtil.wrap(_loc_5, -180, 180);
            return (new LatLng(_loc_4, (param1.lng() + _loc_5)));
        }
        public static function clamp(param1:Number, param2:Number, param3:Number):Number{
            return (Math.min(param3, Math.max(param2, param1)));
        }
        private static function isAltCtrlShift(event:KeyboardEvent, param2:int, param3:int, param4:int):Boolean{
            return (((((matchesState(event.altKey, param2)) && (matchesState(event.ctrlKey, param3)))) && (matchesState(event.shiftKey, param4))));
        }

        private function size():void{
            var _loc_1:IControl;
            var _loc_2:ControlPosition;
            dispatchEvent(new MapEvent(MapEvent.SIZE_CHANGED, this));
            if (this.googleLogo){
                this.placeMovieClip(this.googleLogo, this.googleLogoPosition);
            };
            if (this.controlList){
                for each (_loc_1 in this.controlList) {
                    _loc_2 = _loc_1.getControlPosition();
                    if (_loc_2){
                        this.placeControl(_loc_1, _loc_1.getControlPosition());
                    };
                };
            };
            this.sizeCopyright();
            this.sizeMessageBox();
            this.draw();
        }
        private function configureFocusMouseListener(param1:Boolean):void{
            var _loc_2:Boolean;
            _loc_2 = this._focusSprite.hasEventListener(MouseEvent.MOUSE_DOWN);
            if (((param1) && (!(_loc_2)))){
                this._focusSprite.addEventListener(MouseEvent.MOUSE_DOWN, this.onFocusMouseDown);
            } else {
                if (((!(param1)) && (_loc_2))){
                    this._focusSprite.removeEventListener(MouseEvent.MOUSE_DOWN, this.onFocusMouseDown);
                };
            };
        }
        public function panTo(param1:LatLng):void{
            this.internalPanTo(this._camera.latLngToWorld(param1), PAN_JUMP_ALLOW);
        }
        public function moveDown(param1:Number=100):void{
            if (this.panSiner){
                return;
            };
            this.moveByGroundCoords(new Point(0, param1));
        }
        public function setMapType(param1:IMapType):void{
            if (!(this.isMapTypeRegistered(param1))){
                throw (new Error((("Invalid operation: map type not registered with the map (" + param1.getName()) + ")")));
            };
            this.configure(param1);
        }
        private function panToFitInfoWindow(event:Event):void{
            var _loc_2:InfoWindow;
            var _loc_3:Rectangle;
            if (event){
                event.target.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.panToFitInfoWindow);
            };
            _loc_2 = (this._infoWindow as InfoWindow);
            if (!(_loc_2)){
                return;
            };
            _loc_3 = _loc_2.getViewportBounds();
            _loc_3.inflate(4, 4);
            this.panToViewportRegion(_loc_3);
        }
        private function doPan():void{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            _loc_1 = this.panSiner.next();
            _loc_2 = Point.interpolate(this.panDestination, this.panStart, _loc_1);
            this._center = this.fromPointToLatLng(_loc_2, 0);
            this.configureCamera();
            dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, this.getCenter()));
            if (!(this.panSiner.more())){
                this.cancelPan();
            };
        }
        private function reportMouseDown(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        public function clearControls():void{
            while (((this.controlList) && ((this.controlList.length > 0)))) {
                this.removeControl(this.controlList[0]);
            };
        }
        public function openInfoWindow(param1:LatLng, param2:InfoWindowOptions=null):IInfoWindow{
            return (this.openInfoWindowOnOverlay(param1, null, param2));
        }
        public function controlByKeyboardEnabled():Boolean{
            return (this._controlByKeyboard);
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
            this.onContainerSet();
        }
        public function removeControl(param1:IControl):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            _loc_2 = this.controlList.indexOf(param1);
            if (_loc_2 < 0){
                return;
            };
            _loc_3 = param1.getDisplayObject();
            param1.initControlWithMap(null);
            this.controlList.splice(_loc_2, 1);
            this.spriteFactory.removeChild(this.controlsContainer, _loc_3);
            dispatchEvent(new MapEvent(MapEvent.CONTROL_REMOVED, param1));
            this.sizeCopyright();
        }
        public function loadResourceString(param1:String):String{
            return (this.getBootstrap().getMessage(param1));
        }
        public function getZoom():Number{
            return (this._zoom);
        }
        private function zoomContinuously(param1:Number, param2:Boolean=false, param3:LatLng=null, param4:Boolean=false):void{
            var _loc_5:Number = NaN;
            var _loc_6:LatLng;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            if (this.zooming_){
                if (((this.zoomSiner) && (param2))){
                    _loc_8 = this.mapBoundZoom((this.zoomTarget + param1), this._mapType, this.getCenter());
                    if (_loc_8 != this.zoomTarget){
                        this.zoomTarget = _loc_8;
                        _loc_9 = (_loc_8 - this._zoom);
                        this.zoomSiner.extend();
                        this.zoomStart = (this._zoom - (this.zoomSiner.fract() * _loc_9));
                        this.zoomBy = (_loc_8 - this.zoomStart);
                        this.tileManager.setTargetZoom(this.zoomTarget, false);
                    };
                };
                return;
            };
            _loc_5 = (param2) ? (this._zoom + param1) : param1;
            _loc_5 = this.mapBoundZoom(_loc_5, this._mapType, this.getCenter());
            if (_loc_5 == this._zoom){
                if (((param3) && (param4))){
                    this.panTo(param3);
                };
                return;
            };
            this.zoomTargetStart = this._center;
            this.zoomTargetEnd = (((param3) && (param4))) ? param3 : null;
            _loc_6 = null;
            if (param3){
                _loc_6 = param3;
            } else {
                if (((this.focus_) && (this.isLatLngVisible(this.focus_)))){
                    _loc_6 = this.focus_;
                } else {
                    _loc_6 = this._center;
                };
            };
            this.focusBeforeContinuousZoom_ = this.focus_;
            this.focus_ = _loc_6;
            _loc_7 = (((param3) && (param4))) ? 7 : 6;
            this.zoomTarget = _loc_5;
            this.zoomStart = this._zoom;
            this.zoomBy = (_loc_5 - this.zoomStart);
            this.zoomSiner = new Siner(_loc_7);
            this.zooming_ = true;
            this.tileManager.setTargetZoom(this.zoomTarget, false);
            dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_START, this.getZoom()));
            dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_START, this.getZoom()));
            dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, this.getCenter()));
            this.doContinuousZoom();
        }
        public function disableDragging():void{
            if (this._dragLocal){
                this.dragStop(null);
            };
            this.isDraggable = false;
        }
        private function onMouseDrag(param1:Boolean, param2:MouseEvent):void{
            if (!(this.isLoaded())){
                return;
            };
            if (this.tooltip){
                this.adjustTooltipPosition();
            };
            if (((!(this.isMouseDown)) || (this.panSiner))){
                return;
            };
            if (!(param1)){
                this.isMouseDown = false;
                if (this._dragLocal){
                    this.dragStop(param2);
                };
            } else {
                if (this._dragLocal){
                    this.dragMove(param2);
                };
            };
        }
        public function getDoubleClickMode():Number{
            return (this._doubleClickMode);
        }
        public function zoomIn(param1:LatLng=null, param2:Boolean=false, param3:Boolean=false):void{
            if (((this.continuousZoom) && (param3))){
                this.zoomContinuously(1, true, param1, param2);
            } else {
                this.zoomNoncontinuously(1, true, param1, param2);
            };
        }
        public function fromLatLngToPoint(param1:LatLng, param2:Number=NaN):Point{
            var _loc_3:Number = NaN;
            _loc_3 = Math.max(0, Math.floor((isNaN(param2)) ? this.getZoom() : param2));
            return (this.getProjection().fromLatLngToPixel(param1, _loc_3));
        }
        public function addOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.getDefaultPane(this);
            _loc_2.addOverlay(param1);
        }
        private function mapBoundZoom(param1:Number, param2:IMapType, param3:LatLng=null):Number{
            return (Util.bound(param1, this.getMinZoomLevel(param2, param3), this.getMaxZoomLevel(param2, param3)));
        }
        public function getSize():Point{
            return (this.viewportSize);
        }
        private function onInfoWindowClosing(event:Event):void{
            if (!(this._infoWindow)){
                return;
            };
            this._infoWindow.removeEventListener(MapEvent.OVERLAY_BEFORE_REMOVED, this.onInfoWindowClosing);
            if (this.paneManager){
                this.paneManager.placePaneShadow(this._infoWindow.pane, this._infoWindow.pane);
            };
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSING, this._infoWindow));
        }
        private function getFilledSize(param1:Number):Point{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:IControl;
            var _loc_7:ControlPosition;
            _loc_2 = 0;
            _loc_3 = 0;
            _loc_4 = 0;
            _loc_5 = this.controlList.length;
            while (_loc_4 < _loc_5) {
                _loc_6 = this.controlList[_loc_4];
                _loc_7 = _loc_6.getControlPosition();
                if (!(_loc_7)){
                } else {
                    if (_loc_7.getAnchor() == param1){
                        _loc_2 = Math.max(_loc_2, (_loc_6.getSize().x + _loc_7.getOffsetX()));
                        _loc_3 = Math.max(_loc_3, (_loc_6.getSize().y + _loc_7.getOffsetY()));
                    };
                };
                _loc_4++;
            };
            return (new Point(_loc_2, _loc_3));
        }
        public function disableContinuousZoom():void{
            this.continuousZoom = false;
        }
        private function getOptMapType(param1:IMapType):IMapType{
            return (((((param1) || (this._mapType))) || (this.mapTypes[0])));
        }
        private function addKeyDownListener(event:Event):void{
            this._focusSprite.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this._focusSprite.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            this._focusSprite.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.onKeyFocusChange);
            if (event){
                removeEventListener(Event.ADDED_TO_STAGE, this.addKeyDownListener);
            };
        }
        public function configureMap():void{
            var initMapType:* = null;
            if (this._loaded){
                return;
            };
            if (((this.options.mapTypes) && (this.options.mapTypes[0]))){
                this.mapTypes = this.options.mapTypes;
            } else {
                this.mapTypes = [];
                this.mapTypes = this.mapTypes.concat(this.getBootstrap().getDefaultMapTypes());
            };
            initMapType = this.options.mapType;
            if (!(initMapType)){
                initMapType = this.getBootstrap().getNormalMapType();
                if (this.mapTypes.indexOf(initMapType) < 0){
                    initMapType = this.mapTypes[0];
                };
            };
            this.internalSetMapType(initMapType);
            this.zoomTarget = this.getZoom();
            this._loaded = true;
            dispatchEvent(new MapEvent(MapEvent.MAP_READY_INTERNAL, null));
            if (this.getStage()){
                this.addKeyDownListener(null);
            } else {
                addEventListener(Event.ADDED_TO_STAGE, this.addKeyDownListener);
            };
            MouseHandler.instance().addListener(this.container, MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            if (this.tooltip){
                this.adjustTooltipPosition();
            };
            if (this.getBootstrap().isClientVersionAfter(8, "c")){
                dispatchEvent(new MapEvent(MapEvent.MAP_READY, this));
                this.tileManager.setTargetZoom(Math.floor(this.getZoom()), true);
                this.createUsageTracker();
                addEventListener(MapMoveEvent.MOVE_END, this.updateZoomRange);
            } else {
                DelayHandler.delayCall(function ():void{
                    tileManager.setTargetZoom(Math.floor(getZoom()), true);
                    createUsageTracker();
                    addEventListener(MapMoveEvent.MOVE_END, updateZoomRange);
                });
            };
            if (((this.getBootstrap().isClientVersionAfter(18, "b")) && (!(this.getBootstrap().getClientConfiguration().sensor)))){
                this.displayMessage((("<p><b>The Map.sensor parameter is missing. Please set sensor = " + "\"false\" or sensor = \"true\" or some services may not work.") + "</b></p>"));
            };
            this.savePosition();
        }
        public function disableControlByKeyboard():void{
            var _loc_1:IMapFocusableComponent;
            this._controlByKeyboard = false;
            _loc_1 = this.getFocusComponent();
            if (_loc_1){
                if (_loc_1.hasFocus()){
                    _loc_1.releaseFocus();
                };
                _loc_1.focusable = false;
            };
            this.configureFocusMouseListener(this._controlByKeyboard);
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!(this.container)){
                this.container = getSprite();
                this.onContainerSet();
            };
        }
        private function onDisplayMessage(event:MapEvent):void{
            this.displayMessage((event.feature as String));
        }
        private function onMouseRollOut(event:MouseEvent):void{
            if (!(this.isLoaded())){
                return;
            };
            event.stopPropagation();
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.ROLL_OUT, this, null));
        }
        private function moveByGroundCoords(param1:Point):void{
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            _loc_2 = this._camera.getWorldCenter();
            _loc_3 = this._camera.zoomScale;
            _loc_4 = new Point((param1.x / _loc_3), (param1.y / _loc_3));
            this.panTo(this._camera.worldToLatLng(_loc_2.add(_loc_4)));
        }
        private function onFocusMouseDown(event:Event):void{
            var _loc_2:IMapFocusableComponent;
            _loc_2 = this.getFocusComponent();
            if (_loc_2){
                _loc_2.grabFocus();
            };
        }
        private function getCopyrightExtentMin():Number{
            return ((copyrightPadL + Math.max((this.googleLogo) ? (this.googleLogo.x + this.googleLogo.width) : 0, this.getFilledSize(ControlPosition.ANCHOR_BOTTOM_LEFT).x)));
        }
        private function onKeyDown(event:KeyboardEvent):void{
            if (((!(this.isLoaded())) || (!(this._controlByKeyboard)))){
                return;
            };
            this.applyKeyboardEvent(event, 1, true);
        }
        public function moveRight(param1:Number=100):void{
            if (this.panSiner){
                return;
            };
            this.moveByGroundCoords(new Point(param1, 0));
        }
        private function sizeCopyright(event:Event=null):void{
            if (!(this.copyrightView)){
                return;
            };
            this.copyrightView.width = (this.getCopyrightExtentMax() - this.getCopyrightExtentMin());
            this.placeObject(this.copyrightView, new ControlPosition(ControlPosition.ANCHOR_BOTTOM_RIGHT, (this.viewportSize.x - this.getCopyrightExtentMax()), 2));
        }
        private function onDoubleClick(event:MouseEvent):void{
            var _loc_2:LatLng;
            _loc_2 = this.getMouseEventLatLng(event);
            switch (this._doubleClickMode){
                case MapAction.ACTION_PAN:
                    this.panTo(_loc_2);
                    break;
                case MapAction.ACTION_ZOOM_IN:
                    this.zoomIn(null, false, true);
                    break;
                case MapAction.ACTION_PAN_ZOOM_IN:
                    this.zoomIn(_loc_2, true, true);
                    break;
                case MapAction.ACTION_NOTHING:
                    break;
            };
            this.isMouseDown = false;
            if (this.isClickValid){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DOUBLE_CLICK, this, _loc_2));
            };
        }
        public function getMaxZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            var _loc_3:IMapType;
            var _loc_4:LatLng;
            var _loc_5:Number = NaN;
            _loc_3 = this.getOptMapType(param1);
            _loc_4 = ((param2) || (this._center));
            _loc_5 = _loc_3.getMaximumResolution(_loc_4);
            return (Math.min(_loc_5, this.maxZoomLevel_));
        }
        private function displayMessage(param1:String):void{
            if (this.messageBox){
                this.sizeMessageBox();
                this.messageBox.setText(param1);
            };
        }
        private function doContinuousZoom():void{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            if (this.zoomSiner){
                _loc_1 = this.zoomSiner.next();
                _loc_2 = (this.zoomStart + (_loc_1 * this.zoomBy));
                if (((this.zoomTargetStart) && (this.zoomTargetEnd))){
                    this._center = interpolateLatLngLinear(this.zoomTargetStart, this.zoomTargetEnd, _loc_1);
                } else {
                    this.postZoomCenter(_loc_2);
                };
                this._zoom = _loc_2;
                this.configureCamera();
                dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_STEP, this.getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_STEP, this.getZoom()));
                if (!(this.zoomSiner.more())){
                    this.zoomSiner = null;
                    this.finishContinuousZoom();
                };
            };
        }
        private function removeCopyrightView():void{
            var _loc_1:DisplayObjectContainer;
            if (this.copyrightView){
                this.copyrightView.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, this.sizeCopyright);
                _loc_1 = this.spriteFactory.getParent(this.copyrightView);
                if (_loc_1){
                    this.spriteFactory.removeChild(_loc_1, this.copyrightView);
                };
                this.copyrightView.unload();
                this.copyrightView = null;
            };
            if (this.googleLogo){
                _loc_1 = this.spriteFactory.getParent(this.googleLogo);
                if (_loc_1){
                    this.spriteFactory.removeChild(_loc_1, this.googleLogo);
                };
                this.googleLogo = null;
            };
        }
        private function onMouseWheel(event:MouseEvent):void{
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:Point;
            var _loc_5:LatLng;
            if (((!(this.isLoaded())) || (!(this.ownsMouseEvent(event))))){
                return;
            };
            event.stopPropagation();
            if (!(this.scrollWheelZoomEnabled())){
                return;
            };
            _loc_2 = getTimer();
            _loc_3 = (_loc_2 - this.timerMouseWheel);
            if ((((_loc_3 >= 0)) && ((_loc_3 < MOUSE_WHEEL_NULL_TIME)))){
                return;
            };
            this.timerMouseWheel = _loc_2;
            _loc_4 = this.getLocalCoords(event);
            _loc_5 = this.fromViewportToLatLng(_loc_4, true);
            if (event.delta < 0){
                this.zoomOut(_loc_5, true);
            } else {
                this.zoomIn(_loc_5, false, true);
            };
        }
        public function get dragMode():int{
            return (this._dragMode);
        }
        override public function get interfaceChain():Array{
            return (["IMap", "IWrappableEventDispatcher"]);
        }
        private function onMapTypeStyleChanged(event:Event):void{
            dispatchEvent(event);
        }
        public function invalidate():void{
            var map:* = null;
            DelayHandler.delayCall(function ():void{
                map.draw();
            });
        }
        private function draw():void{
            var _loc_1:Number = NaN;
            var _loc_2:Rectangle;
            var _loc_3:Number = NaN;
            var _loc_4:Rectangle;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:StrokeStyle;
            _loc_1 = 0;
            this.mcBack.graphics.clear();
            _loc_2 = this.getViewport();
            if (this._backgroundFillStyle.alpha > 0){
                Render.beginFill(this.mcBack.graphics, this._backgroundFillStyle);
                this.mcBack.graphics.lineStyle();
                this.mcBack.graphics.drawRect(_loc_2.left, _loc_2.top, _loc_2.width, _loc_2.height);
                this.mcBack.graphics.endFill();
            };
            this._focusSprite.graphics.clear();
            this._focusSprite.graphics.beginFill(Color.BLACK, Alpha.UNSEEN);
            this._focusSprite.graphics.drawRect(0, 0, _loc_2.width, _loc_2.height);
            this._focusSprite.x = _loc_2.left;
            this._focusSprite.x = _loc_2.top;
            this._focusSprite.width = _loc_2.width;
            this._focusSprite.height = _loc_2.height;
            this._focusSprite.graphics.endFill();
            this.mcFore.graphics.clear();
            if (this._crosshairs){
                _loc_5 = (this.viewportSize.x / 2);
                _loc_6 = (this.viewportSize.y / 2);
                _loc_7 = this._crosshairsStrokeStyle;
                this.mcFore.graphics.lineStyle((_loc_7.thickness as Number), (_loc_7.color as uint), (_loc_7.alpha as Number), (_loc_7.pixelHinting as Boolean));
                this.mcFore.graphics.moveTo(_loc_5, (_loc_6 - CENTER_CROSS_SIZE));
                this.mcFore.graphics.lineTo(_loc_5, (_loc_6 + CENTER_CROSS_SIZE));
                this.mcFore.graphics.moveTo((_loc_5 - CENTER_CROSS_SIZE), _loc_6);
                this.mcFore.graphics.lineTo((_loc_5 + CENTER_CROSS_SIZE), _loc_6);
            };
            this.mcMaskTiles.graphics.clear();
            this.mcMaskPanes.graphics.clear();
            _loc_3 = (2 * _loc_1);
            _loc_4 = Util.dilateRectangle(_loc_2, new Point(-(_loc_3), -(_loc_3)));
            Render.drawRect(this.mcMaskTiles, _loc_4, Color.BLUE, Alpha.PERCENT_20, Color.BLACK, Alpha.UNSEEN);
            Render.drawRect(this.mcMaskPanes, _loc_4, Color.BLUE, Alpha.PERCENT_20, Color.BLACK, Alpha.UNSEEN);
        }
        private function getStage():Stage{
            return (this.container.stage);
        }
        private function onInfoWindowClosed(event:Event):void{
            if (!(this._infoWindow)){
                return;
            };
            this._infoWindow.removeEventListener(MapEvent.OVERLAY_REMOVED, this.onInfoWindowClosed);
            this._infoWindow = null;
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSED, null));
        }
        private function panToViewportRegion(param1:Rectangle):void{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            _loc_2 = this.calcOffsetForViewportRegion(param1);
            _loc_3 = this.getViewportCenter().add(_loc_2);
            _loc_4 = this._camera.viewportToWorld(_loc_3);
            this.internalPanTo(_loc_4, PAN_JUMP_ALLOW);
        }
        public function placeMovieClip(param1:DisplayObject, param2:ControlPosition, param3:Point=null):void{
            this.placeObject(param1, param2, param3);
        }
        public function continuousZoomEnabled():Boolean{
            return (this.continuousZoom);
        }
        public function monitorCopyrightInternal(param1:MapImpl):void{
            if (!(this.copyrightView)){
                this.isCopyrightSuppressed = false;
                this.initCopyrightView();
            };
            this.copyrightView.monitorMap(param1);
        }
        public function suppressCopyrightInternal(param1:MapImpl):void{
            if (this.copyrightView){
                return;
            };
            this.isCopyrightSuppressed = true;
            param1.monitorCopyrightInternal(this);
        }
        private function onCopyrightsUpdated(event:Event):void{
            this.updateZoomRange();
        }
        private function createUsageTracker():void{
            this.usageTracker = new UsageTracker(this, this.usageType);
        }
        private function enterFrame(event:Event):void{
            this.initCopyrightView();
            if (this.panSiner){
                this.doPan();
            };
            if (this.zoomSiner){
                this.doContinuousZoom();
            };
            if (this.tileManager.isAnimatingBlend()){
                this.tileManager.iterateBlend();
            };
        }
        public function disableScrollWheelZoom():void{
            this.controlByScrollWheel = false;
        }
        public function addControl(param1:IControl):void{
            var _loc_2:ControlPosition;
            param1.initControlWithMap(this);
            this.controlList.push(param1);
            this.spriteFactory.addChild(this.controlsContainer, param1.getDisplayObject());
            _loc_2 = param1.getControlPosition();
            if (_loc_2){
                this.placeControl(param1, _loc_2);
            };
            dispatchEvent(new MapEvent(MapEvent.CONTROL_ADDED, param1));
            this.sizeCopyright();
        }
        public function enableScrollWheelZoom():void{
            this.controlByScrollWheel = true;
        }
        public function crosshairsEnabled():Boolean{
            return (this._crosshairs);
        }
        public function fromPointToLatLng(param1:Point, param2:Number=NaN, param3:Boolean=false):LatLng{
            var _loc_4:Number = NaN;
            _loc_4 = Math.max(0, Math.floor((isNaN(param2)) ? this.getZoom() : param2));
            return (this.getProjection().fromPixelToLatLng(param1, _loc_4, param3));
        }
        private function isOnVisibleWorld(param1:Point):Boolean{
            if (!(this._camera.isOnMap(param1))){
                return (false);
            };
            return (true);
        }
        public function getViewportCenter():Point{
            return (new Point((this.viewportSize.x / 2), (this.viewportSize.y / 2)));
        }
        private function isOverviewMap():Boolean{
            return ((this.usageType == UsageTracker.URL_ARGVAL_USAGETYPE_OVERVIEW));
        }
        private function setDefaultDragMode(event:MapMouseEvent):void{
        }
        public function disableCrosshairs():void{
            this._crosshairs = false;
            this.draw();
        }
        public function removeMapType(param1:IMapType):void{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = this.mapTypes.length;
            if (_loc_2 <= 1){
                return;
            };
            _loc_3 = 0;
            while (_loc_3 != _loc_2) {
                if (param1 == this.mapTypes[_loc_3]){
                    this.mapTypes.splice(_loc_3, 1);
                    if (this.getCurrentMapType() == param1){
                        this.configure(this.mapTypes[0]);
                    };
                    dispatchEvent(new MapEvent(MapEvent.MAPTYPE_REMOVED, param1));
                    return;
                };
                _loc_3++;
            };
        }
        private function configureCamera():void{
            var _loc_1:Point;
            _loc_1 = this.viewportSize;
            if ((((_loc_1.x <= 0)) || ((_loc_1.y <= 0)))){
                _loc_1 = new Point(0x0100, 0x0100);
            };
            this._camera.configure(this._center, this._zoom, _loc_1);
        }
        public function fromLatLngToViewport(param1:LatLng, param2:Boolean=false):Point{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!(param2)){
                _loc_3 = this.getCenter().lng();
                _loc_4 = MapUtil.wrap(param1.lng(), (_loc_3 - 180), (_loc_3 + 180));
                param1 = new LatLng(param1.lat(), _loc_4, true);
            };
            return (this._camera.latLngToViewport(param1));
        }
        public function get focusSprite():Sprite{
            return (this._focusSprite);
        }
        public function savePosition():void{
            this.savedCenter = this.getCenter();
            this.savedZoom = this.getZoom();
        }
        private function isMapTypeRegistered(param1:IMapType):Boolean{
            return ((this.mapTypes.indexOf(param1) >= 0));
        }
        public function getLatLngBounds():LatLngBounds{
            return (this._camera.getLatLngBounds());
        }
        public function panBy(param1:Point, param2:Boolean=true):void{
            var _loc_3:Point;
            var _loc_4:Point;
            _loc_3 = this.getViewportCenter();
            _loc_4 = this._camera.viewportToWorld(_loc_3.add(param1));
            this.internalPanTo(_loc_4, (param2) ? PAN_JUMP_NONE : PAN_JUMP_FORCE);
        }
        public function isLoaded():Boolean{
            return (this._loaded);
        }
        private function internalSetZoom(param1:Number):void{
            this.configure(null, param1);
        }
        public function setDoubleClickMode(param1:Number):void{
            switch (param1){
                case MapAction.ACTION_PAN:
                case MapAction.ACTION_ZOOM_IN:
                case MapAction.ACTION_PAN_ZOOM_IN:
                case MapAction.ACTION_NOTHING:
                    this._doubleClickMode = param1;
            };
        }
        private function onMousePress(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            var _loc_3:Boolean;
            if (((!(this.isLoaded())) || (!(this.ownsMouseEvent(event))))){
                return;
            };
            event.stopPropagation();
            this.isClickValid = true;
            this.clickValidRegion = new Rectangle(event.stageX, event.stageY);
            _loc_2 = (this.getOptions().mouseClickRange as Number);
            this.clickValidRegion.inflate(_loc_2, _loc_2);
            if (((!(this._loaded)) || (this._dragLocal))){
                return;
            };
            _loc_3 = this.timedDoubleClick.clickReturnTrueIfDoubleClick();
            if (_loc_3){
                this.onDoubleClick(event);
            };
            this.isMouseDown = true;
            MouseHandler.instance().addGlobalMouseUpListener(this.onMouseRelease);
            if (!(_loc_3)){
                MouseHandler.instance().addGlobalMouseMoveListener(this.onMouseDrag);
                if (((this.isDraggable) && (this.isOnVisibleWorld(this.getLocalCoords(event))))){
                    this.dragStart(event);
                };
            };
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.MOUSE_DOWN, this, this.getMouseEventLatLng(event)));
        }
        private function getMouseEventLatLng(event:MouseEvent):LatLng{
            return (this.fromViewportToLatLng(this.getLocalCoords(event)));
        }
        public function set dragMode(param1:int):void{
            this._dragMode = param1;
            this.updatePivotTarget();
        }
        public function getPaneManager():IPaneManager{
            return (this.paneManager);
        }
        public function fromViewportToLatLng(param1:Point, param2:Boolean=false):LatLng{
            var _loc_3:LatLng;
            _loc_3 = this._camera.viewportToLatLng(param1);
            if (!(param2)){
                return (LatLng.wrapLatLng(_loc_3));
            };
            return (_loc_3);
        }
        public function getMapTypes():Array{
            return (this.mapTypes);
        }
        private function calcOffsetForViewportRegion(param1:Rectangle):Point{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            var _loc_5:int;
            var _loc_6:IControl;
            var _loc_7:ControlPosition;
            var _loc_8:Rectangle;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            _loc_2 = 0;
            _loc_3 = 0;
            _loc_4 = this.getSize();
            if (param1.x < 0){
                _loc_2 = -(param1.x);
            } else {
                if (param1.right > _loc_4.x){
                    _loc_2 = (_loc_4.x - param1.right);
                };
            };
            if (param1.y < 0){
                _loc_3 = -(param1.y);
            } else {
                if (param1.bottom > _loc_4.y){
                    _loc_3 = (_loc_4.y - param1.bottom);
                };
            };
            _loc_5 = 0;
            while (_loc_5 < this.controlList.length) {
                _loc_6 = this.controlList[_loc_5];
                _loc_7 = _loc_6.getControlPosition();
                _loc_8 = this.getControlRect(_loc_6);
                _loc_9 = (param1.x + _loc_2);
                _loc_10 = (param1.y + _loc_3);
                _loc_11 = 0;
                _loc_12 = 0;
                switch (_loc_7.getAnchor()){
                    case ControlPosition.ANCHOR_TOP_LEFT:
                        if (_loc_10 < _loc_8.bottom){
                            _loc_11 = Math.max((_loc_8.right - _loc_9), 0);
                        };
                        if (_loc_9 < _loc_8.right){
                            _loc_12 = Math.max((_loc_8.bottom - _loc_10), 0);
                        };
                        break;
                    case ControlPosition.ANCHOR_BOTTOM_LEFT:
                        if ((_loc_10 + param1.height) > _loc_8.top){
                            _loc_11 = Math.max((_loc_8.right - _loc_9), 0);
                        };
                        if (_loc_9 < _loc_8.right){
                            _loc_12 = Math.min((_loc_8.top - (_loc_10 + param1.height)), 0);
                        };
                        break;
                    case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                        if ((_loc_10 + param1.height) > _loc_8.top){
                            _loc_11 = Math.min((_loc_8.left - (_loc_9 + param1.width)), 0);
                        };
                        if ((_loc_9 + param1.width) > _loc_8.left){
                            _loc_12 = Math.min((_loc_8.top - (_loc_10 + param1.height)), 0);
                        };
                        break;
                    case ControlPosition.ANCHOR_TOP_RIGHT:
                        if (_loc_10 < _loc_8.bottom){
                            _loc_11 = Math.min((_loc_8.left - (_loc_9 + param1.width)), 0);
                        };
                        if ((_loc_9 + param1.width) > _loc_8.left){
                            _loc_12 = Math.max((_loc_8.bottom - _loc_10), 0);
                        };
                        break;
                };
                if (Math.abs(_loc_12) < Math.abs(_loc_11)){
                    _loc_3 = (_loc_3 + _loc_12);
                } else {
                    _loc_2 = (_loc_2 + _loc_11);
                };
                _loc_5++;
            };
            return (new Point(-(_loc_2), -(_loc_3)));
        }
        public function getBoundsZoomLevel(param1:LatLngBounds):Number{
            if (this.getCurrentMapType()){
                return (this.getCurrentMapType().getBoundsZoomLevel(param1, this.getSize()));
            };
            return (NaN);
        }
        public function getCamera():Camera{
            return (this._camera);
        }
        public function getViewport():Rectangle{
            return (new Rectangle(0, 0, this.viewportSize.x, this.viewportSize.y));
        }
        private function applyKeyboardEvent(event:KeyboardEvent, param2:Number, param3:Boolean):void{
            var _loc_4:* = NaN;
            _loc_4 = this.getZoom();
            if (this.is3DView()){
                param2 = (param2 * (event.altKey ? 0.25 : 1));
            };
            if (event.charCode != 0){
                switch (String.fromCharCode(event.charCode)){
                    case "+":
                        this.setZoom((_loc_4 + param2), param3);
                        return;
                    case "-":
                        this.setZoom((_loc_4 - param2), param3);
                        return;
                };
            };
            switch (event.keyCode){
                case Keyboard.LEFT:
                    this.panBy(new Point((-(param2) * DEFAULT_PANNING_DISTANCE), 0), param3);
                    break;
                case Keyboard.RIGHT:
                    this.panBy(new Point((param2 * DEFAULT_PANNING_DISTANCE), 0), param3);
                    break;
                case Keyboard.UP:
                    this.panBy(new Point(0, (-(param2) * DEFAULT_PANNING_DISTANCE)), param3);
                    break;
                case Keyboard.DOWN:
                    this.panBy(new Point(0, (param2 * DEFAULT_PANNING_DISTANCE)), param3);
                    break;
                case Keyboard.PAGE_UP:
                    this.setZoom((_loc_4 + param2), param3);
                    break;
                case Keyboard.PAGE_DOWN:
                    this.setZoom((_loc_4 - param2), param3);
                    break;
            };
        }
        public function openInfoWindowOnOverlay(param1:LatLng, param2:IOverlay, param3:InfoWindowOptions=null):IInfoWindow{
            var _loc_4:InfoWindow;
            this.closeInfoWindow();
            _loc_4 = new InfoWindow(param1, param2, param3);
            this.addOverlay(_loc_4);
            _loc_4.addEventListener(MapEvent.OVERLAY_BEFORE_REMOVED, this.onInfoWindowClosing);
            _loc_4.addEventListener(MapEvent.OVERLAY_REMOVED, this.onInfoWindowClosed);
            this._infoWindow = _loc_4;
            if (_loc_4.initializationPending){
                _loc_4.addEventListener(MapEvent.COMPONENT_INITIALIZED, this.panToFitInfoWindow);
            } else {
                this.panToFitInfoWindow(null);
            };
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_OPENED, _loc_4));
            return (this._infoWindow);
        }
        private function activateTileManager(param1:int):void{
            var _loc_2:IProjection;
            if (((this.tileManager) && ((param1 == this.viewModeValue)))){
                return;
            };
            if (this.tileManager){
                this.tileManager.destroy();
            };
            this.viewModeValue = param1;
            this.tileManager = new TileManager(this, this.tileSprite, this.spriteFactory);
            _loc_2 = this.getProjection();
            this._camera = this.createCamera((_loc_2) ? _loc_2 : this.MERCATOR_PROJECTION);
            this.configureCamera();
        }
        private function getLocalCoords(event:MouseEvent):Point{
			trace("local "+event.localX+","+event.localY);
			trace("stage "+event.stageX+","+event.stageY);  
            //return (this.container.globalToLocal(new Point(event.stageX, event.stageY)));
			//采用event.stageX时，当采用嵌入页面方式加载地图时，鼠标滚轮放大缩小不准确    BY YUXUELI 2011.12.5
			return (this.container.globalToLocal(new Point(event.localX, event.localY)));
        }
        public function set mouseClickRange(param1:Number):void{
            this.options.mouseClickRange = param1;
        }
        public function getProjection():IProjection{
            return ((this.getCurrentMapType()) ? this.getCurrentMapType().getProjection() : null);
        }
        public function moveUp(param1:Number=100):void{
            if (this.panSiner){
                return;
            };
            this.moveByGroundCoords(new Point(0, -(param1)));
        }
        private function reportMouseUp(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        public function getMapsHost():String{
            return (this.getBootstrap().getMapsHost());
        }
        public function placeControl(param1:IControl, param2:ControlPosition):void{
            var _loc_3:DisplayObject;
            _loc_3 = param1.getDisplayObject();
            this.placeMovieClip(_loc_3, param2, param1.getSize());
        }
        private function createMessageBox():void{
            if (this.isOverviewMap()){
                return;
            };
            this.messageBox = new MessageBox();
            this.spriteFactory.addChild(this.container, this.messageBox);
            this.getBootstrap().addEventListener(MapEvent.DISPLAY_MESSAGE, this.onDisplayMessage);
        }
        private function updateZoomRange(event:Event=null):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = this.getMinZoomLevel();
            _loc_3 = this.getMaxZoomLevel();
            if (((!((_loc_2 == this.zoomRangeMin_))) || (!((_loc_3 == this.zoomRangeMax_))))){
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_RANGE_CHANGED, this.getZoom()));
                this.zoomRangeMin_ = _loc_2;
                this.zoomRangeMax_ = _loc_3;
            };
        }
        private function is3DView():Boolean{
            return (false);
        }
        public function getOptions():MapOptions{
            return (this.options);
        }
        public function get maxZoomLevel():Number{
            return (this.maxZoomLevel_);
        }
        public function displayHint(param1:String):void{
            if (param1){
                this.tooltip.htmlText = (("<p>" + param1) + "</p>");
                this.tooltip.width = (this.tooltip.textWidth + 5);
                this.tooltip.height = (this.tooltip.textHeight + 5);
                this.adjustTooltipPosition();
                this.tooltip.visible = true;
            } else {
                this.tooltip.visible = false;
            };
        }
        public function set overlayRaising(param1:Boolean):void{
            this._overlayRaising = param1;
        }
        public function enableCrosshairs():void{
            this._crosshairs = true;
            this.draw();
        }
        public function closeInfoWindow():Boolean{
            if (this._infoWindow){
                this._infoWindow.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.panToFitInfoWindow);
                this.removeOverlay(this._infoWindow);
                this._infoWindow = null;
                return (true);
            };
            return (false);
        }
        public function zoomOut(param1:LatLng=null, param2:Boolean=false):void{
            if (((this.continuousZoom) && (param2))){
                this.zoomContinuously(-1, true, param1, false);
            } else {
                this.zoomNoncontinuously(-1, true, param1, false);
            };
        }
        public function scrollWheelZoomEnabled():Boolean{
            return (this.controlByScrollWheel);
        }
        private function ownsMouseEvent(event:MouseEvent):Boolean{
            var _loc_2:DisplayObject;
            _loc_2 = (event.target as DisplayObject);
            while (_loc_2) {
                if (_loc_2 == this.controlsContainer){
                    return (false);
                };
                if (_loc_2 == this.container){
                    break;
                };
                _loc_2 = this.spriteFactory.getParent(_loc_2);
            };
            return (true);
        }
        private function onKeyFocusChange(event:FocusEvent):void{
            var _loc_2:Object;
            _loc_2 = {};
            _loc_2[Keyboard.LEFT] = true;
            _loc_2[Keyboard.RIGHT] = true;
            _loc_2[Keyboard.UP] = true;
            _loc_2[Keyboard.DOWN] = true;
            _loc_2[Keyboard.NUMPAD_ADD] = true;
            _loc_2[187] = true;
            _loc_2[Keyboard.NUMPAD_SUBTRACT] = true;
            _loc_2[189] = true;
            _loc_2[78] = true;
            _loc_2[85] = true;
            _loc_2[82] = true;
            if (_loc_2.hasOwnProperty(event.keyCode)){
                event.preventDefault();
            };
        }
        private function internalSetMapType(param1:IMapType):void{
            if (this._mapType != param1){
                if (this._mapType){
                    this._mapType.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
                    this._mapType.removeEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, this.onMapTypeStyleChanged);
                };
                this._mapType = param1;
                this._mapType.addEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
                this._mapType.addEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, this.onMapTypeStyleChanged);
                this._camera = this.createCamera(param1.getProjection());
                this.configureCamera();
                this.updateZoomRange();
            };
        }
        private function onKeyUp(event:KeyboardEvent):void{
            this.heldKeyboardEvent = null;
        }
        private function adjustTooltipPosition():void{
            var _loc_1:Point;
            var _loc_2:int;
            if (!(this.mouseMoveStageCoords)){
                return;
            };
            _loc_1 = this.container.globalToLocal(this.mouseMoveStageCoords);
            this.tooltip.x = (_loc_1.x + 20);
            this.tooltip.y = (_loc_1.y + 20);
            _loc_2 = (this.tooltip.x + this.tooltip.textWidth);
            if (_loc_2 >= this.viewportSize.x){
                this.tooltip.x = (_loc_1.x - (this.tooltip.textWidth + 20));
            };
        }
        private function setMinZoomLevel(param1:Number):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = maxResolutionZoomBound(param1);
            if (_loc_2 == this.minZoomLevel_){
                return;
            };
            if (_loc_2 > this.getMaxZoomLevel()){
                return;
            };
            _loc_3 = this.getMinZoomLevel();
            this.minZoomLevel_ = _loc_2;
            if (this.minZoomLevel_ > this.getZoom()){
                this.internalSetZoom(this.minZoomLevel_);
            } else {
                if (this.minZoomLevel_ != _loc_3){
                    this.updateZoomRange();
                };
            };
        }
        public function returnToSavedPosition():void{
            if (!(this.savedCenter)){
                return;
            };
            if (this.savedZoom == this.getZoom()){
                this.panTo(this.savedCenter);
                return;
            };
            this.configure(null, this.savedZoom, this.savedCenter);
        }
        private function postZoomCenter(param1:Number):void{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Camera;
            var _loc_5:Point;
            var _loc_6:Point;
            var _loc_7:Point;
            var _loc_8:LatLng;
            var _loc_9:LatLng;
            var _loc_10:Number = NaN;
            if (((this.focus_) && (this.isLatLngVisible(this.focus_)))){
                _loc_2 = this._camera.latLngToWorld(this.focus_);
                _loc_3 = this.viewportSize;
                _loc_4 = this.createCamera(this.getProjection());
                _loc_4.configure(this._center, param1, _loc_3);
                _loc_5 = _loc_2.subtract(this._camera.viewportToWorld(this.getViewportCenter()));
                _loc_6 = this._camera.viewportToWorld(_loc_4.latLngToViewport(this.focus_));
                _loc_7 = this._camera.worldToViewport(_loc_6.subtract(_loc_5));
                _loc_8 = _loc_4.viewportToLatLng(_loc_7);
                _loc_9 = LatLng.wrapLatLng(_loc_8);
                _loc_10 = (_loc_9.lng() - _loc_8.lng());
                if (_loc_10 != 0){
                    this.focus_ = new LatLng(this.focus_.lat(), (this.focus_.lng() + _loc_10), true);
                };
                this._center = _loc_9;
            };
        }
        public function addMapType(param1:IMapType):void{
            if (((!(param1)) || (this.isMapTypeRegistered(param1)))){
                return;
            };
            this.mapTypes.push(param1);
            dispatchEvent(new MapEvent(MapEvent.MAPTYPE_ADDED, param1));
        }
        private function configure(param1:IMapType=null, param2:Number=NaN, param3:LatLng=null):void{
            var _loc_4:Array;
            var _loc_5:IMapType;
            var _loc_6:Number = NaN;
            var _loc_7:LatLng;
            var _loc_8:Number = NaN;
            var _loc_9:LatLng;
            var _loc_10:int;
            this.cancelPan();
            _loc_4 = [];
            _loc_5 = this.getOptMapType(param1);
            _loc_6 = (isNaN(param2)) ? this._zoom : param2;
            _loc_7 = (((this.focus_) && (this.isLatLngVisible(this.focus_)))) ? this.focus_ : this._center;
            _loc_8 = this.mapBoundZoom(_loc_6, _loc_5, _loc_7);
            _loc_9 = this._center;
            if (param3){
                this._center = param3;
            } else {
                this.postZoomCenter(_loc_8);
            };
            if (_loc_8 != this._zoom){
                this.tileManager.setTargetZoom(_loc_8, false);
                this._zoom = _loc_8;
                _loc_4.push(new MapZoomEvent(MapZoomEvent.ZOOM_END, this.getZoom()));
                _loc_4.push(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, this.getZoom()));
            };
            if (_loc_5 != this._mapType){
                _loc_4.push(new MapEvent(MapEvent.MAPTYPE_CHANGED, _loc_5));
                this.internalSetMapType(_loc_5);
            };
            _loc_4.push(new MapMoveEvent(MapMoveEvent.MOVE_START, _loc_9));
            _loc_4.push(new MapMoveEvent(MapMoveEvent.MOVE_STEP, this.getCenter()));
            _loc_4.push(new MapMoveEvent(MapMoveEvent.MOVE_END, this.getCenter()));
            if (!(this._configured)){
                this.savePosition();
                this._configured = true;
            };
            this.configureCamera();
            _loc_10 = 0;
            while (_loc_10 < _loc_4.length) {
                dispatchEvent(_loc_4[_loc_10]);
                _loc_10++;
            };
        }
        public function draggingEnabled():Boolean{
            return (this.isDraggable);
        }
        private function finishContinuousZoom():void{
            this.focus_ = this.focusBeforeContinuousZoom_;
            this._center = new LatLng(this._center.lat(), this._center.lng());
            this.configureCamera();
            if (this.isLoaded()){
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, this.getCenter()));
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, this.getCenter()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_END, this.getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_END, this.getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, this.getZoom()));
            };
            this.zooming_ = false;
        }
        private function onMouseMove(event:MouseEvent):void{
            if (!(this.isLoaded())){
                return;
            };
            this.mouseMoveStageCoords = new Point(event.stageX, event.stageY);
            if (((!(this.clickValidRegion)) || (!(this.clickValidRegion.contains(event.stageX, event.stageY))))){
                this.isClickValid = false;
                this.timedDoubleClick = new TimedDoubleClick();
            };
            if (((!(this.isDraggable)) || (!(this.isMouseDown)))){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.MOUSE_MOVE, this, this.getMouseEventLatLng(event)));
            };
        }
        public function unload():void{
            var _loc_1:int;
            var _loc_2:IMouse;
            if (this.controlList){
                while (this.controlList.length != 0) {
                    this.removeControl(this.controlList[0]);
                };
            };
            this.closeInfoWindow();
            this.clearOverlays();
            this.removeCopyrightView();
            if (this.usageTracker){
                this.usageTracker.unload();
                this.usageTracker = null;
            };
            removeEventListener(MapMoveEvent.MOVE_END, this.updateZoomRange);
            if (this.container){
                _loc_2 = MouseHandler.instance();
                _loc_2.removeListener(this.container, MouseEvent.ROLL_OVER, this.onMouseRollOver);
                _loc_2.removeListener(this.container, MouseEvent.ROLL_OUT, this.onMouseRollOut);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_DOWN, this.onMousePress);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_MOVE, this.onMouseMove);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_DOWN, this.reportMouseDown);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_UP, this.reportMouseUp);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_MOVE, this.reportMouseMove);
                _loc_2.removeListener(this.container, MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
                _loc_2.removeGlobalMouseUpListener(this.onMouseRelease);
                _loc_2.removeGlobalMouseMoveListener(this.onMouseDrag);
            };
            if (this._focusSprite){
                this._focusSprite.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
                this._focusSprite.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.onKeyFocusChange);
                this.configureFocusMouseListener(false);
            };
            this.getBootstrap().removeEventListener(MapEvent.DISPLAY_MESSAGE, this.onDisplayMessage);
            removeEventListener(Event.ENTER_FRAME, this.enterFrame);
            removeEventListener(Event.ADDED_TO_STAGE, this.addKeyDownListener);
            _loc_1 = 0;
            while (_loc_1 != this.mapTypes.length) {
                this.mapTypes[_loc_1].removeEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
                this.mapTypes[_loc_1].removeEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, this.onMapTypeStyleChanged);
                _loc_1++;
            };
            this.mapTypes = [];
            if (this.paneManager){
                this.paneManager.destroy();
            };
            this.paneManager = null;
            if (this.tileManager){
                this.tileManager.destroy();
                this.tileManager = null;
            };
        }
        public function getDisplayObject():DisplayObject{
            return (this.container);
        }
        private function onMouseRollOver(event:MouseEvent):void{
            if (!(this.isLoaded())){
                return;
            };
            event.stopPropagation();
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.ROLL_OVER, this, this.getMouseEventLatLng(event)));
        }
        public function get mouseClickRange():Number{
            return ((this.options.mouseClickRange as Number));
        }
        private function createChildren():void{
            var _loc_1:IMapFocusableComponent;
            var _loc_2:IMouse;
            if (((!(this.container)) || (this.mc))){
                return;
            };
            this.mcBack = Bootstrap.createChildSprite(this.container);
            this.mcBack.name = "backgroundmc";
            this.mc = Bootstrap.createChildComponent(this.container);
            this.mc.name = "mapmc";
            this.mcMaskTiles = Bootstrap.createChildSprite(this.container);
            this.mcMaskPanes = Bootstrap.createChildSprite(this.container);
            this.controlsContainer = Bootstrap.createChildComponent(this.container);
            this.controlsContainer.name = "controlsmc";
            this.mcFore = Bootstrap.createChildSprite(this.container);
            this.mcFore.mouseEnabled = false;
            this.tileManager = null;
            this.tileSprite = Bootstrap.createChildSprite(this.mc);
            this.tileSprite.name = "tilesmc";
            this.tileSprite.mask = this.mcMaskTiles;
            this.activateTileManager(this.viewModeValue);
            this._focusSprite = Bootstrap.createChildComponent(this.mc, -1, true);
            this.configureFocusMouseListener(this._controlByKeyboard);
            _loc_1 = this.getFocusComponent();
            if (_loc_1){
                _loc_1.focusable = this._controlByKeyboard;
            };
            _loc_2 = MouseHandler.instance();
            _loc_2.addListener(this.container, MouseEvent.ROLL_OVER, this.onMouseRollOver);
            _loc_2.addListener(this.container, MouseEvent.ROLL_OUT, this.onMouseRollOut);
            _loc_2.addListener(this.container, MouseEvent.MOUSE_DOWN, this.onMousePress);
            _loc_2.addListener(this.container, MouseEvent.MOUSE_MOVE, this.onMouseMove);
            if (!(this.getBootstrap().isClientVersionAfter(3))){
                _loc_2.addListener(this.container, MouseEvent.MOUSE_DOWN, this.reportMouseDown);
                _loc_2.addListener(this.container, MouseEvent.MOUSE_UP, this.reportMouseUp);
                _loc_2.addListener(this.container, MouseEvent.MOUSE_MOVE, this.reportMouseMove);
            };
            this.panesContainer = Bootstrap.createChildComponent(this.mc);
            this.panesContainer.name = "overlaysmc";
            this.panesContainer.mask = this.mcMaskPanes;
            this.paneManager = new PaneManager(this, this.panesContainer, this.spriteFactory);
            this.controlList = [];
            this.container.useHandCursor = false;
            this.createMessageBox();
            this.createTooltip();
        }
        public function getImplementationVersion():String{
            return (Release.version);
        }
        private function onMouseRelease(param1:Boolean, param2:MouseEvent):void{
            if (((!(this.isLoaded())) || (!(this.isMouseDown)))){
                return;
            };
            MouseHandler.instance().removeGlobalMouseUpListener(this.onMouseRelease);
            MouseHandler.instance().removeGlobalMouseMoveListener(this.onMouseDrag);
            if (this._dragLocal){
                this.dragStop(param2);
            };
            this.isMouseDown = false;
            dispatchEvent(MapMouseEvent.createFromMouseEvent(param2, MapMouseEvent.MOUSE_UP, this, this.getMouseEventLatLng(param2)));
            if (((param1) && (this.isClickValid))){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(param2, MapMouseEvent.CLICK, this, this.getMouseEventLatLng(param2)));
            };
        }
        public function getFocus():LatLng{
            return (this.focus_);
        }
        private function placeObject(param1:DisplayObject, param2:ControlPosition, param3:Point=null):void{
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = (param3) ? param3.x : param1.width;
            _loc_5 = (param3) ? param3.y : param1.height;
            switch (param2.getAnchor()){
                case ControlPosition.ANCHOR_TOP_LEFT:
                case ControlPosition.ANCHOR_BOTTOM_LEFT:
                    param1.x = param2.getOffsetX();
                    break;
                case ControlPosition.ANCHOR_TOP_RIGHT:
                case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                    param1.x = ((this.viewportSize.x - _loc_4) - param2.getOffsetX());
                    break;
            };
            switch (param2.getAnchor()){
                case ControlPosition.ANCHOR_TOP_LEFT:
                case ControlPosition.ANCHOR_TOP_RIGHT:
                    param1.y = param2.getOffsetY();
                    break;
                case ControlPosition.ANCHOR_BOTTOM_LEFT:
                case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                    param1.y = ((this.viewportSize.y - _loc_5) - param2.getOffsetY());
                    break;
            };
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.pane;
            if (_loc_2){
                _loc_2.removeOverlay(param1);
            };
        }
        private function sizeMessageBox():void{
            var _loc_1:Rectangle;
            if (!(this.messageBox)){
                return;
            };
            _loc_1 = this.getRectBetweenTopEdgeControls();
            if (_loc_1.width < MESSAGE_BOX_MIN_WIDTH){
                _loc_1 = this.getViewport();
            };
            _loc_1.inflate(-10, -10);
            this.messageBox.setWidth(_loc_1.width);
            this.placeObject(this.messageBox, new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, _loc_1.left, _loc_1.top));
        }
        public function get overlayRaising():Boolean{
            return (this._overlayRaising);
        }
        private function dragMove(event:MouseEvent):void{
            var _loc_2:Point;
            var _loc_3:Boolean;
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            var _loc_6:MapMouseEvent;
            var _loc_7:Point;
            _loc_2 = this.getLocalCoords(event);
            _loc_3 = this._camera.isOnMap(_loc_2);
            if (!(this._dragged)){
                _loc_6 = MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_START, this, this.getCenter());
                this.setDefaultDragMode(_loc_6);
                dispatchEvent(_loc_6);
                this._dragModeActive = this._dragMode;
            };
            if (this._dragModeActive != this._dragMode){
                this._dragModeActive = this._dragMode;
                this.dragStop(event);
                this.dragStart(event);
            };
            if (_loc_3){
                if (!(this._dragged)){
                    dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, this.getCenter()));
                };
                _loc_7 = this._camera.viewportToWorld(_loc_2).subtract(this._camera.viewportToWorld(this._dragLocal));
                _loc_4 = this._camera.getWorldCenter().subtract(_loc_7);
                this._center = LatLng.wrapLatLng(this._camera.worldToLatLng(_loc_4));
                this._dragLocal = _loc_2;
                this.configureCamera();
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, this.getCenter()));
            };
            _loc_5 = this._camera.zoom;
            if (this._camera.zoom != this._dragCamera.zoom){
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, this._camera.zoom));
            };
            _loc_6 = MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_STEP, this, this.getCenter());
            this.setDefaultDragMode(_loc_6);
            dispatchEvent(_loc_6);
            this._dragged = true;
        }
        private function createCamera(param1:IProjection):Camera{
            var _loc_2:Number = NaN;
            _loc_2 = Camera.FOCAL_LENGTH_ORTHOGONAL;
            return (new Camera(_loc_2, param1));
        }
        private function reportMouseMove(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        public function getCenter():LatLng{
            return (this._center.clone());
        }
        private function internalPanTo(param1:Point, param2:int):void{
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            this.cancelPan();
            _loc_3 = this._camera.viewportToWorld(this.getViewportCenter());
            _loc_4 = param1.subtract(_loc_3);
            if ((((_loc_4.x == 0)) && ((_loc_4.y == 0)))){
                return;
            };
            _loc_4.x = (_loc_4.x * this._camera.zoomScale);
            _loc_4.y = (_loc_4.y * this._camera.zoomScale);
            if ((((param2 == PAN_JUMP_FORCE)) || ((((param2 == PAN_JUMP_ALLOW)) && ((((Math.abs(_loc_4.x) > this.viewportSize.x)) || ((Math.abs(_loc_4.y) > this.viewportSize.y)))))))){
                this.setCenter(this.fromPointToLatLng(param1, 0));
            } else {
                _loc_5 = Math.max(5, Math.round((_loc_4.length / 20)));
                this.panSiner = new Siner(_loc_5);
                this.panSiner.reset();
                this.panStart = _loc_3;
                this.panDestination = param1;
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, this.getCenter()));
                this.doPan();
            };
        }
        public function setZoom(param1:Number, param2:Boolean=false):void{
            if (((this.continuousZoom) && (param2))){
                this.zoomContinuously(param1);
            } else {
                this.internalSetZoom(param1);
            };
        }
        private function dragStop(event:MouseEvent):void{
            this._dragLocal = null;
            this.updatePivotTarget();
            this.configureCamera();
            if (this._dragged){
                this._dragged = false;
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_END, this, this.getCenter()));
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, this.getCenter()));
            };
        }
        public function setCenter(param1:LatLng, param2:Number=NaN, param3:IMapType=null):void{
            var _loc_4:IMapType;
            var _loc_5:Number = NaN;
            if (!(isNaN(param2))){
                _loc_4 = this.getOptMapType(param3);
                _loc_5 = maxResolutionZoomBound(param2);
                _loc_4.setMaxResolutionOverride(_loc_5);
            };
            this.configure(param3, param2, param1);
        }
        public function enableControlByKeyboard():void{
            var _loc_1:IMapFocusableComponent;
            this._controlByKeyboard = true;
            _loc_1 = this.getFocusComponent();
            if (_loc_1){
                _loc_1.focusable = true;
            };
            this.configureFocusMouseListener(this._controlByKeyboard);
        }
        private function getRectBetweenTopEdgeControls():Rectangle{
            var _loc_1:Rectangle;
            var _loc_2:int;
            var _loc_3:IControl;
            var _loc_4:ControlPosition;
            var _loc_5:Rectangle;
            var _loc_6:Number = NaN;
            _loc_1 = this.getViewport();
            _loc_2 = 0;
            while (_loc_2 < this.controlList.length) {
                _loc_3 = this.controlList[_loc_2];
                _loc_4 = _loc_3.getControlPosition();
                if (!(_loc_4)){
                } else {
                    _loc_5 = this.getControlRect(_loc_3);
                    _loc_6 = _loc_4.getAnchor();
                    if (ControlPosition.ANCHOR_TOP_LEFT == _loc_6){
                        _loc_1.left = Math.max(_loc_1.left, _loc_5.right);
                    } else {
                        if (ControlPosition.ANCHOR_TOP_RIGHT == _loc_6){
                            _loc_1.right = Math.min(_loc_1.right, _loc_5.left);
                        };
                    };
                };
                _loc_2++;
            };
            return (_loc_1);
        }
        public function getPrintableBitmap():Bitmap{
            var _loc_1:BitmapData;
            _loc_1 = new BitmapData(this.viewportSize.x, this.viewportSize.y);
            _loc_1.draw(this.getDisplayObject());
            return (new Bitmap(_loc_1));
        }
        private function createTooltip():void{
            var _loc_1:TextField;
            var _loc_2:StyleSheet;
            if (this.isOverviewMap()){
                return;
            };
            _loc_1 = new TextField();
            _loc_1.x = 10;
            _loc_1.y = 10;
            _loc_1.width = 140;
            _loc_1.height = 40;
            _loc_1.visible = false;
            _loc_1.multiline = false;
            _loc_1.autoSize = TextFieldAutoSize.LEFT;
            _loc_1.wordWrap = false;
            _loc_1.background = true;
            _loc_1.border = true;
            _loc_1.backgroundColor = TOOLTIP_COLOR;
            _loc_2 = new StyleSheet();
            _loc_2.setStyle("p", {
                color:"#000000",
                fontFamily:"_sans",
                fontSize:12
            });
            _loc_1.styleSheet = _loc_2;
            this.spriteFactory.addChild(this.container, _loc_1);
            this.tooltip = _loc_1;
        }
        public function moveLeft(param1:Number=100):void{
            if (this.panSiner){
                return;
            };
            this.moveByGroundCoords(new Point(-(param1), 0));
        }
        private function get continuousMove():Boolean{
            return (this._camera.is3D);
        }
        public function monitorCopyright(param1:IMap):void{
            this.monitorCopyrightInternal((param1 as MapImpl));
        }
        public function clearOverlays():void{
            this.paneManager.clearOverlays();
        }
        private function dragStart(event:MouseEvent):void{
            if (this.panSiner){
                this.panSiner = null;
            };
            this._dragLocal = this.getLocalCoords(event);
            this.updatePivotTarget(this._dragLocal);
            this._dragCamera = this._camera.clone();
            this._dragged = false;
        }
        private function isLatLngVisible(param1:LatLng):Boolean{
            var _loc_2:Number = NaN;
            var _loc_3:LatLng;
            var _loc_4:Point;
            _loc_2 = MapUtil.wrap(param1.lng(), (this._center.lng() - 180), (this._center.lng() + 180));
            _loc_3 = new LatLng(param1.lat(), _loc_2, true);
            if (this._camera.isAhead(_loc_3)){
                _loc_4 = this._camera.latLngToViewport(_loc_3);
                return (this.getViewport().containsPoint(_loc_4));
            };
            return (false);
        }
        private function onContainerSet():void{
            this.createChildren();
            addEventListener(Event.ENTER_FRAME, this.enterFrame);
            DelayHandler.delayCall(this.configureMap);
        }
        private function settingsError(event:Event=null):void{
            Log.log("***** MapImpl, settingsError");
        }
        private function getControlRect(param1:IControl):Rectangle{
            var _loc_2:Rectangle;
            var _loc_3:ControlPosition;
            var _loc_4:Point;
            _loc_2 = new Rectangle();
            _loc_3 = param1.getControlPosition();
            _loc_4 = param1.getSize();
            switch (_loc_3.getAnchor()){
                case ControlPosition.ANCHOR_TOP_LEFT:
                case ControlPosition.ANCHOR_BOTTOM_LEFT:
                    _loc_2.x = _loc_3.getOffsetX();
                    break;
                case ControlPosition.ANCHOR_TOP_RIGHT:
                case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                    _loc_2.x = ((this.viewportSize.x - _loc_4.x) - _loc_3.getOffsetX());
                    break;
            };
            switch (_loc_3.getAnchor()){
                case ControlPosition.ANCHOR_TOP_LEFT:
                case ControlPosition.ANCHOR_TOP_RIGHT:
                    _loc_2.y = _loc_3.getOffsetY();
                    break;
                case ControlPosition.ANCHOR_BOTTOM_LEFT:
                case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                    _loc_2.y = ((this.viewportSize.y - _loc_4.y) - _loc_3.getOffsetY());
                    break;
            };
            _loc_2.width = _loc_4.x;
            _loc_2.height = _loc_4.y;
            return (_loc_2);
        }
        public function setSize(param1:Point):void{
            if (((!((this.viewportSize.x == param1.x))) || (!((this.viewportSize.y == param1.y))))){
                this.viewportSize = param1.clone();
                this.configureCamera();
                this.size();
            };
        }
        public function getMinZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            var _loc_3:IMapType;
            var _loc_4:LatLng;
            var _loc_5:Number = NaN;
            _loc_3 = this.getOptMapType(param1);
            _loc_4 = ((param2) || (this._center));
            _loc_5 = _loc_3.getMinimumResolution(_loc_4);
            return (Math.max(_loc_5, this.minZoomLevel_));
        }
        public function getBootstrap():Bootstrap{
            return (Bootstrap.getBootstrap());
        }
        private function cancelPan():void{
            var _loc_1:InfoWindow;
            if (this.panSiner){
                this.panSiner = null;
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, this.getCenter()));
            };
            _loc_1 = (this._infoWindow as InfoWindow);
            if (((_loc_1) && (_loc_1.initializationPending))){
                _loc_1.removeEventListener(MapEvent.COMPONENT_INITIALIZED, this.panToFitInfoWindow);
            };
        }
        private function getCopyrightExtentMax():Number{
            return (((this.viewportSize.x - copyrightPadR) - this.getFilledSize(ControlPosition.ANCHOR_BOTTOM_RIGHT).x));
        }
        private function zoomNoncontinuously(param1:Number, param2:Boolean=false, param3:LatLng=null, param4:Boolean=false):void{
            var _loc_5:Number = NaN;
            var _loc_6:LatLng;
            param1 = (param2) ? (this.getZoom() + param1) : param1;
            _loc_5 = this.mapBoundZoom(param1, this._mapType, this.getCenter());
            if (_loc_5 == param1){
                if (((param3) && (param4))){
                    this.setCenter(param3, param1, this._mapType);
                } else {
                    if (param3){
                        dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_START, this.getZoom()));
                        dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_START, this.getZoom()));
                        _loc_6 = this.focus_;
                        this.focus_ = param3;
                        this.internalSetZoom(param1);
                        this.focus_ = _loc_6;
                    } else {
                        this.internalSetZoom(param1);
                    };
                };
            } else {
                if (((param3) && (param4))){
                    this.panTo(param3);
                };
            };
        }
        private function initCopyrightView():void{
            var _loc_1:IControl;
            var _loc_2:ControlPosition;
            if (((this.copyrightView) || (this.isCopyrightSuppressed))){
                return;
            };
            this.copyrightView = new CopyrightView(this);
            this.copyrightView.addEventListener(MapEvent.COPYRIGHTS_UPDATED, this.sizeCopyright);
            this.spriteFactory.addChild(this.mcFore, this.copyrightView);
            this.googleLogo = new this.PoweredByLogo();
            this.googleLogoPosition = new ControlPosition(ControlPosition.ANCHOR_BOTTOM_LEFT, 3, 2);
            this.placeMovieClip(this.googleLogo, this.googleLogoPosition);
            for each (_loc_1 in this.controlList) {
                _loc_2 = _loc_1.getControlPosition();
                if (((_loc_2) && ((_loc_2.getAnchor() == ControlPosition.ANCHOR_BOTTOM_LEFT)))){
                    this.placeControl(_loc_1, _loc_2);
                };
            };
            this.spriteFactory.addChild(this.container, this.googleLogo);
        }
        public function getPane(param1:int):IPane{
            return (this.paneManager.getPaneById(param1));
        }
        private function updatePivotTarget(param1:Point=null):void{
        }
        public function enableContinuousZoom():void{
            this.continuousZoom = true;
        }
        private function setMaxZoomLevel(param1:Number):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = maxResolutionZoomBound(param1);
            if (param1 == this.maxZoomLevel_){
                return;
            };
            if (_loc_2 < this.getMinZoomLevel()){
                return;
            };
            _loc_3 = this.getMaxZoomLevel();
            this.maxZoomLevel_ = _loc_2;
            if (this.maxZoomLevel_ < this.getZoom()){
                this.internalSetZoom(this.maxZoomLevel_);
            } else {
                if (this.maxZoomLevel_ != _loc_3){
                    this.updateZoomRange();
                };
            };
        }
        public function getCurrentMapType():IMapType{
            return (this._mapType);
        }
        public function get MERCATOR_PROJECTION():IProjection{
            return (this.getBootstrap().getMercatorProjection());
        }
        public function enableDragging():void{
            this.isDraggable = true;
        }
        private function getFocusComponent():IMapFocusableComponent{
            var _loc_1:IWrappableSprite;
            _loc_1 = this.spriteFactory.toWrappableSprite(this._focusSprite);
            return ((_loc_1 as IMapFocusableComponent));
        }

    }
}//package com.mapplus.maps.core 
