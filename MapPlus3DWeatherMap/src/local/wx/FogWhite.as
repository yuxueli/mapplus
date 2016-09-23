package local.wx
{
	import flash.display.Sprite;

	public class FogWhite extends Sprite 
	{
		[Embed('assets/wx_graphics/fog_white.png')] private var ImgFogWhite:Class;
		   
		public function FogWhite() 
		{
			addChild(new ImgFogWhite());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
