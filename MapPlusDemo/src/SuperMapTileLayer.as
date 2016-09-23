package
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
	
	public class SuperMapTileLayer extends TileLayerBase
	{
		private var mapMinZoom:int = 4;	//最小显示等级
		private var mapMaxZoom:int = 19;	//最大显示等级
		
		public function SuperMapTileLayer(tileSize:Number){
			var copyrightCollection:CopyrightCollection = new CopyrightCollection();
			
			super(copyrightCollection, mapMinZoom, mapMaxZoom, 1);	//调用父类的方法
			
			//创建一个自己的版权说明
			copyrightCollection.addCopyright(
				new Copyright("MyCopyright",
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
			
			
			var zoom2: Number = 0;
			
			switch (zoom)
			{
				case 0:
					zoom2 = 1.68933179819187E-09;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);//
					break;
				case 1:
					zoom2 =3.37866359638375E-09 ;//1 / (Length / (256 * Math.Pow(2, zoom)) * zoomconst * 1000);
					break;
				case 2:
					zoom2 = 6.75732719276748E-09;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 3:
					zoom2 = 1.35146543855351E-08;// 1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 4:
					zoom2 = 2.70293087710701E-08;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 5:
					zoom2 = 5.40586175421402E-08;//1 / (Length / (256 * Math.Pow(2, zoom)) * zoomconst * 1000);
					break;
				case 6:
					zoom2 = 1.08117235084281E-07;//1 / (Length / (256 * Math.Pow(2, zoom)) * zoomconst * 1000);
					break;
				case 7:
					zoom2 = 2.16234470168561E-07;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 8:
					zoom2 =4.32468940337028E-07 ;//1 / (Length / (256 * Math.Pow(2, zoom)) * zoomconst * 1000);
					break;
				case 9:
					zoom2 =8.64937880674429E-07 ;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 10:
					zoom2 = 1.72987576134737E-06;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 11:
					zoom2 =3.45975152270073E-06 ;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 12:
					zoom2 = 6.91950304540116E-06;// 1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 13:
					zoom2 = 1.38390060908011E-05;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 14:
					zoom2 =2.76780121816087E-05 ;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 15:
					zoom2 =5.53560243616607E-05;// 1 / (Length / (256 * Math.Pow(2, zoom)) * zoomconst * 1000);
					break;
				case 16:
					zoom2 =0.000110712048723321 ;//1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 17:
					///3.7795199999990155869850405624226
					zoom2 =0.000221424097471213;// 1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 18:
					zoom2 =0.000442848194844675;// 1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break;
				case 19:
					zoom2 =0.000885696390076313;// 1 / (Length / (256 * Math.Pow(2, zoom) ) * zoomconst * 1000);
					break; 				
			}
			
			if ((zoom < mapMinZoom) || (zoom > mapMaxZoom)) {
				urlRequest =  new URLRequest("assets/tiles/nomap.png");	//没有地图时显示的内容
			}
			else{
				//urlRequest = new URLRequest(
				//"assets/tiles/" + zoom+"/"+ tilePos.x + "/" + y +".png");	//地图存放的路径，现在是本地的，也可以是服务器的地址。
				//				urlRequest = new URLRequest(
				//					"http://202.102.112.27:9001/ArcGIS/rest/services/jiangyou/MapServer/tile/"+zoom+"/"+tilePos.y+"/"+tilePos.x);
				
				urlRequest = new URLRequest(
					"http://202.102.108.26:9001/IS/maphandler/ajax/mapmercator/"+zoom2+"/"+tilePos.x+"/"+tilePos.y+"/256/png/0/true/true/map.ashx");
			}
			//string.Format("http://202.102.108.26:9001/IS/maphandler/ajax/mapmercator/{0}/{1}/{2}/256/png/0/true/true/map.ashx", zoom2, pos.X, pos.Y);
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