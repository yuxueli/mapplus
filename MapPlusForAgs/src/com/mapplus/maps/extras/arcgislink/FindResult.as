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
  public class FindResult
  {
    public var attributes:*;
    public var displayFieldName:String;
    public var foundFieldName:String;
    /**
    * IOverlay[]
    */ 
    public var geometry:Array;
    public var geometryType:String;
    public var layerId:int;
    public var layerName:String;
    public var value:String;
    
    public function FindResult(params:*=null, ovOpts:OverlayOptions=null)
    {
      if (params){
        if (params.geometry){
          geometry=ArcGISUtil.fromGeometryToOverlays(params.geometry, SpatialReferences.WGS84,ovOpts,params.value );
        }
        ArcGISUtil.augmentObject(params, this, false);
      }
    }

  }
}