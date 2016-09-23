﻿package com.mapplus.maps.overlays
{
	import com.mapplus.maps.*;
	import com.mapplus.maps.interfaces.*;
	import com.mapplus.maps.styles.*;
	import com.mapplus.maps.wrappers.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	
	public class MarkerOptions extends Object
	{
		private var _iconOffset:Point;
		private var _draggable:Object;
		private var _distanceScaling:Object;
		private var _gravity:Object;
		private var _strokeStyle:StrokeStyle;
		private var _iconShadow:DisplayObject;
		private var _radius:Object;
		private var _tooltip:String;
		private var _labelFormat:TextFormat;
		private var _icon:DisplayObject;
		private var _hasShadow:Object;
		private var _clickable:Object;
		private var _iconAlignment:Object;
		private var _fillStyle:FillStyle;
		private var _label:String;
		public static const ALIGN_LEFT:Number = 0;
		public static const ALIGN_VERTICAL_CENTER:Number = 16;
		public static const ALIGN_BOTTOM:Number = 32;
		public static const ALIGN_RIGHT:Number = 2;
		public static const ALIGN_HORIZONTAL_CENTER:Number = 1;
		public static const ALIGN_TOP:Number = 0;
		
		public function MarkerOptions(param1:Object = null)
		{
			if (param1 != null)
			{
				this.copyFromObject(param1);
			}
			return;
		}// end function
		
		public function get iconShadow() : DisplayObject
		{
			return this._iconShadow;
		}// end function
		
		public function get tooltip() : String
		{
			return this._tooltip;
		}// end function
		
		public function set tooltip(param1:String) : void
		{
			this._tooltip = param1;
			return;
		}// end function
		
		public function set iconShadow(param1:DisplayObject) : void
		{
			this._iconShadow = param1;
			return;
		}// end function
		
		public function get draggable() : Object
		{
			return this._draggable;
		}// end function
		
		public function get labelFormat() : TextFormat
		{
			return this._labelFormat;
		}// end function
		
		public function get radius() : Object
		{
			return this._radius;
		}// end function
		
		public function set gravity(param1:Object) : void
		{
			this._gravity = param1 as Number;
			return;
		}// end function
		
		public function set draggable(param1:Object) : void
		{
			this._draggable = param1 as Boolean;
			return;
		}// end function
		
		public function set radius(param1:Object) : void
		{
			this._radius = param1 as Number;
			return;
		}// end function
		
		public function set labelFormat(param1:TextFormat) : void
		{
			this._labelFormat = param1;
			return;
		}// end function
		
		public function set distanceScaling(param1:Object) : void
		{
			this._distanceScaling = param1 as Boolean;
			return;
		}// end function
		
		public function set strokeStyle(param1:StrokeStyle) : void
		{
			this._strokeStyle = param1;
			return;
		}// end function
		
		public function set hasShadow(param1:Object) : void
		{
			this._hasShadow = param1 as Boolean;
			return;
		}// end function
		
		public function set clickable(param1:Object) : void
		{
			this._clickable = param1 as Boolean;
			return;
		}// end function
		
		public function get gravity() : Object
		{
			return this._gravity;
		}// end function
		
		public function get distanceScaling() : Object
		{
			return this._distanceScaling;
		}// end function
		
		public function set iconAlignment(param1:Object) : void
		{
			this._iconAlignment = param1;
			return;
		}// end function
		
		public function get strokeStyle() : StrokeStyle
		{
			return this._strokeStyle;
		}// end function
		
		public function get hasShadow() : Object
		{
			return this._hasShadow;
		}// end function
		
		public function set fillStyle(param1:FillStyle) : void
		{
			this._fillStyle = param1;
			return;
		}// end function
		
		public function set iconOffset(param1:Point) : void
		{
			this._iconOffset = param1 != null ? (new Point(param1.x, param1.y)) : (null);
			return;
		}// end function
		
		public function copyFromObject(param1:Object) : void
		{
			Wrapper.copyProperties(this, param1, ["radius", "gravity", "iconAlignment"], Number);
			Wrapper.copyProperties(this, param1, ["hasShadow", "draggable"], Boolean);
			Wrapper.copyProperties(this, param1, ["clickable"], Boolean, true);
			Wrapper.copyProperties(this, param1, ["label", "tooltip"], String);
			Wrapper.copyProperties(this, param1, ["iconOffset"], Point);
			Wrapper.copyProperties(this, param1, ["icon"], DisplayObject);
			Wrapper.copyProperties(this, param1, ["iconShadow"], DisplayObject, true);
			Wrapper.copyProperties(this, param1, ["distanceScaling"], Boolean, true);
			if (param1.strokeStyle != null)
			{
				if (this.strokeStyle == null)
				{
					this.strokeStyle = new StrokeStyle();
				}
				this.strokeStyle.copyFromObject(param1.strokeStyle);
			}
			if (param1.fillStyle != null)
			{
				if (this.fillStyle == null)
				{
					this.fillStyle = new FillStyle();
				}
				this.fillStyle.copyFromObject(param1.fillStyle);
			}
			if (param1.labelFormat != null)
			{
				if (this.labelFormat == null)
				{
					this.labelFormat = new TextFormat();
				}
				Wrapper.copyTextFormatProperties(this.labelFormat, param1.labelFormat);
			}
			return;
		}// end function
		
		public function set label(param1:String) : void
		{
			this._label = param1;
			if (this._label != null)
			{
				this._icon = null;
			}
			return;
		}// end function
		
		public function get clickable() : Object
		{
			return this._clickable;
		}// end function
		
		public function get iconOffset() : Point
		{
			return this._iconOffset;
		}// end function
		
		public function get fillStyle() : FillStyle
		{
			return this._fillStyle;
		}// end function
		
		public function get iconAlignment() : Object
		{
			return this._iconAlignment;
		}// end function
		
		public function set icon(param1:DisplayObject) : void
		{
			this._icon = param1;
			if (this._icon != null)
			{
				this._label = null;
			}
			return;
		}// end function
		
		public function toString() : String
		{
			return "MarkerOptions:" + "\n\t{ strokeStyle: " + this._strokeStyle + "\n\t  fillStyle: " + this._fillStyle + "\n\t  label: " + this._label + "\n\t  labelFormat: " + this._labelFormat + "\n\t  tooltip: " + this._tooltip + "\n\t  radius: " + this._radius + "\n\t  hasShadow: " + this._hasShadow + "\n\t  clickable: " + this._clickable + "\n\t  draggable: " + this._draggable + "\n\t  gravity: " + this._gravity + "\n\t  icon: " + this._icon + "\n\t  iconShadow: " + this._iconShadow + "\n\t  iconAlignment: " + this._iconAlignment + "\n\t  iconOffset: " + this._iconOffset + "\n\t  distanceScaling: " + this._distanceScaling + " }";
		}// end function
		
		public function get label() : String
		{
			return this._label;
		}// end function
		
		public function get icon() : DisplayObject
		{
			return this._icon;
		}// end function
		
		public static function fromObject(param1:Object) : MarkerOptions
		{
			var _loc_2:MarkerOptions = null;
			if (param1 == null)
			{
				return null;
			}
			_loc_2 = new MarkerOptions;
			_loc_2.copyFromObject(param1);
			return _loc_2;
		}// end function
		
		public static function getDefaultOptions() : MarkerOptions
		{
			var _loc_1:IMapsFactory = null;
			_loc_1 = ClientBootstrap.getInstance().getMapsFactory();
			return _loc_1.getDefaultMarkerOptions();
		}// end function
		
		public static function merge(param1:Array) : MarkerOptions
		{
			return Wrapper.mergeStyles(MarkerOptions, param1) as MarkerOptions;
		}// end function
		
		public static function setDefaultOptions(param1:MarkerOptions) : void
		{
			var _loc_2:IMapsFactory = null;
			if (param1._icon != null)
			{
				throw new Error("Cannot specify a custom icon in default MarkerOptions");
			}
			if (param1._iconShadow != null)
			{
				throw new Error("Cannot specify a custom icon shadow in default MarkerOptions");
			}
			_loc_2 = ClientBootstrap.getInstance().getMapsFactory();
			_loc_2.setDefaultMarkerOptions(param1);
			return;
		}// end function
		
	}
}

