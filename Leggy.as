package{

	import org.flixel.*;
	
	public class Leggy extends FlxSprite{
	
		//important player state variables
		private var Alive:Boolean	= true;
		private var speed:Number	= 1;
		private var Direction:Boolean	= true;
		private var Shooting:Boolean	= false;
		public var CanMove:Boolean		= false;
		
		//shot related vars
		private var NotReadyYet:Boolean = false;
		private var ReadyTimer:Number = 1;
		
		//media
		//graphics
		[Embed(source="Images/Leggy2.png")] protected var ImgPlayer:Class;

		
		public function Leggy(newX:uint, newY:uint){
			//set up starting position
			x	= newX;
			y	= newY;
			//load graphic
			loadGraphic(ImgPlayer,true,true,34,29);
			//set up player animations
			addAnimation("Stop", [0], 0, false);
			addAnimation("Move Left", [3, 4, 5, 0, 1, 2], 20, true);
			addAnimation("Move Right", [8, 9, 10, 0, 1, 2], 20, true);
			addAnimation("Wobble", [0, 1, 2], 10, true);
			play("Wobble");
		}
		
		public function Kill():void{
			x		= 320;
			y		= 240;
			exists	= false;
			dead	= true;
		}
		
		//update function
		public override function update():void{
			//AI will go here
			if(CanMove){ doAI(); }
			//update
			super.update();
		}
		public function GetString():String{	return "Leggy"; }
		
		public function restart(X:Number,Y:Number):void
		{
			frame = 0;
			x = X;
			y = Y;
			exists = true;
			dead = false;
			//adding speed
			speed = 1;
			
			//CANT MOVE AM GOAL
			CanMove = false;
			
			//set up velocity
			Direction = true;
			
			//play wobble
			play("Wobble");
		}
		
		//AI function
		private function doAI():void{
			//better AI
			//move left, right, randomly stop to shoot, or move down
			if(NotReadyYet){
				ReadyTimer -= FlxG.elapsed*2;
				if(ReadyTimer <= 0){
					ReadyTimer = 1;
					NotReadyYet = false;
				}
			}else{
				//classic AI
				//very simple, move left, right, randomly shoot down
				//if Direction is True, go right
				//else, go left
				if(Direction){
					x += speed;
					play("Move Right");
				}else{
					x -= speed;
					play("Move Left");
				}
				//if you are going past a screen edge, reverse direction and increase speed, also move down some
				if(x >= FlxG.width - 40){
					Direction = false;
					speed += .25;
					//change animation
					play("Move Left");
				}else if(x < 0){
					Direction = true;
					speed += .25;
					//change animation
					play("Move Right");
				}
				
				//randomly move down by 1 px
				if(FlxU.random() > .90){
					y += 2;
				}
				
				//decide if you should fire a bullet
				if((FlxU.random()) > .985){
					Shooting	= true;
					NotReadyYet = true;
					ReadyTimer = 1;
					play("Stop");
				}
			}
		}
		
		public function GetSpeed():Number{	return speed; }
		
		public function CheckShooting():Boolean{	return Shooting; }
		
		public function StopShooting():void{	Shooting = false; }
	}
}
