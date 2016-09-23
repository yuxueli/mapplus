//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {

    public interface IPaneManager extends IWrappable {

		function placePaneAt(param1:IPane, param2:int):void;
		function createPane(param1:int=-1):IPane;
		function removePane(param1:IPane):void;
		function removeAllPanes():void;
		function getPaneById(param1:int):IPane;
		function getPaneAt(param1:int):IPane;
		function getPaneIndex(param1:IPane):int;
		function containsPane(param1:IPane):Boolean;
		function clearOverlays():void;
		function get map():IMap;
		function get paneCount():int;

    }
}//package com.mapplus.maps.interfaces 
