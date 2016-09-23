/*
* Copyright 2008 Google Inc. 
* Licensed under the Apache License, Version 2.0:
*  http://www.apache.org/licenses/LICENSE-2.0
*/
package com.mapplus.maps.extras.planetary {
	import com.mapplus.maps.Copyright;
	import com.mapplus.maps.CopyrightCollection;
	import com.mapplus.maps.LatLng;
	import com.mapplus.maps.LatLngBounds;
	import com.mapplus.maps.MapType;
	import com.mapplus.maps.MapTypeOptions;
	import com.mapplus.maps.TileLayerBase;
	
    /**
     * Contains all the static Mars map types. To use, import this class and then call on your Map object:
     * addMapType(Sky.VISIBLE_MAP_TYPE);
     */
	public class Sky  {
		
        private static var PLANETARY_MAPS_SERVER:String =  "http://mw1.google.com/mw-planetary/";
        
        private static var SKY_PARAMETERS:Object = {
        "visible" : {
            url: PLANETARY_MAPS_SERVER + "sky/skytiles_v1/",
            zoom_levels: 19
        }
        };
        
        private static var SKY_MAP_TYPES:Object = {};
        
        /**
        * This map type shows a mosaic of the sky, covering the full celestial sphere.
        */
        public static function get VISIBLE_MAP_TYPE():MapType {
            return getMapType("visible");
        }  
        
        private static function getMapType(name:String):MapType {
        	if (!SKY_MAP_TYPES[name]) {
	            var params:Object = SKY_PARAMETERS[name];
	            var copyright:CopyrightCollection = new CopyrightCollection();
	            copyright.addCopyright(
	                new Copyright(
	                  "sky_" + name,
	                   new LatLngBounds(new LatLng(-180, -90), new LatLng(180,90)), 
	                   0, 
	                   "SDSS, DSS Consortium, NASA/ESA/STScI"));
	            var layer:SkyTileLayer = new SkyTileLayer(params.url, copyright, params.zoom_levels);
	            var maptype:MapType = new MapType(
	                [layer],  
	                MapType.NORMAL_MAP_TYPE.getProjection(), 
	                name, 
	                new MapTypeOptions({
	                                  radius: 57.2957763671875,
	                                  shortName: name,
	                                  alt: "Show " + name + " map"
	                }));
	            SKY_MAP_TYPES[name] = maptype;
            }
            return SKY_MAP_TYPES[name];
        }
    } 
}