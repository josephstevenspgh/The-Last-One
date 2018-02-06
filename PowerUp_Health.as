package{

	import org.flixel.*;
	
	public class PowerUp_Health extends FlxSprite{
		//media
		[Embed(source="Images/PowerUp_Health.png")] 	private var ImgPowerUp:Class;
		
		private var speed:Number = 0;
	
		//variables		
		public function PowerUp_Health(X:Number = 0, Y:Number = 0){
			x = X;
			y = Y;
			//load graphic
			loadGraphic(ImgPowerUp,true,true,16,16);
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
			speed = 1.5 + (FlxU.random()/2);
		}
		
		public function GetType():String{	return "Health"; }
		
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
