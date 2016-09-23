package com.control 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class CustomIconSprite extends Sprite
	{
		[Embed('assets/style/one.png')]
		private var S2000Img:Class;
		
		[Embed('assets/style/two.png')] 
		private var S2001Img:Class;
		
		[Embed('assets/style/three.png')] 
		private var S1999Img:Class;
		
		public function CustomIconSprite(label:String,styleIndex:String = "S2000")
		{
			var styleClass:DisplayObject;
			switch (styleIndex){
				case "S2000":
					styleClass = new S2000Img();
					break;
				case "S2001":
					styleClass = new S2001Img();
					break;
				case "S1999":
					styleClass = new S1999Img();
					break;
			}
			addChild(styleClass);	//添加图片
			var labelMc:TextField = createTextField(label);	//创建文本标注
			
			var sprite:Sprite = new Sprite();	//创建文本标注的背景
			var width:Number = labelMc.textWidth + 6;
			var height:Number = labelMc.textHeight + 6;
			sprite.graphics.lineStyle(1,0x000000,1);
			sprite.graphics.beginFill(0xffffff,1);
			sprite.graphics.drawRoundRect(0-width / 2,0-height / 2,width,height,3,3);
			labelMc.x = 0 - width / 2 + 3;
			labelMc.y = 0 - height / 2 + 0;
			sprite.addChild(labelMc);
			
			sprite.x = styleClass.width + width / 2;
			sprite.y = styleClass.y + sprite.height / 2 + height / 2;
			addChild(sprite);
			cacheAsBitmap = true;
		}
		
		private function createTextField(label:String):TextField {
			var labelMc:TextField = new TextField();
			labelMc.autoSize = TextFieldAutoSize.LEFT;
			labelMc.selectable = false;
			labelMc.border = false;
			labelMc.embedFonts = false;
			labelMc.mouseEnabled = false;

			labelMc.text = label;
			labelMc.x = 5;
			
			return labelMc;
		}
	}
}