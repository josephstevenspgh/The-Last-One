package{

	import org.flixel.*;
	
	public class PowerUp_Recovery extends FlxSprite{
		//media
		[Embed(source="Images/PowerUp_Recovery.png")] 	private var ImgPowerUp:Class;
		
		private var speed:Number = 0;
	
		//variables		
		public function PowerUp_Recovery(X:Number = 0, Y:Number = 0){
			x = X;
			y = Y;
			//load graphic
			loadGraphic(ImgCoin,true,true,16,16);
			//set up player animations
			addAnimation("Spin", [0, 1, 2, 3, 2, 1], 20, true);
			play("Spin");
			//calculate speed
			speed = 2 + (FlxU.random()*10);
		}
		
		public function restart(X:Number,Y:Number):void{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			speed = 2 + (FlxU.random()*10);
		}
		
		//update function
		public override function update():void{
			//fall down!
			y += speed;
			
			//if you fall off the edge, DIE
			if(y > FlxG.height){
				kill();
			}
			//update
			super.update();
		}
	}
}
