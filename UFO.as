package{

	import org.flixel.*;
	
	public class UFO extends FlxSprite{
	
		//important player state variables
		private var Alive:Boolean			= true;
		private var speed:Number			= 1;
		private var Direction:Boolean	= true;
		private var Shooting:Boolean	= false;
		private var LastOne:Boolean		= false;
		public var CanMove:Boolean		= false;
		//media
		//graphics
		[Embed(source="Images/UFO2.png")] protected var ImgPlayer:Class;
		
		public function Kill():void{
			x		= 320;
			y		= 240;
			exists	= false;
			dead	= true;
		}
		
		
		public function UFO(newX:uint, newY:uint){
			//set up starting position
			x	= newX;
			y	= newY;
			//load graphic
			loadGraphic(ImgPlayer,true,true,32,19);
			//set up player animations
			addAnimation("Wobble", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 15, true);
			play("Wobble");
		}
		
		//update function
		public override function update():void{
			//AI will go here
			if(CanMove){ doAI(); }
			//update
			super.update();
		}
		
		public function GetString():String{	return "UFO"; }
		
		public function SetLastOne():void{
			if(!LastOne){
				LastOne = true;
				color = 0xFF8888;
				speed *= 2;
			}
		}
		
		public function restart(X:Number,Y:Number):void
		{
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
			LastOne = false;
			color = 0xFFFFFF;
		}
		
		//AI function
		private function doAI():void{
			//classic AI
			//very simple, move left, right, randomly shoot down
			//if Direction is True, go right
			//else, go left
			if(Direction){
				x += speed;
			}else{
				x -= speed;
			}
			//if you are going past a screen edge, reverse direction and increase speed, also move down some
			if(x >= FlxG.width - 40){
				Direction = false;
				speed += .05;
				y += 8;
			}else if(x < 0){
				Direction = true;
				speed += .05;
				y += 8;
			}
			
			//decide if you should fire a bullet
			if(!LastOne){
				if((FlxU.random()) > .9975){
					Shooting	= true;
				}
			}else{
				if((FlxU.random()) > .95){
					Shooting	= true;
				}
			}
		}
		
		public function GetSpeed():Number{	return speed; }
		
		public function CheckShooting():Boolean{	return Shooting; }
		
		public function StopShooting():void{	Shooting = false; }
	}
}
