package local.wx
{
	import flash.display.Sprite;

	public class Sunny extends Sprite 
	{
		[Embed('assets/wx_graphics/sunny.png')] private var ImgSunny:Class;
		   
		public function Sunny() 
		{
			addChild(new ImgSunny());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
