package com.mapplus.model
{
	import com.mapplus.maps.LatLng;

	public class CityDataVo
	{
		public var name:String;
		public var latlng:LatLng;
		
		public function CityDataVo(name:String,latlng:LatLng)
		{
			this.name = name;
			this.latlng = latlng;
		}
	}
}