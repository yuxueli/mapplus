//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.overlays.*;

    dynamic class DirectionsResponse {

        var distanceHtml:String;
        var routes:Array;
        var name:String;
        var duration:Number;
        var copyrightsHtml:String;
        var durationHtml:String;
        var placemarks:Array;
        var summaryHtml:String;
        var status:uint;
        var distance:Number;
        var encodedPolyline:EncodedPolylineData;

        public function DirectionsResponse(){
            super();
        }
    }
}//package com.mapplus.maps.services 
