package
{
	import org.flixel.FlxPreloader;
	import org.flixel.*;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mochi.as3.*;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.IOErrorEvent;
    import flash.utils.getDefinitionByName;
	import flash.ui.Mouse;
	import flash.net.*;
	import flash.system.System;
	
	public class TLO_Splash extends FlxState{
	
		[Embed(source="Images/BGTile1.png")] 			protected var ImgBG:Class;
//		[Embed(source="Images/Logo.png")] 				protected var ImgMyLogo:Class;
		[Embed(source="Images/PowerBar_Empty.png")]		protected var ImgEmptyBar:Class;
		[Embed(source="Images/Loader_Bar.png")] 		protected var ImgFullBar:Class;
		[Embed(source="Images/trans.png")] 				protected var ImgTrans:Class;
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG.png")]				private var ImgMyLogo:Class;
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG_Mouse_Over.png")]	private var ImgAG_MouseOver:Class;
		
		//Logo BS
		private var Logo:FlxSprite;
		private var Logo_MouseOver:FlxSprite;
		private var ProgressBar:FlxSprite;
		private var TheTimer:Number	= 0;
		private var FlxUButton:FlxURLButton;
	
		public function TLO_Splash(){
			createThis();
			FlxG.mouse.show();
			FlxG.log("Hi 0");
		}
		
		
		public function createThis():void {
			
			var b:FlxSprite;
			
			for (var i:uint = 0; i < 10; i++){
				for(var j:uint = 0; j < 8; j++){
					b = new FlxSprite();
					b.loadGraphic(ImgBG, true, true, 64, 64);
					b.width = b.height = 64;			
					b.x = i*64;
					b.y = j*64;
					add(b);
				}
			}
			
			Logo = new FlxSprite();
			Logo.loadGraphic(ImgMyLogo, true, true, 296, 121);
			Logo.x	= (FlxG.width/2) - (Logo.width/2);
			Logo.y	= 20;
			add(Logo);
			
			Logo_MouseOver = new FlxSprite();
			Logo_MouseOver.loadGraphic(ImgMyLogo, true, true, 296, 121);
			Logo_MouseOver.x		= (FlxG.width/2) - (Logo_MouseOver.width/2);
			Logo_MouseOver.y		= 20;
			Logo_MouseOver.alpha	= 0;
			add(Logo_MouseOver);
			
			var EProgressBar:FlxSprite = new FlxSprite();
			EProgressBar.loadGraphic(ImgEmptyBar, true, true, 100, 16);
			EProgressBar.x			= (FlxG.width/2) - (EProgressBar.width/2);
			EProgressBar.y			= FlxG.height - 64;
			EProgressBar.width		= 0;
			add(EProgressBar);
			
			ProgressBar = new FlxSprite();
			ProgressBar.loadGraphic(ImgFullBar, true, true, 1, 16);
			ProgressBar.x			= (FlxG.width/2) - (ProgressBar.width/2);
			ProgressBar.y			= FlxG.height - 64;
			add(ProgressBar);
			
			//FUCK
			var transpr:FlxSprite = new FlxSprite();
			transpr.loadGraphic(ImgTrans, true, true, 110, 110);
			
			//link bullshit
			var LCB:Function;
			LCB = OpenLink;
			FlxUButton = new FlxURLButton(Logo.x, Logo.y, Logo, LCB);
			FlxUButton.loadGraphic(transpr);
			FlxUButton.width	= Logo.width;
			FlxUButton.height	= Logo.height;
			add(FlxUButton);
			
		}
		
		private function OpenLink():void{
			navigateToURL(new URLRequest('http://www.accoladegames.com'), '_blank');		
		}
		
		private function MouseOverSprite(FSprite:FlxSprite):Boolean{
			//see if you're mousing over the sprite
			var IsWAT:Boolean = false;
			if((FSprite.visible) && (FlxG.mouse.x >= FSprite.left) && (FlxG.mouse.x <= FSprite.right) 
			&& (FlxG.mouse.y >= FSprite.top) && (FlxG.mouse.y <= FSprite.bottom)){
				return true;
			}
			return IsWAT;
		}	
		
		private function ShowLogoMO():void{
			Logo_MouseOver.alpha	= 1;
		}
		
		private function HideLogoMO():void{
			Logo_MouseOver.alpha	= 0;
		}
		
		override public function update():void{
			Mouse.show();
			
			//Check for MouseOver
			if(MouseOverSprite(Logo)){
				ShowLogoMO();
			}else{
				HideLogoMO();
			}
			
			if(TheTimer < 3){
				TheTimer += FlxG.elapsed;
				ProgressBar = new FlxSprite();
				ProgressBar.loadGraphic(ImgFullBar, true, true, (TheTimer/3)*100, 16);
				ProgressBar.x			= (FlxG.width/2) - 50;
				ProgressBar.y			= FlxG.height - 64;
				add(ProgressBar);
			}else if(TheTimer < 4){
				TheTimer += FlxG.elapsed;
				ProgressBar = new FlxSprite();
				ProgressBar.loadGraphic(ImgFullBar, true, true, 100, 16);
				ProgressBar.x			= (FlxG.width/2) - (ProgressBar.width/2);
				ProgressBar.y			= FlxG.height - 64;
				add(ProgressBar);			
			}else{
				FlxG.log("Switching States!");
				FlxG.state = new Title();
			}
		/*
			//Update the graphics...			
			var b:Bitmap = new ImgFullBar();
			b.width		= 100;
			b.height	= 16;
			b.scaleX	= Percent*3;
			b.scaleY	= 3;
			b.x			= (_width/2) - (b.width/2);
			b.y			= _height - 160;
			_buffer.addChild(b);
		*/
				super.update();
		}
	}
}
