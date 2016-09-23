package local.wx
{
	import flash.display.Sprite;

	public class Cloudy extends Sprite 
	{
		[Embed('assets/wx_graphics/cloudy.png')] private var ImgCloudy:Class;
		   
		public function Cloudy() 
		{
			
			addChild(new ImgCloudy());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
