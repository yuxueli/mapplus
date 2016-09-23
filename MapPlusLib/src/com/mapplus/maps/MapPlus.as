//Created by yuxueli 2011.6.6
package com.mapplus.maps {
	import flash.system.*;
	
	public class MapPlus extends LibraryClip {
		
		public static var mapurl:String = "http://mapplus.googlecode.com/svn/trunk/MapPlus.swf";
		
		public var _bindingsByDestination:Object;
		public var _bindingsBeginWithWord:Object;
		
		public function MapPlus(){
			super();
			this.allowLibraryDomain(mapurl);
		}
		private function allowLibraryDomain(param1:String):void{
			var _loc_2:Number = NaN;
			var _loc_3:RegExp;
			_loc_2 = param1.lastIndexOf("/");
			if (_loc_2 >= 0){
				param1 = param1.substring(0, _loc_2);
			};
			_loc_3 = /:\d+/;
			Security.allowDomain(param1.replace(_loc_3, ""));
		}
		
	}
}//package com.mapplus.maps 