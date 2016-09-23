//Created by yuxueli 2011.6.6
package com.mapplus.maps.interfaces {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;

    public interface IClientFactory extends IWrappable {

        function getLoaderContent(param1:Loader):DisplayObject;
        function createTextField():TextField;
        function getVersion():int;
        function getSwcVersion():String;
        function getLoaderInfoContent(param1:LoaderInfo):DisplayObject;
        function drawBitmapData(_arg1:BitmapData, _arg2:IBitmapDrawable, _arg3:Matrix=null, _arg4:ColorTransform=null, _arg5:String=null, _arg6:Rectangle=null, _arg7:Boolean=false):void;
        function copyToBitmap(_arg1:DisplayObject, _arg2:Point, _arg3:Matrix):DisplayObject;
        function getSpriteFactory():ISpriteFactory;

    }
}//package com.mapplus.maps.interfaces 
