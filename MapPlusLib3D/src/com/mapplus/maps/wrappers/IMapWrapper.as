//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.controls.*;
    import com.mapplus.maps.*;
    import flash.utils.*;

    public class IMapWrapper extends IWrappableSpriteWrapper implements IMap {

        public function IMapWrapper(){
            super();
            if (getQualifiedClassName(this).indexOf("::IMapWrapper") != -1){
                throw (new Error(("Abstract class - " + "Cannot instantiate objects of class IMapWrapper directly")));
            };
        }
        public function draggingEnabled():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.draggingEnabled());
        }
        public function getCurrentMapType():IMapType{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMapType(this.instance.getCurrentMapType()));
        }
        public function panTo(param1:LatLng):void{
            Wrapper.checkValid(this.instance);
            this.instance.panTo(this.extWrapper.wrapLatLng(param1));
        }
        override public function get interfaceChain():Array{
            return (["IMap", "IWrappableSprite"]);
        }
        public function getBoundsZoomLevel(param1:LatLngBounds):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getBoundsZoomLevel(this.extWrapper.wrapLatLngBounds(param1)));
        }
        public function unload():void{
            Wrapper.checkValid(this.instance);
            this.instance.unload();
        }
        public function getImplementationVersion():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getImplementationVersion());
        }
        public function clearControls():void{
            Wrapper.checkValid(this.instance);
            this.instance.clearControls();
        }
        public function controlByKeyboardEnabled():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.controlByKeyboardEnabled());
        }
        public function openInfoWindow(param1:LatLng, param2:InfoWindowOptions=null):IInfoWindow{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIInfoWindow(this.instance.openInfoWindow(this.extWrapper.wrapLatLng(param1), this.extWrapper.wrapInfoWindowOptions(param2))));
        }
        public function removeControl(param1:IControl):void{
            Wrapper.checkValid(this.instance);
            this.instance.removeControl(this.extWrapper.wrapIControl(param1));
        }
        public function removeOverlay(param1:IOverlay):void{
            Wrapper.checkValid(this.instance);
            this.instance.removeOverlay(this.extWrapper.wrapIOverlay(param1));
        }
        public function getDoubleClickMode():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getDoubleClickMode());
        }
        public function loadResourceString(param1:String):String{
            Wrapper.checkValid(this.instance);
            return (this.instance.loadResourceString(param1));
        }
        public function get overlayRaising():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.overlayRaising);
        }
        public function getZoom():Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getZoom());
        }
        public function getCenter():LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.getCenter()));
        }
        public function getProjection():IProjection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIProjection(this.instance.getProjection()));
        }
        public function setZoom(param1:Number, param2:Boolean=false):void{
            Wrapper.checkValid(this.instance);
            this.instance.setZoom(param1, param2);
        }
        public function setCenter(param1:LatLng, param2:Number=NaN, param3:IMapType=null):void{
            Wrapper.checkValid(this.instance);
            this.instance.setCenter(this.extWrapper.wrapLatLng(param1), param2, this.extWrapper.wrapIMapType(param3));
        }
        public function placeControl(param1:IControl, param2:ControlPosition):void{
            Wrapper.checkValid(this.instance);
            this.instance.placeControl(this.extWrapper.wrapIControl(param1), this.extWrapper.wrapControlPosition(param2));
        }
        public function zoomIn(param1:LatLng=null, param2:Boolean=false, param3:Boolean=false):void{
            Wrapper.checkValid(this.instance);
            this.instance.zoomIn(this.extWrapper.wrapLatLng(param1), param2, param3);
        }
        public function getPrintableBitmap():Bitmap{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapBitmap(this.instance.getPrintableBitmap()));
        }
        public function enableControlByKeyboard():void{
            Wrapper.checkValid(this.instance);
            this.instance.enableControlByKeyboard();
        }
        public function getOptions():MapOptions{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapMapOptions(this.instance.getOptions()));
        }
        public function displayHint(param1:String):void{
            Wrapper.checkValid(this.instance);
            this.instance.displayHint(param1);
        }
        public function fromLatLngToPoint(param1:LatLng, param2:Number=NaN):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromLatLngToPoint(this.extWrapper.wrapLatLng(param1), param2));
        }
        public function continuousZoomEnabled():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.continuousZoomEnabled());
        }
        public function disableDragging():void{
            Wrapper.checkValid(this.instance);
            this.instance.disableDragging();
        }
        public function set overlayRaising(param1:Boolean):void{
            Wrapper.checkValid(this.instance);
            this.instance.overlayRaising = param1;
        }
        public function enableCrosshairs():void{
            Wrapper.checkValid(this.instance);
            this.instance.enableCrosshairs();
        }
        public function addOverlay(param1:IOverlay):void{
            Wrapper.checkValid(this.instance);
            this.instance.addOverlay(this.extWrapper.wrapIOverlay(param1));
        }
        public function getSize():Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.getSize());
        }
        public function disableScrollWheelZoom():void{
            Wrapper.checkValid(this.instance);
            this.instance.disableScrollWheelZoom();
        }
        public function zoomOut(param1:LatLng=null, param2:Boolean=false):void{
            Wrapper.checkValid(this.instance);
            this.instance.zoomOut(this.extWrapper.wrapLatLng(param1), param2);
        }
        public function enableScrollWheelZoom():void{
            Wrapper.checkValid(this.instance);
            this.instance.enableScrollWheelZoom();
        }
        public function crosshairsEnabled():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.crosshairsEnabled());
        }
        public function scrollWheelZoomEnabled():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.scrollWheelZoomEnabled());
        }
        public function disableContinuousZoom():void{
            Wrapper.checkValid(this.instance);
            this.instance.disableContinuousZoom();
        }
        public function monitorCopyright(param1:IMap):void{
            Wrapper.checkValid(this.instance);
            this.instance.monitorCopyright(this.extWrapper.wrapIMap(param1));
        }
        public function fromPointToLatLng(param1:Point, param2:Number=NaN, param3:Boolean=false):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.fromPointToLatLng(param1, param2, param3)));
        }
        public function closeInfoWindow():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.closeInfoWindow());
        }
        public function clearOverlays():void{
            Wrapper.checkValid(this.instance);
            this.instance.clearOverlays();
        }
        public function setSize(param1:Point):void{
            Wrapper.checkValid(this.instance);
            this.instance.setSize(param1);
        }
        public function disableControlByKeyboard():void{
            Wrapper.checkValid(this.instance);
            this.instance.disableControlByKeyboard();
        }
        public function configureMap():void{
            Wrapper.checkValid(this.instance);
            this.instance.configureMap();
        }
        public function removeMapType(param1:IMapType):void{
            Wrapper.checkValid(this.instance);
            this.instance.removeMapType(this.extWrapper.wrapIMapType(param1));
        }
        public function addControl(param1:IControl):void{
            Wrapper.checkValid(this.instance);
            this.instance.addControl(this.extWrapper.wrapIControl(param1));
        }
        public function disableCrosshairs():void{
            Wrapper.checkValid(this.instance);
            this.instance.disableCrosshairs();
        }
        public function fromLatLngToViewport(param1:LatLng, param2:Boolean=false):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromLatLngToViewport(this.extWrapper.wrapLatLng(param1), param2));
        }
        public function getMinZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMinZoomLevel(this.extWrapper.wrapIMapType(param1), this.extWrapper.wrapLatLng(param2)));
        }
        public function setDoubleClickMode(param1:Number):void{
            Wrapper.checkValid(this.instance);
            this.instance.setDoubleClickMode(param1);
        }
        public function returnToSavedPosition():void{
            Wrapper.checkValid(this.instance);
            this.instance.returnToSavedPosition();
        }
        public function savePosition():void{
            Wrapper.checkValid(this.instance);
            this.instance.savePosition();
        }
        public function isLoaded():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.isLoaded());
        }
        public function getLatLngBounds():LatLngBounds{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLngBounds(this.instance.getLatLngBounds()));
        }
        public function panBy(param1:Point, param2:Boolean=true):void{
            Wrapper.checkValid(this.instance);
            this.instance.panBy(param1, param2);
        }
        public function addMapType(param1:IMapType):void{
            Wrapper.checkValid(this.instance);
            this.instance.addMapType(this.extWrapper.wrapIMapType(param1));
        }
        public function getMaxZoomLevel(param1:IMapType=null, param2:LatLng=null):Number{
            Wrapper.checkValid(this.instance);
            return (this.instance.getMaxZoomLevel(this.extWrapper.wrapIMapType(param1), this.extWrapper.wrapLatLng(param2)));
        }
        public function enableContinuousZoom():void{
            Wrapper.checkValid(this.instance);
            this.instance.enableContinuousZoom();
        }
        public function getDisplayObject():DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.getDisplayObject());
        }
        public function get MERCATOR_PROJECTION():IProjection{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIProjection(this.instance.MERCATOR_PROJECTION));
        }
        public function fromViewportToLatLng(param1:Point, param2:Boolean=false):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.fromViewportToLatLng(param1, param2)));
        }
        public function enableDragging():void{
            Wrapper.checkValid(this.instance);
            this.instance.enableDragging();
        }
        public function getMapTypes():Array{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMapTypeArray(this.instance.getMapTypes()));
        }
        public function setMapType(param1:IMapType):void{
            Wrapper.checkValid(this.instance);
            this.instance.setMapType(this.extWrapper.wrapIMapType(param1));
        }
        public function getPaneManager():IPaneManager{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPaneManager(this.instance.getPaneManager()));
        }

    }
}//package com.mapplus.maps.wrappers 
