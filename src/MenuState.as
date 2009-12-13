package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private const _blur:uint = 8;	//How much light bloom to have - larger numbers = more
		private var _fx:FlxSprite;
		
		public function MenuState()
		{
			//Title text
			var t:FlxText = new FlxText(0,FlxG.height/2-10,FlxG.width,"FlxBloom");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			//This is the sprite we're going to use to help with the light bloom affect
			_fx = new FlxSprite();
			_fx.createGraphic(FlxG.width/_blur,FlxG.height/_blur,0,true);
			_fx.x = (FlxG.width-_fx.width)/2;
			_fx.y = (FlxG.height-_fx.height)/2;
			_fx.scrollFactor.x = 0;
			_fx.scrollFactor.y = 0;
			_fx.scale.x = _blur;
			_fx.scale.y = _blur;
			_fx.antialiasing = true;
			_fx.alpha = 0.50;
			_fx.blend = "screen";
			//Note that we do not add it to the game state
			
			//This is the particle emitter that spews things off the bottom of the screen
			var e:FlxEmitter = new FlxEmitter();
			e.width = FlxG.width;
			e.y = FlxG.height;
			e.delay = 0.03;
			e.gravity = -80;
			e.setXVelocity();
			e.setYVelocity(-100,0);
			var particles:uint = 200;
			var a:Array = new Array();
			for(var i:uint = 0; i < particles; i++)
				a.push(add(new FlxSprite()));
			add(e.loadSprites(a));
		}
		
		override public function postProcess():void
		{
			screen.scale.x = 1/_blur;
			screen.scale.y = 1/_blur;
			_fx.draw(screen,(FlxG.width/_blur - FlxG.width)/2,(FlxG.height/_blur - FlxG.height)/2);
			screen.draw(_fx,_fx.x,_fx.y);
			screen.scale.x = 1;
			screen.scale.y = 1;
		}
	}
}
