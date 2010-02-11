package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private const _bloom:uint = 8;	//How much light bloom to have - larger numbers = more
		private var _fx:FlxSprite;		//Our helper sprite - basically a mini screen buffer (see below)
		
		override public function create():void
		{
			//Title text, nothing crazy here!
			var t:FlxText = new FlxText(0,FlxG.height/2-20,FlxG.width,"FlxBloom");
			t.size = 32;
			t.alignment = "center";
			add(t);
			
			//This is the sprite we're going to use to help with the light bloom effect
			//First, we're going to initialize it to be a fraction of the screens size
			_fx = new FlxSprite();
			_fx.createGraphic(FlxG.width/_bloom,FlxG.height/_bloom,0,true);
			_fx.origin.x = _fx.origin.y = 0;	//Zero the origin so scaling goes from top-left not center
			_fx.scale.x = _fx.scale.y = _bloom;	//Scale it up to be the same size as the screen again
			_fx.antialiasing = true;			//Set AA to true for maximum blurry
			_fx.color = 0xafffff;				//Tint it a little, cuz that looks cool
			_fx.blend = "screen";				//Finally, set blend mode to "screen" (important!)
			//Note that we do not add it to the game state!  It's just a helper, not a real sprite.
			
			//Then we scale the screen buffer down, so it draws a smaller version of itself
			// into our tiny FX buffer, which is then scaled up.  The net result of this operation
			// is a blurry image that we can render back over the screen buffer to create the bloom.
			screen.scale.x = screen.scale.y = 1/_bloom;
			
			//This is the particle emitter that spews things off the bottom of the screen.
			//I'm not going to go over it in too much detail here, but basically we
			// create the emitter, then we create 50 16x16 sprites and add them to it.
			var e:FlxEmitter = new FlxEmitter();
			e.width = FlxG.width;
			e.y = FlxG.height+8;
			e.delay = 0.08;
			e.gravity = -40;
			e.setXSpeed();
			e.setYSpeed(-50,0);
			var s:FlxSprite;
			var particles:uint = 50;
			for(var i:uint = 0; i < particles; i++)
			{
				s = new FlxSprite();
				s.createGraphic(16,16);
				s.exists = false;
				e.add(s);
			}
			e.start(false);
			add(e);
		}
		
		//This is the new hotness!  This is essentially a callback from the game rendering loop,
		// letting us know that all the game rendering has finished,
		// and that FlxState.screen has been filled with the game's visual contents.
		override public function postProcess():void
		{
			//The actual blur process is quite simple now.
			//First we draw the contents of the screen onto the tiny FX buffer:
			_fx.draw(screen);
			//Then we draw the scaled-up contents of the FX buffer back onto the screen:
			screen.draw(_fx);
		}
	}
}
