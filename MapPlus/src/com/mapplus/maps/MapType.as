//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.wrappers.*;
    import flash.events.*;

    public class MapType extends IMapTypeWrapper implements IMapType, IEventDispatcher {

        public function MapType(tileLayers:Array, projection:IProjection, name:String, options:MapTypeOptions=null){
            super();
            var _loc_5:ClientBootstrap;
            var _loc_6:IMapsFactory;
            _loc_5 = ClientBootstrap.getInstance();
            _loc_6 = _loc_5.getMapsFactory();
            Wrapper.instance().wrap(_loc_6.createMapType(tileLayers, projection, name, options), this, IMapType, MapType);
        }
        public static function get HYBRID_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.HYBRID_MAP_TYPE_NAME));
        }
        public static function get SATELLITE_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.SATELLITE_MAP_TYPE_NAME));
        }
        public static function get QQ_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.QQ_MAP_TYPE_NAME));
        }
        public static function get PHYSICAL_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.PHYSICAL_MAP_TYPE_NAME));
        }
        public static function get NORMAL_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.NORMAL_MAP_TYPE_NAME));
        }
        public static function get MAPABC_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.MAPABC_MAP_TYPE_NAME));
        }
        public static function get DEFAULT_MAP_TYPES():Array{
            var _loc_1:ClientBootstrap;
            var _loc_2:IMapsFactory;
            _loc_1 = ClientBootstrap.getInstance();
            _loc_2 = _loc_1.getMapsFactory();
            return (_loc_2.getDefaultMapTypesList());
        }
        private static function getDefaultMapType(param1:String):IMapType{
            var _loc_2:ClientBootstrap;
            var _loc_3:IMapsFactory;
            _loc_2 = ClientBootstrap.getInstance();
            _loc_3 = _loc_2.getMapsFactory();
            return (_loc_3.getDefaultMapType(param1));
        }
        public static function get BING_MAP_TYPE():IMapType{
            return (getDefaultMapType(PConstants.BING_MAP_TYPE_NAME));
        }

    }
}//package com.mapplus.maps 
