package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class FlxBloom extends FlxGame
	{
		public function FlxBloom()
		{
			super(320,240,MenuState,2);
			//showLogo = false;
		}
	}
}
