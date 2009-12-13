package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private const _blur:uint = 8;	//How much light bloom to have - larger numbers = more
		private var _fx:FlxSprite;		//Our helper sprite - basically a mini screen buffer (see below)
		
		public function MenuState()
		{
			//Title text, nothing crazy here!
			var t:FlxText = new FlxText(0,FlxG.height/2-10,FlxG.width,"FlxBloom");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			//This is the sprite we're going to use to help with the light bloom effect
			//First, we're going to initialize it to be a fraction of the screens size
			_fx = new FlxSprite();
			_fx.createGraphic(FlxG.width/_blur,FlxG.height/_blur,0,true);
			_fx.x = (FlxG.width-_fx.width)/2;	//Then we center it
			_fx.y = (FlxG.height-_fx.height)/2;
			_fx.scale.x = _blur;				//Scale it up to be the same size as the screen again
			_fx.scale.y = _blur;
			_fx.antialiasing = true;			//Set AA to true for maximum blurry
			_fx.alpha = 0.50;					//Set alpha to 50% so the bloom isn't overwhelming
			_fx.blend = "screen";				//Finally, set blend mode to "screen" (important!)
			//Note that we do not add it to the game state!  It's just a helper, not a real sprite.
			
			//Then we're going to alter the scale and position of FlxState.screen
			// so that it always draws into the _fx buffer correctly.
			//If this math looks kind of weird, it's because we have to account for
			// the fact that currently flixel always scales and rotates things
			// around their center!
			screen.x = (FlxG.width/_blur - FlxG.width)/2;
			screen.y = (FlxG.height/_blur - FlxG.height)/2;
			screen.scale.x = 1/_blur;
			screen.scale.y = 1/_blur;
			
			//This is the particle emitter that spews things off the bottom of the screen.
			//I'm not going to go over it in too much detail here, but basically we
			// create the emitter, then we create 100 default sprites and add them to it.
			//Note that both the sprites we create and the emitter ARE added to the game state.
			var e:FlxEmitter = new FlxEmitter();
			e.width = FlxG.width;
			e.y = FlxG.height+8;
			e.delay = 0.03;
			e.gravity = -80;
			e.setXVelocity();
			e.setYVelocity(-100,0);
			var particles:uint = 100;
			var a:Array = new Array();
			for(var i:uint = 0; i < particles; i++)
				a.push(add(new FlxSprite()));
			add(e.loadSprites(a));
		}
		
		//This is the new hotness!  This is essentially a callback from the game rendering loop,
		// letting us know that all the game rendering has finished,
		// and that FlxState.screen has been filled with the game's visual contents.
		override public function postProcess():void
		{
			//The actual blur process is quite simple since we set
			// everything up in the constructor.
			//First we draw the contents of the screen onto the FX buffer:
			_fx.draw(screen,screen.x,screen.y);
			//Then we draw the contents of the FX buffer back onto the screen:
			screen.draw(_fx,_fx.x,_fx.y);
			//Remember in the constructor we changed the scale of these objects,
			// their positions, and their blending modes.  Otherwise this part
			// would look more complex.
			//Finally, if you are doing multiple post-process effects, you may
			// not be able to simply pre-set FlxState.screen, because you may
			// need to use it at different scales or blend modes.
			//Ok that's it, have fun!!
		}
	}
}
