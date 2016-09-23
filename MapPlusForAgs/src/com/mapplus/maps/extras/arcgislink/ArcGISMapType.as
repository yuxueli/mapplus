/*
 * ArcGIS for Google Maps Flash API
 *
 * License http://www.apache.org/licenses/LICENSE-2.0
 */
 /**
 * @author nianwei at gmail dot com
 */ 

package com.mapplus.maps.extras.arcgislink {
  import com.mapplus.maps.LatLng;
  import com.mapplus.maps.MapType;
  import com.mapplus.maps.MapTypeOptions;
  import com.mapplus.maps.interfaces.*;
  
  import flash.events.*;
 

/**
 * A customized map type that can be used as background map.
 */ 
  public class ArcGISMapType extends MapType {// MapType already implements IEventDispatcher {
    
    private var projection_:ArcGISTileConfig;
    
    public function ArcGISMapType(tileLayers:*, opt_typeOpts:ArcGISMapTypeOptions=null) {
      var me:ArcGISMapType = this;
      opt_typeOpts=opt_typeOpts || new ArcGISMapTypeOptions();
	  //2011.6.8 付radius默认值，影响比例尺控件　 by于学利
	  opt_typeOpts.radius=opt_typeOpts.radius || LatLng.EARTH_RADIUS;
	  opt_typeOpts.errorMessage=new String("很抱歉，在这一缩放级别的地图上未找到此区域。");
      var layers:Array;
      var i:int;
      if (tileLayers is String){
        layers = [new ArcGISTileLayer(tileLayers)];
      } else if (tileLayers is Array){
        if (tileLayers[0] is String){
          layers = [];
          for (i = 0; i < tileLayers.length; i++){
            layers.push(new ArcGISTileLayer(tileLayers[i]));
          }
        } else {
          layers = tileLayers;
        }
         
      }
      var layer0:ArcGISTileLayer=layers[0] as ArcGISTileLayer;
      var prj:ArcGISTileConfig=opt_typeOpts.projection||layer0.getProjection();
     // var gOpts:MapTypeOptions=new MapTypeOptions({tileSize: prj.getTileSize()});
     // ArcGISUtil.augmentObject(opt_typeOpts, gOpts);
      opt_typeOpts.tileSize =prj.getTileSize(); 
      super(layers, prj, opt_typeOpts.name || layer0.getMapService().name, opt_typeOpts);
      
      function checkLoaded():void{
        if (layersLoaded == layers.length){
          me.init_(layers, opt_typeOpts);
          me.dispatchEvent(new ServiceEvent(ServiceEvent.LOAD));
        }
      }
      var layersLoaded:int;
      for (i = 0 ; i < layers.length; i++){
        var layer:ArcGISTileLayer = layers[i];
        if (opt_typeOpts.projection){
          layer.projection_ = opt_typeOpts.projection;
        }
        var svc:MapService = layer.getMapService();
        if (svc.hasLoaded()){
          layersLoaded++;
        }else {
          svc.addEventListener(ServiceEvent.LOAD, function(evt:Event):void{
            layersLoaded++;
            checkLoaded();
          });
        }
      }
      checkLoaded();
    }
    private function init_(tileLayers:Array, opt_typeOpts:ArcGISMapTypeOptions):void{
      var layer:ArcGISTileLayer = tileLayers[0] as ArcGISTileLayer;
      this.projection_ = layer.getProjection();
    }
    
    public override function getTileSize():Number {
      return this.projection_?this.projection_.getTileSize():super.getTileSize();
    }
    public override function getProjection():IProjection {
      return this.projection_?this.projection_:super.getProjection();
    }
    
  }
}