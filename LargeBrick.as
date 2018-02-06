package{

	import org.flixel.*;
	
	public class LargeBrick extends FlxSprite{
		//media
		[Embed(source="Images/Bricks.png")] 	private var ImgLargeBricks:Class;
	
		//variables
		public var life:Number = 12;
		
		public function GetName():String { return "Large"; }
		
		public function LargeBrick(X:Number = 0, Y:Number = 0){
			x = X;
			y = Y;
			//load graphic
			loadGraphic(ImgLargeBricks,true,true,32,32);
			//set up player animations
			addAnimation("TheOnlyFrame", [0], 0, false);
			play("TheOnlyFrame");
		}
		
		public function HitMe():void{
			life--;
			if (life <= 6){
				frame = 1;
			}else if(life == 0){
				x = 500;
				super.update();
			}
			//FlxG.log("Life: "+life);
		}
		
		//update function
		public override function update():void{
			//update
			super.update();
		}
	}
}
