package com.mapplus.maps.extras.panecontentmanager
{
import com.mapplus.maps.interfaces.IOverlay;
import com.mapplus.maps.interfaces.IPane;
/*
PaneContentManager. 
a new way to organize a list of overlay in a pane.
*/
public interface IPaneContentManager
{
	function set pane(value:IPane):void;
	
	function set dataProvider(value:Array):void;
	
	function set overlayFunction(value:Function):void;
	function get selectedOverlay():IOverlay;
	/**
	 * execute what has to be done.
	 * 
	 * 
	 */ 
	function execute():void;
}
}