package{

	import org.flixel.*;
	
	public class HurtyBullet extends FlxSprite{
		//media
		[Embed(source="Images/HurtyBullet.png")] 	private var ImgBullet:Class;
		[Embed(source="Sound/shoot.mp3")] 			private var BulletSFX:Class;
		[Embed(source="Sound/PlanetHit.mp3")] 			private var PlanetHitSFX:Class;
	
		//variables
		private var speed:Number;
		private var Planet:FlxSprite;
		
		public function HurtyBullet(X:Number, Y:Number, s:Number, p:FlxSprite){
			x = X;
			y = Y;
			speed = s;
			Planet = p;
			//load graphic
			loadGraphic(ImgBullet,true,true,4,16);
			//set up player animations
			addAnimation("TheOnlyFrame", [0], 0, false);
			play("TheOnlyFrame");
			FlxG.play(BulletSFX);
		}
		
		//update function
		public override function update():void{
			//move down
			y += speed;
			if(y >= FlxG.height){
				Planet.alpha -= .01;
				FlxG.play(PlanetHitSFX);
				kill();
			}
			//update
			super.update();
		}
	}
}
