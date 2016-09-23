//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class Copyright {

        private var supplemental:Boolean;
        private var minZoom:Number;
        private var text:String;
        private var bounds:LatLngBounds;
        private var maxZoom:Number;
        private var id:String;

        public function Copyright(id:String, bounds:LatLngBounds, minZoom:Number, text:String, opt_maxZoom:Number=NaN, opt_isSupplemental:Boolean=false){
            super();
            this.id = id;
            this.bounds = bounds;
            this.minZoom = minZoom;
            this.text = text;
            this.maxZoom = opt_maxZoom;
            this.supplemental = opt_isSupplemental;
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
