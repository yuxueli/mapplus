package com.customTileLayer
{
	import com.mapplus.maps.Copyright;
	import com.mapplus.maps.CopyrightCollection;
	import com.mapplus.maps.LatLng;
	import com.mapplus.maps.LatLngBounds;
	import com.mapplus.maps.TileLayerBase;
	import com.mapplus.maps.interfaces.ICopyrightCollection;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	public class BaiduTileLayer extends TileLayerBase
	{
		private var mapMinZoom:int = 1; //最小显示等级
		private var mapMaxZoom:int = 18;//最大显示等级
		public function BaiduTileLayer(tileSize:Number)
		{
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			super(copyrightCollection, mapMinZoom, mapMaxZoom, 1);  //调用父类的方法
			//创建一个自己的版权说明
			copyrightCollection.addCopyright(
				new Copyright("BaiduData",
					new LatLngBounds(new LatLng(-180, -90),
						new LatLng(180, 90)),  0,
					"百度地图数据"));
		}

		//覆盖加载地图数据的方法，这个很重要，地图数据从这里读取
		override public function loadTile(tilePos:Point, zoom:Number):DisplayObject {
			var testLoader:Loader = new Loader();

			zoom = zoom - 1;
			var offsetX:Number = Math.pow(2,zoom);
			var offsetY:Number = offsetX - 1;
			var numX:Number = tilePos.x - offsetX;
			var numY:Number = (-tilePos.y) + offsetY;
			zoom = zoom + 1;
			var num:int = (tilePos.x + tilePos.y) % 8 + 1;
			var x:String = numX.toString().replace("-","M");
			var y:String = numY.toString().replace("-","M");
			var strURL:String = "";
			strURL = "http://q" + num + ".baidu.com/it/u=x=" + x + ";y=" + y + ";z=" + zoom + ";v=005;type=web&fm=44";
			var urlRequest:URLRequest;
			urlRequest =  new URLRequest(strURL);   //没有地图时显示的内容
			testLoader.load(urlRequest);
			testLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			return testLoader;
		}      

		//出错处理

		private function ioErrorHandler(event:IOErrorEvent):void {

			trace("ioErrorHandler: " + event);

		}

	}

}