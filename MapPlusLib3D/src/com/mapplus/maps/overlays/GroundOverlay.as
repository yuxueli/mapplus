//Created by yuxueli 2011.6.6
package com.mapplus.maps.overlays {
    import com.mapplus.maps.core.*;
    import flash.display.*;
    import flash.geom.*;
    import com.mapplus.maps.interfaces.*;
    import com.mapplus.maps.geom.*;
    import com.mapplus.maps.styles.*;
    import com.mapplus.maps.*;

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

        private var bitmapData:BitmapData;
        private var contentContainer:Sprite;
        private var preTransform:Matrix;
        private var contentBounds:Rectangle;
        private var transformHPoint:Function;
        private var options:GroundOverlayOptions;
        private var contentClipAxes:Array;
        private var xyzTransform:Array;
        private var contentClipPoly:Array;
        private var latLngBounds:LatLngBounds;
        private var worldIndex:Number;
        private var contentClip:Rectangle;
        private var transform:Function;
        private var content:DisplayObject;

        public function GroundOverlay(param1:DisplayObject, param2:LatLngBounds, param3:GroundOverlayOptions=null){
            super(FLAG_DISPATCHMOUSEEVENTS);
            this.options = GroundOverlayOptions.merge([GroundOverlay.getDefaultOptions(), param3]);
            this.content = param1;
            this.latLngBounds = param2.clone();
            contentBounds = param1.getBounds(param1);
            if (this.options.renderContent){
                renderContentToBitmapData();
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
            return (((applyProjection) && (((!((rotation == 0))) || (((latLngBounds.getNorth() * latLngBounds.getSouth()) < 0))))));
        }
        private function get renderContent():Boolean{
            return ((options.renderContent as Boolean));
        }
        private function renderContentToBitmapData():void{
            var _loc_1:int;
            var _loc_2:int;
            if (content){
                contentBounds = content.getBounds(content);
                _loc_1 = Math.ceil(contentBounds.width);
                _loc_2 = Math.ceil(contentBounds.height);
                bitmapData = new BitmapData(_loc_1, _loc_2, true, 0);
                if (!Bootstrap.drawBitmapData(bitmapData, content, new Matrix(1, 0, 0, 1, -(contentBounds.left), -(contentBounds.top)), content.transform.colorTransform)){
                    throw (new Error(((("GroundOverlay content could not be rendered into bitmap data. " + "Set Options.renderContent false to allow basic display. ") + "Alternatively, if you have access to the content's server, you ") + "can use a crossdomain.xml file to authorize access.")));
                };
            };
        }
        private function renderRectPartsAhead(param1:Rectangle, param2:int):void{
            var _loc_3:Boolean;
            var _loc_4:Boolean;
            var _loc_5:Boolean;
            var _loc_6:Boolean;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:int;
            if (!Geometry.convexPolyIntersects(contentClipPoly, param1, contentClipAxes)){
                return;
            };
            _loc_3 = (transformHPoint(param1.left, param1.top).w < 0);
            _loc_4 = (transformHPoint(param1.left, param1.bottom).w < 0);
            _loc_5 = (transformHPoint(param1.right, param1.top).w < 0);
            _loc_6 = (transformHPoint(param1.right, param1.bottom).w < 0);
            if (((((((_loc_3) && (_loc_4))) && (_loc_5))) && (_loc_6))){
                ImageTransformRenderer.render(bitmapData, param1.intersection(contentClip), transform, mc.graphics, map.getSize(), param2, ImageTransformRenderer.MAX_SINGLE_QUAD_ERROR, ImageTransformRenderer.MAX_RECURSE_ERROR, true, useOverSampling);
            } else {
                if (((((((!(_loc_3)) && (!(_loc_4)))) && (!(_loc_5)))) && (!(_loc_6)))){
                } else {
                    if (param2 > 0){
                        _loc_7 = (0.5 * param1.width);
                        _loc_8 = (0.5 * param1.height);
                        _loc_9 = param1.left;
                        _loc_10 = param1.top;
                        _loc_11 = (_loc_9 + _loc_7);
                        _loc_12 = (_loc_10 + _loc_8);
                        _loc_13 = (param2 - 1);
                        renderRectPartsAhead(new Rectangle(_loc_9, _loc_10, _loc_7, _loc_8), _loc_13);
                        renderRectPartsAhead(new Rectangle(_loc_11, _loc_10, _loc_7, _loc_8), _loc_13);
                        renderRectPartsAhead(new Rectangle(_loc_9, _loc_12, _loc_7, _loc_8), _loc_13);
                        renderRectPartsAhead(new Rectangle(_loc_11, _loc_12, _loc_7, _loc_8), _loc_13);
                    };
                };
            };
        }
        private function contentMiddleFromBounds():Point{
            var _loc_1:Point;
            var _loc_2:Rectangle;
            _loc_1 = transform(contentBounds.left, contentBounds.top);
            _loc_2 = new Rectangle(_loc_1.x, _loc_1.y);
            Util.rectangleExtend(_loc_2, transform(contentBounds.right, contentBounds.top));
            Util.rectangleExtend(_loc_2, transform(contentBounds.left, contentBounds.bottom));
            Util.rectangleExtend(_loc_2, transform(contentBounds.right, contentBounds.bottom));
            return (camera.viewportToWorld(Util.rectCenter(_loc_2)));
        }
        override public function get interfaceChain():Array{
            return (["IGroundOverlay", "IOverlay"]);
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
            if (!bitmapData){
                return;
            };
            worldIndex = 0;
            if (applyProjection){
                _loc_2 = latLngBounds.getSouthWest();
                _loc_3 = latLngBounds.toSpan();
                _loc_4 = new Rectangle(_loc_2.lng(), _loc_2.lat(), _loc_3.lng(), _loc_3.lat());
                preTransform = Util.windowMatrix(contentBounds, _loc_4, true);
                if (rotation != 0){
                    transform = imageToViewportRotateProject2D;
                    _loc_5 = preTransform.transformPoint(getRotationCenter());
                    _loc_6 = new LatLng(_loc_5.y, _loc_5.x);
                    xyzTransform = Util.rotationMatrix3DCoeffs(rotation, Util.latLngToXYZ(_loc_6));
                } else {
                    transform = imageToViewportProject2D;
                };
                _loc_1 = contentMiddleFromBounds();
            } else {
                _loc_7 = projectBounds(latLngBounds);
                _loc_8 = Util.windowMatrix(contentBounds, _loc_7);
                _loc_9 = _loc_8.transformPoint(getRotationCenter());
                _loc_10 = Util.rotationMatrix(rotation, _loc_9);
                preTransform = Util.matrixMultiply(_loc_10, _loc_8);
                transform = imageToViewportNoProject2D;
                _loc_1 = _loc_10.transformPoint(Point.interpolate(camera.latLngToWorld(latLngBounds.getNorthWest()), camera.latLngToWorld(latLngBounds.getSouthEast()), 0.5));
            };
            worldIndex = ((camera.getWorldClosestToCenter(_loc_1).x - _loc_1.x) / 0x0100);
            ImageTransformRenderer.render(bitmapData, contentBounds, transform, mc.graphics, camera.viewport, MAX_RENDERER_RECURSION, ImageTransformRenderer.MAX_SINGLE_QUAD_ERROR, ImageTransformRenderer.MAX_RECURSE_ERROR, true, useOverSampling);
        }
        private function imageToViewportProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            var _loc_4:LatLng;
            _loc_3 = preTransform.transformPoint(new Point(param1, param2));
            _loc_4 = new LatLng(_loc_3.y, (_loc_3.x + (360 * worldIndex)), true);
            return (camera.latLngToViewport(_loc_4));
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
            _loc_1 = camera.latLngToViewport(latLngBounds.getNorthWest());
            _loc_2 = camera.latLngToViewport(latLngBounds.getSouthEast());
            _loc_3 = latLngBounds.getCenter();
            _loc_4 = (camera.latLngToViewport(getLatLngClosestToCenter(_loc_3)).x - camera.latLngToViewport(_loc_3).x);
            _loc_1.offset(_loc_4, 0);
            _loc_2.offset(_loc_4, 0);
            _loc_5 = Util.windowMatrix(contentBounds, Util.rectFromExtents(_loc_1.x, _loc_1.y, _loc_2.x, _loc_2.y));
            _loc_6 = _loc_5.transformPoint(getRotationCenter());
            _loc_7 = Util.matrixMultiply(Util.rotationMatrix(rotation, _loc_6), _loc_5);
            if (contentContainer){
                contentContainer.transform.matrix = _loc_7;
            };
            if (strokeStyle){
                Render.setStroke(mc.graphics, strokeStyle);
                _loc_8 = _loc_7.transformPoint(contentBounds.topLeft);
                _loc_9 = _loc_7.transformPoint(new Point(contentBounds.bottom, contentBounds.left));
                _loc_10 = _loc_7.transformPoint(new Point(contentBounds.top, contentBounds.right));
                _loc_11 = _loc_7.transformPoint(contentBounds.bottomRight);
                mc.graphics.moveTo(_loc_8.x, _loc_8.y);
                mc.graphics.lineTo(_loc_10.x, _loc_10.y);
                mc.graphics.lineTo(_loc_11.x, _loc_11.y);
                mc.graphics.lineTo(_loc_9.x, _loc_9.y);
                mc.graphics.lineTo(_loc_8.x, _loc_8.y);
            };
        }
        public function get mc():Sprite{
            return (super._foreground);
        }
        private function setContentContainerVisible(param1:Boolean):void{
            if (contentContainer){
                contentContainer.visible = param1;
            };
        }
        private function imageToViewportNoProjectHPoint(param1:Number, param2:Number):HPoint{
            var _loc_3:Point;
            _loc_3 = preTransform.transformPoint(new Point(param1, param2));
            return (getMapWorldToViewport().project(new HPoint(_loc_3.x, _loc_3.y, 1)));
        }
        private function renderContent3D():void{
            var _loc_12:*;
            var _loc_1:Point;
            var _loc_2:Rectangle;
            var _loc_3:Rectangle;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:Array;
            var _loc_7:Matrix;
            var _loc_8:LatLng;
            var _loc_9:LatLng;
            var _loc_10:Rectangle;
            if (!bitmapData){
                return;
            };
            _loc_1 = latLngToWorld(camera.center);
            _loc_2 = new Rectangle((_loc_1.x - 128), 0, 0x0100, 0x0100);
            worldIndex = -1;
            while (worldIndex <= 1) {
                _loc_3 = projectBounds(latLngBounds);
                _loc_3.offset((0x0100 * worldIndex), 0);
                _loc_4 = content.width;
                _loc_5 = content.height;
                if (applyProjection){
                    transform = imageToViewportProject;
                    transformHPoint = imageToViewportProjectHPoint;
                    _loc_8 = latLngBounds.getSouthWest();
                    _loc_9 = latLngBounds.toSpan();
                    _loc_10 = new Rectangle((_loc_8.lng() + (360 * worldIndex)), _loc_8.lat(), _loc_9.lng(), _loc_9.lat());
                    preTransform = Util.windowMatrix(contentBounds, _loc_10, true);
                } else {
                    transform = imageToViewportNoProject;
                    transformHPoint = imageToViewportNoProjectHPoint;
                    preTransform = Util.windowMatrix(contentBounds, _loc_3);
                };
                _loc_6 = camera.getWorldViewPolygon();
                _loc_7 = Util.windowMatrix(_loc_3, contentBounds);
                contentClipPoly = Geometry.transformPoly(_loc_6, _loc_7);
                contentClipAxes = Geometry.computeSeparatingAxes(contentClipPoly);
                contentClip = Util.rectFromPoints(_loc_7.transformPoint(_loc_2.topLeft), _loc_7.transformPoint(_loc_2.bottomRight));
                renderRectPartsAhead(new Rectangle(0, 0, _loc_4, _loc_5), MAX_RENDERER_RECURSION);
                _loc_12 = (worldIndex + 1);
                worldIndex = _loc_12;
            };
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
            if (content){
                contentContainer = Bootstrap.getSpriteFactory().createComponent().getSprite();
                contentContainer.addChild(content);
                mc.addChild(contentContainer);
            };
            redraw();
        }
        private function update(param1:Boolean):void{
            if (((!(map)) || (!(visible)))){
                return;
            };
            mc.graphics.clear();
            if (is3DView()){
                setContentContainerVisible(false);
                renderContent3D();
                return;
            };
            if (renderContent){
                setContentContainerVisible(false);
                renderContent2D();
            } else {
                setContentContainerVisible(true);
                configureContentTransforms();
            };
        }
        private function imageToViewportNoProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            _loc_3 = preTransform.transformPoint(new Point(param1, param2));
            _loc_3.offset((0x0100 * worldIndex), 0);
            return (camera.worldToViewport(_loc_3));
        }
        private function get rotationContentCenter():Point{
            return (options.rotationContentCenter);
        }
        private function get strokeStyle():StrokeStyle{
            return (options.strokeStyle);
        }
        override protected function onRemovedFromPane():void{
            if (((contentContainer) && (contentContainer.parent))){
                contentContainer.parent.removeChild(contentContainer);
            };
            super.onRemovedFromPane();
            contentContainer = null;
            content = null;
        }
        private function get applyProjection():Boolean{
            return ((options.applyProjection as Boolean));
        }
        private function applyXYZTransform(param1:LatLng):LatLng{
            return (Util.xyzToLatLng(Util.matrixMultiplyPoint3D(xyzTransform, Util.latLngToXYZ(param1))));
        }
        public function setOptions(param1:GroundOverlayOptions):void{
            options = GroundOverlayOptions.merge([options, param1]);
            if (((!(bitmapData)) && (options.renderContent))){
                renderContentToBitmapData();
            };
            redraw();
        }
        private function imageToViewportProjectHPoint(param1:Number, param2:Number):HPoint{
            var _loc_3:Point;
            var _loc_4:LatLng;
            var _loc_5:Point;
            _loc_3 = preTransform.transformPoint(new Point(param1, param2));
            _loc_4 = new LatLng(_loc_3.y, _loc_3.x, true);
            _loc_5 = latLngToWorld(_loc_4);
            return (getMapWorldToViewport().project(new HPoint(_loc_5.x, _loc_5.y, 1)));
        }
        override public function positionOverlay(param1:Boolean):void{
            update(param1);
        }
        public function getOptions():GroundOverlayOptions{
            return (options);
        }
        private function getMapWorldToViewport():Homography{
            return (map.getCamera().mapWorldToViewport);
        }
        private function getRotationCenter():Point{
            return ((rotationContentCenter) ? rotationContentCenter : Util.rectCenter(contentBounds));
        }
        override public function isHidden():Boolean{
            return (!(visible));
        }
        override protected function redraw():void{
            update(true);
        }
        private function imageToViewportRotateProject2D(param1:Number, param2:Number):Point{
            var _loc_3:Point;
            var _loc_4:LatLng;
            var _loc_5:Point;
            _loc_3 = preTransform.transformPoint(new Point(param1, param2));
            _loc_4 = new LatLng(_loc_3.y, _loc_3.x, true);
            _loc_5 = camera.latLngToWorld(applyXYZTransform(_loc_4));
            _loc_5.offset((worldIndex * 0x0100), 0);
            return (camera.worldToViewport(_loc_5));
        }
        private function imageToViewportNoProject(param1:Number, param2:Number):Point{
            return (imageToViewportNoProjectHPoint(param1, param2).euclideanPoint());
        }
        private function imageToViewportProject(param1:Number, param2:Number):Point{
            return (imageToViewportProjectHPoint(param1, param2).euclideanPoint());
        }
        private function get rotation():Number{
            return ((options.rotation as Number));
        }

    }
}//package com.mapplus.maps.overlays 
