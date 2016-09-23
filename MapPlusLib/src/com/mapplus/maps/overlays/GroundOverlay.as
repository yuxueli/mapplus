//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.*;
    import flash.display.*;
    import com.mapplus.maps.core.*;
    import flash.geom.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.interfaces.*;

    public class GroundOverlay extends Overlay implements IGroundOverlay {

        private static const MAX_RENDERER_RECURSION:int = 6;

        private static var defaultOptions:GroundOverlayOptions = new GroundOverlayOptions({
            strokeStyle:{
                thickness:0,
                alpha:0,
                color:Color.BLACK,
                pixelHinting:false
            },
            rotation:0,
            applyProjection:false,
            renderContent:true
        });

        private var preTransform:Matrix;
        private var contentClipAxes:Array;
        private var contentContainer:Sprite;
        private var latLngBounds:LatLngBounds;
        private var worldIndex:Number;
        private var contentClip:Rectangle;
        private var content:DisplayObject;
        private var bitmapData:BitmapData;
        private var transform:Function;
        private var transformHPoint:Function;
        private var contentBounds:Rectangle;
        private var options:GroundOverlayOptions;
        private var contentClipPoly:Array;
        private var xyzTransform:Array;

        public function GroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            this.options = GroundOverlayOptions.merge([GroundOverlay.getDefaultOptions(), param3]);
            this.content = param1;
            this.latLngBounds = param2.clone();
            this.contentBounds = param1.getBounds(param1);
            if (this.options.renderContent){
                this.renderContentToBitmapData();
            };
        }
        public static function getDefaultOptions():GroundOverlayOptions{
            return (GroundOverlay.defaultOptions);
        }
        private static function getContentAsBitmap(param1:DisplayObject):Bitmap{
            if ((param1 is Bitmap)){
                return ((param1 as Bitmap));
            };
            if ((param1 is Loader)){
                return ((Bootstrap.getLoaderContent((param1 as Loader)) as Bitmap));
            };
            return (null);
        }
        public static function setDefaultOptions(param1:GroundOverlayOptions):void{
            GroundOverlay.defaultOptions = GroundOverlayOptions.merge([GroundOverlay.defaultOptions, param1]);
        }

        private function get useOverSampling():Boolean{
            return (((this.applyProjection) && (((!((this.rotation == 0))) || (((this.latLngBounds.getNorth() * this.latLngBounds.getSouth()) < 0))))));
        }
        private function get renderContent():Boolean{
            return ((this.options.renderContent as Boolean));
        }
        private function contentMiddleFromBounds():Point{
            var _loc_1:Point;
            var _loc_2:Rectangle;
            _loc_1 = this.transform(this.contentBounds.left, this.contentBounds.top);
            _loc_2 = new Rectangle(_loc_1.x, _loc_1.y);
            Util.rectangleExtend(_loc_2, this.transform(this.contentBounds.right, this.contentBounds.top));
            Util.rectangleExtend(_loc_2, this.transform(this.contentBounds.left, this.contentBounds.bottom));
            Util.rectangleExtend(_loc_2, this.transform(this.contentBounds.right, this.contentBounds.bottom));
            return (camera.viewportToWorld(Util.rectCenter(_loc_2)));
        }
        override public function get interfaceChain():Array{
            return (["IGroundOverlay", "IOverlay"]);
        }
        private function projectBounds(param1:LatLngBounds):Rectangle{
            var _loc_2:Point;
            var _loc_3:Point;
            var _loc_4:Rectangle;
            _loc_2 = latLngToWorld(param1.getNorthWest());
            _loc_3 = latLngToWorld(param1.getSouthEast());
            if (param1.getEast() <= param1.getWest()){
                _loc_3.offset(0x0100, 0);
            };
            _loc_4 = new Rectangle(_loc_2.x, _loc_2.y, (_loc_3.x - _loc_2.x), (_loc_3.y - _loc_2.y));
            return (_loc_4);
        }
        override protected function onAddedToPane():void{
            super.onAddedToPane();
            if (this.content){
                this.contentContainer = Bootstrap.getSpriteFactory().createComponent().getSprite();
                this.contentContainer.addChild(this.content);
                this.mc.addChild(this.contentContainer);
            };
            this.redraw();
        }
        private function get rotationContentCenter():Point{
            return (this.options.rotationContentCenter);
        }
        private function get strokeStyle():StrokeStyle{
            return (this.options.strokeStyle);
        }
        private function get applyProjection():Boolean{
            return ((this.options.applyProjection as Boolean));
        }
        private function applyXYZTransform(param1:LatLng):LatLng{
            return (Util.xyzToLatLng(Util.matrixMultiplyPoint3D(this.xyzTransform, Util.latLngToXYZ(param1))));
        }
        private function getRotationCenter():Point{
            return ((this.rotationContentCenter) ? this.rotationContentCenter : Util.rectCenter(this.contentBounds));
        }
        override public function isHidden():Boolean{
            return (!(visible));
        }
        private function imageToViewportRotateProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            var _loc_4:LatLng;
            var _loc_5:Point;
            _loc_3 = this.preTransform.transformPoint(new Point(param1, param2));
            _loc_4 = new LatLng(_loc_3.y, _loc_3.x, true);
            _loc_5 = camera.latLngToWorld(this.applyXYZTransform(_loc_4));
            _loc_5.offset((this.worldIndex * 0x0100), 0);
            return (camera.worldToViewport(_loc_5));
        }
        private function get rotation():Number{
            return ((this.options.rotation as Number));
        }
        private function setContentContainerVisible(param1:Boolean):void{
            if (this.contentContainer){
                this.contentContainer.visible = param1;
            };
        }
        private function imageToViewportProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            var _loc_4:LatLng;
            _loc_3 = this.preTransform.transformPoint(new Point(param1, param2));
            _loc_4 = new LatLng(_loc_3.y, (_loc_3.x + (360 * this.worldIndex)), true);
            return (camera.latLngToViewport(_loc_4));
        }
        private function renderContent2D():void{
            var _loc_1:Point;
            var _loc_2:LatLng;
            var _loc_3:LatLng;
            var _loc_4:Rectangle;
            var _loc_5:Point;
            var _loc_6:LatLng;
            var _loc_7:Rectangle;
            var _loc_8:Matrix;
            var _loc_9:Point;
            var _loc_10:Matrix;
            if (!(this.bitmapData)){
                return;
            };
            this.worldIndex = 0;
            if (this.applyProjection){
                _loc_2 = this.latLngBounds.getSouthWest();
                _loc_3 = this.latLngBounds.toSpan();
                _loc_4 = new Rectangle(_loc_2.lng(), _loc_2.lat(), _loc_3.lng(), _loc_3.lat());
                this.preTransform = Util.windowMatrix(this.contentBounds, _loc_4, true);
                if (this.rotation != 0){
                    this.transform = this.imageToViewportRotateProject2D;
                    _loc_5 = this.preTransform.transformPoint(this.getRotationCenter());
                    _loc_6 = new LatLng(_loc_5.y, _loc_5.x);
                    this.xyzTransform = Util.rotationMatrix3DCoeffs(this.rotation, Util.latLngToXYZ(_loc_6));
                } else {
                    this.transform = this.imageToViewportProject2D;
                };
                _loc_1 = this.contentMiddleFromBounds();
            } else {
                _loc_7 = this.projectBounds(this.latLngBounds);
                _loc_8 = Util.windowMatrix(this.contentBounds, _loc_7);
                _loc_9 = _loc_8.transformPoint(this.getRotationCenter());
                _loc_10 = Util.rotationMatrix(this.rotation, _loc_9);
                this.preTransform = Util.matrixMultiply(_loc_10, _loc_8);
                this.transform = this.imageToViewportNoProject2D;
                _loc_1 = _loc_10.transformPoint(Point.interpolate(camera.latLngToWorld(this.latLngBounds.getNorthWest()), camera.latLngToWorld(this.latLngBounds.getSouthEast()), 0.5));
            };
            this.worldIndex = ((camera.getWorldClosestToCenter(_loc_1).x - _loc_1.x) / 0x0100);
            ImageTransformRenderer.render(this.bitmapData, this.contentBounds, this.transform, this.mc.graphics, camera.viewport, MAX_RENDERER_RECURSION, ImageTransformRenderer.MAX_SINGLE_QUAD_ERROR, ImageTransformRenderer.MAX_RECURSE_ERROR, true, this.useOverSampling);
        }
        private function configureContentTransforms():void{
            var _loc_1:Point;
            var _loc_2:Point;
            var _loc_3:LatLng;
            var _loc_4:Number = NaN;
            var _loc_5:Matrix;
            var _loc_6:Point;
            var _loc_7:Matrix;
            var _loc_8:Point;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:Point;
            _loc_1 = camera.latLngToViewport(this.latLngBounds.getNorthWest());
            _loc_2 = camera.latLngToViewport(this.latLngBounds.getSouthEast());
            _loc_3 = this.latLngBounds.getCenter();
            _loc_4 = (camera.latLngToViewport(getLatLngClosestToCenter(_loc_3)).x - camera.latLngToViewport(_loc_3).x);
            _loc_1.offset(_loc_4, 0);
            _loc_2.offset(_loc_4, 0);
            _loc_5 = Util.windowMatrix(this.contentBounds, Util.rectFromExtents(_loc_1.x, _loc_1.y, _loc_2.x, _loc_2.y));
            _loc_6 = _loc_5.transformPoint(this.getRotationCenter());
            _loc_7 = Util.matrixMultiply(Util.rotationMatrix(this.rotation, _loc_6), _loc_5);
            if (this.contentContainer){
                this.contentContainer.transform.matrix = _loc_7;
            };
            if (this.strokeStyle){
                Render.setStroke(this.mc.graphics, this.strokeStyle);
                _loc_8 = _loc_7.transformPoint(this.contentBounds.topLeft);
                _loc_9 = _loc_7.transformPoint(new Point(this.contentBounds.bottom, this.contentBounds.left));
                _loc_10 = _loc_7.transformPoint(new Point(this.contentBounds.top, this.contentBounds.right));
                _loc_11 = _loc_7.transformPoint(this.contentBounds.bottomRight);
                this.mc.graphics.moveTo(_loc_8.x, _loc_8.y);
                this.mc.graphics.lineTo(_loc_10.x, _loc_10.y);
                this.mc.graphics.lineTo(_loc_11.x, _loc_11.y);
                this.mc.graphics.lineTo(_loc_9.x, _loc_9.y);
                this.mc.graphics.lineTo(_loc_8.x, _loc_8.y);
            };
        }
        public function getOptions():GroundOverlayOptions{
            return (this.options);
        }
        public function get mc():Sprite{
            return (super._foreground);
        }
        private function update(param1:Boolean):void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            this.mc.graphics.clear();
            if (this.renderContent){
                this.setContentContainerVisible(false);
                this.renderContent2D();
            } else {
                this.setContentContainerVisible(true);
                this.configureContentTransforms();
            };
        }
        private function imageToViewportNoProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            _loc_3 = this.preTransform.transformPoint(new Point(param1, param2));
            _loc_3.offset((0x0100 * this.worldIndex), 0);
            return (camera.worldToViewport(_loc_3));
        }
        override protected function onRemovedFromPane():void{
            if (((this.contentContainer) && (this.contentContainer.parent))){
                this.contentContainer.parent.removeChild(this.contentContainer);
            };
            super.onRemovedFromPane();
            this.contentContainer = null;
            this.content = null;
        }
        public function setOptions(param1:GroundOverlayOptions):void{
            this.options = GroundOverlayOptions.merge([this.options, param1]);
            if (((!(this.bitmapData)) && (this.options.renderContent))){
                this.renderContentToBitmapData();
            };
            this.redraw();
        }
        override public function positionOverlay(param1:Boolean):void{
            this.update(param1);
        }
        override protected function redraw():void{
            this.update(true);
        }
        private function renderContentToBitmapData():void{
            var _loc_1:int;
            var _loc_2:int;
            if (this.content){
                this.contentBounds = this.content.getBounds(this.content);
                _loc_1 = Math.ceil(this.contentBounds.width);
                _loc_2 = Math.ceil(this.contentBounds.height);
                this.bitmapData = new BitmapData(_loc_1, _loc_2, true, 0);
                if (!(Bootstrap.drawBitmapData(this.bitmapData, this.content, new Matrix(1, 0, 0, 1, -(this.contentBounds.left), -(this.contentBounds.top)), this.content.transform.colorTransform))){
                    throw (new Error(((("GroundOverlay content could not be rendered into bitmap data. " + "Set Options.renderContent false to allow basic display. ") + "Alternatively, if you have access to the content's server, you ") + "can use a crossdomain.xml file to authorize access.")));
                };
            };
        }

    }
}//package com.mapplus.maps.overlays 
