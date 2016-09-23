package com.mapplus.demo
{
	import com.mapplus.maps.LatLng;
	import com.mapplus.model.CityDataVo;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;

	public class CityData
	{
		public static const Capital:ArrayCollection = new ArrayCollection([ 
			new CityDataVo("北京",new LatLng(39.55,116.24)),
			new CityDataVo("澳门",new LatLng(21.33,115.07)),
			new CityDataVo("福州",new LatLng(26.05,119.18)),
			new CityDataVo("广州",new LatLng(23.08,113.14)),
			new CityDataVo("贵阳",new LatLng(26.35,106.42)),
			new CityDataVo("郑州",new LatLng(34.46,113.4)),
			new CityDataVo("哈尔滨",new LatLng(45.44,126.36)),
			new CityDataVo("长沙",new LatLng(28.12,112.59)),
			new CityDataVo("沈阳",new LatLng(41.48,123.25)),
			new CityDataVo("呼和浩特",new LatLng(40.48,111.41)),
			new CityDataVo("银川",new LatLng(38.27,106.16)),
			new CityDataVo("西宁",new LatLng(36.38,101.48)),
			new CityDataVo("西安",new LatLng(34.17,108.57)),
			new CityDataVo("上海",new LatLng(31.14,121.29)),
			new CityDataVo("成都",new LatLng(30.4,104.04)),
			new CityDataVo("拉萨",new LatLng(29.39,91.08)),
			new CityDataVo("乌鲁木齐",new LatLng(43.45,87.36))
		]);
		
		public static const WeatherType:Array = new Array(
			"Cloudy",
			"Partly Cloudy",
			"Fog Black",
			"Fog White",
			"Hail",
			"Heavy Rain",
			"Light Rain",
			"Lightning",
			"Sleet",
			"Snow",
			"Sunny"
		);
		
/*		
		[Embed('assets/icon/b_0.gif')]
		public static var b0:Class;
		[Embed('assets/icon/b_1.gif')]
		public static var b1:Class;
		[Embed('assets/icon/b_2.gif')]
		public static var b2:Class;
		[Embed('assets/icon/b_3.gif')]
		public static var b3:Class;
		[Embed('assets/icon/b_4.gif')]
		public static var b4:Class;
		[Embed('assets/icon/b_5.gif')]
		public static var b5:Class;
		[Embed('assets/icon/b_6.gif')]
		public static var b6:Class;
		[Embed('assets/icon/b_7.gif')]
		public static var b7:Class;
		[Embed('assets/icon/b_8.gif')]
		public static var b8:Class;
		[Embed('assets/icon/b_9.gif')]
		public static var b9:Class;
		[Embed('assets/icon/b_10.gif')]
		public static var b10:Class;
		[Embed('assets/icon/b_11.gif')]
		public static var b11:Class;
		[Embed('assets/icon/b_12.gif')]
		public static var b12:Class;
		[Embed('assets/icon/b_13.gif')]
		public static var b13:Class;
		[Embed('assets/icon/b_14.gif')]
		public static var b14:Class;
		[Embed('assets/icon/b_15.gif')]
		public static var b15:Class;
		[Embed('assets/icon/b_16.gif')]
		public static var b16:Class;
		[Embed('assets/icon/b_17.gif')]
		public static var b17:Class;
		[Embed('assets/icon/b_18.gif')]
		public static var b18:Class;
		[Embed('assets/icon/b_19.gif')]
		public static var b19:Class;
		[Embed('assets/icon/b_20.gif')]
		public static var b20:Class;
		[Embed('assets/icon/b_21.gif')]
		public static var b21:Class;
		[Embed('assets/icon/b_22.gif')]
		public static var b22:Class;
		[Embed('assets/icon/b_23.gif')]
		public static var b23:Class;
		[Embed('assets/icon/b_24.gif')]
		public static var b24:Class;
		[Embed('assets/icon/b_25.gif')]
		public static var b25:Class;
		[Embed('assets/icon/b_26.gif')]
		public static var b26:Class;
		[Embed('assets/icon/b_27.gif')]
		public static var b27:Class;
		[Embed('assets/icon/b_28.gif')]
		public static var b28:Class;
		[Embed('assets/icon/b_29.gif')]
		public static var b29:Class;
		[Embed('assets/icon/b_30.gif')]
		public static var b30:Class;
		[Embed('assets/icon/b_nothing.gif')] 
		public static var nothing:Class;
		public static function getIconClass(iconName:String):DisplayObject{
		var iconClass:DisplayObject;
		switch (iconName){
		case "0.gif":
		iconClass = new b0;
		break;
		case "1.gif":
		iconClass = new b1;
		break;
		case "2.gif":
		iconClass = new b2;
		break;
		case "3.gif":
		iconClass = new b3;
		break;
		case "4.gif":
		iconClass = new b4;
		break;
		case "5.gif":
		iconClass = new b5;
		break;
		case "6.gif":
		iconClass = new b6;
		break;
		case "7.gif":
		iconClass = new b7;
		break;
		case "8.gif":
		iconClass = new b8;
		break;
		case "9.gif":
		iconClass = new b9;
		break;
		case "10.gif":
		iconClass = new b10;
		break;
		case "11.gif":
		iconClass = new b11;
		break;
		case "12.gif":
		iconClass = new b12;
		break;
		case "13.gif":
		iconClass = new b13;
		break;
		case "14.gif":
		iconClass = new b14;
		break;
		case "15.gif":
		iconClass = new b15;
		break;
		case "16.gif":
		iconClass = new b16;
		break;
		case "17.gif":
		iconClass = new b17;
		break;
		case "18.gif":
		iconClass = new b18;
		break;
		case "19.gif":
		iconClass = new b19;
		break;
		case "20.gif":
		iconClass = new b20;
		break;
		case "21.gif":
		iconClass = new b21;
		break;
		case "22.gif":
		iconClass = new b22;
		break;
		case "23.gif":
		iconClass = new b23;
		break;
		case "24.gif":
		iconClass = new b24;
		break;
		case "25.gif":
		iconClass = new b25;
		break;
		case "26.gif":
		iconClass = new b26;
		break;
		case "27.gif":
		iconClass = new b27;
		break;
		case "28.gif":
		iconClass = new b28;
		break;
		case "29.gif":
		iconClass = new b29;
		break;
		case "30.gif":
		iconClass = new b30;
		break;
		default:
		iconClass = new nothing;
		break;
		}
		
		return iconClass;
		}
*/
		public function CityData()
		{
		}
		
		public static function toString():void {
			for(var i:int=0;i<31;i++){
				trace("case \"" + i + ".gif\":");
				trace("	iconClass = new b" + i + ";");
				trace("	break;");
			}
		}
	}
}