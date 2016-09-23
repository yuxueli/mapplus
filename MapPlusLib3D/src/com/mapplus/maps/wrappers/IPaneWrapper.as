//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.*;

    public class IPaneWrapper extends EventDispatcherWrapper implements IPane {

        public function IPaneWrapper(){
            super();
        }
        override public function get interfaceChain():Array{
            return (["IPane"]);
        }
        public function clear():void{
            Wrapper.checkValid(this.instance);
            this.instance.clear();
        }
        public function updatePosition(param1:Boolean=false):void{
            Wrapper.checkValid(this.instance);
            this.instance.updatePosition(param1);
        }
        public function getViewportBounds():Rectangle{
            Wrapper.checkValid(this.instance);
            return (this.instance.getViewportBounds());
        }
        public function fromProjectionPointToPaneCoords(param1:Point):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromProjectionPointToPaneCoords(param1));
        }
        public function get map():IMap{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIMap(this.instance.map));
        }
        public function get id():uint{
            Wrapper.checkValid(this.instance);
            return (this.instance.id);
        }
        public function set visible(param1:Boolean):void{
            Wrapper.checkValid(this.instance);
            this.instance.visible = param1;
        }
        public function get paneManager():IPaneManager{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapIPaneManager(this.instance.paneManager));
        }
        public function bringToTop(param1:IOverlay):void{
            Wrapper.checkValid(this.instance);
            this.instance.bringToTop(this.extWrapper.wrapIOverlay(param1));
        }
        public function fromLatLngToPaneCoords(param1:LatLng, param2:Boolean=false):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromLatLngToPaneCoords(this.extWrapper.wrapLatLng(param1), param2));
        }
        public function get visible():Boolean{
            Wrapper.checkValid(this.instance);
            return (this.instance.visible);
        }
        public function removeOverlay(param1:IOverlay):void{
            Wrapper.checkValid(this.instance);
            this.instance.removeOverlay(this.extWrapper.wrapIOverlay(param1));
        }
        public function addOverlay(param1:IOverlay):void{
            Wrapper.checkValid(this.instance);
            this.instance.addOverlay(this.extWrapper.wrapIOverlay(param1));
        }
        public function fromPaneCoordsToLatLng(param1:Point, param2:Boolean=false):LatLng{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapLatLng(this.instance.fromPaneCoordsToLatLng(param1, param2)));
        }
        public function invalidate():void{
            Wrapper.checkValid(this.instance);
            this.instance.invalidate();
        }
        public function fromPaneCoordsToProjectionPoint(param1:Point):Point{
            Wrapper.checkValid(this.instance);
            return (this.instance.fromPaneCoordsToProjectionPoint(param1));
        }

    }
}//package com.mapplus.maps.wrappers 
