//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.text.*;
    import flash.geom.*;

    public interface IClientFactory extends IWrappable {

        function getLoaderInfoContent(param1:LoaderInfo):DisplayObject;
        function getVersion():int;
        function getSpriteFactory():ISpriteFactory;
        function getLoaderContent(param1:Loader):DisplayObject;
        function createTextField():TextField;
        function getSwcVersion():String;
        function drawBitmapData(param1:BitmapData, param2:IBitmapDrawable, param3:Matrix=null, param4:ColorTransform=null, param5:String=null, param6:Rectangle=null, param7:Boolean=false):void;
        function copyToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):DisplayObject;

    }
}//package com.mapplus.maps.interfaces 
