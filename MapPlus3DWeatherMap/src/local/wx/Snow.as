package local.wx
{
	import flash.display.Sprite;

	public class Snow extends Sprite 
	{
		[Embed('assets/wx_graphics/snow.png')] private var ImgSnow:Class;
		   
		public function Snow()
		{
			addChild(new ImgSnow());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
