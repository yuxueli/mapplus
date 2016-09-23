//Created by yuxueli 2011.6.6
package com.mapplus.maps.wrappers {
    import mx.core.*;
    import mx.events.*;
    import flash.display.*;
    import com.mapplus.maps.*;

    public class WrappableComponentContainer extends WrappableComponent {

        private var uiComponent:UIComponent;

        public function WrappableComponentContainer(param1:DisplayObject){
            super();
            addChild(param1);
            uiComponent = (param1 as UIComponent);
            if (uiComponent){
            };
            if (!(uiComponent.initialized)){
                visible = false;
                uiComponent.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            };
        }
        override protected function updateDisplayList(param1:Number, param2:Number):void{
            var _loc_3:UIComponent;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            super.updateDisplayList(param1, param2);
            _loc_3 = uiComponent;
            if (_loc_3){
            };
            if (contains(_loc_3)){
            };
            if (!(_loc_3.includeInLayout)){
                return;
            };
            if (scaleX > 0){
            };
            _loc_4 = (!((scaleX == 1))) ? (minWidth / Math.abs(scaleX)) : minWidth;
            if (scaleY > 0){
            };
            _loc_5 = (!((scaleY == 1))) ? (minHeight / Math.abs(scaleY)) : minHeight;
            _loc_6 = Math.max(param1, _loc_4);
            _loc_7 = Math.max(param2, _loc_5);
            _loc_8 = _loc_3.percentWidth;
            _loc_9 = _loc_3.percentHeight;
            _loc_10 = (_loc_8) ? MapUtil.bound(((_loc_6 * _loc_8) / 100), _loc_3.minWidth, _loc_3.maxWidth) : _loc_3.getExplicitOrMeasuredWidth();
            _loc_11 = (_loc_9) ? MapUtil.bound(((_loc_7 * _loc_9) / 100), _loc_3.minHeight, _loc_3.maxHeight) : _loc_3.getExplicitOrMeasuredHeight();
            if (_loc_3.scaleX == 1){
            };
            if (_loc_3.scaleY == 1){
                _loc_3.setActualSize(Math.floor(_loc_10), Math.floor(_loc_11));
            } else {
                _loc_3.setActualSize(_loc_10, _loc_11);
            };
        }
        override protected function measure():void{
            var _loc_1:UIComponent;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            super.measure();
            _loc_1 = uiComponent;
            if (_loc_1){
            };
            if (contains(_loc_1)){
            };
            if (!(_loc_1.includeInLayout)){
                return;
            };
            _loc_2 = _loc_1.getExplicitOrMeasuredWidth();
            _loc_3 = _loc_1.getExplicitOrMeasuredHeight();
            measuredMinWidth = Math.max(measuredMinWidth, (isNaN(_loc_1.percentWidth)) ? _loc_2 : _loc_1.minWidth);
            measuredMinHeight = Math.max(measuredMinHeight, (isNaN(_loc_1.percentHeight)) ? _loc_3 : _loc_1.minHeight);
            measuredWidth = _loc_2;
            measuredHeight = _loc_3;
        }
        private function onCreationComplete(event:FlexEvent):void{
            event.target.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            visible = true;
            dispatchEvent(new MapEvent(MapEvent.COMPONENT_INITIALIZED, this));
        }

    }
}//package com.mapplus.maps.wrappers 
