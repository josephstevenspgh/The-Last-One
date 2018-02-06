package{
	import org.flixel.*;
	import Playtomic.*;
	import org.flixel.data.*;
	import flash.display.LoaderInfo;
	import flash.net.*;   
	import flash.external.ExternalInterface;	 
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.ui.Mouse;
	import flash.display.BitmapData;    
 
	public class Title extends FlxState{
	
		private var SiteLock:Boolean		= false;
		private var OnNewgrounds:Boolean	= false;
		
		private var BGGroup:FlxGroup;
		private var TitleTextGroup:FlxGroup;
		private var CreditTextGroup:FlxGroup;
		private var BullGroup:FlxGroup;
		
		private var IsCredits:Boolean	= false;
		private var DoNothing:Boolean	= false;
		
		//sounds
		[Embed(source="Sound/shoot.mp3")] 						private var ShotSFX:Class;
		[Embed(source="Sound/PlayerShot.mp3")] 					private var ClickSFX:Class;

		//images
		[Embed(source="Images/BG.png")] 						private var ImgBackground:Class;
		[Embed(source="Images/Stars.png")] 						private var ImgStars:Class;
		[Embed(source="Images/Planet.png")] 					private var ImgPlanet:Class;
		[Embed(source="Images/BigFont.png")] 					private var ImgBigFont:Class;
		[Embed(source="Images/NESFont.png")] 					private var ImgNESFont:Class;

		//Sponsorship		
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG.png")]				private var ImgAG:Class;
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG_Mouse_Over.png")]	private var ImgAG_MouseOver:Class;
		[Embed(source="Sponsor/Accolade Games_small_v3.png")]					private var ImgSmallLogo:Class;
		[Embed(source="Sponsor/Accolade Games_small_v3_mouse_over.png")]		private var ImgSmallLogo_Mouseover:Class;
		[Embed(source="Images/trans.png")] 										protected var ImgTrans:Class;
		private var Logo:Bitmap;
		private var LogoMouseOver:Bitmap;
		private var IsHighlighting:Boolean	= false;
		
		//links need url buttons
		private var LogoButton:FlxURLButton;
		private var MoreGamesButton:FlxURLButton;
		private var BonusesButton:FlxURLButton;
		private var SplixelButton:FlxURLButton;
		
		//initializing function
		public function Title(){
		
			//Keep track of users.
			if(!OnNewgrounds){
				if(ExternalInterface.available && ExternalInterface.objectID != null){
					Log.View(3569, "f681f939806e4280", ExternalInterface.call('window.location.href.toString'));
				}
			}
		
			//SITELOCK BS
			if(SiteLock){
				var allowed_site:String = "splixel.com"; 
				var domain:String = ExternalInterface.call('window.location.href.toString').split("/")[2];
				if (domain.indexOf(allowed_site) != (domain.length - allowed_site.length)) { 
					// kill
					DoNothing = true;		
				}
			}
		
			BullGroup = new FlxGroup();
		
			//Sponsor BS
			var _buffer:Sprite 		= new Sprite();
			_buffer.width	= 640;
			_buffer.height	= 480;
			_buffer.scaleX	= .5;
			_buffer.scaleY	= .5;
			addChild(_buffer);
			
			Logo = new ImgSmallLogo();
			Logo.width 	= 137;
			Logo.height	= 101;
			Logo.x		= 475;
			Logo.y		= 350;
			_buffer.addChild(Logo);
			
			LogoMouseOver 			= new ImgSmallLogo_Mouseover();
			LogoMouseOver.width		= 137;
			LogoMouseOver.height	= 101;
			LogoMouseOver.x			= 1475;
			LogoMouseOver.y			= 350;
			_buffer.addChild(LogoMouseOver);
			
			//be lazy, use flixel!~
			var bull:FlxSprite = new FlxSprite();			
			bull = new FlxSprite();
			bull.loadGraphic(ImgSmallLogo,true,true,137,101);
			bull.x	= (475/2);
			bull.y	= (350/2);
			bull.scale = new FlxPoint(0.5, 0.5);
			bull.alpha	= 0;
			BullGroup.add(bull);
			
			//fucking links
			var transpr:FlxSprite = new FlxSprite();
			transpr.loadGraphic(ImgTrans, true, true, 110, 110);
			
			//link bullshit
			

		
			if(!DoNothing){
				//show mouse
				FlxG.mouse.show();
			
				//init shit
				BGGroup 			= new FlxGroup();
				TitleTextGroup 		= new FlxGroup();
				CreditTextGroup		= new FlxGroup();
			
				//add shit to groups
			
				//backgrounds
				BGGroup.add(new FlxSprite(0, 0, ImgBackground));
				BGGroup.add(new FlxSprite(0, 0, ImgStars));
				BGGroup.add(new FlxSprite(0, 0, ImgPlanet));
			
				//title
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 50, "The Last One", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 74, "------------------", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 70, "-----------------", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 78, "-----------------", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 110, "Start Game", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 130, "Start With Bonuses", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 150, "More Games", "Center", 16, 16));
				TitleTextGroup.add(new PixelFont(ImgBigFont, 0, 170, "Credits", "Center", 16, 16));
				
				//credits
				CreditTextGroup.add(new PixelFont(ImgBigFont, 0, 32, "- Credits -", "Center", 16, 16));
				CreditTextGroup.add(new PixelFont(ImgBigFont, 16, 64, "Joseph Stevens", "Left", 16, 16));
				CreditTextGroup.add(new PixelFont(ImgNESFont, 0, 80, "Artist, Coder, Designer,", "Center", 8, 8));
				CreditTextGroup.add(new PixelFont(ImgNESFont, 0, 88, "Sound effects, Iced tea drinker,", "Center", 8, 8));
				CreditTextGroup.add(new PixelFont(ImgNESFont, 0, 96, "yknow, everything else.", "Center", 8, 8));
				CreditTextGroup.add(new PixelFont(ImgBigFont, 16, 128, "Dustin Wyatt", "Left", 16, 16));
				CreditTextGroup.add(new PixelFont(ImgNESFont, 0, 144, "Musician", "Center", 8, 8));
				CreditTextGroup.add(new PixelFont(ImgBigFont, 0, 180, "Return to TItle", "Center", 16, 16));
						
				//add groups
				add(BGGroup);
				add(TitleTextGroup);
				add(CreditTextGroup);
				add(BullGroup);
				
				//hide credits
				HideCredits();
				
				
				//cheap workaround :)
				var dummysprite:FlxSprite = new FlxSprite(1000, 1000);
				add(dummysprite);
			
				//Sponsor Logo
				var LCB:Function;
				LCB = OpenLink;
				LogoButton = new FlxURLButton(237, 175, dummysprite, LCB);
				LogoButton.loadGraphic(transpr);
				LogoButton.width	= Logo.width;
				LogoButton.height	= Logo.height;
						
				//More Games
				MoreGamesButton = new FlxURLButton(80, 150, dummysprite, LCB);
				MoreGamesButton.loadGraphic(transpr);
				MoreGamesButton.width	= 160;
				MoreGamesButton.height	= 16;
			
			
				var LCB1:Function;
				LCB1 = OpenLink1;
				BonusesButton = new FlxURLButton(16, 130, dummysprite, LCB1);
				BonusesButton.loadGraphic(transpr);
				BonusesButton.width		= 288;
				BonusesButton.height	= 16;
			
			
				var LCB2:Function;
				LCB2 = OpenLink2;
				SplixelButton = new FlxURLButton(16, 64, dummysprite, LCB2);
				SplixelButton.loadGraphic(transpr);
				SplixelButton.width		= 224;
				SplixelButton.height	= 16;
			
				//SplixelButton.DisableMe();
			
			
				add(LogoButton);
				add(MoreGamesButton);
				add(BonusesButton);
				add(SplixelButton);				
			}
		}
		
		private function ShowSplixelButton(Visibility:Boolean):void{
			if(Visibility){
				SplixelButton.x	= 16;
				SplixelButton.y	= 64;
			}else{
				SplixelButton.x	= 1016;
				SplixelButton.y	= 1064;
			}
		}
		
		private function ShowLogoButton(Visibility:Boolean):void{
			if(Visibility){
				LogoButton.x	= 237;
				LogoButton.y	= 175;
			}else{
				LogoButton.x	= 1237;
				LogoButton.y	= 1175;
			}
		}
		
		private function ShowMoreButton(Visibility:Boolean):void{
			if(Visibility){
				MoreGamesButton.x	= 80;
				MoreGamesButton.y	= 150;
			}else{
				MoreGamesButton.x	= 1080;
				MoreGamesButton.y	= 1150;
			}
		}
		
		private function ShowBonusButton(Visibility:Boolean):void{
			if(Visibility){
				BonusesButton.x	= 16;
				BonusesButton.y	= 130;
			}else{
				BonusesButton.x	= 1016;
				BonusesButton.y	= 1130;
			}
		}
		
		private function OpenLink():void{
			navigateToURL(new URLRequest('http://www.accoladegames.com'), '_blank');		
		}
		
		private function OpenLink1():void{
			navigateToURL(new URLRequest('http://www.accoladegames.com/shooting-games/the-last-one.html'), '_blank');
		}
		
		private function OpenLink2():void{
			navigateToURL(new URLRequest('http://www.splixel.com'), '_blank');
		}
		
		private function LoadCredits():void{
			HideTitle();
			ShowCredits();
			IsCredits	= true;
		}
		
		private function UnLoadCredits():void{
			ShowTitle();
			HideCredits();
			IsCredits	= false;
		}
		
		private function ShowCredits():void{
			//Show the credits
			for(var i:uint = 0; i < CreditTextGroup.members.length; i++){
				ShowGroup(CreditTextGroup.members[i]);
			}
		}
		
		private function HideCredits():void{
			//Hide the credits
			for(var i:uint = 0; i < CreditTextGroup.members.length; i++){
				HideGroup(CreditTextGroup.members[i]);
			}
		}
		
		private function HideTitle():void {
			for(var i:uint = 0; i < TitleTextGroup.members.length; i++){
				HideGroup(TitleTextGroup.members[i]);
			}
		}
		
		private function ShowTitle():void {
			for(var i:uint = 0; i < TitleTextGroup.members.length; i++){
				ShowGroup(TitleTextGroup.members[i]);
			}
		}
		
		private function HideGroup(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length; i++){
				Group.members[i].visible = false;
			}
		}
		
		private function ShowGroup(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length; i++){
				Group.members[i].visible = true;
			}
		}
		
		private function MouseOverGroup(Group:FlxGroup):Boolean{
			//see if you're mousing over any of the sprites
			var IsWAT:Boolean = false;
			for(var i:uint = 0;i < Group.members.length; i++){
				if((Group.members[i].visible) && (FlxG.mouse.x >= Group.members[i].left) && (FlxG.mouse.x <= Group.members[i].right) 
				&& (FlxG.mouse.y >= Group.members[i].top) && (FlxG.mouse.y <= Group.members[i].bottom)){
					return true;
				}
			}
			return IsWAT;
		}
		
		private function MouseOver(Sprite:FlxSprite):Boolean{
			//see if you're mousing over any of the sprites
			if((Sprite.visible) && (FlxG.mouse.x >= Sprite.left) && (FlxG.mouse.x <= Sprite.right) 
			&& (FlxG.mouse.y >= Sprite.top) && (FlxG.mouse.y <= Sprite.bottom)){
				return true;
			}else{
				return false;
			}
		}
		
		private function Highlight(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length; i++){
				Group.members[i].color = 0xFFFFFF;
			}
		}
		
		private function Dim(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length; i++){
				Group.members[i].color = 0x808080;
			}
		}

		private function LogoMouseOverToggle():void{
			if(!IsCredits){
				if(LogoMouseOver.x	== 1475){
					LogoMouseOver.x	= 475;
				}else{
					LogoMouseOver.x	= 1475;
				}
			}
		}
		private function LogoToggle():void{
			if(Logo.x	== 1475){
				Logo.x	= 475;
			}else{
				Logo.x	= 1475;
			}
		}
		
		override public function update():void{
			if(!DoNothing){
				Mouse.show();

				//blugh
				if(IsCredits){
					ShowSplixelButton(true);
					ShowLogoButton(false);
					ShowMoreButton(false);
					ShowBonusButton(false);
				}else{
					ShowSplixelButton(false);
					ShowLogoButton(true);
					ShowMoreButton(true);
					ShowBonusButton(true);
				}
				
				//testing
				if(MouseOver(BullGroup.members[0])){
					if(!IsHighlighting){
						LogoMouseOverToggle();
						IsHighlighting	= true;
					}
				}else{
					IsHighlighting=false;
					LogoMouseOver.x	= 1475;
				}		
			
				//start dimming that shit, dawg
				Dim(TitleTextGroup.members[4]);
				Dim(TitleTextGroup.members[5]);
				Dim(TitleTextGroup.members[6]);
				Dim(TitleTextGroup.members[7]);
				//if you highlight an option.. highlight it, if not, stop highlighting it!
				if(MouseOverGroup(TitleTextGroup.members[4])){
					Highlight(TitleTextGroup.members[4]);
				}else if(MouseOverGroup(TitleTextGroup.members[5])){
					Highlight(TitleTextGroup.members[5]);
				}else if(MouseOverGroup(TitleTextGroup.members[6])){
					Highlight(TitleTextGroup.members[6]);
				}else if(MouseOverGroup(TitleTextGroup.members[7])){
					Highlight(TitleTextGroup.members[7]);
				}
			
				//start game on enter or space
				if(FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")){
					FlxG.state = new GameState();
				}
			
				//mousepresses do stuff
				if(FlxG.mouse.justPressed()){
					//handle mouseclicks
					if(FlxG.mouse.justPressed()){
						if(MouseOverGroup(TitleTextGroup.members[4])){
							FlxG.play(ClickSFX);
							//start game
							FlxG.state = new GameState();
						}else if(MouseOverGroup(TitleTextGroup.members[7])){
							FlxG.play(ClickSFX);
							//Load Credits
							LoadCredits();
							LogoToggle();
						}else if(MouseOverGroup(CreditTextGroup.members[7])){
							FlxG.play(ClickSFX);
							//Load Credits
							UnLoadCredits();
							LogoToggle();
						}
					}
				}
				super.update();
			}
		}
	}
}
