//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls.common {
    import flash.display.*;
    import flash.geom.*;

    public class IconButton extends Button {

        private var icon:DisplayObject;

        public function IconButton(param1:Sprite){
            super(param1);
        }
        public function setIcon(param1:DisplayObject):void{
            var _loc_2:Point;
            if (this.icon != null){
                this.mc.removeChild(this.icon);
            };
            this.icon = param1;
            this.mc.addChild(this.icon);
            _loc_2 = getButtonSize();
            this.icon.x = Math.ceil(((_loc_2.x / 2) - (this.icon.width / 2)));
            this.icon.y = Math.ceil(((_loc_2.y / 2) - (this.icon.height / 2)));
        }
        private function getIcon():DisplayObject{
            return (this.icon);
        }

    }
}//package com.mapplus.maps.controls.common 
