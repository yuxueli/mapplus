//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.display.*;
    import flash.events.*;

    public interface ITile extends IEventDispatcher {

        function getDisplayObject():DisplayObject;
        function get loadComplete():Boolean;
        function unload():void;

    }
}//package com.mapplus.maps.core 
