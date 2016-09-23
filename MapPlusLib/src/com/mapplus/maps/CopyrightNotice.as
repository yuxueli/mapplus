//Created by yuxueli 2011.6.6
package com.mapplus.maps {

    public class CopyrightNotice {

        private var prefix:String;
        private var copyrightTexts:Array;

        public function CopyrightNotice(param1:String, param2:Array){
            super();
            this.prefix = param1;
            this.copyrightTexts = param2;
        }
        public static function fromObject(param1:Object):CopyrightNotice{
            if (param1 == null){
                return (null);
            };
            return (new CopyrightNotice(param1.getPrefix(), param1.getTexts()));
        }

        public function getTexts():Array{
            return (this.copyrightTexts);
        }
        public function getPrefix():String{
            return (this.prefix);
        }
        public function toString():String{
            return (((this.prefix + " ") + this.copyrightTexts.join(", ")));
        }

    }
}//package com.mapplus.maps 
