//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.interfaces.*;

    public class MapOptions {

        private var _crosshairsStrokeStyle:StrokeStyle;
        private var _controlByKeyboard:Object;
        private var _backgroundFillStyle:FillStyle;
        private var _continuousZoom:Object;
        private var _dragging:Object;
        private var _crosshairs:Object;
        private var _zoom:Object;
        private var _doubleClickMode:Object;
        private var _scrollWheelZoom:Object;
        private var _overlayRaising:Object;
        private var _mouseClickRange:Object;
        private var _mapTypes:Array;
        private var _mapType:IMapType;
        private var _center:LatLng;

        public function MapOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function merge(param1:Array):MapOptions{
            return ((Wrapper.mergeStyles(MapOptions, param1) as MapOptions));
        }
        public static function fromObject(param1:Object):MapOptions{
            var _loc_2:MapOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (MapOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }

        public function set scrollWheelZoom(param1:Object):void{
            this._scrollWheelZoom = (param1 as Boolean);
        }
        public function get crosshairsStrokeStyle():StrokeStyle{
            return (this._crosshairsStrokeStyle);
        }
        public function set continuousZoom(param1:Object):void{
            this._continuousZoom = (param1 as Boolean);
        }
        public function set crosshairsStrokeStyle(param1:StrokeStyle):void{
            this._crosshairsStrokeStyle = param1;
        }
        public function get continuousZoom():Object{
            return (this._continuousZoom);
        }
        public function get crosshairs():Object{
            return (this._crosshairs);
        }
        public function get scrollWheelZoom():Object{
            return (this._scrollWheelZoom);
        }
        public function get mouseClickRange():Object{
            return (this._mouseClickRange);
        }
        public function get controlByKeyboard():Object{
            return (this._controlByKeyboard);
        }
        public function set dragging(param1:Object):void{
            this._dragging = (param1 as Boolean);
        }
        public function set crosshairs(param1:Object):void{
            this._crosshairs = (param1 as Boolean);
        }
        public function set zoom(param1:Object):void{
            this._zoom = (param1 as Number);
        }
        public function set mapTypes(param1:Array):void{
            this._mapTypes = param1;
        }
        public function set center(param1:LatLng):void{
            this._center = param1;
        }
        public function set mouseClickRange(param1:Object):void{
            this._mouseClickRange = (param1 as Number);
        }
        public function set controlByKeyboard(param1:Object):void{
            this._controlByKeyboard = (param1 as Boolean);
        }
        public function get overlayRaising():Object{
            return (this._overlayRaising);
        }
        public function get mapType():IMapType{
            return (this._mapType);
        }
        public function set backgroundFillStyle(param1:FillStyle):void{
            this._backgroundFillStyle = param1;
        }
        public function get dragging():Object{
            return (this._dragging);
        }
        public function get zoom():Object{
            return (this._zoom);
        }
        public function get center():LatLng{
            return (this._center);
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["zoom", "doubleClickMode"], Number);
            Wrapper.copyProperties(this, param1, ["mouseClickRange"], Number, true);
            Wrapper.copyProperties(this, param1, ["crosshairs", "controlByKeyboard", "overlayRaising", "dragging", "continuousZoom"], Boolean);
            Wrapper.copyProperties(this, param1, ["scrollWheelZoom"], Boolean, true);
            if (param1.backgroundFillStyle != null){
                if (this.backgroundFillStyle == null){
                    this.backgroundFillStyle = new FillStyle();
                };
                this.backgroundFillStyle.copyFromObject(param1.backgroundFillStyle);
            };
            if (param1.crosshairsStrokeStyle != null){
                if (this.crosshairsStrokeStyle == null){
                    this.crosshairsStrokeStyle = new StrokeStyle();
                };
                this.crosshairsStrokeStyle.copyFromObject(param1.crosshairsStrokeStyle);
            };
            if (param1.mapType){
                this.mapType = Wrapper.instance().wrapIMapType(param1.mapType);
            };
            if (param1.mapTypes != null){
                this.mapTypes = Wrapper.instance().wrapIMapTypeArray(param1.mapTypes);
            };
            if (param1.center != null){
                this.center = LatLng.fromObject(param1.center);
            };
        }
        public function get backgroundFillStyle():FillStyle{
            return (this._backgroundFillStyle);
        }
        public function set mapType(param1:IMapType):void{
            this._mapType = param1;
        }
        public function set overlayRaising(param1:Object):void{
            this._overlayRaising = (param1 as Boolean);
        }
        public function toString():String{
            return (((((((((((((((((((((((((((((("MapOptions: {" + "\n\tbackgroundFillStyle: ") + this._backgroundFillStyle) + "\n\tcrosshairs: ") + this._crosshairs) + "\n\tcrosshairsStrokeStyle: ") + this._crosshairsStrokeStyle) + "\n\tcontrolByKeyboard: ") + this._controlByKeyboard) + "\n\tscrollWheelZoom: ") + this._scrollWheelZoom) + "\n\toverlayRaising: ") + this._overlayRaising) + "\n\tdoubleClickMode: ") + this._doubleClickMode) + "\n\tdragging: ") + this._dragging) + "\n\tcontinuousZoom: ") + this._continuousZoom) + "\n\tmapType: ") + this._mapType) + "\n\tmapTypes: ") + this._mapTypes) + "\n\tcenter: ") + this._center) + "\n\tzoom: ") + this._zoom) + "\n\tmouseClickRange: ") + this._mouseClickRange) + "\n\t}"));
        }
        public function set doubleClickMode(param1:Object):void{
            this._doubleClickMode = (param1 as Number);
        }
        public function get doubleClickMode():Object{
            return (this._doubleClickMode);
        }
        public function get mapTypes():Array{
            return (this._mapTypes);
        }

    }
}//package com.mapplus.maps 
