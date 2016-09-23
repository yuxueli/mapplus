/*
 * ArcGIS for Google Maps Flash API
 *
 * License http://www.apache.org/licenses/LICENSE-2.0
 */
 /**
 * @author nianwei at gmail dot com
 */ 

package com.mapplus.maps.extras.arcgislink
{

  import com.mapplus.maps.LatLng;
  
  public class ReverseGeocodeParameters
  {
    public var distance:Number;
    public var f:String;
    public var location:LatLng;
    public function ReverseGeocodeParameters(params:*=null)
    {
      if (params){
        ArcGISUtil.augmentObject(params, this, false);
      }
    }

  }
}