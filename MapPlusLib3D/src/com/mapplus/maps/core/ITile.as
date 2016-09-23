//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {
    import flash.events.*;
    import flash.display.*;

    public interface ITile extends IEventDispatcher {

        function getDisplayObject():DisplayObject;
        function unload():void;
        function get loadComplete():Boolean;

    }
}//package com.mapplus.maps.core 
