package com.customTileLayer
{
	import com.mapplus.maps.Color;
	import com.mapplus.maps.Copyright;
	import com.mapplus.maps.CopyrightCollection;
	import com.mapplus.maps.LatLng;
	import com.mapplus.maps.LatLngBounds;
	import com.mapplus.maps.TileLayerBase;
	import com.mapplus.maps.interfaces.ICopyrightCollection;
	import com.mapplus.maps.interfaces.IMap;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	public class AliMapTileLayer extends TileLayerBase
	{
		private var mapMinZoom:int = 3;	//最小显示等级
		private var mapMaxZoom:int = 18;	//最大显示等级
		
		public function AliMapTileLayer(tileSize:Number){
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			
			super(copyrightCollection, mapMinZoom, mapMaxZoom, 1);	//调用父类的方法
			
			//创建一个自己的版权说明
			copyrightCollection.addCopyright(
				new Copyright("AliCopyright",
					new LatLngBounds(new LatLng(-180, -90),
						new LatLng(180, 90)),  0,
					"江苏鸿信系统集成有限公司版权所有"));
		}
		
		//覆盖加载地图数据的方法，这个很重要，地图数据从这里读取
		override public function loadTile(tilePos:Point, zoom:Number):DisplayObject {
			var testLoader:Loader = new Loader();
			//var ymax:int = 1 << zoom;
			//var y:int = ymax - tilePos.y - 1;
			
			var urlRequest:URLRequest;
			
			if ((zoom < mapMinZoom) || (zoom > mapMaxZoom)) {
				urlRequest =  new URLRequest("assets/tiles/nomap.png");	//没有地图时显示的内容
			}
			else{

				urlRequest = new URLRequest(
					"http://img.ditu.aliyun.com/get_png?v=v4&x="+tilePos.x+"&y="+tilePos.y+"&z="+zoom);
			}
			testLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			testLoader.load(urlRequest);        
			return testLoader;
		}
		
		//出错处理
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
	}
}
