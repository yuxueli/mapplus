//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.interfaces.*;

    public class Map3D extends Map implements IMap3D {

        public function Map3D(){
            super();
            setInitOptions(new MapOptions({}));
        }
        public function setAttitude(param1:Attitude):void{
            Wrapper.checkValid(this.instance);
            this.instance.setAttitude(this.extWrapper.wrapAttitude(param1));
        }
        public function get camera():ICamera{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapICamera(this.instance.camera));
        }
        public function getAttitude():Attitude{
            Wrapper.checkValid(this.instance);
            return (Wrapper.instance().wrapAttitude(this.instance.getAttitude()));
        }
        public function get viewMode():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.viewMode);
        }
        override public function setInitOptions(param1:MapOptions):void{
            var _loc_2:MapOptions;
            _loc_2 = new MapOptions({controlByKeyboard:true});
            super.setInitOptions(MapOptions.merge([_loc_2, param1]));
        }
        public function set dragMode(param1:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.dragMode = param1;
        }
        override public function get interfaceChain():Array{
            return (["IMap3D", "IMap"]);
        }
        public function set viewMode(param1:int):void{
            Wrapper.checkValid(this.instance);
            this.instance.viewMode = param1;
        }
        public function cancelFlyTo():void{
            Wrapper.checkValid(this.instance);
            this.instance.cancelFlyTo();
        }
        public function flyTo(param1:LatLng, param2:Number=NaN, param3:Attitude=null, param4:Number=1):void{
            Wrapper.checkValid(this.instance);
            this.instance.flyTo(this.extWrapper.wrapLatLng(param1), param2, this.extWrapper.wrapAttitude(param3), param4);
        }
        public function get dragMode():int{
            Wrapper.checkValid(this.instance);
            return (this.instance.dragMode);
        }

    }
}//package com.mapplus.maps 
