package local.wx
{
	import flash.display.Sprite;

	public class LightRain extends Sprite 
	{
		[Embed('assets/wx_graphics/light_rain.png')] private var ImgLightRain:Class;
		   
		public function LightRain() 
		{
			addChild(new ImgLightRain());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
