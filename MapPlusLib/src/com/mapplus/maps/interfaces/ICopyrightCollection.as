//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import com.mapplus.maps.*;

    public interface ICopyrightCollection extends IWrappableEventDispatcher {

        function getCopyrights(param1:LatLngBounds, param2:Number):Array;
        function getCopyrightNotice(param1:LatLngBounds, param2:Number):CopyrightNotice;
        function getCopyrightsAtLatLng(param1:LatLng):Array;
        function addCopyright(param1:Copyright):Boolean;

    }
}//package com.mapplus.maps.interfaces 
