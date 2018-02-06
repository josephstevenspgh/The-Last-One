package{

	import org.flixel.*;
	
	public class PlayerBullet extends FlxSprite{
		//media
		[Embed(source="Images/PlayerBullet.png")] 	private var ImgBullet:Class;
		//Enemy Group
		private var EGroup:FlxGroup;
		//bs
		private var killed:uint;
		
		public function PlayerBullet(){
			x = 0;
			y = 0;
			//load graphic
			loadGraphic(ImgBullet,true,true,10,20);
			//set up player animations
		}
		
		//override this
		public function regen(X:Number,Y:Number):void
		{
			x = X;
			y = Y;
			exists = true;
			dead = false;
		}
		
		//update function
		public override function update():void{
			//kill me if I go offscreen
			if(y <= -20){
				kill();
			}
			randomFrame();
			//move down
			y -= 5;
			//update
			super.update();
		}
	}
}
