package{

	import org.flixel.*;
	
	public class HurtyBullet extends FlxSprite{
		//media
		[Embed(source="Images/HurtyBullet.png")] 	private var ImgBullet:Class;
		[Embed(source="Sound/shoot.mp3")] 			private var BulletSFX:Class;
		[Embed(source="Sound/PlanetHit.mp3")] 		private var PlanetHitSFX:Class;
	
		//variables
		private var speed:Number;
		
		public function HurtyBullet(){
			x = 0;
			y = 0;
			//load graphic
			loadGraphic(ImgBullet,true,true,4,16);
			//set up player animations
			addAnimation("TheOnlyFrame", [0], 0, false);
			play("TheOnlyFrame");
		}
		
		//override this
		public function restart(X:Number,Y:Number, S:Number):void{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			//adding speed
			speed = S;
			//play sound
			FlxG.play(BulletSFX, .5);
		}
		
		//update function
		public override function update():void{
			//move down
			y += speed;
			//killing handled ingame
			//update
			super.update();
		}
		
		private function SetSpeed(s:Number):void{
			speed = s;
		}
	}
}
