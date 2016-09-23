//Created by yuxueli 2011.6.6
package com.mapplus.maps.core {

    public interface ILoaderInfo {

        function get domain():String;
        function get priority():int;
        function onScheduled():void;

    }
}//package com.mapplus.maps.core 
