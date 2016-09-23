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
	
	public class TiandituTileLayer extends TileLayerBase 
	{ 
		public static const EMAP:String = "EMap";//矢量地图
		public static const ANNO:String = "Anno";//矢量标注
		public static const IMGANNO:String = "ImgAnno";//影像标注
		public static const IMG:String = "Img";//影像地图
		
		private var mapMinZoom:int = 1; //最小显示等级 
		private var mapMaxZoom:int = 18;//最大显示等级 
		private var _mapType:String = EMAP;

		public function TiandituTileLayer(tileSize:Number,mapMinZoom:Number,mapMaxZoom:Number,alpha:Number) 
		{ 
			var copyrightCollection:CopyrightCollection = new CopyrightCollection(); 
			//创建一个自己的版权说明 
			copyrightCollection.addCopyright( 
				new Copyright("TiandituData" + MapType, 
					new LatLngBounds(new LatLng(-180, -90), 
						new LatLng(180, 90)),  0,
					"天地图数据",18)); 
			
			super(copyrightCollection, mapMinZoom, mapMaxZoom, alpha);  //调用父类的方法 
		}
		
		public function get MapType():String
		{
			return _mapType;
		}

		public function set MapType(value:String):void
		{
			_mapType = value;
		}

		//覆盖加载地图数据的方法，这个很重要，地图数据从这里读取 
		override public function loadTile(tilePos:Point, zoom:Number):DisplayObject { 
			var testLoader:Loader = new Loader(); 

			var z:Number = Math.pow(2,zoom - 1) - Math.pow(2,zoom - 2) - 1;
			var x:Number = tilePos.x;
			z = Math.pow(2,zoom - 2);
			var y:Number = tilePos.y;
			
			var layerName:String = "";
			var strURL:String = "";
			switch(_mapType){
				case EMAP:
					if (zoom <= 10) {
						layerName = "A0512_EMap";
					} else if (zoom == 11 || zoom == 12) {
						layerName = "B0627_EMap1112";
					} else if (zoom >= 13 && zoom <= 18) {
						layerName = "siwei0608";
					}
					break;
				case IMG:
					if (zoom <= 10) {
						layerName = "sbsm0210";
					} else if (zoom == 11) {
						layerName = "e11";
					} else if (zoom == 12) {
						layerName = "e12";
					} else if (zoom == 13) {
						layerName = "e13";
					} else if (zoom == 14) {
						layerName = "eastdawnall";
					} else if (zoom >= 15 && zoom <= 18) {
						layerName = "sbsm1518";
					}
					break;
				case ANNO:
					if (zoom <= 10) {
						layerName = "AB0512_Anno";
					} else {
						strURL = "http://www.tianditu.com/js/GeoSurfJSAPI/img/blank.gif";
					}
					break;
				case IMGANNO:
					if (zoom <= 10) {
						layerName = "A0610_ImgAnno";
					} else if(zoom >= 11 && zoom <= 14){
						layerName = "B0530_eImgAnno";
					} else if(zoom > 14 && zoom < 19){
						layerName = "siweiAnno68";
					} else {
						strURL = "http://www.tianditu.com/js/GeoSurfJSAPI/img/blank.gif";
					}
					break;
			}
			
			var num:int = Math.random()* 3;
			if(strURL == ""){
				strURL = encodeURI("http://tile" + num + ".tianditu.com/DataServer?" +
					"T=" + layerName +  
					"&X=" + x + 
					"&Y=" + y + 
					"&L=" + zoom +
					"&d=2009-10-22T20:25:15&cd=9999-12-31T00:00:00");
			}
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