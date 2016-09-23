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
	
	public class LingtuTileLayer extends TileLayerBase
	{
		private var mapMinZoom:int = 1;	//最小显示等级
		private var mapMaxZoom:int = 18;//最大显示等级
		
		private const imgURL:String = "http://cache2.51ditu.com/";
		
		public function LingtuTileLayer(tileSize:Number)
		{
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			
			super(copyrightCollection, mapMinZoom, mapMaxZoom, 1);	//调用父类的方法
			
			//创建一个自己的版权说明
			copyrightCollection.addCopyright(
				new Copyright("LingtuData",
					new LatLngBounds(new LatLng(-180, -90),
						new LatLng(180, 90)),  0,
					"51地图数据"));
		}
		
		//覆盖加载地图数据的方法，这个很重要，地图数据从这里读取
		override public function loadTile(tilePos:Point, zoom:Number):DisplayObject {
			var testLoader:Loader = new Loader();
			
			var strURL:String = "";
			
			//51地图是从左下角开始为0,0的，所以这里的Y需要翻转一下
			tilePos.y = Math.pow(2,zoom - 1) - (tilePos.y - 1);
			strURL = getTileUrl(tilePos,zoom);
			
			//trace("x:" + tilePos.x + ",y:" + tilePos.y + ",url:" + strURL);
			
			var urlRequest:URLRequest;
			urlRequest =  new URLRequest(strURL);	//没有地图时显示的内容
			
			testLoader.load(urlRequest);
			testLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			return testLoader;
		}
		
		private function getTileUrl(p:Point, zoom:int) : String
		{
			var bx:Number = p.x;
			var by:Number = p.y;
			
			var nGrade:Number = Math.ceil((zoom - 5) / 4);
			var nPreRow:int = 0;
			var nPreCol:int = 0;
			var nPreSize:int = 0;
			var path:String = "";
			for (var i:int = 0; i < nGrade; ++i) {
				var nSize:int = 1 << 4 * (nGrade - i);
				var nRow:int = parseInt((bx - nPreRow * nPreSize) / nSize + "");
				var nCol:int = parseInt((by - nPreCol * nPreSize) / nSize + "");
				path = path + ((nRow > 9 ? (nRow) : ("0" + nRow)) + "" + (nCol > 9 ? (nCol) : ("0" + nCol)) + "/");
				nPreRow = nRow;
				nPreCol = nCol;
				nPreSize = nSize;
			} 
			
			var id:Number = (((bx)&((1<<20)-1))+(((by)&((1<<20)-1))*Math.pow(2,20))+(((zoom)&((1<<8)-1))*Math.pow(2,40)));
			
			return imgURL + zoom + "/" + path + id + ".png";
		}
		
		private function getZoomFactor (zoom:int):Number {
			return Math.pow(2, (18 - zoom)) * 256
		}
		
		//出错处理
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
	}
}