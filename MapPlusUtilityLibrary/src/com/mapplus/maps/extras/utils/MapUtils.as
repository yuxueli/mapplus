package com.mapplus.maps.extras.utils
{
import com.mapplus.maps.LatLng;
import com.mapplus.maps.LatLngBounds;
import com.mapplus.maps.interfaces.IMap;

public class MapUtils
{
	public function MapUtils()
	{
	}

	public static function autoCenterZoom(map:IMap, latlngs:Array):void{
		
		var bounds:LatLngBounds = new LatLngBounds();
		for each(var latlng:LatLng in latlngs){
			if(latlng == null) continue;
			bounds.extend(latlng);
		}
		map.setCenter(bounds.getCenter(), map.getBoundsZoomLevel(bounds));
	}
}
}