package{

	import org.flixel.*;
	
	public class Boom extends FlxSprite{
	
		//important player state variables
		//graphics
		[Embed(source="Images/Boomey.png")] protected var ImgPlayer:Class;

		
		public function Boom(newX:uint, newY:uint){
			//set up starting position
			x	= newX;
			y	= newY;
			//load graphic
			loadGraphic(ImgPlayer,true,true,32,32);
			//set up player animations
			addAnimation("Explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
			play("Explode");
		}
		
		//update function
		public override function update():void{
			if(frame == 9){
				kill();
			}
			//update
			super.update();
		}
		
		public function restart(X:Number,Y:Number):void	{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			play("Explode");
		}
	}
}
