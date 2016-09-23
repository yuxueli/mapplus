//Created by yuxueli 2011.6.6
package com.mapplus.maps.controls {
    import flash.events.*;
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import com.mapplus.maps.interfaces.*;
    import flash.text.*;
    import com.mapplus.maps.*;

    public class CopyrightView extends Sprite {

        private var updatePending:Boolean;
        private var recordList:Array;
        private var map:IMapBase;
        private var copyrightField:TextField;

        public function CopyrightView(param1:IMapBase){
            super();
            var _loc_2:IClientFactory;
            var _loc_3:TextFormat;
            this.map = param1;
            this.recordList = [];
            _loc_2 = Bootstrap.getBootstrap().getClientFactory();
            if (_loc_2 != null){
                this.copyrightField = _loc_2.createTextField();
            } else {
                this.copyrightField = new TextField();
            };
            this.copyrightField.x = 0;
            this.copyrightField.y = 0;
            this.copyrightField.multiline = true;
            this.copyrightField.autoSize = TextFieldAutoSize.RIGHT;
            this.copyrightField.wordWrap = true;
            this.copyrightField.background = false;
            this.copyrightField.type = TextFieldType.DYNAMIC;
            this.copyrightField.selectable = true;
            _loc_3 = new TextFormat();
            _loc_3.align = TextFormatAlign.RIGHT;
            this.copyrightField.defaultTextFormat = _loc_3;
            this.addChild(this.copyrightField);
            monitorMap(param1);
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            addEventListener(MouseEvent.MOUSE_DOWN, this.stopPropagation);
            addEventListener(MouseEvent.CLICK, this.stopPropagation);
            addEventListener(MouseEvent.DOUBLE_CLICK, this.stopPropagation);
        }
        private function createCopyrightStyleSheet():StyleSheet{
            var _loc_1:StyleSheet;
            var _loc_2:IMapType;
            _loc_1 = new StyleSheet();
            _loc_2 = this.map.getCurrentMapType();
            _loc_1.setStyle("p", {
                color:Color.toHtml(_loc_2.getTextColor()),
                fontFamily:"_sans",
                fontSize:11,
                textDecoration:"none"
            });
            _loc_1.setStyle("a:link", {color:Color.toHtml(_loc_2.getLinkColor())});
            _loc_1.setStyle("a:hover", {
                color:Color.toHtml(_loc_2.getLinkColor()),
                textDecoration:"underline"
            });
            return (_loc_1);
        }
        private function setCopyright(param1:String):void{
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:String;
            if ((((param1 == null)) || (!(this.map.isLoaded())))){
                return;
            };
            if (param1.length > 0){
                param1 = (param1 + " - ");
            };
            _loc_2 = ("<p>" + param1);
            _loc_3 = Bootstrap.getBootstrap().getSettings()[PConstants.TERMS_OF_USE_URL];
            if (_loc_3){
                _loc_4 = Bootstrap.getBootstrap().getMessage(PConstants.TERMS_OF_USE_TEXT);
                if (!_loc_4){
                    _loc_4 = "Terms of Use";
                };
                _loc_2 = (_loc_2 + (((("<a href=\"" + _loc_3) + "\" target=\"_blank\">") + _loc_4) + "</a></p>"));
            };
            copyrightField.styleSheet = createCopyrightStyleSheet();
            copyrightField.htmlText = _loc_2;
            dispatchEvent(new MapEvent(MapEvent.COPYRIGHTS_UPDATED, this));
        }
        override public function set width(param1:Number):void{
            copyrightField.width = param1;
        }
        private function onMapMoveEnd(param1:Object):void{
            updateCopyright();
        }
        private function addRecord(param1:Object):void{
            configureListeners(param1);
            param1.map.addEventListener(MapEvent.MAPTYPE_CHANGED, param1.onMapTypeChanged);
            param1.map.addEventListener(MapEvent.MAP_READY_INTERNAL, param1.onMapReady);
            param1.map.addEventListener(MapMoveEvent.MOVE_END, param1.onMapMoveEnd);
            this.recordList.push(param1);
        }
        private function removeListeners(param1:Object):void{
            var _loc_2:IMapType;
            _loc_2 = param1.mapType;
            if (_loc_2 != null){
                _loc_2.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
            };
        }
        private function onMapTypeChanged(param1:Object):void{
            configureListeners(param1);
            updateCopyright();
        }
        public function monitorMap(param1:IMapBase):void{
            var owner:* = null;
            var mapRecord:* = null;
            var param1:* = param1;
            var map:* = param1;
            owner = this;
            mapRecord = new Object();
            mapRecord.map = map;
            mapRecord.mapType = null;
            mapRecord.onMapTypeChanged = function (event:Event):void{
                owner.onMapTypeChanged(mapRecord);
            };
            mapRecord.onMapMoveEnd = function (event:Event):void{
                owner.onMapMoveEnd(mapRecord);
            };
            mapRecord.onMapReady = function (event:Event):void{
                owner.onMapReady(mapRecord);
            };
            addRecord(mapRecord);
            updateCopyright();
        }
        private function computeCopyrightText():String{
            var _loc_1:String;
            var _loc_2:Array;
            var _loc_3:Object;
            var _loc_4:Number = NaN;
            var _loc_5:String;
            var _loc_6:String;
            var _loc_7:IMapBase;
            var _loc_8:IMapType;
            var _loc_9:Number = NaN;
            var _loc_10:String;
            var _loc_11:CopyrightNotice;
            var _loc_12:Array;
            var _loc_13:Number = NaN;
            _loc_3 = {};
            _loc_3[""] = [];
            _loc_4 = 0;
            while (_loc_4 < this.recordList.length) {
                _loc_7 = this.recordList[_loc_4].map;
                if (_loc_7 == null){
                } else {
                    _loc_8 = _loc_7.getCurrentMapType();
                    if (_loc_8 == null){
                    } else {
                        _loc_2 = _loc_8.getCopyrights(_loc_7.getCamera().get2DLatLngBounds(), Math.round(_loc_7.getZoom()));
                        if (_loc_2 == null){
                        } else {
                            _loc_9 = 0;
                            while (_loc_9 < _loc_2.length) {
                                _loc_10 = (_loc_2[_loc_9] as String);
                                if (_loc_10 != null){
                                    Util.addValueToArray(_loc_3[""], _loc_10);
                                } else {
                                    _loc_11 = (_loc_2[_loc_9] as CopyrightNotice);
                                    _loc_1 = _loc_11.getPrefix();
                                    _loc_12 = _loc_11.getTexts();
                                    if (_loc_12 != null){
                                        if (_loc_3[_loc_1] == null){
                                            _loc_3[_loc_1] = [];
                                        };
                                        Util.addArrayElementsToArray(_loc_3[_loc_1], _loc_11.getTexts());
                                    };
                                };
                                _loc_9 = (_loc_9 + 1);
                            };
                        };
                    };
                };
                _loc_4 = (_loc_4 + 1);
            };
            _loc_5 = "";
            _loc_6 = "";
            for (_loc_1 in _loc_3) {
                _loc_2 = _loc_3[_loc_1];
                if ((((_loc_2 == null)) || ((_loc_2.length == 0)))){
                } else {
                    if (((!((_loc_1 == null))) && (!((_loc_1 == ""))))){
                        _loc_5 = (_loc_5 + _loc_6);
                        _loc_5 = (_loc_5 + _loc_1);
                        _loc_6 = " ";
                    };
                    _loc_13 = 0;
                    while (_loc_13 < _loc_2.length) {
                        _loc_5 = (_loc_5 + _loc_6);
                        _loc_5 = (_loc_5 + _loc_2[_loc_13]);
                        _loc_6 = ", ";
                        _loc_13 = (_loc_13 + 1);
                    };
                };
            };
            return (_loc_5);
        }
        private function stopPropagation(event:Event):void{
            event.stopPropagation();
        }
        private function onMapReady(param1:Object):void{
            configureListeners(param1);
            updateCopyright();
        }
        private function onCopyrightsUpdated(event:Event):void{
            updateCopyright();
        }
        private function onEnterFrame(event:Event):void{
            var _loc_2:String;
            if (!this.updatePending){
                return;
            };
            this.updatePending = false;
            _loc_2 = computeCopyrightText();
            setCopyright(unescape(_loc_2));
        }
        private function removeRecord(param1:Object):void{
            var _loc_2:int;
            removeListeners(param1);
            param1.map.removeEventListener(MapEvent.MAPTYPE_CHANGED, param1.onMapTypeChanged);
            param1.map.removeEventListener(MapEvent.MAP_READY_INTERNAL, param1.onMapReady);
            param1.map.removeEventListener(MapMoveEvent.MOVE_END, param1.onMapMoveEnd);
            _loc_2 = this.recordList.indexOf(param1);
            if (_loc_2 >= 0){
                this.recordList.splice(_loc_2, 1);
            };
        }
        private function configureListeners(param1:Object):void{
            var _loc_2:IMapType;
            var _loc_3:IMapBase;
            _loc_2 = param1.mapType;
            _loc_3 = param1.map;
            if (_loc_3.getCurrentMapType() == _loc_2){
                return;
            };
            if (_loc_2 != null){
                _loc_2.removeEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
                _loc_2 = null;
            };
            if (!_loc_3.isLoaded()){
                return;
            };
            _loc_2 = _loc_3.getCurrentMapType();
            _loc_2.addEventListener(MapEvent.COPYRIGHTS_UPDATED, this.onCopyrightsUpdated);
            param1.mapType = _loc_2;
        }
        private function updateCopyright():void{
            this.updatePending = true;
        }
        public function unload():void{
            while (this.recordList.length > 0) {
                removeRecord(this.recordList[0]);
            };
        }

    }
}//package com.mapplus.maps.controls 
