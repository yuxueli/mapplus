package local.wx
{
	import flash.display.Sprite;

	public class HeavyRain extends Sprite 
	{
		[Embed('assets/wx_graphics/heavy_rain.png')] private var ImgHeavyRain:Class;
		   
		public function HeavyRain() 
		{
			addChild(new ImgHeavyRain());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
