package local.wx
{
	import flash.display.Sprite;

	public class Lightning extends Sprite 
	{
		[Embed('assets/wx_graphics/lightning.png')] private var ImgLightning:Class;
		   
		public function Lightning() 
		{
			addChild(new ImgLightning());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
