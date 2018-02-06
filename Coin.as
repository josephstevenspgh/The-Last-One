package{

	import org.flixel.*;
	
	public class Coin extends FlxSprite{
		//media
		[Embed(source="Images/Coin.png")] 	private var ImgCoin:Class;
	
		private var speed:Number = 0;
		//variables		
		public function Coin(X:Number = 0, Y:Number = 0){
			x = X;
			y = Y;
			//load graphic
			loadGraphic(ImgCoin,true,true,16,16);
			//set up player animations
			addAnimation("Spin", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 15, true);
			play("Spin");
			//calculate speed
			speed = 2 + ((FlxU.random()*10)/5);
		}
		
		public function restart(X:Number,Y:Number):void{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			speed = 2 + ((FlxU.random()/2));
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
