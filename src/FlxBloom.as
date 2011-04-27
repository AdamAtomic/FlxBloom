package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class FlxBloom extends FlxGame
	{
		public function FlxBloom()
		{
			super(640,480,PlayState,1,60,60);
			forceDebugger = true;
		}
	}
}
