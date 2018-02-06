package{

	import org.flixel.*;
	
	public class BouncyBullet extends FlxSprite{
		//media
		[Embed(source="Images/BounceyBullet.png")] protected var ImgBullet:Class;
		[Embed(source="Sound/Bouncy.mp3")] 		public static var BulletSFX:Class;
	
		//variables
		private var player:Player;
		private var XDirection:Number 	= 0;
		private var YDirection:Number 	= 1;
		
		public function BouncyBullet(p:Player){
			x = 0;
			y = 0;
			player	= p;
			//load graphic
			loadGraphic(ImgBullet,true,true,4,4);
			//set up player animations
			addAnimation("TheOnlyFrame", [0], 0, false);
			play("TheOnlyFrame");
		}
		
		//override this
		public function restart(X:Number,Y:Number):void
		{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			
			//set up velocity
			XDirection = 0;
			YDirection = 1 + (FlxU.random()/2);
			//play sound
			FlxG.play(BulletSFX, .5);
		}
		
		//update function
		public override function update():void{
			//see if you overlap with the player and are goin down
			if((YDirection > 0) && (right >= player.x) && (left <= player.right) && (bottom >= player.top) && (bottom <= player.bottom)){
				//change direction
				ChangeDirection();
				YDirection = -1;
			}
			if(left <= 0 || right >= FlxG.width){
				//flip and increase X direction
				XDirection = 2*(-XDirection);
			}
			//Fix bullets being too far offscreen
			if(left <= -1){
				x = 0;
			}else if(right >= FlxG.width + 1){
				x = FlxG.width - width;
			}
			//move
			x += XDirection;
			y += YDirection;


			//stop out of control acceleration
			if(XDirection >= 4){
				XDirection = 4;
			}else if(XDirection <= -4){
				XDirection = -4;		
			}

			//kill sprite if offscreen
			if(y >= FlxG.height){
				kill();
			}else if(y <= 0){
				kill();
			}
			//update
			super.update();
		}
		
		private function ChangeDirection():void{
			//calculate where you hit, one of 16 possible positions
			var point1:Number = x + width/2;
			var point2:Number = player.x + player.width/2;
			var Location:Number = point1 - point2;
			XDirection = Location * .1;	
			//reverse and double
			YDirection = 2*(-YDirection);
		}
		
		public function SetXDirection(n:Number):void	{ XDirection = n; }
		public function SetYDirection(n:Number):void	{ YDirection = n; }
		
		public function GetXDirection():Number	{ return XDirection; }
		public function GetYDirection():Number { return YDirection; }
	}
}
