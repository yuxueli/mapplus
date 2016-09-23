//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class Copyright {

        private var supplemental:Boolean;
        private var minZoom:Number;
        private var text:String;
        private var bounds:LatLngBounds;
        private var maxZoom:Number;
        private var id:String;

        public function Copyright(param1:String, param2:LatLngBounds, param3:Number, param4:String, param5:Number=NaN, param6:Boolean=false){
            super();
            this.id = param1;
            this.minZoom = param3;
            this.bounds = param2;
            this.text = param4;
            this.maxZoom = param5;
            this.supplemental = param6;
        }
        public static function fromObject(param1:Object):Copyright{
            if (param1 == null){
                return (null);
            };
            return (new Copyright(param1.getId(), LatLngBounds.fromObject(param1.getBounds()), param1.getMinZoom(), param1.getText(), param1.getMaxZoom(), param1.isSupplemental()));
        }

        public function getMaxZoom():Number{
            return (this.maxZoom);
        }
        public function getText():String{
            return (this.text);
        }
        public function getBounds():LatLngBounds{
            return (this.bounds);
        }
        public function getMinZoom():Number{
            return (this.minZoom);
        }
        public function getId():String{
            return (id);
        }
        public function isSupplemental():Boolean{
            return (this.supplemental);
        }

    }
}//package com.mapplus.maps 
