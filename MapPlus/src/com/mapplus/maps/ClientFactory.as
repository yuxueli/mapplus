//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;

    public class ClientFactory implements IClientFactory {

        private var spriteFactory:ISpriteFactory;
        private var _wrapper:Object;

        public function ClientFactory(){
            super();
        }
        public function get interfaceChain():Array{
            return (["IClientFactory"]);
        }
        public function getSwcVersion():String{
            return (Release.version);
        }
        public function get wrapper():Object{
            return (_wrapper);
        }
        public function getVersion():int{
            return (3);
        }
        public function drawBitmapData(param1:BitmapData, param2:IBitmapDrawable, param3:Matrix=null, param4:ColorTransform=null, param5:String=null, param6:Rectangle=null, param7:Boolean=false):void{
            Wrapper.drawBitmapData(param1, param2, param3, param4, param5, param6, param7);
        }
        public function set wrapper(param1:Object):void{
            this._wrapper = param1;
        }
        public function getSpriteFactory():ISpriteFactory{
            if (!(spriteFactory)){
                spriteFactory = new SpriteFactory();
            };
            return (spriteFactory);
        }
        public function copyToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):DisplayObject{
            return (Wrapper.copyPixelsToBitmap(param1, param2, param3));
        }
        public function getLoaderContent(param1:Loader):DisplayObject{
            return (Wrapper.getLoaderContent(param1));
        }
        public function createTextField():TextField{
            return (new TextField());
        }
        public function getLoaderInfoContent(param1:LoaderInfo):DisplayObject{
            return (Wrapper.getLoaderInfoContent(param1));
        }

    }
}//package com.mapplus.maps 
