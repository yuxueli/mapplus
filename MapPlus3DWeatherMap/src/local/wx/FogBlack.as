package local.wx
{
	import flash.display.Sprite;

	public class FogBlack extends Sprite 
	{
		[Embed('assets/wx_graphics/fog_black.png')] private var ImgFogBlack:Class;
		   
		public function FogBlack() 
		{
			addChild(new ImgFogBlack());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
