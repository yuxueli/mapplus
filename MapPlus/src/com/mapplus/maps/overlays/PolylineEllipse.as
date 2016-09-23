//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.interfaces.*;
    import flash.display.*;
    import flash.events.*;

    public class PolylineEllipse extends IPolylineWrapper implements IPolylineShape, IEventDispatcher {

        private static var CREATE_UNLINKED:Array = [];

        public function PolylineEllipse(point:LatLng, r1:Number, r2:Number, rotation:Number, opts:PolylineOptions=null){
            super();
            var _loc_3:ClientBootstrap;
            var _loc_4:IMapsFactory;
            _loc_3 = ClientBootstrap.getInstance();
            _loc_4 = _loc_3.getMapsFactory();
            Wrapper.instance().wrap(_loc_4.createPolylineEllipse(point, r1, r2, rotation, opts), this, IPolylineShape, PolylineShape);
        }
        public static function fromEncoded(param1:Array, param2:PolylineOptions=null):Polyline{
            var _loc_3:Polyline;
            var _loc_4:ClientBootstrap;
            var _loc_5:Object;
            _loc_3 = new Polyline(CREATE_UNLINKED);
            _loc_4 = ClientBootstrap.getInstance();
            _loc_5 = _loc_4.getMapsFactory();
            Wrapper.instance().wrap(_loc_5.createPolylineFromEncoded(param1, param2), _loc_3, IPolyline, Polyline);
            return (_loc_3);
        }

        override public function set pane(param1:IPane):void{
        }
        public function getDisplayObject():DisplayObject{
            return (this.foreground);
        }
        override public function get pane():IPane{
            return (super.pane);
        }

    }
}//package com.mapplus.maps.overlays 
