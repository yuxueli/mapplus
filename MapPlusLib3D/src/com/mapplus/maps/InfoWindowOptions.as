//Created by yuxueli 2011.6.6
package com.mapplus.maps {
    import com.mapplus.maps.wrappers.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import com.mapplus.maps.styles.*;

    public class InfoWindowOptions {

        public static const ALIGN_LEFT:Number = 0;
        public static const ALIGN_RIGHT:Number = 2;
        public static const ALIGN_CENTER:Number = 1;

        private var _contentStyleSheet:StyleSheet;
        private var _tailAlign:Object;
        private var _cornerRadius:Object;
        private var _tailHeight:Object;
        private var _content:String;
        private var _customOffset:Point;
        private var _height:Object;
        private var _customCloseRect:Rectangle;
        private var _title:String;
        private var _titleStyleSheet:StyleSheet;
        private var _hasCloseButton:Object;
        private var _fillStyle:FillStyle;
        private var _pointOffset:Point;
        private var _titleHTML:String;
        private var _drawDefaultFrame:Object;
        private var _strokeStyle:StrokeStyle;
        private var _tailOffset:Object;
        private var _titleFormat:TextFormat;
        private var _width:Object;
        private var _customContent:DisplayObject;
        private var _hasTail:Object;
        private var _contentFormat:TextFormat;
        private var _padding:Object;
        private var _tailWidth:Object;
        private var _hasShadow:Object;
        private var _contentHTML:String;

        public function InfoWindowOptions(param1:Object=null){
            super();
            if (param1 != null){
                this.copyFromObject(param1);
            };
        }
        public static function fromObject(param1:Object):InfoWindowOptions{
            var _loc_2:InfoWindowOptions;
            if (param1 == null){
                return (null);
            };
            _loc_2 = new (InfoWindowOptions)();
            _loc_2.copyFromObject(param1);
            return (_loc_2);
        }
        public static function merge(param1:Array):InfoWindowOptions{
            return ((Wrapper.mergeStyles(InfoWindowOptions, param1) as InfoWindowOptions));
        }

        public function set titleFormat(param1:TextFormat):void{
            this._titleFormat = param1;
        }
        public function get tailOffset():Object{
            return (this._tailOffset);
        }
        public function set tailOffset(param1:Object):void{
            this._tailOffset = (param1 as Number);
        }
        public function get hasTail():Object{
            return (this._hasTail);
        }
        public function set titleHTML(param1:String):void{
            this._titleHTML = param1;
            if (this._titleHTML != null){
                this._title = null;
            };
        }
        public function set contentStyleSheet(param1:StyleSheet):void{
            this._contentStyleSheet = param1;
        }
        public function get padding():Object{
            return (this._padding);
        }
        public function get titleHTML():String{
            return (this._titleHTML);
        }
        public function set hasTail(param1:Object):void{
            this._hasTail = (param1 as Boolean);
        }
        public function set customCloseRect(param1:Rectangle):void{
            this._customCloseRect = ((param1)!=null) ? param1.clone() : null;
        }
        public function get drawDefaultFrame():Object{
            return (this._drawDefaultFrame);
        }
        public function set drawDefaultFrame(param1:Object):void{
            this._drawDefaultFrame = (param1 as Boolean);
        }
        public function set padding(param1:Object):void{
            this._padding = (param1 as Number);
        }
        public function get height():Object{
            return (this._height);
        }
        public function set tailAlign(param1:Object):void{
            this._tailAlign = (param1 as Number);
        }
        public function set tailHeight(param1:Object):void{
            this._tailHeight = (param1 as Number);
        }
        public function get cornerRadius():Object{
            return (this._cornerRadius);
        }
        public function set contentHTML(param1:String):void{
            this._contentHTML = param1;
            if (this._contentHTML != null){
                this._content = null;
            };
        }
        public function get pointOffset():Point{
            return (this._pointOffset);
        }
        public function set height(param1:Object):void{
            this._height = (param1 as Number);
        }
        public function get hasCloseButton():Object{
            return (this._hasCloseButton);
        }
        public function get tailWidth():Object{
            return (this._tailWidth);
        }
        public function get title():String{
            return (this._title);
        }
        public function get hasShadow():Object{
            return (this._hasShadow);
        }
        public function set titleStyleSheet(param1:StyleSheet):void{
            this._titleStyleSheet = param1;
        }
        public function get customOffset():Point{
            return (this._customOffset);
        }
        public function get strokeStyle():StrokeStyle{
            return (this._strokeStyle);
        }
        public function get titleFormat():TextFormat{
            return (this._titleFormat);
        }
        public function toString():String{
            return (((((((((((((((((((((((((((((((((((((((((((((((((((("InfoWindowOptions:" + "\n\t{ strokeStyle: ") + this._strokeStyle) + "\n\t  fillStyle: ") + this._fillStyle) + "\n\t  titleFormat: ") + this._titleFormat) + "\n\t  titleStyleSheet: ") + this._titleStyleSheet) + "\n\t  contentFormat: ") + this._contentFormat) + "\n\t  contentStyleSheet: ") + this._contentStyleSheet) + "\n\t  width: ") + this._width) + "\n\t  height: ") + this._height) + "\n\t  cornerRadius: ") + this._cornerRadius) + "\n\t  padding: ") + this._padding) + "\n\t  hasCloseButton: ") + this._hasCloseButton) + "\n\t  hasTail: ") + this._hasTail) + "\n\t  tailWidth: ") + this._tailWidth) + "\n\t  tailHeight: ") + this._tailHeight) + "\n\t  tailOffset: ") + this._tailOffset) + "\n\t  tailAlign: ") + this._tailAlign) + "\n\t  pointOffset: ") + this._pointOffset) + "\n\t  hasShadow: ") + this._hasShadow) + "\n\t  title: ") + this._title) + "\n\t  titleHTML: ") + this._titleHTML) + "\n\t  content: ") + this._content) + "\n\t  contentHTML: ") + this._contentHTML) + "\n\t  customContent: ") + this._customContent) + "\n\t  customOffset: ") + this._customOffset) + "\n\t  customCloseRect: ") + this._customCloseRect) + " }"));
        }
        public function get content():String{
            return (this._content);
        }
        public function get contentStyleSheet():StyleSheet{
            return (this._contentStyleSheet);
        }
        public function set pointOffset(param1:Point):void{
            this._pointOffset = param1;
        }
        public function set customContent(param1:DisplayObject):void{
            this._customContent = param1;
        }
        public function set width(param1:Object):void{
            this._width = (param1 as Number);
        }
        public function get tailAlign():Object{
            return (this._tailAlign);
        }
        public function get tailHeight():Object{
            return (this._tailHeight);
        }
        public function set cornerRadius(param1:Object):void{
            this._cornerRadius = (param1 as Number);
        }
        public function set contentFormat(param1:TextFormat):void{
            this._contentFormat = param1;
        }
        public function get customCloseRect():Rectangle{
            return (this._customCloseRect);
        }
        public function get titleStyleSheet():StyleSheet{
            return (this._titleStyleSheet);
        }
        public function set hasCloseButton(param1:Object):void{
            this._hasCloseButton = (param1 as Boolean);
        }
        public function get contentHTML():String{
            return (this._contentHTML);
        }
        public function set tailWidth(param1:Object):void{
            this._tailWidth = (param1 as Number);
        }
        public function set hasShadow(param1:Object):void{
            this._hasShadow = (param1 as Boolean);
        }
        public function set title(param1:String):void{
            this._title = param1;
            if (this._title != null){
                this._titleHTML = null;
            };
        }
        public function set strokeStyle(param1:StrokeStyle):void{
            this._strokeStyle = param1;
        }
        public function get width():Object{
            return (this._width);
        }
        public function get customContent():DisplayObject{
            return (this._customContent);
        }
        public function set customOffset(param1:Point):void{
            this._customOffset = ((param1)!=null) ? new Point(param1.x, param1.y) : null;
        }
        public function get contentFormat():TextFormat{
            return (this._contentFormat);
        }
        public function set fillStyle(param1:FillStyle):void{
            this._fillStyle = param1;
        }
        public function copyFromObject(param1:Object):void{
            Wrapper.copyProperties(this, param1, ["width", "height", "cornerRadius", "padding", "tailWidth", "tailHeight", "tailOffset", "tailAlign"], Number);
            Wrapper.copyProperties(this, param1, ["hasCloseButton", "hasTail", "hasShadow"], Boolean);
            Wrapper.copyProperties(this, param1, ["title", "titleHTML", "content", "contentHTML"], String);
            Wrapper.copyProperties(this, param1, ["customContent"], DisplayObject, true);
            Wrapper.copyProperties(this, param1, ["drawDefaultFrame"], Boolean, true);
            if (param1.strokeStyle != null){
                if (this.strokeStyle == null){
                    this.strokeStyle = new StrokeStyle();
                };
                this.strokeStyle.copyFromObject(param1.strokeStyle);
            };
            if (param1.fillStyle != null){
                if (this.fillStyle == null){
                    this.fillStyle = new FillStyle();
                };
                this.fillStyle.copyFromObject(param1.fillStyle);
            };
            if (param1.titleFormat != null){
                if (this.titleFormat == null){
                    this.titleFormat = new TextFormat();
                };
                Wrapper.copyTextFormatProperties(this.titleFormat, param1.titleFormat);
            };
            if (param1.titleStyleSheet != null){
                if (this.titleStyleSheet == null){
                    this.titleStyleSheet = new StyleSheet();
                };
                Wrapper.copyStyleSheetProperties(this.titleStyleSheet, param1.titleStyleSheet);
            };
            if (param1.contentFormat != null){
                if (this.contentFormat == null){
                    this.contentFormat = new TextFormat();
                };
                Wrapper.copyTextFormatProperties(this.contentFormat, param1.contentFormat);
            };
            if (param1.contentStyleSheet != null){
                if (this.contentStyleSheet == null){
                    this.contentStyleSheet = new StyleSheet();
                };
                Wrapper.copyStyleSheetProperties(this.contentStyleSheet, param1.contentStyleSheet);
            };
            if (param1.pointOffset != null){
                if (this.pointOffset == null){
                    this.pointOffset = new Point();
                };
                Wrapper.copyPointProperties(this.pointOffset, param1.pointOffset);
            };
            if (MapUtil.hasNonNullProperty(param1, "customOffset")){
                if (this.customOffset == null){
                    this.customOffset = new Point();
                };
                Wrapper.copyPointProperties(this.customOffset, param1.customOffset);
            };
            if (MapUtil.hasNonNullProperty(param1, "customCloseRect")){
                if (this.customCloseRect == null){
                    this.customCloseRect = new Rectangle();
                };
                Wrapper.copyRectangleProperties(this.customCloseRect, param1.customCloseRect);
            };
        }
        public function get fillStyle():FillStyle{
            return (this._fillStyle);
        }
        public function set content(param1:String):void{
            this._content = param1;
            if (this._content != null){
                this._contentHTML = null;
            };
        }

    }
}//package com.mapplus.maps 
