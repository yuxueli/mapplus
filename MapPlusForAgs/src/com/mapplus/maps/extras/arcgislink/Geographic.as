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
  /**
  This class will simply retuns same LatLng as Coordinates. 
   *   The <code>param</code> should have wkid property. Any Geographic Coordinate Systems (eg. WGS84(4326)) can 
   *   use this class As-Is. 
   *   <br/>Note:<b> This class does not support datum transformation</b>.
   */
  public class Geographic extends SpatialReference
  {
    public function Geographic(params:Object)
    {
      //TODO: implement function
      super(params);
    }
    
  }
}