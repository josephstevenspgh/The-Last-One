package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Player extends FlxSprite{
	
		//important player state variables
		public var Alive:Boolean					= true;
		public var Stun:Boolean						= false;
		public var CanShoot:Boolean 				= true;
		private var TimeMultiplier:Number 			= 1;
		private var BlowUp:Boolean					= false;
		
		//This is so mouse and keyboard movement don't argue with each other
		private var OldMouseX:Number 				= 0;
		private var MouseTracking:Boolean 			= true;
		
		//Barrier
		private var Barrier:FlxSprite;
		
		//bullet counter - you can only fire once every 10 seconds
		private var Bullet:PlayerBullet;
		private var BulletCounter:Number			= 0;
		private var ShotNotReady:Boolean			= true;
		private var Shooting:Boolean				= false;
		
		//awesome mode
		private var AwesomeMode:Boolean				= false;
		private var AwesomeTimer:Number				= 0;
		
		//acceleration
		private var Accel:Number					= 0;
		
		//media
		//graphics
		[Embed(source="Images/SmallShip.png")]		protected var ImgPlayer:Class;
		[Embed(source="Images/Shield_frames.png")]	protected var ImgShield:Class;
		[Embed(source="Images/Left.png")] 			private var ImgMouseLeft:Class;
		[Embed(source="Images/Right.png")] 			private var ImgMouseRight:Class;
		[Embed(source="Images/Center.png")] 		private var ImgMouseCenter:Class;
		[Embed(source="Images/Boomey.png")] 		protected var ImgBoom:Class;
		//sound
		[Embed(source="Sound/WeaponReady.mp3")] 	private var WeaponReadySFX:Class;
		[Embed(source="Sound/PlayerShot.mp3")] 		private var PlayerShotSFX:Class;
		
		
		public function Player(f:FlxSprite, bar:FlxSprite, b:PlayerBullet){
			//load graphic
			loadGraphic(ImgPlayer,true,true,32,26);
			//set up player animations
			addAnimation("Stopped", [0], 0, false);
			addAnimation("GoingLeft", [0, 1, 2], 20, false);
			addAnimation("GoingRight", [0, 5, 6], 20, false);
			addAnimation("Shooting", [0], 30, false);
			//initialize position onscreen
			x	= (FlxG.width/2) - 32;
			y	= FlxG.height - 64;
			
			
			//Set up barrier
			Barrier = bar;
			Barrier.y = y - 2;
			Barrier.x = x;
			Barrier.loadGraphic(ImgShield, true, true, 32, 16);
			Barrier.addAnimation("Pulsate", [0, 1, 2, 3, 4], 20, true);
			Barrier.play("Pulsate");
			
			//set up bullet
			Bullet = b;
		}
		
		private function Explodey():void{	
			//load graphic
			loadGraphic(ImgBoom,true,true,32,32);
			//set up player animations
			addAnimation("Explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
			play("Explode");
			Alive	= false;
			dead	= true;
			Barrier.alpha = 0;
		}
		
		public function IncreaseTimeMultiplier():void{
			TimeMultiplier = TimeMultiplier+.5;
		}
		
		private function GetAccel():Number{
			//get location of the ship's center relative to the location of the mouse
			var ShipCenterX:Number = x + (width/2);
			var Difference:Number = (FlxG.mouse.x - ShipCenterX)/3;
			if(!MouseTracking && (FlxG.keys.A || FlxG.keys.LEFT)){
				return -6;
			}else if(!MouseTracking && (FlxG.keys.D || FlxG.keys.RIGHT)){
				return 6;
			}else if(Difference >= 10){
				return 10;
			}else if(Difference <= -10){
				return -10;
			}else{
				return Difference;
			}
		}
		
		public function MaxShot():void{
			BulletCounter = 10;
		}
		
		public function StartAwesome():void{
			AwesomeMode = true;
			AwesomeTimer = 0;
		}
		
		//update function
		public override function update():void{
			if(!dead){
				var Elap:Number = FlxG.elapsed;
				if(AwesomeMode){
					AwesomeTimer += Elap;
					BulletCounter = 10;
					if(AwesomeTimer >= 10){
						AwesomeMode = false;
					}
				}
				//if the player presses A, D, Left, Right, Up, Space, or W, set the movement mode to keyboard only
				if(FlxG.keys.A || FlxG.keys.D || FlxG.keys.W || FlxG.keys.SPACE || FlxG.keys.UP || FlxG.keys.LEFT || FlxG.keys.RIGHT){
					MouseTracking = false;
					//hide mouse
					FlxG.mouse.hide();
				}
				//if the mouse was moved more recently than keys were moved, set movement to mouse tracking
				if(FlxG.mouse.x != OldMouseX){
					//show mouse
					FlxG.mouse.show();
					//set mouse tracking to true
					MouseTracking = true;
				}
				OldMouseX = FlxG.mouse.x;
				//increase bullet counter
				if(BulletCounter < 10){
					BulletCounter += (Elap * TimeMultiplier);
				}
				if(Stun){
					randomFrame();
					if(BulletCounter > 1.5){
						Stun = false;
						if(BlowUp){
							Explodey();
						}
					}
				}else{
					if(ShotNotReady && BulletCounter >= 10){
						//play sound effect signaling that the bullet is ready to be shot
						FlxG.play(WeaponReadySFX, .5);
						ShotNotReady = false;
					}
					if(Alive && !Shooting){
						//mouse movement, *sigh*
						//x = FlxG.mouse.x;
					
						//movement
						if((FlxG.keys.A || FlxG.keys.LEFT) || ((FlxG.mouse.x < (x + 12)) && (MouseTracking))){
							//change mouse cursor
							FlxG.mouse.cursor = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y, ImgMouseLeft);
							//move left if you can
							if(x >= 0){
								play("GoingLeft");
							
								if(Barrier.facing == LEFT){
									x += Accel;
								}else{
									Accel = 1;
								}
								Accel = GetAccel();
								Barrier.facing = LEFT;
								Barrier.x = x;
							}
						}else if((FlxG.keys.D || FlxG.keys.RIGHT) || ((FlxG.mouse.x > (right - 12)) && (MouseTracking))){
							//change mouse cursor
							FlxG.mouse.cursor = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y, ImgMouseRight);
							//move right if you can
							if (right <= FlxG.width){
								play("GoingRight");
								if(Barrier.facing == RIGHT){
									x += Accel;
								}else{
									Accel = 1;
								}
								Accel = GetAccel();
								Barrier.facing = RIGHT;
								Barrier.x = x;
							}
						}else{
							//change mouse cursor
							FlxG.mouse.cursor = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y, ImgMouseCenter);
							//not moving at all
							play("Stopped");
							//stop accelleration
							Accel = 1;
						}
						//shooting
						if(!ShotNotReady && !Bullet.exists && CanShoot){
							//you can shoot!
							if(FlxG.mouse.justPressed() || FlxG.keys.SPACE || FlxG.keys.UP || FlxG.keys.W){
								//shot that shit yo
								play("Shooting");
								FlxG.play(PlayerShotSFX, .5);
								BulletCounter = 0;
								ShotNotReady = true;
								//fire shot
								Bullet.regen((x + width/2) - 5, y - 20);
							}
						}
					}else{
						//yo dead
					}
				}
			}
			//update
			super.update();
		}
		
		public function Kill():void{
			BlowUp			= true;
			BulletCounter	= 0;
			ShotNotReady	= true;
			Stun			= true;
		}
		
		public function Stunned():void{
			BulletCounter 	= 0;
			ShotNotReady 	= true;
			
			Stun = true;
		}
		
		public function GetAwesomeMode():Boolean{	return AwesomeMode;}		
		public function GetTimeMultiplier():Number{ return TimeMultiplier; }		
		public function GetBulletCounter():Number{	return BulletCounter;}
		public function GetShooting():Boolean{	return Shooting;}
	}
	
	
}
