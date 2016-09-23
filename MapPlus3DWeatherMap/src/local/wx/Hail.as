package local.wx
{
	import flash.display.Sprite;

	public class Hail extends Sprite 
	{
		[Embed('assets/wx_graphics/hail.png')] private var ImgHail:Class;
		   
		public function Hail() 
		{
			addChild(new ImgHail());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
