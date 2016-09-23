package com.customTileLayer
{
	import com.customTileLayer.*;
	import com.mapplus.maps.LatLng;
	import com.mapplus.maps.interfaces.IProjection;
	
	import flash.geom.Point;
	
	public class TiandituProjection implements IProjection
	{
		private var _wrapper:Object;
		private var pixelRange:Array;
		private var pixelsPerLonDegree:Array;
		private var pixelOrigo:Array;
		private var pixelsPerLonRadian:Array;
		public static const MERCATOR_ZOOM_LEVEL_ZERO_RANGE:Number = 256;
		private var titeSize:int = 256;
		
		public function TiandituProjection(zoom:int)
		{
			var mapSize:Number = MERCATOR_ZOOM_LEVEL_ZERO_RANGE;
			var i:int = 0;
			var mapOrigo:Number = 0;
			pixelsPerLonDegree = [];
			pixelsPerLonRadian = [];
			pixelOrigo = [];
			pixelRange = [];
			while (i < zoom)
			{
				mapOrigo = mapSize / 2;
				pixelsPerLonDegree.push(mapSize / 360);
				pixelsPerLonRadian.push(mapSize / (2 * Math.PI));
				pixelOrigo.push(new Point(mapOrigo, mapOrigo));
				pixelRange.push(mapSize);
				mapSize = mapSize * 2;
				i++;
			}			
		}
		
		public function fromPixelToLatLng(pixel:Point, zoom:Number, nowrap:Boolean = false) : LatLng
		{
			var x:Number = 0;
			var y:Number = 0;

			x = pixel.x / (Math.pow(2,zoom) * titeSize) * 360 - 180;
			y = 90 - pixel.y / (Math.pow(2,zoom-1) * titeSize) * 180;
			
			var latlng:LatLng  = new LatLng(y, x, nowrap);
			return latlng;
		}
		
		public function fromLatLngToPixel(latLng:LatLng, zoom:Number) : Point
		{
			var point:Point = new Point(0,0);
			var x:Number = 0;
			var y:Number = 0;
			
			latLng = new LatLng(latLng.lat(),latLng.lng());
			
			point.x = (latLng.lng() + 180) / 360 * (Math.pow(2,zoom) * titeSize);
			point.y = (90 - latLng.lat()) / 180 * (Math.pow(2,zoom-1) * titeSize);
			
			return point;
		}
		
		public function get interfaceChain() : Array
		{
			return ["IProjection"];
		}
		
		public function get wrapper() : Object
		{
			return this._wrapper;
		}
		
		public function tileCheckRange(param1:Point, param2:Number, param3:Number) : Boolean
		{
			var x:Number = 0;
			var y:Number = 0;
			x = pixelRange[param2];
			if (param1.y < 0 || param1.y * param3 >= x)
			{
				return false;
			}
			if (param1.x < 0 || param1.x * param3 >= x)
			{
				y = Math.floor(x / param3);
				param1.x = param1.x % y;
				if (param1.x < 0)
				{
					param1.x = param1.x + y;
				}
			}
			return true;
		}
		
		public function getWrapWidth(param1:Number) : Number
		{
			return pixelRange[param1];
		}
		
		public function set wrapper(param1:Object) : void
		{
			this._wrapper = param1;
			return;
		}
		
	}
}