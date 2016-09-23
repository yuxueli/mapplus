//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;

    public class IClientFactoryWrapper extends WrapperBase implements IClientFactory {

        public function IClientFactoryWrapper(){
            super();
        }
        public function getLoaderInfoContent(param1:LoaderInfo):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.getLoaderInfoContent(this.extWrapper.wrapLoaderInfo(param1)));
        }
        public function drawBitmapData(param1:BitmapData, param2:IBitmapDrawable, param3:Matrix=null, param4:ColorTransform=null, param5:String=null, param6:Rectangle=null, param7:Boolean=false):void{
            Wrapper.checkValid(this.instance);
            this.instance.drawBitmapData(this.extWrapper.wrapBitmapData(param1), this.extWrapper.wrapIBitmapDrawable(param2), this.extWrapper.wrapMatrix(param3), this.extWrapper.wrapColorTransform(param4), param5, param6, param7);
        }
        public function getLoaderContent(param1:Loader):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.getLoaderContent(param1));
        }
        public function createTextField():TextField{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapTextField(this.instance.createTextField()));
        }
        public function getSpriteFactory():ISpriteFactory{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapISpriteFactory(this.instance.getSpriteFactory()));
        }
        override public function get interfaceChain():Array{
            return (["IClientFactory"]);
        }
        public function getVersion():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.getVersion());
        }
        public function getSwcVersion():String{
            Wrapper.checkValid(this.instance);
            return (this.instance.getSwcVersion());
        }
        public function copyToBitmap(param1:DisplayObject, param2:Point, param3:Matrix):DisplayObject{
            Wrapper.checkValid(this.instance);
            return (this.instance.copyToBitmap(param1, param2, this.extWrapper.wrapMatrix(param3)));
        }

    }
}//package com.mapplus.maps.wrappers 
