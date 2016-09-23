//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import com.mapplus.maps.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.interfaces.*;

    public class StyledMapTypeImpl extends MapTypeImpl implements IStyledMapType {

        public function StyledMapTypeImpl(param1:Array, param2:StyledMapTypeOptions=null){
            var _loc_3:MapTypeOptions;
            var _loc_4:Array;
            _loc_3 = new MapTypeOptions({
                urlArg:"m",
                tileSize:MapTypeImpl.DEFAULT_TILE_SIZE
            });
            if (param2){
                _loc_3.shortName = param2.name;
                _loc_3.minResolution = param2.minResolution;
                _loc_3.maxResolution = param2.maxResolution;
                _loc_3.alt = param2.alt;
            };
            param1 = convertUntypedObjects(param1);
            _loc_4 = (((param2) && (param2.baseMapType))) ? param2.baseMapType.getStyle().slice().concat(param1) : param1;
            super([new StyledMapTileLayer(_loc_4)], Bootstrap.getBootstrap().getMercatorProjection(), (param2) ? param2.name : "", _loc_3);
        }
        static function convertUntypedObjects(param1:Array):Array{
            var _loc_2:int;
            var _loc_3:Object;
            param1 = param1.slice();
            _loc_2 = 0;
            while (_loc_2 < param1.length) {
                if (!((param1[_loc_2] is MapTypeStyle))){
                    _loc_3 = param1[_loc_2];
                    param1[_loc_2] = new MapTypeStyle(_loc_3.featureType, _loc_3.elementType, _loc_3.stylers);
                };
                _loc_2++;
            };
            return (param1);
        }

        public function getStyle():Array{
            return ((tileLayers[0] as StyledMapTileLayer).style);
        }
        public function setStyle(param1:Array):void{
            (tileLayers[0] as StyledMapTileLayer).style = convertUntypedObjects(param1);
            dispatchEvent(new MapEvent(MapEvent.MAPTYPE_STYLE_CHANGED, this));
        }

    }
}//package com.mapplus.maps.core 
