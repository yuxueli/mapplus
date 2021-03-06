﻿//Created by yuxueli 2011.6.6
package com.mapplus.maps.styles {

    public class MapTypeStyle {

        private var elementTypeVar:String;
        private var stylersVar:Array;
        private var featureTypeVar:String;

        public function MapTypeStyle(param1:String, param2:String, param3:Array){
            super();
            this.featureTypeVar = param1;
            this.elementTypeVar = param2;
            this.stylersVar = param3;
        }
        public static function fromObject(param1:Object):MapTypeStyle{
            var _loc_2:MapTypeStyle;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new MapTypeStyle(param1.featureType, param1.elementType, param1.stylers);
            return (_loc_2);
        }

        public function set featureType(param1:String):void{
            this.featureTypeVar = param1;
        }
        public function set stylers(param1:Array):void{
            this.stylersVar = param1;
        }
        public function set elementType(param1:String):void{
            this.elementTypeVar = param1;
        }
        public function get featureType():String{
            return (this.featureTypeVar);
        }
        public function get stylers():Array{
            return (this.stylersVar);
        }
        public function get elementType():String{
            return (this.elementTypeVar);
        }

    }
}//package com.mapplus.maps.styles 
