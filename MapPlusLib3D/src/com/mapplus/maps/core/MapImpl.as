//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.overlays.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;
    import flash.utils.*;
    import com.mapplus.maps.managers.*;
    import com.mapplus.maps.window.*;
    import flash.ui.*;

    public class MapImpl extends IWrappableSpriteWrapper implements IMap3D, IMapBase2, IControllableMap {

        public static const FLASH_MAPS_API_PATH:String = "/mapsapi/publicapi";
        private static const PAN_JUMP_FORCE:int = 2;
        private static const YAW_PER_DRAG_PIXEL:Number = -0.4;
        private static const MOUSE_WHEEL_NULL_TIME:int = 80;
        private static const PITCH_PER_DRAG_PIXEL:Number = 0.3;
        private static const DEFAULT_PANNING_DISTANCE:Number = 100;
        private static const TOOLTIP_COLOR:Number = 16777120;
        private static const DEFAULT_YAW_STEP:Number = 15;
        private static const CENTER_CROSS_SIZE:Number = 10;
        private static const CENTER_CROSS_WIDTH:Number = 1;
        private static const MESSAGE_BOX_MIN_WIDTH:uint = 260;
        private static const PAN_JUMP_NONE:int = 0;
        private static const DEFAULT_PITCH_STEP:Number = 10;
        private static const CAMERA_YAW_PER_DRAG_PIXEL:Number = -0.2;
        private static const CONTINUOUS_ZOOM_FRACTIONS:Number = 4;
        private static const PAN_JUMP_ALLOW:int = 1;
        private static const CAMERA_PITCH_PER_DRAG_PIXEL:Number = 0.15;

        private static var copyrightPadL:Number = 2;
        private static var copyrightPadR:Number = 2;
        private static var viewer:MapImpl = null;
        private static var defaultOptions:MapOptions = new MapOptions({
            attitude:new Attitude(0, 0, 0),
            viewMode:View.VIEWMODE_2D,
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
        private var savedAttitude:Attitude;
        private var _dragged:Boolean;
        private var PivotTarget:Class;
        private var viewModeValue:int;
        private var flyController:FlyController;
        private var pivotTarget:Bitmap;
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
        private var pivotTargetColorClamped:ColorTransform;
        private var _crosshairsStrokeStyle:StrokeStyle;
        private var _attitude:Attitude;
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
        private var continuousZoom:Boolean;
        private var isDraggable:Boolean;
        private var googleLogo:DisplayObject;
        private var zoomBy:Number;
        private var maxZoomLevel_:Number;
        private var controlList:Array;
        private var mcBack:Sprite;
        private var isCopyrightSuppressed:Boolean;
        private var pivotTargetColorNormal:ColorTransform;
        private var _isMovingX:Boolean;
        private var _isMovingY:Boolean;
        private var zoomRangeMax_:Number;
        private var _configured:Boolean;
        private var _infoWindow:IInfoWindow;
        private var _dragAttitude:Attitude;
        private var _focusSprite:Sprite;

        public function MapImpl(param1:String=null, param2:MapOptions=null){
            super();
            //PoweredByLogo = MapImpl_PoweredByLogo;
            PivotTarget = MapImpl_PivotTarget;
            pivotTarget = new PivotTarget();
            pivotTargetColorNormal = new ColorTransform();
            pivotTargetColorClamped = new ColorTransform(1, 0, 0, 1, 128);
            Log.log("Init...", 0);
            this.usageType = param1;
            this.options = MapOptions.merge([getDefaultOptions(), param2]);
            _backgroundFillStyle = this.options.backgroundFillStyle;
            _crosshairs = (this.options.crosshairs as Boolean);
            _crosshairsStrokeStyle = this.options.crosshairsStrokeStyle;
            _controlByKeyboard = (this.options.controlByKeyboard as Boolean);
            controlByScrollWheel = (this.options.scrollWheelZoom as Boolean);
            _overlayRaising = (this.options.overlayRaising as Boolean);
            _doubleClickMode = (this.options.doubleClickMode as Number);
            isDraggable = (this.options.dragging as Boolean);
            continuousZoom = (this.options.continuousZoom as Boolean);
            mapTypes = [];
            _center = this.options.center;
            _zoom = (this.options.zoom as Number);
            viewModeValue = (this.options.viewMode as int);
            _attitude = this.options.attitude;
            _dragMode = MapAction.DRAGMODE_LATLNG;
            _dragModeActive = _dragMode;
            _configured = false;
            _loaded = false;
            viewportSize = new Point(0, 0);
            isMouseDown = false;
            spriteFactory = Bootstrap.getSpriteFactory();
            focus_ = null;
            _camera = createCamera(MERCATOR_PROJECTION);
            minZoomLevel_ = 0;
            maxZoomLevel_ = Math.max(PConstants.MAX_RESOLUTION_MAP, PConstants.MAX_RESOLUTION_SATELLITE);
            zooming_ = false;
            zoomRangeMin_ = NaN;
            zoomRangeMax_ = NaN;
            _moveVector = new Point(0, 0);
            timedDoubleClick = new TimedDoubleClick();
            flyController = new FlyController(this);
            isCopyrightSuppressed = false;
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
        private static function isDragTranslation(param1:int):Boolean{
            return ((param1 == MapAction.DRAGMODE_LATLNG));
        }
        private static function matchesState(param1:Boolean, param2:int):Boolean{
            if (param2 == 0){
                return (true);
            };
            return (((param2 > 0)) ? param1 : !(param1));
        }
        private static function isDragRotation(param1:int):Boolean{
            return ((((((((param1 == MapAction.DRAGMODE_YAW)) || ((param1 == MapAction.DRAGMODE_PITCH)))) || ((param1 == MapAction.DRAGMODE_MAP_YAW_PITCH)))) || ((param1 == MapAction.DRAGMODE_CAMERA_YAW_PITCH))));
        }
        public static function getDefaultOptions():MapOptions{
            return (MapImpl.defaultOptions);
        }
        private static function maxResolutionZoomBound(param1:Number):Number{
            return (Util.bound(param1, 0, Math.max(PConstants.MAX_RESOLUTION_MAP, PConstants.MAX_RESOLUTION_SATELLITE)));
        }

        private function size():void{
            var _loc_1:IControl;
            var _loc_2:ControlPosition;
            dispatchEvent(new MapEvent(MapEvent.SIZE_CHANGED, this));
            if (googleLogo){
                placeMovieClip(googleLogo, googleLogoPosition);
            };
            if (controlList){
                for each (_loc_1 in controlList) {
                    _loc_2 = _loc_1.getControlPosition();
                    if (_loc_2){
                        placeControl(_loc_1, _loc_1.getControlPosition());
                    };
                };
            };
            sizeCopyright();
            sizeMessageBox();
            draw();
        }
        private function configureFocusMouseListener(param1:Boolean):void{
            var _loc_2:Boolean;
            _loc_2 = _focusSprite.hasEventListener(MouseEvent.MOUSE_DOWN);
            if (((param1) && (!(_loc_2)))){
                _focusSprite.addEventListener(MouseEvent.MOUSE_DOWN, onFocusMouseDown);
            } else {
                if (((!(param1)) && (_loc_2))){
                    _focusSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onFocusMouseDown);
                };
            };
        }
        public function moveDown(param1:Number=100):void{
            if (panSiner){
                return;
            };
            moveByGroundCoords(new Point(0, param1));
        }
        private function panToFitInfoWindow(event:Event):void{
            var _loc_2:InfoWindow;
            var _loc_3:Rectangle;
            if (event){
                event.target.removeEventListener(MapEvent.COMPONENT_INITIALIZED, panToFitInfoWindow);
            };
            _loc_2 = (_infoWindow as InfoWindow);
            if (!_loc_2){
                return;
            };
            _loc_3 = _loc_2.getViewportBounds();
            _loc_3.inflate(4, 4);
            panToViewportRegion(_loc_3);
        }
        private function reportMouseDown(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        private function doPan():void{
            var _loc_1:Number = NaN;
            var _loc_2:Point;
            _loc_1 = panSiner.next();
            _loc_2 = Point.interpolate(panDestination, panStart, _loc_1);
            _center = fromPointToLatLng(_loc_2, 0);
            configureCamera();
            dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, getCenter()));
            if (!panSiner.more()){
                cancelPan();
            };
        }
        public function clearControls():void{
            while (((controlList) && ((controlList.length > 0)))) {
                removeControl(controlList[0]);
            };
        }
        public function openInfoWindow(param1:LatLng, param2:InfoWindowOptions=null):IInfoWindow{
            return (openInfoWindowOnOverlay(param1, null, param2));
        }
        public function controlByKeyboardEnabled():Boolean{
            return (_controlByKeyboard);
        }
        public function legacyInitialize(param1:Sprite, param2:Object):void{
            this.container = param1;
            initializeEventDispatcher(param2);
            onContainerSet();
        }
        public function setMapType(param1:IMapType):void{
            if (!isMapTypeRegistered(param1)){
                throw (new Error((("Invalid operation: map type not registered with the map (" + param1.getName()) + ")")));
            };
            configure(param1);
        }
        public function removeControl(param1:IControl):void{
            var _loc_2:int;
            var _loc_3:DisplayObject;
            _loc_2 = controlList.indexOf(param1);
            if (_loc_2 < 0){
                return;
            };
            _loc_3 = param1.getDisplayObject();
            param1.initControlWithMap(null);
            controlList.splice(_loc_2, 1);
            spriteFactory.removeChild(controlsContainer, _loc_3);
            dispatchEvent(new MapEvent(MapEvent.CONTROL_REMOVED, param1));
            sizeCopyright();
        }
        public function loadResourceString(param1:String):String{
            return (getBootstrap().getMessage(param1));
        }
        public function getZoom():Number{
            return (_zoom);
        }
        private function zoomContinuously(param1:Number, param2:Boolean=false, param3:LatLng=null, param4:Boolean=false):void{
            var _loc_5:Number = NaN;
            var _loc_6:LatLng;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            if (zooming_){
                if (((zoomSiner) && (param2))){
                    _loc_8 = mapBoundZoom((zoomTarget + param1), _mapType, getCenter());
                    if (_loc_8 != zoomTarget){
                        zoomTarget = _loc_8;
                        _loc_9 = (_loc_8 - _zoom);
                        zoomSiner.extend();
                        zoomStart = (_zoom - (zoomSiner.fract() * _loc_9));
                        zoomBy = (_loc_8 - zoomStart);
                        tileManager.setTargetZoom(zoomTarget, false);
                    };
                };
                return;
            };
            _loc_5 = (param2) ? (_zoom + param1) : param1;
            _loc_5 = mapBoundZoom(_loc_5, _mapType, getCenter());
            if (_loc_5 == _zoom){
                if (((param3) && (param4))){
                    panTo(param3);
                };
                return;
            };
            zoomTargetStart = _center;
            zoomTargetEnd = (((param3) && (param4))) ? param3 : null;
            _loc_6 = null;
            if (param3){
                _loc_6 = param3;
            } else {
                if (((focus_) && (isLatLngVisible(focus_)))){
                    _loc_6 = focus_;
                } else {
                    _loc_6 = _center;
                };
            };
            focusBeforeContinuousZoom_ = focus_;
            focus_ = _loc_6;
            _loc_7 = (((param3) && (param4))) ? 7 : 6;
            zoomTarget = _loc_5;
            zoomStart = _zoom;
            zoomBy = (_loc_5 - zoomStart);
            zoomSiner = new Siner(_loc_7);
            zooming_ = true;
            tileManager.setTargetZoom(zoomTarget, false);
            dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_START, getZoom()));
            dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_START, getZoom()));
            dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, getCenter()));
            doContinuousZoom();
        }
        public function disableDragging():void{
            if (_dragLocal){
                dragStop(null);
            };
            isDraggable = false;
        }
        public function getDoubleClickMode():Number{
            return (_doubleClickMode);
        }
        public function zoomIn(param1:LatLng=null, param2:Boolean=false, param3:Boolean=false):void{
            if (((continuousZoom) && (param3))){
                zoomContinuously(1, true, param1, param2);
            } else {
                zoomNoncontinuously(1, true, param1, param2);
            };
        }
        private function onMouseDrag(param1:Boolean, param2:MouseEvent):void{
            if (!isLoaded()){
                return;
            };
            if (tooltip){
                adjustTooltipPosition();
            };
            if (((!(isMouseDown)) || (panSiner))){
                return;
            };
            if (!param1){
                isMouseDown = false;
                if (_dragLocal){
                    dragStop(param2);
                };
            } else {
                if (_dragLocal){
                    dragMove(param2);
                };
            };
        }
        public function fromLatLngToPoint(param1:LatLng, param2:Number=NaN):Point{
            var _loc_3:Number = NaN;
            _loc_3 = Math.max(0, Math.floor((isNaN(param2)) ? getZoom() : param2));
            return (getProjection().fromLatLngToPixel(param1, _loc_3));
        }
        private function mapBoundZoom(param1:Number, param2:IMapType, param3:LatLng=null):Number{
            return (Util.bound(param1, getMinZoomLevel(param2, param3), getMaxZoomLevel(param2, param3)));
        }
        public function getSize():Point{
            return (viewportSize);
        }
        private function onInfoWindowClosing(event:Event):void{
            if (!_infoWindow){
                return;
            };
            _infoWindow.removeEventListener(MapEvent.OVERLAY_BEFORE_REMOVED, onInfoWindowClosing);
            if (paneManager){
                paneManager.placePaneShadow(_infoWindow.pane, _infoWindow.pane);
            };
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSING, _infoWindow));
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
            _loc_5 = controlList.length;
            while (_loc_4 < _loc_5) {
                _loc_6 = controlList[_loc_4];
                _loc_7 = _loc_6.getControlPosition();
                if (!_loc_7){
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
        public function addOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.getDefaultPane(this);
            _loc_2.addOverlay(param1);
        }
        public function disableContinuousZoom():void{
            continuousZoom = false;
        }
        public function disableControlByKeyboard():void{
            var _loc_1:IMapFocusableComponent;
            _controlByKeyboard = false;
            _loc_1 = getFocusComponent();
            if (_loc_1){
                if (_loc_1.hasFocus()){
                    _loc_1.releaseFocus();
                };
                _loc_1.focusable = false;
            };
            configureFocusMouseListener(_controlByKeyboard);
        }
        private function addKeyDownListener(event:Event):void{
            _focusSprite.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _focusSprite.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            _focusSprite.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
            if (event){
                removeEventListener(Event.ADDED_TO_STAGE, addKeyDownListener);
            };
        }
        public function configureMap():void{
            var initMapType:* = null;
            if (_loaded){
                return;
            };
            if (((options.mapTypes) && (options.mapTypes[0]))){
                mapTypes = options.mapTypes;
            } else {
                mapTypes = [];
                mapTypes = mapTypes.concat(getBootstrap().getDefaultMapTypes());
            };
            initMapType = options.mapType;
            if (!initMapType){
                initMapType = getBootstrap().getNormalMapType();
                if (mapTypes.indexOf(initMapType) < 0){
                    initMapType = mapTypes[0];
                };
            };
            internalSetMapType(initMapType);
            zoomTarget = getZoom();
            _loaded = true;
            dispatchEvent(new MapEvent(MapEvent.MAP_READY_INTERNAL, null));
            if (getStage()){
                addKeyDownListener(null);
            } else {
                addEventListener(Event.ADDED_TO_STAGE, addKeyDownListener);
            };
            MouseHandler.instance().addListener(container, MouseEvent.MOUSE_WHEEL, onMouseWheel);
            if (tooltip){
                adjustTooltipPosition();
            };
            if (getBootstrap().isClientVersionAfter(8, "c")){
                dispatchEvent(new MapEvent(MapEvent.MAP_READY, this));
                tileManager.setTargetZoom(Math.floor(getZoom()), true);
                createUsageTracker();
                addEventListener(MapMoveEvent.MOVE_END, updateZoomRange);
            } else {
                DelayHandler.delayCall(function ():void{
                    tileManager.setTargetZoom(Math.floor(getZoom()), true);
                    createUsageTracker();
                    addEventListener(MapMoveEvent.MOVE_END, updateZoomRange);
                });
            };
            if (((getBootstrap().isClientVersionAfter(18, "b")) && (!(getBootstrap().getClientConfiguration().sensor)))){
                displayMessage((("<p><b>The Map.sensor parameter is missing. Please set sensor = " + "\"false\" or sensor = \"true\" or some services may not work.") + "</b></p>"));
            };
            savePosition();
        }
        private function getOptMapType(param1:IMapType):IMapType{
            return (((((param1) || (_mapType))) || (mapTypes[0])));
        }
        override protected function onAttached():void{
            super.onAttached();
            if (!container){
                container = getSprite();
                onContainerSet();
            };
        }
        private function onDisplayMessage(event:MapEvent):void{
            displayMessage((event.feature as String));
        }
        private function onMouseRollOut(event:MouseEvent):void{
            if (!isLoaded()){
                return;
            };
            event.stopPropagation();
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.ROLL_OUT, this, null));
        }
        public function cancelFlyTo():void{
            if (flyController.isActive()){
                flyController.cancel();
                dispatchEvent(new MapEvent(MapEvent.FLY_TO_CANCELED, this));
                dispatchEvent(new MapEvent(MapEvent.FLY_TO_DONE, this));
            };
        }
        private function moveByGroundCoords(param1:Point):void{
            var _loc_2:Point;
            var _loc_3:Number = NaN;
            var _loc_4:Point;
            var _loc_5:Homography;
            var _loc_6:Point;
            var _loc_7:Point;
            var _loc_8:Point;
            _loc_2 = _camera.getWorldCenter();
            _loc_3 = _camera.zoomScale;
            _loc_4 = new Point((param1.x / _loc_3), (param1.y / _loc_3));
            if (is3DView()){
                _loc_5 = _camera.mapViewportToWorld;
                _loc_6 = new Point((viewportSize.x / 2), (viewportSize.y / 2));
                _loc_7 = _loc_5.projectUnitX(_loc_6);
                _loc_8 = _loc_5.projectUnitY(_loc_6);
                _loc_4.x = ((_loc_7.x * param1.x) + (_loc_8.x * param1.y));
                _loc_4.y = ((_loc_7.y * param1.x) + (_loc_8.y * param1.y));
            };
            panTo(_camera.worldToLatLng(_loc_2.add(_loc_4)));
        }
        private function onFocusMouseDown(event:Event):void{
            var _loc_2:IMapFocusableComponent;
            _loc_2 = getFocusComponent();
            if (_loc_2){
                _loc_2.grabFocus();
            };
        }
        private function getCopyrightExtentMin():Number{
            return ((copyrightPadL + Math.max((googleLogo) ? (googleLogo.x + googleLogo.width) : 0, getFilledSize(ControlPosition.ANCHOR_BOTTOM_LEFT).x)));
        }
        private function onKeyDown(event:KeyboardEvent):void{
            if (((!(isLoaded())) || (!(_controlByKeyboard)))){
                return;
            };
            if (((is3DView()) && (continuousMove))){
                if (((!(heldKeyboardEvent)) || (!((heldKeyboardEvent.keyCode == event.keyCode))))){
                    heldKeyboardEvent = event;
                    heldKeyboardTimer = getTimer();
                };
                return;
            };
            applyKeyboardEvent(event, 1, true);
        }
        public function moveRight(param1:Number=100):void{
            if (panSiner){
                return;
            };
            moveByGroundCoords(new Point(param1, 0));
        }
        private function sizeCopyright(event:Event=null):void{
            if (!copyrightView){
                return;
            };
            copyrightView.width = (getCopyrightExtentMax() - getCopyrightExtentMin());
            placeObject(copyrightView, new ControlPosition(ControlPosition.ANCHOR_BOTTOM_RIGHT, (viewportSize.x - getCopyrightExtentMax()), 2));
        }
        private function onDoubleClick(event:MouseEvent):void{
            var _loc_2:LatLng;
            _loc_2 = getMouseEventLatLng(event);
            switch (_doubleClickMode){
                case MapAction.ACTION_PAN:
                    panTo(_loc_2);
                    break;
                case MapAction.ACTION_ZOOM_IN:
                    zoomIn(null, false, true);
                    break;
                case MapAction.ACTION_PAN_ZOOM_IN:
                    zoomIn(_loc_2, true, true);
                    break;
                case MapAction.ACTION_NOTHING:
                    break;
            };
            isMouseDown = false;
            if (isClickValid){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DOUBLE_CLICK, this, _loc_2));
            };
        }
        public function getMaxZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            var _loc_3:IMapType;
            var _loc_4:LatLng;
            var _loc_5:Number = NaN;
            _loc_3 = getOptMapType(param1);
            _loc_4 = ((param2) || (_center));
            _loc_5 = _loc_3.getMaximumResolution(_loc_4);
            return (Math.min(_loc_5, maxZoomLevel_));
        }
        private function displayMessage(param1:String):void{
            if (messageBox){
                sizeMessageBox();
                messageBox.setText(param1);
            };
        }
        private function doContinuousZoom():void{
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            if (zoomSiner){
                _loc_1 = zoomSiner.next();
                _loc_2 = (zoomStart + (_loc_1 * zoomBy));
                if (((zoomTargetStart) && (zoomTargetEnd))){
                    _center = interpolateLatLngLinear(zoomTargetStart, zoomTargetEnd, _loc_1);
                } else {
                    postZoomCenter(_loc_2);
                };
                _zoom = _loc_2;
                configureCamera();
                dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_STEP, getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_STEP, getZoom()));
                if (!zoomSiner.more()){
                    zoomSiner = null;
                    finishContinuousZoom();
                };
            };
        }
        private function removeCopyrightView():void{
            var _loc_1:DisplayObjectContainer;
            if (copyrightView){
                copyrightView.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, sizeCopyright);
                _loc_1 = spriteFactory.getParent(copyrightView);
                if (_loc_1){
                    spriteFactory.removeChild(_loc_1, copyrightView);
                };
                copyrightView.unload();
                copyrightView = null;
            };
            if (googleLogo){
                _loc_1 = spriteFactory.getParent(googleLogo);
                if (_loc_1){
                    spriteFactory.removeChild(_loc_1, googleLogo);
                };
                googleLogo = null;
            };
        }
        private function onMouseWheel(event:MouseEvent):void{
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:Point;
            var _loc_5:LatLng;
            if (((!(isLoaded())) || (!(ownsMouseEvent(event))))){
                return;
            };
            event.stopPropagation();
            if (!scrollWheelZoomEnabled()){
                return;
            };
            _loc_2 = getTimer();
            _loc_3 = (_loc_2 - timerMouseWheel);
            if ((((_loc_3 >= 0)) && ((_loc_3 < MOUSE_WHEEL_NULL_TIME)))){
                return;
            };
            timerMouseWheel = _loc_2;
            _loc_4 = getLocalCoords(event);
            _loc_5 = fromViewportToLatLng(_loc_4, true);
            if (event.delta < 0){
                zoomOut(_loc_5, true);
            } else {
                zoomIn(_loc_5, false, true);
            };
        }
        public function get dragMode():int{
            return (_dragMode);
        }
        override public function get interfaceChain():Array{
            return (["IMap", "IWrappableEventDispatcher"]);
        }
        private function attitudeDelta(param1:Number, param2:Number, param3:Number, param4:Boolean):void{
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            _loc_5 = MapUtil.wrapHalfOpen((_attitude.yaw + param1), -180, 180);
            _loc_6 = Util.bound((_attitude.pitch + param2), Camera.MIN_PITCH, Camera.MAX_PITCH);
            _loc_7 = Util.bound((_attitude.roll + param3), Camera.MIN_ROLL, Camera.MAX_ROLL);
            flyTo(_center, _zoom, new Attitude(_loc_5, _loc_6, _loc_7), (param4) ? 1 : 0);
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
            mcBack.graphics.clear();
            _loc_2 = getViewport();
            Render.beginFill(mcBack.graphics, _backgroundFillStyle);
            mcBack.graphics.lineStyle();
            mcBack.graphics.drawRect(_loc_2.left, _loc_2.top, _loc_2.width, _loc_2.height);
            mcBack.graphics.endFill();
            _focusSprite.graphics.clear();
            _focusSprite.graphics.beginFill(Color.BLACK, Alpha.UNSEEN);
            _focusSprite.graphics.drawRect(0, 0, _loc_2.width, _loc_2.height);
            _focusSprite.x = _loc_2.left;
            _focusSprite.x = _loc_2.top;
            _focusSprite.width = _loc_2.width;
            _focusSprite.height = _loc_2.height;
            _focusSprite.graphics.endFill();
            mcFore.graphics.clear();
            if (_crosshairs){
                _loc_5 = (viewportSize.x / 2);
                _loc_6 = (viewportSize.y / 2);
                _loc_7 = _crosshairsStrokeStyle;
                mcFore.graphics.lineStyle((_loc_7.thickness as Number), (_loc_7.color as uint), (_loc_7.alpha as Number), (_loc_7.pixelHinting as Boolean));
                mcFore.graphics.moveTo(_loc_5, (_loc_6 - CENTER_CROSS_SIZE));
                mcFore.graphics.lineTo(_loc_5, (_loc_6 + CENTER_CROSS_SIZE));
                mcFore.graphics.moveTo((_loc_5 - CENTER_CROSS_SIZE), _loc_6);
                mcFore.graphics.lineTo((_loc_5 + CENTER_CROSS_SIZE), _loc_6);
            };
            mcMaskTiles.graphics.clear();
            mcMaskPanes.graphics.clear();
            _loc_3 = (2 * _loc_1);
            _loc_4 = Util.dilateRectangle(_loc_2, new Point(-(_loc_3), -(_loc_3)));
            Render.drawRect(mcMaskTiles, _loc_4, Color.BLUE, Alpha.PERCENT_20, Color.BLACK, Alpha.UNSEEN);
            Render.drawRect(mcMaskPanes, _loc_4, Color.BLUE, Alpha.PERCENT_20, Color.BLACK, Alpha.UNSEEN);
        }
        private function getStage():Stage{
            return (container.stage);
        }
        private function onInfoWindowClosed(event:Event):void{
            if (!_infoWindow){
                return;
            };
            _infoWindow.removeEventListener(MapEvent.OVERLAY_REMOVED, onInfoWindowClosed);
            _infoWindow = null;
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_CLOSED, null));
        }
        private function panToViewportRegion(param1:Rectangle):void{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Point;
            _loc_2 = calcOffsetForViewportRegion(param1);
            _loc_3 = getViewportCenter().add(_loc_2);
            _loc_4 = _camera.viewportToWorld(_loc_3);
            internalPanTo(_loc_4, PAN_JUMP_ALLOW);
        }
        public function placeMovieClip(param1:DisplayObject, param2:ControlPosition, param3:Point=null):void{
            placeObject(param1, param2, param3);
        }
        public function continuousZoomEnabled():Boolean{
            return (continuousZoom);
        }
        public function monitorCopyrightInternal(param1:MapImpl):void{
            if (!copyrightView){
                isCopyrightSuppressed = false;
                initCopyrightView();
            };
            copyrightView.monitorMap(param1);
        }
        public function suppressCopyrightInternal(param1:MapImpl):void{
            if (copyrightView){
                return;
            };
            isCopyrightSuppressed = true;
            param1.monitorCopyrightInternal(this);
        }
        private function onCopyrightsUpdated(event:Event):void{
            updateZoomRange();
        }
        private function createUsageTracker():void{
            usageTracker = new UsageTracker(this, usageType);
        }
        private function enterFrame(event:Event):void{
            var _loc_2:int;
            initCopyrightView();
            _loc_2 = getTimer();
            if (((heldKeyboardEvent) && (continuousMove))){
                applyKeyboardEvent(heldKeyboardEvent, Math.min(((3 * (_loc_2 - heldKeyboardTimer)) / 1000), 1), false);
            };
            heldKeyboardTimer = _loc_2;
            if (((flyController.isActive()) && (!(_dragLocal)))){
                advanceFlyController();
                if (!flyController.isActive()){
                    dispatchEvent(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_END, getAttitude()));
                    dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_END, getZoom()));
                    dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_END, getZoom()));
                    dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, getZoom()));
                    dispatchEvent(new MapEvent(MapEvent.FLY_TO_DONE, this));
                    dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, getCenter()));
                };
            };
            if (panSiner){
                doPan();
            };
            if (zoomSiner){
                doContinuousZoom();
            };
            if (tileManager.isAnimatingBlend()){
                tileManager.iterateBlend();
            };
        }
        public function disableScrollWheelZoom():void{
            controlByScrollWheel = false;
        }
        public function addControl(param1:IControl):void{
            var _loc_2:ControlPosition;
            param1.initControlWithMap(this);
            controlList.push(param1);
            spriteFactory.addChild(controlsContainer, param1.getDisplayObject());
            _loc_2 = param1.getControlPosition();
            if (_loc_2){
                placeControl(param1, _loc_2);
            };
            dispatchEvent(new MapEvent(MapEvent.CONTROL_ADDED, param1));
            sizeCopyright();
        }
        public function enableScrollWheelZoom():void{
            controlByScrollWheel = true;
        }
        public function crosshairsEnabled():Boolean{
            return (_crosshairs);
        }
        public function fromPointToLatLng(param1:Point, param2:Number=NaN, param3:Boolean=false):LatLng{
            var _loc_4:Number = NaN;
            _loc_4 = Math.max(0, Math.floor((isNaN(param2)) ? getZoom() : param2));
            return (getProjection().fromPixelToLatLng(param1, _loc_4, param3));
        }
        private function isOnVisibleWorld(param1:Point):Boolean{
            var _loc_2:Rectangle;
            if (!_camera.isOnMap(param1)){
                return (false);
            };
            if (is3DView()){
                _loc_2 = _camera.getVisibleWorld();
                return (_loc_2.containsPoint(_camera.viewportToWorld(param1)));
            };
            return (true);
        }
        public function getViewportCenter():Point{
            return (new Point((viewportSize.x / 2), (viewportSize.y / 2)));
        }
        private function isOverviewMap():Boolean{
            return ((usageType == UsageTracker.URL_ARGVAL_USAGETYPE_OVERVIEW));
        }
        private function setDefaultDragMode(event:MapMouseEvent):void{
            if (((is3DView()) && (event.shiftKey))){
                dragMode = MapAction.DRAGMODE_MAP_YAW_PITCH;
            } else {
                if (((is3DView()) && (event.ctrlKey))){
                    dragMode = MapAction.DRAGMODE_CAMERA_YAW_PITCH;
                } else {
                    dragMode = MapAction.DRAGMODE_LATLNG;
                };
            };
        }
        public function disableCrosshairs():void{
            _crosshairs = false;
            draw();
        }
        public function removeMapType(param1:IMapType):void{
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = mapTypes.length;
            if (_loc_2 <= 1){
                return;
            };
            _loc_3 = 0;
            while (_loc_3 != _loc_2) {
                if (param1 == mapTypes[_loc_3]){
                    mapTypes.splice(_loc_3, 1);
                    if (getCurrentMapType() == param1){
                        configure(mapTypes[0]);
                    };
                    dispatchEvent(new MapEvent(MapEvent.MAPTYPE_REMOVED, param1));
                    return;
                };
                _loc_3++;
            };
        }
        private function configureCamera():void{
            var _loc_1:Point;
            _loc_1 = viewportSize;
            if ((((_loc_1.x <= 0)) || ((_loc_1.y <= 0)))){
                _loc_1 = new Point(0x0100, 0x0100);
            };
            _camera.configure(_center, _zoom, _loc_1, (is3DView()) ? _attitude : null);
        }
        public function fromLatLngToViewport(param1:LatLng, param2:Boolean=false):Point{
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!param2){
                _loc_3 = getCenter().lng();
                _loc_4 = MapUtil.wrap(param1.lng(), (_loc_3 - 180), (_loc_3 + 180));
                param1 = new LatLng(param1.lat(), _loc_4, true);
            };
            return (_camera.latLngToViewport(param1));
        }
        public function get focusSprite():Sprite{
            return (_focusSprite);
        }
        public function savePosition():void{
            savedCenter = getCenter();
            savedZoom = getZoom();
            savedAttitude = _attitude;
        }
        private function isMapTypeRegistered(param1:IMapType):Boolean{
            return ((mapTypes.indexOf(param1) >= 0));
        }
        public function isLoaded():Boolean{
            return (_loaded);
        }
        private function getMouseEventLatLng(event:MouseEvent):LatLng{
            return (fromViewportToLatLng(getLocalCoords(event)));
        }
        public function panBy(param1:Point, param2:Boolean=true):void{
            var _loc_3:Point;
            var _loc_4:Homography;
            var _loc_5:Point;
            var _loc_6:Point;
            var _loc_7:Point;
            var _loc_8:Point;
            _loc_3 = getViewportCenter();
            _loc_4 = _camera.mapViewportToWorld;
            _loc_5 = _camera.getWorldCenter();
            _loc_6 = _loc_4.projectUnitX(_loc_3);
            _loc_7 = _loc_4.projectUnitY(_loc_3);
            _loc_8 = new Point(((_loc_5.x + (_loc_6.x * param1.x)) + (_loc_7.x * param1.y)), ((_loc_5.y + (_loc_6.y * param1.x)) + (_loc_7.y * param1.y)));
            internalPanTo(_loc_8, (param2) ? PAN_JUMP_NONE : PAN_JUMP_FORCE);
        }
        private function internalSetZoom(param1:Number):void{
            configure(null, param1);
        }
        public function setDoubleClickMode(param1:Number):void{
            switch (param1){
                case MapAction.ACTION_PAN:
                case MapAction.ACTION_ZOOM_IN:
                case MapAction.ACTION_PAN_ZOOM_IN:
                case MapAction.ACTION_NOTHING:
                    _doubleClickMode = param1;
            };
        }
        private function onMousePress(event:MouseEvent):void{
            var _loc_2:Number = NaN;
            var _loc_3:Boolean;
            if (((!(isLoaded())) || (!(ownsMouseEvent(event))))){
                return;
            };
            event.stopPropagation();
            isClickValid = true;
            clickValidRegion = new Rectangle(event.stageX, event.stageY);
            _loc_2 = (getOptions().mouseClickRange as Number);
            clickValidRegion.inflate(_loc_2, _loc_2);
            if (((!(_loaded)) || (_dragLocal))){
                return;
            };
            _loc_3 = timedDoubleClick.clickReturnTrueIfDoubleClick();
            if (_loc_3){
                onDoubleClick(event);
            };
            isMouseDown = true;
            MouseHandler.instance().addGlobalMouseUpListener(onMouseRelease);
            if (!_loc_3){
                MouseHandler.instance().addGlobalMouseMoveListener(onMouseDrag);
                if (((isDraggable) && (isOnVisibleWorld(getLocalCoords(event))))){
                    dragStart(event);
                };
            };
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.MOUSE_DOWN, this, getMouseEventLatLng(event)));
        }
        public function getLatLngBounds():LatLngBounds{
            return (_camera.getLatLngBounds());
        }
        public function get viewMode():int{
            return (viewModeValue);
        }
        public function getMapTypes():Array{
            return (mapTypes);
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
            _loc_4 = getSize();
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
            while (_loc_5 < controlList.length) {
                _loc_6 = controlList[_loc_5];
                _loc_7 = _loc_6.getControlPosition();
                _loc_8 = getControlRect(_loc_6);
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
        public function set dragMode(param1:int):void{
            _dragMode = param1;
            updatePivotTarget();
        }
        public function getPaneManager():IPaneManager{
            return (paneManager);
        }
        public function getBoundsZoomLevel(param1:LatLngBounds):Number{
            if (getCurrentMapType()){
                return (getCurrentMapType().getBoundsZoomLevel(param1, getSize()));
            };
            return (NaN);
        }
        public function getCamera():Camera{
            return (_camera);
        }
        public function getViewport():Rectangle{
            return (new Rectangle(0, 0, viewportSize.x, viewportSize.y));
        }
        public function fromViewportToLatLng(param1:Point, param2:Boolean=false):LatLng{
            var _loc_3:LatLng;
            _loc_3 = _camera.viewportToLatLng(param1);
            if (!param2){
                return (LatLng.wrapLatLng(_loc_3));
            };
            return (_loc_3);
        }
        private function cameraAttitudeDelta(param1:Number, param2:Number, param3:Number, param4:Boolean):void{
            var _loc_5:Camera;
            _loc_5 = _camera.tiltCamera(new Attitude(param1, param2, 0));
            flyTo(_loc_5.center, _loc_5.zoom, _loc_5.attitude, (param4) ? 1 : 0);
        }
        private function applyKeyboardEvent(event:KeyboardEvent, param2:Number, param3:Boolean):void{
            var _loc_4:Number = NaN;
            _loc_4 = getZoom();
            if (is3DView()){
                param2 = param2 * (event.altKey ? 0.25 : 1);
            };
            if (event.charCode != 0){
                switch (String.fromCharCode(event.charCode)){
                    case "+":
                        setZoom((_loc_4 + param2), param3);
                        return;
                    case "-":
                        setZoom((_loc_4 - param2), param3);
                        return;
                    case "n":
                        setAttitude(new Attitude(0, _attitude.pitch, _attitude.roll));
                        heldKeyboardEvent = null;
                        return;
                    case "u":
                        setAttitude(new Attitude(_attitude.yaw, 0, _attitude.roll));
                        heldKeyboardEvent = null;
                        return;
                    case "r":
                        setAttitude(new Attitude(0, 0, _attitude.roll));
                        heldKeyboardEvent = null;
                        return;
                };
            };
            if (isAltCtrlShift(event, 0, -1, -1)){
                switch (event.keyCode){
                    case Keyboard.LEFT:
                        panBy(new Point((-(param2) * DEFAULT_PANNING_DISTANCE), 0), param3);
                        break;
                    case Keyboard.RIGHT:
                        panBy(new Point((param2 * DEFAULT_PANNING_DISTANCE), 0), param3);
                        break;
                    case Keyboard.UP:
                        panBy(new Point(0, (-(param2) * DEFAULT_PANNING_DISTANCE)), param3);
                        break;
                    case Keyboard.DOWN:
                        panBy(new Point(0, (param2 * DEFAULT_PANNING_DISTANCE)), param3);
                        break;
                    case Keyboard.PAGE_UP:
                        setZoom((_loc_4 + param2), param3);
                        break;
                    case Keyboard.PAGE_DOWN:
                        setZoom((_loc_4 - param2), param3);
                        break;
                };
            };
            if (isAltCtrlShift(event, 0, -1, 1)){
                switch (event.keyCode){
                    case Keyboard.LEFT:
                        attitudeDelta((-(param2) * DEFAULT_YAW_STEP), 0, 0, param3);
                        break;
                    case Keyboard.RIGHT:
                        attitudeDelta((param2 * DEFAULT_YAW_STEP), 0, 0, param3);
                        break;
                    case Keyboard.UP:
                        attitudeDelta(0, (-(param2) * DEFAULT_PITCH_STEP), 0, param3);
                        break;
                    case Keyboard.DOWN:
                        attitudeDelta(0, (param2 * DEFAULT_PITCH_STEP), 0, param3);
                        break;
                };
            };
            if (isAltCtrlShift(event, 0, 1, -1)){
                switch (event.keyCode){
                    case Keyboard.LEFT:
                        cameraAttitudeDelta((-(param2) * DEFAULT_YAW_STEP), 0, 0, param3);
                        break;
                    case Keyboard.RIGHT:
                        cameraAttitudeDelta((param2 * DEFAULT_YAW_STEP), 0, 0, param3);
                        break;
                    case Keyboard.UP:
                        cameraAttitudeDelta(0, (param2 * DEFAULT_PITCH_STEP), 0, param3);
                        break;
                    case Keyboard.DOWN:
                        cameraAttitudeDelta(0, (-(param2) * DEFAULT_PITCH_STEP), 0, param3);
                        break;
                };
            };
        }
        public function getAttitude():Attitude{
            return (_attitude);
        }
        public function openInfoWindowOnOverlay(param1:LatLng, param2:IOverlay, param3:InfoWindowOptions=null):IInfoWindow{
            var _loc_4:InfoWindow;
            closeInfoWindow();
            _loc_4 = new InfoWindow(param1, param2, param3);
            addOverlay(_loc_4);
            _loc_4.addEventListener(MapEvent.OVERLAY_BEFORE_REMOVED, onInfoWindowClosing);
            _loc_4.addEventListener(MapEvent.OVERLAY_REMOVED, onInfoWindowClosed);
            _infoWindow = _loc_4;
            if (_loc_4.initializationPending){
                _loc_4.addEventListener(MapEvent.COMPONENT_INITIALIZED, panToFitInfoWindow);
            } else {
                panToFitInfoWindow(null);
            };
            dispatchEvent(new MapEvent(MapEvent.INFOWINDOW_OPENED, _loc_4));
            return (_infoWindow);
        }
        private function activateTileManager(param1:int):void{
            var _loc_2:IProjection;
            var _loc_3:Number = NaN;
            if (((tileManager) && ((param1 == viewModeValue)))){
                return;
            };
            if (tileManager){
                tileManager.destroy();
            };
            viewModeValue = param1;
            if ((((viewModeValue == View.VIEWMODE_PERSPECTIVE)) || ((viewModeValue == View.VIEWMODE_ORTHOGONAL)))){
                tileManager = new PerspectiveTileManager(this, tileSprite, spriteFactory);
            } else {
                tileManager = new TileManager(this, tileSprite, spriteFactory);
            };
            _loc_2 = getProjection();
            _camera = createCamera((_loc_2) ? _loc_2 : MERCATOR_PROJECTION);
            configureCamera();
            if (_loaded){
                dispatchEvent(new MapEvent(MapEvent.VIEW_CHANGED, this));
            };
            _loc_3 = Math.round(_zoom);
            if ((((tileManager is TileManager)) && (!((_loc_3 == _zoom))))){
                setZoom(_loc_3, true);
            };
        }
        private function getLocalCoords(event:MouseEvent):Point{
            return (container.globalToLocal(new Point(event.stageX, event.stageY)));
        }
        public function set mouseClickRange(param1:Number):void{
            options.mouseClickRange = param1;
        }
        public function getProjection():IProjection{
            return ((getCurrentMapType()) ? getCurrentMapType().getProjection() : null);
        }
        public function moveUp(param1:Number=100):void{
            if (panSiner){
                return;
            };
            moveByGroundCoords(new Point(0, -(param1)));
        }
        public function flyTo(param1:LatLng, param2:Number=NaN, param3:Attitude=null, param4:Number=1):void{
            var _loc_5:IMapType;
            var _loc_6:Number = NaN;
            var _loc_7:Point;
            if (!isNaN(param2)){
                _loc_5 = getOptMapType(null);
                _loc_6 = maxResolutionZoomBound(param2);
                _loc_5.setMaxResolutionOverride(_loc_6);
            };
            if (param4 > 0){
                _loc_7 = _camera.latLngToWorld(param1);
                flyController.zoomScaleBase = _camera.base;
                flyController.addSegment(getTimer(), new FlyStep(_loc_7, param2, param3), Math.ceil((param4 * 1000)));
            } else {
                configure(null, param2, param1, param3);
            };
        }
        private function reportMouseUp(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        public function getMapsHost():String{
            return (getBootstrap().getMapsHost());
        }
        public function placeControl(param1:IControl, param2:ControlPosition):void{
            var _loc_3:DisplayObject;
            _loc_3 = param1.getDisplayObject();
            placeMovieClip(_loc_3, param2, param1.getSize());
        }
        private function createMessageBox():void{
            if (isOverviewMap()){
                return;
            };
            messageBox = new MessageBox();
            spriteFactory.addChild(container, messageBox);
            getBootstrap().addEventListener(MapEvent.DISPLAY_MESSAGE, onDisplayMessage);
        }
        private function updateZoomRange(event:Event=null):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = getMinZoomLevel();
            _loc_3 = getMaxZoomLevel();
            if (((!((_loc_2 == zoomRangeMin_))) || (!((_loc_3 == zoomRangeMax_))))){
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_RANGE_CHANGED, getZoom()));
                zoomRangeMin_ = _loc_2;
                zoomRangeMax_ = _loc_3;
            };
        }
        private function is3DView():Boolean{
            return ((((viewModeValue == View.VIEWMODE_PERSPECTIVE)) || ((viewModeValue == View.VIEWMODE_ORTHOGONAL))));
        }
        public function getOptions():MapOptions{
            return (options);
        }
        public function get maxZoomLevel():Number{
            return (maxZoomLevel_);
        }
        public function displayHint(param1:String):void{
            if (param1){
                tooltip.htmlText = (("<p>" + param1) + "</p>");
                tooltip.width = (tooltip.textWidth + 5);
                tooltip.height = (tooltip.textHeight + 5);
                adjustTooltipPosition();
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            };
        }
        public function set overlayRaising(param1:Boolean):void{
            _overlayRaising = param1;
        }
        public function enableCrosshairs():void{
            _crosshairs = true;
            draw();
        }
        public function scrollWheelZoomEnabled():Boolean{
            return (controlByScrollWheel);
        }
        private function ownsMouseEvent(event:MouseEvent):Boolean{
            var _loc_2:DisplayObject;
            _loc_2 = (event.target as DisplayObject);
            while (_loc_2) {
                if (_loc_2 == controlsContainer){
                    return (false);
                };
                if (_loc_2 == container){
                    break;
                };
                _loc_2 = spriteFactory.getParent(_loc_2);
            };
            return (true);
        }
        public function closeInfoWindow():Boolean{
            if (_infoWindow){
                _infoWindow.removeEventListener(MapEvent.COMPONENT_INITIALIZED, panToFitInfoWindow);
                removeOverlay(_infoWindow);
                _infoWindow = null;
                return (true);
            };
            return (false);
        }
        public function zoomOut(param1:LatLng=null, param2:Boolean=false):void{
            if (((continuousZoom) && (param2))){
                zoomContinuously(-1, true, param1, false);
            } else {
                zoomNoncontinuously(-1, true, param1, false);
            };
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
            if (_mapType != param1){
                if (_mapType){
                    _mapType.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, onCopyrightsUpdated);
                };
                _mapType = param1;
                _mapType.addEventListener(MapEvent.COPYRIGHTS_UPDATED, onCopyrightsUpdated);
                _camera = createCamera(param1.getProjection());
                configureCamera();
                updateZoomRange();
            };
        }
        private function onKeyUp(event:KeyboardEvent):void{
            heldKeyboardEvent = null;
        }
        private function adjustTooltipPosition():void{
            var _loc_1:Point;
            var _loc_2:int;
            if (!mouseMoveStageCoords){
                return;
            };
            _loc_1 = container.globalToLocal(mouseMoveStageCoords);
            tooltip.x = (_loc_1.x + 20);
            tooltip.y = (_loc_1.y + 20);
            _loc_2 = (tooltip.x + tooltip.textWidth);
            if (_loc_2 >= viewportSize.x){
                tooltip.x = (_loc_1.x - (tooltip.textWidth + 20));
            };
        }
        private function setMinZoomLevel(param1:Number):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = maxResolutionZoomBound(param1);
            if (_loc_2 == minZoomLevel_){
                return;
            };
            if (_loc_2 > getMaxZoomLevel()){
                return;
            };
            _loc_3 = getMinZoomLevel();
            minZoomLevel_ = _loc_2;
            if (minZoomLevel_ > getZoom()){
                internalSetZoom(minZoomLevel_);
            } else {
                if (minZoomLevel_ != _loc_3){
                    updateZoomRange();
                };
            };
        }
        public function returnToSavedPosition():void{
            if (!savedCenter){
                return;
            };
            if (savedZoom == getZoom()){
                if (((!(is3DView())) || (savedAttitude.equals(_attitude)))){
                    panTo(savedCenter);
                    return;
                };
            };
            configure(null, savedZoom, savedCenter, savedAttitude);
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
            if (((focus_) && (isLatLngVisible(focus_)))){
                _loc_2 = _camera.latLngToWorld(focus_);
                _loc_3 = viewportSize;
                _loc_4 = createCamera(getProjection());
                _loc_4.configure(_center, param1, _loc_3, (is3DView()) ? _attitude : null);
                _loc_5 = _loc_2.subtract(_camera.viewportToWorld(getViewportCenter()));
                _loc_6 = _camera.viewportToWorld(_loc_4.latLngToViewport(focus_));
                _loc_7 = _camera.worldToViewport(_loc_6.subtract(_loc_5));
                _loc_8 = _loc_4.viewportToLatLng(_loc_7);
                _loc_9 = LatLng.wrapLatLng(_loc_8);
                _loc_10 = (_loc_9.lng() - _loc_8.lng());
                if (_loc_10 != 0){
                    focus_ = new LatLng(focus_.lat(), (focus_.lng() + _loc_10), true);
                };
                _center = _loc_9;
            };
        }
        public function addMapType(param1:IMapType):void{
            if (((!(param1)) || (isMapTypeRegistered(param1)))){
                return;
            };
            mapTypes.push(param1);
            dispatchEvent(new MapEvent(MapEvent.MAPTYPE_ADDED, param1));
        }
        private function configure(param1:IMapType=null, param2:Number=NaN, param3:LatLng=null, param4:Attitude=null):void{
            var _loc_5:Array;
            var _loc_6:IMapType;
            var _loc_7:Number = NaN;
            var _loc_8:LatLng;
            var _loc_9:Number = NaN;
            var _loc_10:LatLng;
            var _loc_11:int;
            cancelPan();
            _loc_5 = [];
            _loc_6 = getOptMapType(param1);
            _loc_7 = (isNaN(param2)) ? _zoom : param2;
            _loc_8 = (((focus_) && (isLatLngVisible(focus_)))) ? focus_ : _center;
            _loc_9 = mapBoundZoom(_loc_7, _loc_6, _loc_8);
            _loc_10 = _center;
            if (param3){
                _center = param3;
            } else {
                postZoomCenter(_loc_9);
            };
            if (param4){
                if (is3DView()){
                    _loc_5.push(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_START, _attitude));
                    _attitude = param4;
                    _loc_5.push(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_STEP, _attitude));
                    _loc_5.push(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_END, _attitude));
                } else {
                    _attitude = param4;
                };
            };
            if (_loc_9 != _zoom){
                tileManager.setTargetZoom(_loc_9, false);
                _zoom = _loc_9;
                _loc_5.push(new MapZoomEvent(MapZoomEvent.ZOOM_END, getZoom()));
                _loc_5.push(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, getZoom()));
            };
            if (_loc_6 != _mapType){
                _loc_5.push(new MapEvent(MapEvent.MAPTYPE_CHANGED, _loc_6));
                internalSetMapType(_loc_6);
            };
            _loc_5.push(new MapMoveEvent(MapMoveEvent.MOVE_START, _loc_10));
            _loc_5.push(new MapMoveEvent(MapMoveEvent.MOVE_STEP, getCenter()));
            _loc_5.push(new MapMoveEvent(MapMoveEvent.MOVE_END, getCenter()));
            if (!_configured){
                savePosition();
                _configured = true;
            };
            configureCamera();
            _loc_11 = 0;
            while (_loc_11 < _loc_5.length) {
                dispatchEvent(_loc_5[_loc_11]);
                _loc_11++;
            };
        }
        public function draggingEnabled():Boolean{
            return (isDraggable);
        }
        private function finishContinuousZoom():void{
            focus_ = focusBeforeContinuousZoom_;
            _center = new LatLng(_center.lat(), _center.lng());
            configureCamera();
            if (isLoaded()){
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, getCenter()));
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, getCenter()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_END, getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_END, getZoom()));
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, getZoom()));
            };
            zooming_ = false;
        }
        private function onMouseMove(event:MouseEvent):void{
            if (!isLoaded()){
                return;
            };
            mouseMoveStageCoords = new Point(event.stageX, event.stageY);
            if (((!(clickValidRegion)) || (!(clickValidRegion.contains(event.stageX, event.stageY))))){
                isClickValid = false;
                timedDoubleClick = new TimedDoubleClick();
            };
            if (((!(isDraggable)) || (!(isMouseDown)))){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.MOUSE_MOVE, this, getMouseEventLatLng(event)));
            };
        }
        public function unload():void{
            var _loc_1:int;
            var _loc_2:IMouse;
            if (controlList){
                while (controlList.length != 0) {
                    removeControl(controlList[0]);
                };
            };
            closeInfoWindow();
            clearOverlays();
            removeCopyrightView();
            if (usageTracker){
                usageTracker.unload();
                usageTracker = null;
            };
            removeEventListener(MapMoveEvent.MOVE_END, updateZoomRange);
            if (container){
                _loc_2 = MouseHandler.instance();
                _loc_2.removeListener(container, MouseEvent.ROLL_OVER, onMouseRollOver);
                _loc_2.removeListener(container, MouseEvent.ROLL_OUT, onMouseRollOut);
                _loc_2.removeListener(container, MouseEvent.MOUSE_DOWN, onMousePress);
                _loc_2.removeListener(container, MouseEvent.MOUSE_MOVE, onMouseMove);
                _loc_2.removeListener(container, MouseEvent.MOUSE_DOWN, reportMouseDown);
                _loc_2.removeListener(container, MouseEvent.MOUSE_UP, reportMouseUp);
                _loc_2.removeListener(container, MouseEvent.MOUSE_MOVE, reportMouseMove);
                _loc_2.removeListener(container, MouseEvent.MOUSE_WHEEL, onMouseWheel);
                _loc_2.removeGlobalMouseUpListener(onMouseRelease);
                _loc_2.removeGlobalMouseMoveListener(onMouseDrag);
            };
            if (_focusSprite){
                _focusSprite.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
                _focusSprite.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
                configureFocusMouseListener(false);
            };
            getBootstrap().removeEventListener(MapEvent.DISPLAY_MESSAGE, onDisplayMessage);
            removeEventListener(Event.ENTER_FRAME, enterFrame);
            removeEventListener(Event.ADDED_TO_STAGE, addKeyDownListener);
            _loc_1 = 0;
            while (_loc_1 != mapTypes.length) {
                mapTypes[_loc_1].removeEventListener(MapEvent.COPYRIGHTS_UPDATED, onCopyrightsUpdated);
                _loc_1++;
            };
            mapTypes = [];
            if (paneManager){
                paneManager.destroy();
            };
            paneManager = null;
            if (tileManager){
                tileManager.destroy();
                tileManager = null;
            };
        }
        public function advanceFlyController():void{
            var _loc_1:FlyStep;
            _loc_1 = flyController.advanceTo(getTimer());
            _center = _camera.worldToLatLng(_loc_1.center);
            _zoom = _loc_1.zoom;
            _attitude = _loc_1.attitude;
            configureCamera();
            dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, _center));
            dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_STEP, _zoom));
            dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_STEP, _zoom));
            dispatchEvent(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_STEP, _attitude));
        }
        private function onMouseRollOver(event:MouseEvent):void{
            if (!isLoaded()){
                return;
            };
            event.stopPropagation();
            dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.ROLL_OVER, this, getMouseEventLatLng(event)));
        }
        public function get mouseClickRange():Number{
            return ((options.mouseClickRange as Number));
        }
        private function createChildren():void{
            var _loc_1:IMapFocusableComponent;
            var _loc_2:IMouse;
            if (((!(container)) || (mc))){
                return;
            };
            mcBack = Bootstrap.createChildSprite(container);
            mcBack.name = "backgroundmc";
            mc = Bootstrap.createChildComponent(container);
            mc.name = "mapmc";
            mcMaskTiles = Bootstrap.createChildSprite(container);
            mcMaskPanes = Bootstrap.createChildSprite(container);
            controlsContainer = Bootstrap.createChildComponent(container);
            controlsContainer.name = "controlsmc";
            mcFore = Bootstrap.createChildSprite(container);
            mcFore.mouseEnabled = false;
            mcFore.addChild(pivotTarget);
            pivotTarget.visible = false;
            tileManager = null;
            tileSprite = Bootstrap.createChildSprite(mc);
            tileSprite.name = "tilesmc";
            tileSprite.mask = mcMaskTiles;
            activateTileManager(viewModeValue);
            _focusSprite = Bootstrap.createChildComponent(mc, -1, true);
            configureFocusMouseListener(_controlByKeyboard);
            _loc_1 = getFocusComponent();
            if (_loc_1){
                _loc_1.focusable = _controlByKeyboard;
            };
            _loc_2 = MouseHandler.instance();
            _loc_2.addListener(container, MouseEvent.ROLL_OVER, onMouseRollOver);
            _loc_2.addListener(container, MouseEvent.ROLL_OUT, onMouseRollOut);
            _loc_2.addListener(container, MouseEvent.MOUSE_DOWN, onMousePress);
            _loc_2.addListener(container, MouseEvent.MOUSE_MOVE, onMouseMove);
            if (!getBootstrap().isClientVersionAfter(3)){
                _loc_2.addListener(container, MouseEvent.MOUSE_DOWN, reportMouseDown);
                _loc_2.addListener(container, MouseEvent.MOUSE_UP, reportMouseUp);
                _loc_2.addListener(container, MouseEvent.MOUSE_MOVE, reportMouseMove);
            };
            panesContainer = Bootstrap.createChildComponent(mc);
            panesContainer.name = "overlaysmc";
            panesContainer.mask = mcMaskPanes;
            paneManager = new PaneManager(this, panesContainer, spriteFactory);
            controlList = [];
            container.useHandCursor = false;
            createMessageBox();
            createTooltip();
        }
        public function getImplementationVersion():String{
            return (Release.version);
        }
        public function getFocus():LatLng{
            return (focus_);
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
        private function onMouseRelease(param1:Boolean, param2:MouseEvent):void{
            if (((!(isLoaded())) || (!(isMouseDown)))){
                return;
            };
            MouseHandler.instance().removeGlobalMouseUpListener(onMouseRelease);
            MouseHandler.instance().removeGlobalMouseMoveListener(onMouseDrag);
            if (_dragLocal){
                dragStop(param2);
            };
            isMouseDown = false;
            dispatchEvent(MapMouseEvent.createFromMouseEvent(param2, MapMouseEvent.MOUSE_UP, this, getMouseEventLatLng(param2)));
            if (((param1) && (isClickValid))){
                dispatchEvent(MapMouseEvent.createFromMouseEvent(param2, MapMouseEvent.CLICK, this, getMouseEventLatLng(param2)));
            };
        }
        public function setAttitude(param1:Attitude):void{
            configure(null, NaN, null, param1);
        }
        private function sizeMessageBox():void{
            var _loc_1:Rectangle;
            if (!messageBox){
                return;
            };
            _loc_1 = getRectBetweenTopEdgeControls();
            if (_loc_1.width < MESSAGE_BOX_MIN_WIDTH){
                _loc_1 = getViewport();
            };
            _loc_1.inflate(-10, -10);
            messageBox.setWidth(_loc_1.width);
            placeObject(messageBox, new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT, _loc_1.left, _loc_1.top));
        }
        public function get overlayRaising():Boolean{
            return (_overlayRaising);
        }
        public function get camera():ICamera{
            return (_camera);
        }
        public function getDisplayObject():DisplayObject{
            return (container);
        }
        private function createCamera(param1:IProjection):Camera{
            var _loc_2:Number = NaN;
            _loc_2 = Camera.FOCAL_LENGTH_ORTHOGONAL;
            if (viewModeValue == View.VIEWMODE_PERSPECTIVE){
                _loc_2 = Camera.FOCAL_LENGTH_3D;
            };
            return (new Camera(_loc_2, param1));
        }
        private function reportMouseMove(event:MouseEvent):void{
            MouseHandler.instance().reportMouseEvent(event);
        }
        private function internalPanTo(param1:Point, param2:int):void{
            var _loc_3:Point;
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            cancelPan();
            _loc_3 = _camera.viewportToWorld(getViewportCenter());
            _loc_4 = param1.subtract(_loc_3);
            if ((((_loc_4.x == 0)) && ((_loc_4.y == 0)))){
                return;
            };
            _loc_4.x = (_loc_4.x * _camera.zoomScale);
            _loc_4.y = (_loc_4.y * _camera.zoomScale);
            if ((((param2 == PAN_JUMP_FORCE)) || ((((param2 == PAN_JUMP_ALLOW)) && ((((Math.abs(_loc_4.x) > viewportSize.x)) || ((Math.abs(_loc_4.y) > viewportSize.y)))))))){
                setCenter(fromPointToLatLng(param1, 0));
            } else {
                _loc_5 = Math.max(5, Math.round((_loc_4.length / 20)));
                panSiner = new Siner(_loc_5);
                panSiner.reset();
                panStart = _loc_3;
                panDestination = param1;
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, getCenter()));
                doPan();
            };
        }
        public function getCenter():LatLng{
            return (_center.clone());
        }
        public function setZoom(param1:Number, param2:Boolean=false):void{
            if (((continuousZoom) && (param2))){
                zoomContinuously(param1);
            } else {
                internalSetZoom(param1);
            };
        }
        private function dragStop(event:MouseEvent):void{
            _dragLocal = null;
            updatePivotTarget();
            configureCamera();
            if (_dragged){
                _dragged = false;
                dispatchEvent(MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_END, this, getCenter()));
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, getCenter()));
            };
            if (flyController.isActive()){
                flyController.continueFrom(getTimer());
            };
        }
        public function setCenter(param1:LatLng, param2:Number=NaN, param3:IMapType=null):void{
            var _loc_4:IMapType;
            var _loc_5:Number = NaN;
            if (!isNaN(param2)){
                _loc_4 = getOptMapType(param3);
                _loc_5 = maxResolutionZoomBound(param2);
                _loc_4.setMaxResolutionOverride(_loc_5);
            };
            configure(param3, param2, param1);
        }
        public function enableControlByKeyboard():void{
            var _loc_1:IMapFocusableComponent;
            _controlByKeyboard = true;
            _loc_1 = getFocusComponent();
            if (_loc_1){
                _loc_1.focusable = true;
            };
            configureFocusMouseListener(_controlByKeyboard);
        }
        public function removeOverlay(param1:IOverlay):void{
            var _loc_2:IPane;
            _loc_2 = param1.pane;
            if (_loc_2){
                _loc_2.removeOverlay(param1);
            };
        }
        public function getPrintableBitmap():Bitmap{
            var _loc_1:BitmapData;
            _loc_1 = new BitmapData(viewportSize.x, viewportSize.y);
            _loc_1.draw(getDisplayObject());
            return (new Bitmap(_loc_1));
        }
        private function getRectBetweenTopEdgeControls():Rectangle{
            var _loc_1:Rectangle;
            var _loc_2:int;
            var _loc_3:IControl;
            var _loc_4:ControlPosition;
            var _loc_5:Rectangle;
            var _loc_6:Number = NaN;
            _loc_1 = getViewport();
            _loc_2 = 0;
            while (_loc_2 < controlList.length) {
                _loc_3 = controlList[_loc_2];
                _loc_4 = _loc_3.getControlPosition();
                if (!_loc_4){
                } else {
                    _loc_5 = getControlRect(_loc_3);
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
        private function dragMove(event:MouseEvent):void{
            var _loc_2:Point;
            var _loc_3:Boolean;
            var _loc_4:Point;
            var _loc_5:Number = NaN;
            var _loc_6:MapMouseEvent;
            var _loc_7:Point;
            var _loc_8:Point;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Camera;
            var _loc_12:Point;
            var _loc_13:Point;
            var _loc_14:Point;
            var _loc_15:Number = NaN;
            var _loc_16:Attitude;
            var _loc_17:Camera;
            var _loc_18:Point;
            _loc_2 = getLocalCoords(event);
            _loc_3 = _camera.isOnMap(_loc_2);
            if (!_dragged){
                _loc_6 = MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_START, this, getCenter());
                setDefaultDragMode(_loc_6);
                dispatchEvent(_loc_6);
                _dragModeActive = _dragMode;
            };
            if (_dragModeActive != _dragMode){
                _dragModeActive = _dragMode;
                dragStop(event);
                dragStart(event);
            };
            if (_loc_3){
                if (!_dragged){
                    dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_START, getCenter()));
                };
                if (((is3DView()) && (isDragRotation(_dragMode)))){
                    _loc_7 = _dragCamera.viewportToWorld(_loc_2);
                    _loc_8 = _loc_2.subtract(_dragLocal);
                    if (_dragMode == MapAction.DRAGMODE_MAP_YAW_PITCH){
                        _loc_11 = dragYawPitch(_loc_8);
                        if (_loc_11){
                            pivotTarget.transform.colorTransform = pivotTargetColorNormal;
                        } else {
                            pivotTarget.transform.colorTransform = pivotTargetColorClamped;
                            _loc_11 = dragYawPitchClamped(_loc_8);
                        };
                        if (_loc_11){
                            _center = _loc_11.center;
                            _zoom = _loc_11.zoom;
                            _attitude = _loc_11.attitude;
                            _camera = _loc_11;
                        };
                    } else {
                        if (_dragMode == MapAction.DRAGMODE_YAW){
                            _loc_4 = _camera.getWorldCenter();
                            _loc_12 = _dragCamera.viewportToWorld(_dragLocal);
                            _loc_13 = _loc_12.subtract(_loc_4);
                            _loc_14 = _loc_7.subtract(_loc_4);
                            _loc_15 = Util.radiansToDegrees((Math.atan2(_loc_14.x, _loc_14.y) - Math.atan2(_loc_13.x, _loc_13.y)));
                            _attitude = new Attitude((_dragAttitude.yaw + _loc_15), _attitude.pitch, _attitude.roll);
                        } else {
                            if (_dragMode == MapAction.DRAGMODE_PITCH){
                                _loc_9 = Util.bound((_dragAttitude.pitch - _loc_8.y), 0, Camera.MAX_PITCH);
                                _attitude = new Attitude(_attitude.yaw, _loc_9, _attitude.roll);
                            } else {
                                if (_dragMode == MapAction.DRAGMODE_CAMERA_YAW_PITCH){
                                    _loc_16 = new Attitude((CAMERA_YAW_PER_DRAG_PIXEL * _loc_8.x), (CAMERA_PITCH_PER_DRAG_PIXEL * _loc_8.y), 0);
                                    _loc_17 = _dragCamera.tiltCamera(_loc_16);
                                    _center = _loc_17.center;
                                    _zoom = _loc_17.zoom;
                                    _attitude = _loc_17.attitude;
                                };
                            };
                        };
                    };
                    dispatchEvent(new MapAttitudeEvent(MapAttitudeEvent.ATTITUDE_CHANGE_STEP, _attitude));
                } else {
                    if (((!(is3DView())) || (isDragTranslation(_dragMode)))){
                        _loc_18 = _camera.viewportToWorld(_loc_2).subtract(_camera.viewportToWorld(_dragLocal));
                        _loc_4 = _camera.getWorldCenter().subtract(_loc_18);
                        _center = LatLng.wrapLatLng(_camera.worldToLatLng(_loc_4));
                        _dragLocal = _loc_2;
                    };
                };
                configureCamera();
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_STEP, getCenter()));
            };
            _loc_5 = _camera.zoom;
            if (_camera.zoom != _dragCamera.zoom){
                dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_CHANGED, _camera.zoom));
            };
            _loc_6 = MapMouseEvent.createFromMouseEvent(event, MapMouseEvent.DRAG_STEP, this, getCenter());
            setDefaultDragMode(_loc_6);
            dispatchEvent(_loc_6);
            _dragged = true;
        }
        private function dragYawPitch(param1:Point):Camera{
            var _loc_2:Camera;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Attitude;
            var _loc_6:Point;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Rectangle;
            var _loc_12:LatLng;
            _loc_2 = createCamera(getProjection());
            _loc_3 = MapUtil.wrapHalfOpen((_dragAttitude.yaw + (YAW_PER_DRAG_PIXEL * param1.x)), -180, 180);
            _loc_4 = Util.bound((_dragAttitude.pitch + (PITCH_PER_DRAG_PIXEL * param1.y)), 0, Camera.MAX_PITCH);
            _loc_5 = new Attitude(_loc_3, _loc_4, _attitude.roll);
            _loc_2.configure(_center, _zoom, viewportSize, _loc_5);
            if (((!(_dragCamera.isOnMap(_dragLocal))) || (!(_loc_2.isOnMap(_dragLocal))))){
                return (null);
            };
            _loc_6 = _dragCamera.viewportToWorld(_dragLocal);
            _loc_7 = _dragCamera.worldDistance(_loc_6);
            _loc_8 = (_zoom + Util.zoomFactorToOffset((_loc_2.worldDistance(_loc_2.viewportToWorld(_dragLocal)) / _loc_7), _camera.base));
            _loc_2.configure(_center, _loc_8, viewportSize, _loc_5);
            if (!_loc_2.isOnMap(_dragLocal)){
                return (null);
            };
            _loc_9 = _loc_6.subtract(_loc_2.viewportToWorld(_dragLocal));
            _loc_10 = _loc_2.getWorldCenter().add(_loc_9);
            _loc_11 = _dragCamera.getVisibleWorld();
            if (((((!(_loc_11.containsPoint(_loc_10))) || (!(_loc_11.containsPoint(_loc_6))))) || (((_loc_8 - _dragCamera.zoom) > 4)))){
                return (null);
            };
            _loc_12 = LatLng.wrapLatLng(_loc_2.worldToLatLng(_loc_10));
            _loc_2.configure(_loc_12, _loc_8, viewportSize, _loc_5);
            return (_loc_2);
        }
        private function dragYawPitchClamped(param1:Point):Camera{
            var _loc_2:Number = NaN;
            var _loc_3:Camera;
            var _loc_4:int;
            var _loc_5:Number = NaN;
            var _loc_6:Camera;
            _loc_2 = 0;
            _loc_3 = null;
            _loc_4 = 0;
            while (_loc_4 < 16) {
                _loc_5 = (_loc_2 + Math.pow(0.5, _loc_4));
                _loc_6 = dragYawPitch(new Point((param1.x * _loc_5), (param1.y * _loc_5)));
                if (_loc_6){
                    _loc_2 = _loc_5;
                    _loc_3 = _loc_6;
                };
                _loc_4++;
            };
            return (_loc_3);
        }
        private function createTooltip():void{
            var _loc_1:TextField;
            var _loc_2:StyleSheet;
            if (isOverviewMap()){
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
            spriteFactory.addChild(container, _loc_1);
            this.tooltip = _loc_1;
        }
        public function moveLeft(param1:Number=100):void{
            if (panSiner){
                return;
            };
            moveByGroundCoords(new Point(-(param1), 0));
        }
        private function get continuousMove():Boolean{
            return (_camera.is3D);
        }
        public function monitorCopyright(param1:IMap):void{
            monitorCopyrightInternal((param1 as MapImpl));
        }
        public function clearOverlays():void{
            paneManager.clearOverlays();
        }
        private function dragStart(event:MouseEvent):void{
            if (panSiner){
                panSiner = null;
            };
            _dragLocal = getLocalCoords(event);
            updatePivotTarget(_dragLocal);
            _dragCamera = _camera.clone();
            _dragged = false;
            _dragAttitude = _attitude;
        }
        private function isLatLngVisible(param1:LatLng):Boolean{
            var _loc_2:Number = NaN;
            var _loc_3:LatLng;
            var _loc_4:Point;
            _loc_2 = MapUtil.wrap(param1.lng(), (_center.lng() - 180), (_center.lng() + 180));
            _loc_3 = new LatLng(param1.lat(), _loc_2, true);
            if (_camera.isAhead(_loc_3)){
                _loc_4 = _camera.latLngToViewport(_loc_3);
                return (getViewport().containsPoint(_loc_4));
            };
            return (false);
        }
        private function onContainerSet():void{
            createChildren();
            addEventListener(Event.ENTER_FRAME, enterFrame);
            DelayHandler.delayCall(configureMap);
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
                    _loc_2.x = ((viewportSize.x - _loc_4.x) - _loc_3.getOffsetX());
                    break;
            };
            switch (_loc_3.getAnchor()){
                case ControlPosition.ANCHOR_TOP_LEFT:
                case ControlPosition.ANCHOR_TOP_RIGHT:
                    _loc_2.y = _loc_3.getOffsetY();
                    break;
                case ControlPosition.ANCHOR_BOTTOM_LEFT:
                case ControlPosition.ANCHOR_BOTTOM_RIGHT:
                    _loc_2.y = ((viewportSize.y - _loc_4.y) - _loc_3.getOffsetY());
                    break;
            };
            _loc_2.width = _loc_4.x;
            _loc_2.height = _loc_4.y;
            return (_loc_2);
        }
        public function setSize(param1:Point):void{
            if (((!((viewportSize.x == param1.x))) || (!((viewportSize.y == param1.y))))){
                viewportSize = param1.clone();
                configureCamera();
                size();
            };
        }
        public function getMinZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            var _loc_3:IMapType;
            var _loc_4:LatLng;
            var _loc_5:Number = NaN;
            _loc_3 = getOptMapType(param1);
            _loc_4 = ((param2) || (_center));
            _loc_5 = _loc_3.getMinimumResolution(_loc_4);
            return (Math.max(_loc_5, minZoomLevel_));
        }
        public function getBootstrap():Bootstrap{
            return (Bootstrap.getBootstrap());
        }
        private function cancelPan():void{
            var _loc_1:InfoWindow;
            if (panSiner){
                panSiner = null;
                dispatchEvent(new MapMoveEvent(MapMoveEvent.MOVE_END, getCenter()));
            };
            _loc_1 = (_infoWindow as InfoWindow);
            if (((_loc_1) && (_loc_1.initializationPending))){
                _loc_1.removeEventListener(MapEvent.COMPONENT_INITIALIZED, panToFitInfoWindow);
            };
        }
        public function set viewMode(param1:int):void{
            if (param1 == View.VIEWMODE_2D){
                dragMode = MapAction.DRAGMODE_LATLNG;
            };
            if ((((((param1 == View.VIEWMODE_2D)) || ((param1 == View.VIEWMODE_PERSPECTIVE)))) || ((param1 == View.VIEWMODE_ORTHOGONAL)))){
                activateTileManager(param1);
            };
        }
        private function zoomNoncontinuously(param1:Number, param2:Boolean=false, param3:LatLng=null, param4:Boolean=false):void{
            var _loc_5:Number = NaN;
            var _loc_6:LatLng;
            param1 = (param2) ? (getZoom() + param1) : param1;
            _loc_5 = mapBoundZoom(param1, _mapType, getCenter());
            if (_loc_5 == param1){
                if (((param3) && (param4))){
                    setCenter(param3, param1, _mapType);
                } else {
                    if (param3){
                        dispatchEvent(new MapZoomEvent(MapZoomEvent.CONTINUOUS_ZOOM_START, getZoom()));
                        dispatchEvent(new MapZoomEvent(MapZoomEvent.ZOOM_START, getZoom()));
                        _loc_6 = focus_;
                        focus_ = param3;
                        internalSetZoom(param1);
                        focus_ = _loc_6;
                    } else {
                        internalSetZoom(param1);
                    };
                };
            } else {
                if (((param3) && (param4))){
                    panTo(param3);
                };
            };
        }
        private function getCopyrightExtentMax():Number{
            return (((viewportSize.x - copyrightPadR) - getFilledSize(ControlPosition.ANCHOR_BOTTOM_RIGHT).x));
        }
        private function initCopyrightView():void{
            var _loc_1:IControl;
            var _loc_2:ControlPosition;
            if (((copyrightView) || (isCopyrightSuppressed))){
                return;
            };
            copyrightView = new CopyrightView(this);
            copyrightView.addEventListener(MapEvent.COPYRIGHTS_UPDATED, sizeCopyright);
            spriteFactory.addChild(mcFore, copyrightView);
            googleLogo = new PoweredByLogo();
            googleLogoPosition = new ControlPosition(ControlPosition.ANCHOR_BOTTOM_LEFT, 3, 2);
            placeMovieClip(googleLogo, googleLogoPosition);
            for each (_loc_1 in controlList) {
                _loc_2 = _loc_1.getControlPosition();
                if (((_loc_2) && ((_loc_2.getAnchor() == ControlPosition.ANCHOR_BOTTOM_LEFT)))){
                    placeControl(_loc_1, _loc_2);
                };
            };
            spriteFactory.addChild(container, googleLogo);
        }
        public function getPane(param1:int):IPane{
            return (paneManager.getPaneById(param1));
        }
        private function updatePivotTarget(param1:Point=null):void{
            if (param1){
                pivotTarget.x = (param1.x - (0.5 * pivotTarget.width));
                pivotTarget.y = (param1.y - (0.5 * pivotTarget.height));
            };
            if (((((_dragLocal) && (_dragged))) && ((_dragMode == MapAction.DRAGMODE_MAP_YAW_PITCH)))){
                pivotTarget.visible = true;
            } else {
                pivotTarget.visible = false;
            };
        }
        private function setMaxZoomLevel(param1:Number):void{
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = maxResolutionZoomBound(param1);
            if (param1 == maxZoomLevel_){
                return;
            };
            if (_loc_2 < getMinZoomLevel()){
                return;
            };
            _loc_3 = getMaxZoomLevel();
            maxZoomLevel_ = _loc_2;
            if (maxZoomLevel_ < getZoom()){
                internalSetZoom(maxZoomLevel_);
            } else {
                if (maxZoomLevel_ != _loc_3){
                    updateZoomRange();
                };
            };
        }
        public function enableDragging():void{
            isDraggable = true;
        }
        public function getCurrentMapType():IMapType{
            return (_mapType);
        }
        public function get MERCATOR_PROJECTION():IProjection{
            return (getBootstrap().getMercatorProjection());
        }
        private function getFocusComponent():IMapFocusableComponent{
            var _loc_1:IWrappableSprite;
            _loc_1 = spriteFactory.toWrappableSprite(_focusSprite);
            return ((_loc_1 as IMapFocusableComponent));
        }
        public function enableContinuousZoom():void{
            continuousZoom = true;
        }
        public function panTo(param1:LatLng):void{
            internalPanTo(_camera.latLngToWorld(param1), PAN_JUMP_ALLOW);
        }

    }
}//package com.mapplus.maps.core 
