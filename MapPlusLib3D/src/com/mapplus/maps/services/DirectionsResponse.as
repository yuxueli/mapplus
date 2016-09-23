//Created by yuxueli 2011.6.6
package com.mapplus.maps.services {
    import com.mapplus.maps.overlays.*;

    dynamic class DirectionsResponse {

        var distanceHtml:String;
        var placemarks:Array;
        var routes:Array;
        var name:String;
        var summaryHtml:String;
        var status:uint;
        var duration:Number;
        var distance:Number;
        var copyrightsHtml:String;
        var encodedPolyline:EncodedPolylineData;
        var durationHtml:String;

        public function DirectionsResponse(){
            super();
        }
    }
}//package com.mapplus.maps.services 
