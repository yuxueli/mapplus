package local.wx
{
	import flash.display.Sprite;

	public class Sleet extends Sprite 
	{
		[Embed('assets/wx_graphics/sleet.png')] private var ImgSleet:Class;
		   
		public function Sleet() 
		{
			addChild(new ImgSleet());
			width = width / 2;
		    height = height / 2;
		    cacheAsBitmap = true;
		}
	}
}
