package
{
	import flash.display.Sprite;

	public class Cloudy extends Sprite 
	{
		[Embed('/assets/style/one.png')] private var ImgCloudy:Class;
		   
		public function Cloudy() 
		{
			addChild(new ImgCloudy());
			width = width;
		    height = height;
		    cacheAsBitmap = true;
		}
	}
}
