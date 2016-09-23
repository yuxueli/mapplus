//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.events.*;

    public interface IWrappableEventDispatcher extends IEventDispatcher, IWrappable {

        function getBaseEventDispatcher():Object;

    }
}//package com.mapplus.maps.interfaces 
