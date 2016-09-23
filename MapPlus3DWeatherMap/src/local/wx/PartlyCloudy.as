package local.wx
{
	import flash.display.Sprite;
	
	public class PartlyCloudy extends Sprite 
	{
		[Embed('assets/wx_graphics/partly_cloudy.png')] private var ImgPartlyCloudy:Class;
		   
		public function PartlyCloudy() 
		{
			addChild(new ImgPartlyCloudy());	
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
