package{
	import org.flixel.*;
	import flash.net.*;
 
	public class GameState extends FlxState{
	
		//Game Over Stuff
		private var EndGame:Boolean					= false;
		private var StarsFalling:Boolean			= false;
		private var StarSpeed:Number				= 250;
		private var StarFallTimer:Number;
		private var PlanetFading:Boolean			= false;
		private var CurrentStar:uint				= 0;
		
	
		//Memory Management stuff
		private var CurrentBouncyBullet:uint		= 0;
		private var MaxBouncyBullets:uint 			= 64;
		private var CurrentHurtyBullet:uint 		= 0;
		private var MaxHurtyBullets:uint			= 64;
		private var CurrentUFO:uint 				= 0;
		private var MaxUFO:uint 					= 32;
		private var CurrentSquiddy:uint 			= 0;
		private var MaxSquiddy:uint 				= 32;
		private var CurrentLeggy:uint 				= 0;
		private var MaxLeggy:uint 					= 32;
		private var CurrentSBrick:uint 				= 0;
		private var MaxSBrick:uint 					= 32;
		private var CurrentLBrick:uint 				= 0;
		private var MaxLBrick:uint 					= 32;
		private var CurrentCoin:uint				= 0;
		private var MaxCoin:uint					= 32;
		private var CurrentMN:uint					= 0;
		private var MaxMN:uint						= 5;
		private var CurrentSmallBrick:uint			= 0;
		private var CurrentLargeBrick:uint			= 0;
		private var UnlitStars:uint					= 0;
		private var LastLitStar:uint				= 0;
		
		//powerups: only one of each
		private var P_Health:PowerUp_Health 		= new PowerUp_Health();
		private var P_Recovery:PowerUp_Recovery		= new PowerUp_Recovery();
		private var P_Cash:PowerUp_Cash 			= new PowerUp_Cash();
		
		//health!
		private var DamagePlanet:Boolean			= false;
		private var DamagingPlanet:Number			= 0;
		private var Health:Number					= 1;
		
		//upgrade limitations
		private var MaxCities:uint					= 10;
		private var MaxFactories:uint				= 10;
		private var MaxHospitals:uint				= 10;
		private var MaxSmallBricks:uint				= 10;
		private var MaxLargeBricks:uint				= 10;
		private var CurrentCity:uint				= 0;
		private var CurrentFactory:uint				= 0;
		private var CurrentHospital:uint			= 0;		
		private var SBrickAmount:uint 				= 0;
		private var LBrickAmount:uint 				= 0;
		private var CityAmount:uint 				= 0;
		private var FactoryAmount:uint				= 0;
		private var HospitalAmount:uint 			= 0;
		
		//prices
		private var SBrickCost:uint					= 1500;
		private var LBrickCost:uint					= 5000;
		private var CityCost:uint					= 1250;
		private var FactoryCost:uint				= 2500;
		private var HospitalCost:uint				= 5000;
		
		//I dont even know
		private var FadingOutWaveNotifier:Boolean 	= false;
		private var EnemyMovement:Boolean			= true;
		private var Lost:Boolean 					= false;
		private var HardMode:Boolean 				= false;

		//cash and upgrades info
		private var Cash:Number 					= 0;
		private var Multiplier:Number				= 1;
		private var Healing:uint					= 1;
		
		//High Score/Stat tracking
		private var Score:uint						= 0;
		private var EnemiesKilled:uint				= 0;
		private var Waves:uint						= 1;
		private var TotalCash:uint					= 0;
		private var CitiesBuilt:uint				= 0;
		private var FactoriesBuilt:uint				= 0;
		private var HospitalsBuilt:uint				= 0;
		private var BuildingsBuilt:uint				= 0;
		private var SmallBricksBuilt:uint			= 0;
		private var LargeBricksBuilt:uint			= 0;
		private var TotalBricksBuilt:uint			= 0;
		
		//Menu bullshit
		private var BuyScreen:Boolean				= true;
		private var ItemPlacing:Boolean				= false;
		private var ItemToPlace:uint;
	
		//wave info
		private var WaveNumber:uint					= 1;
		private var killgoal:uint					= 100;
		private var killed:uint 					= 0;
		
		//groups
		private var BackgroundGroup:FlxGroup;
		private var PlayerGroup:FlxGroup;
		private var BulletGroup:FlxGroup;
		private var BouncyGroup:FlxGroup;
		private var PlayerBulletGroup:FlxGroup;
		private var MoneyGroup:FlxGroup;
		private var BuyingGroup:FlxGroup;
		private var ItemPlacingGroup:FlxGroup;
		private var BrickGroup:FlxGroup;
		private var PlacingGroup:FlxGroup;
		private var CoinGroup:FlxGroup;
		private var MoneyNotifierGroup:FlxGroup;
		private var BoomGroup:FlxGroup;
		private var PowerUpGroup:FlxGroup;
		private var CityGroup:FlxGroup;
		private var FactoryGroup:FlxGroup;
		private var HospitalGroup:FlxGroup;
		private var SmallBrickGroup:FlxGroup;
		private var LargeBrickGroup:FlxGroup;
		private var StarsGroup:FlxGroup;
		
		//enemy mini groups
		private var UFOGroup:FlxGroup;
		private var SquiddyGroup:FlxGroup;
		private var LeggyGroup:FlxGroup;
		
		//Game over groups
		private var GameOverGroup:FlxGroup;
		
		//images
		[Embed(source="Images/BG.png")] 						private var ImgBackground:Class;
		[Embed(source="Images/Stars.png")] 						private var ImgStars:Class;
		[Embed(source="Images/Planet_Greyscale.png")]			private var ImgDeadPlanet:Class;
		[Embed(source="Images/Planet.png")] 					private var ImgPlanet:Class;
		[Embed(source="Images/PowerBar_Empty_Smallest.png")] 	private var ImgShotEmpty:Class;
		[Embed(source="Images/PowerBar_Full_Smallest.png")] 	private var ImgShotFull:Class;
		[Embed(source="Images/PowerBar_Empty.png")] 			private var ImgPlanetHealthEmpty:Class;
		[Embed(source="Images/PowerBar_Full.png")] 				private var ImgPlanetHealthFull:Class;
		[Embed(source="Images/Factory.png")] 					private var ImgFactory:Class;
		[Embed(source="Images/Hospital.png")] 					private var ImgHospital:Class;
		[Embed(source="Images/City.png")] 						private var ImgCity:Class;
		[Embed(source="Images/Bricks.png")] 					private var ImgLargeBricks:Class;
		[Embed(source="Images/SmallBricks.png")]				private var ImgSmallBricks:Class;
		[Embed(source="Images/BuyButton.png")] 					private var ImgBuyButton:Class;
		[Embed(source="Images/SmallStars.png")]					private var ImgSmallStars:Class;
		[Embed(source="Images/BigFont.png")] 					private var ImgBigFont:Class;
		[Embed(source="org/flixel/data/cursor.png")] 			private var ImgMouse:Class;

		//sounds
		[Embed(source="Sound/Last One.mp3")]					private var BackgroundMusic:Class;
		[Embed(source="Sound/Die.mp3")] 						private var DieSFX:Class;
		[Embed(source="Sound/CoinGet.mp3")] 					private var CoinGetSFX:Class;
		[Embed(source="Sound/PowerUp.mp3")] 					private var PowerUpSFX:Class;
		
		
		//initializing function
		public function GameState(){
			//hide mouse
			FlxG.mouse.hide();
			//set up EVERYTHING
			//create objects to use later
			
			//initialize groups
			PlayerGroup 				= new FlxGroup();
			BulletGroup					= new FlxGroup();
			BouncyGroup 				= new FlxGroup();
			BackgroundGroup 			= new FlxGroup();
			PlayerBulletGroup 			= new FlxGroup();
			MoneyGroup					= new FlxGroup();
			BuyingGroup					= new FlxGroup();
			BrickGroup					= new FlxGroup();
			PlacingGroup 				= new FlxGroup();
			UFOGroup	 				= new FlxGroup();
			SquiddyGroup 				= new FlxGroup();
			LeggyGroup	 				= new FlxGroup();
			CoinGroup					= new FlxGroup();
			MoneyNotifierGroup			= new FlxGroup();
			BoomGroup					= new FlxGroup();
			PowerUpGroup				= new FlxGroup();
			CityGroup					= new FlxGroup();
			FactoryGroup				= new FlxGroup();
			HospitalGroup				= new FlxGroup();
			SmallBrickGroup				= new FlxGroup();
			LargeBrickGroup				= new FlxGroup();
			StarsGroup					= new FlxGroup();
			
			//background image
			BackgroundGroup.add(new FlxSprite(0, 0, ImgBackground));
			BackgroundGroup.add(StarsGroup);
			BackgroundGroup.add(new FlxSprite(0, 0, ImgDeadPlanet));
			BackgroundGroup.add(new FlxSprite(0, 0, ImgPlanet));
			
			UnlitStars					= 0;
			
			//new player
			//add player to display group
			var flame:FlxSprite = new FlxSprite();
			var Bullet:PlayerBullet = new PlayerBullet();
			Bullet.kill();
			PlayerGroup.add(new Player(flame, Bullet));
			PlayerGroup.add(flame);
			PlayerBulletGroup.add(Bullet);

			//add helpful text to help the user place items
			PlacingGroup.add(new FlxText(48, 30, 500, "Click to place your item."));
			PlacingGroup.add(new FlxText(48, 40, 500, "Wave will start as soon as item is placed."));
			
			
			//add visual shot timer
			PlayerGroup.add(new FlxSprite(0, FlxG.height - 51));
			PlayerGroup.add(new FlxSprite(0, FlxG.height - 51));
			PlayerGroup.members[2].loadGraphic(ImgShotEmpty, false, false, 16, 4);
			PlayerGroup.members[3].loadGraphic(ImgShotFull, false, false, 1, 4);
			PlayerGroup.members[3].addAnimation("Stop", [0], 0, false);
			PlayerGroup.members[3].addAnimation("Flash", [0, 1, 2, 3, 2, 1], 5, true);
			
			//add visual planet health indicator
			PlayerGroup.add(new FlxSprite((FlxG.width/2) - 50, FlxG.height - 32));
			PlayerGroup.add(new FlxSprite((FlxG.width/2) - 50, FlxG.height - 32));
			PlayerGroup.members[4].loadGraphic(ImgPlanetHealthEmpty, false, false, 100, 16);
			PlayerGroup.members[5].loadGraphic(ImgPlanetHealthFull, false, false, 100, 16);
			
			
			//add money counter
			MoneyGroup.add(new FlxText(8,8, 256, "Cash: "+Cash));
			
			//add Score counter
			MoneyGroup.members[1] = (new FlxText(FlxG.width/2 - 50, 8, FlxG.width/2, "Score: "+Score));
			MoneyGroup.members[1].alignment = "right";
			
			//kill off powerups early
			P_Cash.kill();
			P_Recovery.kill();
			P_Health.kill();
			//add them to their group
			PowerUpGroup.add(P_Cash);
			PowerUpGroup.add(P_Recovery);
			PowerUpGroup.add(P_Health);
			
			//buying group
			CreateBuyGroup();
			
			//item placing group
			ItemPlacingGroup = new FlxGroup();
			
			//Hide item placement screen
			HidePlacingScreen();
			
			//This is the wave notifier
			MoneyGroup.add(new FlxText(8,800, 256, ""));
			
			//create a bunch of objects
			CreateObjects();
	
			//add groups
			add(BackgroundGroup);
			add(BrickGroup);
			add(CoinGroup);
			add(UFOGroup);
			add(SquiddyGroup);
			add(LeggyGroup);
			add(BulletGroup);
			add(ItemPlacingGroup);
			add(BouncyGroup);
			add(PlayerGroup);
			add(PlayerBulletGroup);
			add(BoomGroup);
			add(PlacingGroup);
			add(PowerUpGroup);
			add(BuyingGroup);
			add(MoneyNotifierGroup);
			add(MoneyGroup);
			add(GameOverGroup);
			
			//first wave starts immediately
			HideBuyScreen();
			BuyScreen 		= false;
			ItemPlacing 	= false;
			GenerateWave();
			
			//Add some stars
			AddStars(10);
			
			//Play dat musics
			FlxG.playMusic(BackgroundMusic);
		}
		
		private function CreateBuyGroup():void{			
			//tinted background
			var TintedBG:FlxSprite = new FlxSprite(8, 8);
			TintedBG.createGraphic(FlxG.width - 16, FlxG.height - 16, 0x80000000);
			
			//building icon FlxSprites
			var City:FlxSprite 		= new FlxSprite(24, 48);
			var Factory:FlxSprite 	= new FlxSprite(88, 48);
			var Hospital:FlxSprite 	= new FlxSprite(152, 48);
			var SBrick:FlxSprite 	= new FlxSprite(216, 48);
			var LBrick:FlxSprite 	= new FlxSprite(272, 40);
			
			//"Buy" buttons
			var BButton1:FlxSprite = new FlxSprite(14, 38);
			var BButton2:FlxSprite = new FlxSprite(78, 38);
			var BButton3:FlxSprite = new FlxSprite(142, 38);
			var BButton4:FlxSprite = new FlxSprite(206, 38);
			var BButton5:FlxSprite = new FlxSprite(270, 38);
			
			//load graphics
			City.loadGraphic(ImgCity, false, false, 16, 16);
			Factory.loadGraphic(ImgFactory, false, false, 16, 16);
			Hospital.loadGraphic(ImgHospital, false, false, 16, 16);
			SBrick.loadGraphic(ImgSmallBricks, false, false, 16, 16);
			LBrick.loadGraphic(ImgLargeBricks, false, false, 32, 32);
			BButton1.loadGraphic(ImgBuyButton, false, false, 36, 51);
			BButton2.loadGraphic(ImgBuyButton, false, false, 36, 51);
			BButton3.loadGraphic(ImgBuyButton, false, false, 36, 51);
			BButton4.loadGraphic(ImgBuyButton, false, false, 36, 51);
			BButton5.loadGraphic(ImgBuyButton, false, false, 36, 51);
			BButton1.frame = 1;
			BButton2.frame = 1;
			BButton3.frame = 1;
			BButton4.frame = 1;
			//add shit to the group
			BuyingGroup.add(TintedBG);
			BuyingGroup.add(BButton1);
			BuyingGroup.add(BButton2);
			BuyingGroup.add(BButton3);
			BuyingGroup.add(BButton4);
			BuyingGroup.add(BButton5);
			BuyingGroup.add(City);
			BuyingGroup.add(Factory);
			BuyingGroup.add(Hospital);
			BuyingGroup.add(SBrick);
			BuyingGroup.add(LBrick);
			
			//add text
			
			//BuyingGroup members 1 - 10: item display and buy buttons
			//BuyingGroup members 11 - 15: Amount of each item bought
			//BuyingGroup members 16 - 20: price of items
			//BuyingGroup member 21: "Start Wave"
			//BuyingGroup members 22 - end: Status indicators
			
			BuyingGroup.add(new FlxText(14,  24, 34, CityAmount+"/10"));
			BuyingGroup.add(new FlxText(78,  24, 34, FactoryAmount+"/10"));
			BuyingGroup.add(new FlxText(142, 24, 34, HospitalAmount+"/10"));
			BuyingGroup.add(new FlxText(206, 24, 34, SBrickAmount+"/10"));
			BuyingGroup.add(new FlxText(270, 24, 34, LBrickAmount+"/10"));
			BuyingGroup.members[11].alignment = "center";
			BuyingGroup.members[12].alignment = "center";
			BuyingGroup.members[13].alignment = "center";
			BuyingGroup.members[14].alignment = "center";
			BuyingGroup.members[15].alignment = "center";
			
			BuyingGroup.add(new FlxText(14,  91, 34, "$"+CityCost));
			BuyingGroup.add(new FlxText(78,  91, 34, "$"+FactoryCost));
			BuyingGroup.add(new FlxText(142, 91, 34, "$"+HospitalCost));
			BuyingGroup.add(new FlxText(206, 91, 34, "$"+SBrickCost));
			BuyingGroup.add(new FlxText(270, 91, 34, "$"+LBrickCost));
			BuyingGroup.members[16].alignment = "center";
			BuyingGroup.members[17].alignment = "center";
			BuyingGroup.members[18].alignment = "center";
			BuyingGroup.members[19].alignment = "center";
			BuyingGroup.members[20].alignment = "center";
			
			BuyingGroup.add(new FlxText(0, 110, 320, "Start Wave"));
			BuyingGroup.members[21].size = 32;
			BuyingGroup.members[21].color = 0xFFFF00;
			BuyingGroup.members[21].alignment = "center";
			
			BuyingGroup.add(new FlxText(16, 140, 500, "Next Wave: "+(Waves+1)));
			BuyingGroup.add(new FlxText(16, 150, 500, "Recovery Multiplier: "+PlayerGroup.members[0].GetTimeMultiplier()));
			BuyingGroup.add(new FlxText(16, 160, 500, "Cash Multiplier: "+Multiplier));
			BuyingGroup.add(new FlxText(16, 170, 500, "Healing Per Turn: "+int(Healing * 5)+"%"));
			BuyingGroup.add(new FlxText(16, 180, 500, "Health Remaining: "+(int(Health * 100))+"%"));
			BuyingGroup.add(new FlxText(16, 190, 500, "Enemies Killed: "+EnemiesKilled));
		}
		
		private function CreateObjects():void{
			var i:uint;
			
			//bouncy bullets
			for (i = 0; i < MaxBouncyBullets; i++){
				var a:BouncyBullet = new BouncyBullet(PlayerGroup.members[0]);
				a.kill();
				BouncyGroup.add(a);
			}
			//HurtyBullets
			for (i = 0; i < MaxHurtyBullets; i++){
				var b:HurtyBullet = new HurtyBullet();
				b.kill();
				BulletGroup.add(b);
			}
			//UFOs
			for (i = 0; i < MaxUFO; i++){
				var c:UFO = new UFO(0, 0);
				c.kill();
				UFOGroup.add(c);
			}
			//Squiddies
			for (i = 0; i < MaxSquiddy; i++){
				var d:Squiddy = new Squiddy(0, 0);
				d.kill();
				SquiddyGroup.add(d);
			}
			//Leggies
			for (i = 0; i < MaxLeggy; i++){
				var e:Leggy = new Leggy(0, 0);
				e.kill();
				LeggyGroup.add(e);
			}
			//Small Bricks
			for (i = 0; i < MaxSBrick; i++){
				var f:SmallBrick = new SmallBrick(0, 0);
				f.kill();
				BrickGroup.add(f);
			}
			//Large Bricks
			for (i = 0; i < MaxLBrick; i++){
				var g:SmallBrick = new SmallBrick(0, 0);
				g.kill();
				BrickGroup.add(g);
			}
			//Coins
			for(i = 0;i < MaxCoin; i++){
				var h:Coin = new Coin(0, 0);
				h.kill();
				CoinGroup.add(h);
			}
			//money notifier
			for(i = 0;i < MaxMN; i++){
				var j:Coin = new Coin(0, 0);
				j.kill();
				MoneyNotifierGroup.add(j);
			}
			//Cities
			for(i = 0; i < MaxCities; i++){
				var k:FlxSprite = new FlxSprite(0, 0);
				k.loadGraphic(ImgCity, false, false, 16, 16);
				k.kill();
				CityGroup.add(k);
			}
			//Factories
			for(i = 0; i < MaxFactories; i++){
				k = new FlxSprite(0, 0);
				k.loadGraphic(ImgFactory, false, false, 16, 16);
				k.kill();
				FactoryGroup.add(k);
			}
			//Hospitals
			for(i = 0; i < MaxHospitals; i++){
				k = new FlxSprite(0, 0);
				k.loadGraphic(ImgHospital, false, false, 16, 16);
				k.kill();
				HospitalGroup.add(k);
			}
			//small bricks
			for(i = 0; i < MaxSmallBricks; i++){
				var l:SmallBrick = new SmallBrick(0, 0);
				l.kill();
				SmallBrickGroup.add(l);
			}
			//large bricks
			for(i = 0; i < MaxLargeBricks; i++){
				var m:LargeBrick = new LargeBrick(0, 0);
				m.kill();
				LargeBrickGroup.add(m);
			}			
		}
			
		private function HidePlacingScreen():void{
			for(var i:uint = 0; i < PlacingGroup.members.length; i++){
				PlacingGroup.members[i].x += 1000;
			}
		}
			
		private function ShowPlacingScreen():void{
			for(var i:uint = 0; i < PlacingGroup.members.length; i++){
				PlacingGroup.members[i].x -= 1000;
			}
		}

		private function ShowBuyScreen():void{
			//prevent player from shooting
			PlayerGroup.members[0].CanShoot = false;
			
			//move shit
			for(var i:uint= 0;i< BuyingGroup.members.length;i++){
				BuyingGroup.members[i].y -= 1000;
			}

			//BuyingGroup members 1 - 10: item display and buy buttons
			//BuyingGroup members 11 - 15: Amount of each item bought
			//BuyingGroup members 16 - 20: price of items
			//BuyingGroup member 21: "Start Wave"
			//BuyingGroup members 22 - end: Status indicators
			
			//update amounts
			BuyingGroup.members[11] = new FlxText(14,  24, 34, CityAmount+"/10");
			BuyingGroup.members[12] = new FlxText(78,  24, 34, FactoryAmount+"/10");
			BuyingGroup.members[13] = new FlxText(142, 24, 34, HospitalAmount+"/10");
			BuyingGroup.members[14] = new FlxText(206, 24, 34, SBrickAmount+"/10");
			BuyingGroup.members[15] = new FlxText(270, 24, 34, LBrickAmount+"/10");
			BuyingGroup.members[11].alignment = "center";
			BuyingGroup.members[12].alignment = "center";
			BuyingGroup.members[13].alignment = "center";
			BuyingGroup.members[14].alignment = "center";
			BuyingGroup.members[15].alignment = "center";
			
			//update prices
			BuyingGroup.members[16] = new FlxText(14,  91, 34, "$"+CityCost);
			BuyingGroup.members[17] = new FlxText(78,  91, 34, "$"+FactoryCost);
			BuyingGroup.members[18] = new FlxText(142, 91, 34, "$"+HospitalCost);
			BuyingGroup.members[19] = new FlxText(206, 91, 34, "$"+SBrickCost);
			BuyingGroup.members[20] = new FlxText(270, 91, 34, "$"+LBrickCost);
			BuyingGroup.members[16].alignment = "center";
			BuyingGroup.members[17].alignment = "center";
			BuyingGroup.members[18].alignment = "center";
			BuyingGroup.members[19].alignment = "center";
			BuyingGroup.members[20].alignment = "center";
			
			//update stats			
			BuyingGroup.members[22] = new FlxText(16, 150, 500, "Next Wave: "+(Waves));
			BuyingGroup.members[23] = new FlxText(16, 160, 500, "Recovery Multiplier: "+PlayerGroup.members[0].GetTimeMultiplier());
			BuyingGroup.members[24] = new FlxText(16, 170, 500, "Cash Multiplier: "+Multiplier);
			BuyingGroup.members[25] = new FlxText(16, 180, 500, "Healing Per Turn: "+(int(Healing * 5))+"%");
			BuyingGroup.members[26] = new FlxText(16, 190, 500, "Health Remaining: "+(int(Health * 100))+"%");
			BuyingGroup.members[27] = new FlxText(16, 200, 500, "Enemies Killed: "+EnemiesKilled);
			
		}
		
		private function HideBuyScreen():void{
			for(var i:uint= 0;i< BuyingGroup.members.length;i++){
				BuyingGroup.members[i].y += 1000;
			}
		}
		
		private function ClickOnSprite(Button:FlxSprite):Boolean{
			//this is used to check to see if something is clicked that you can buy
			if((FlxG.mouse.justPressed()) && (FlxG.mouse.x >= Button.left) && (FlxG.mouse.x <= Button.right) 
			&& (FlxG.mouse.y >= Button.top) && (FlxG.mouse.y <= Button.bottom)){
				return true;
			}else{
				return false;
			}
		}
		
		private function DoTheItemPlacement():void{
			//move icon around
			if(ItemToPlace < 4){
				ItemPlacingGroup.members[ItemPlacingGroup.members.length - 1].x = FlxG.mouse.x;
				ItemPlacingGroup.members[ItemPlacingGroup.members.length - 1].y = FlxG.mouse.y;
			}else{
				BrickGroup.members[BrickGroup.members.length - 1].x = FlxG.mouse.x;
				BrickGroup.members[BrickGroup.members.length - 1].y = FlxG.mouse.y;
			}

			//if you click: place the item there
			if(FlxG.mouse.justPressed()){
				//create a variable to see if you can afford to place another one
				var thisamount:uint;
				var CashNeeded:uint;
				switch(ItemToPlace){
					case 1:
						CityCost += 100;
						CashNeeded = CityCost;
						thisamount = CityAmount;
						break;
					case 2:
						FactoryCost += 100;
						CashNeeded = FactoryCost;
						thisamount = FactoryAmount;
						break;
					case 3:
						HospitalCost += 100;
						CashNeeded = HospitalCost;
						thisamount = HospitalAmount;
						break;
					case 4:
						SBrickCost += 100;
						CashNeeded = SBrickCost;
						thisamount = SBrickAmount;
						break;
					case 5:
						LBrickCost += 100;
						CashNeeded = LBrickCost;
						thisamount = LBrickAmount;
						break;
				}
				var CanAfford:Boolean = (Cash >= CashNeeded) ? true : false;
				//if you have shift held, then keep placing items
				if(!FlxG.keys.SHIFT || !CanAfford || thisamount >= 10){
					ItemPlacing = false;
					//hide text
					HidePlacingScreen();
					//go back to the shop screen
					ShowBuyScreen();
					BuyScreen = true;
				}else{
					Cash -= CashNeeded;
					PlaceItem(ItemToPlace);
					//hackish
					HidePlacingScreen();
					//update cash
					MoneyGroup.members[0] = new FlxText(8,8, 256, "Cash: "+Cash);
				}
				//place item on the map
			}
		}
		
		private function PlaceItem(Item:uint):void{
			//show item placement text
			ShowPlacingScreen();

			ItemPlacing = true;
			ItemToPlace = Item;
			var NewItem:FlxSprite = new FlxSprite(0,0);

			switch(Item){
				case 1:
					NewItem.loadGraphic(ImgCity, false, false, 16, 16);
					//increase Player Time Multiplier
					PlayerGroup.members[0].IncreaseTimeMultiplier();
					//increase cities bought stat
					CityAmount++;
					CitiesBuilt++;
					BuildingsBuilt++;
					break;
				case 2:
					NewItem.loadGraphic(ImgFactory, false, false, 16, 16);
					//increase multiplier
					Multiplier += .5;
					//stats yo
					FactoryAmount++;
					FactoriesBuilt++;
					BuildingsBuilt++;
					break;
				case 3:
					NewItem.loadGraphic(ImgHospital, false, false, 16, 16);
					Healing  = Healing + 1;
					//fuck yeah stats
					HospitalAmount++;
					HospitalsBuilt++;
					BuildingsBuilt++;
					break;
				case 4:
					NewItem.loadGraphic(ImgSmallBricks, false, false, 16, 16);
					SBrickAmount++;
					SmallBricksBuilt++;
					TotalBricksBuilt++;
					break;
				case 5:
					NewItem.loadGraphic(ImgLargeBricks, false, false, 32, 32);
					LBrickAmount++;
					LargeBricksBuilt++;
					TotalBricksBuilt++;
					break;
			}

			if(Item < 4){
				ItemPlacingGroup.add(NewItem);
			}else if (Item == 4){
				BrickGroup.add(new SmallBrick());
			}else if (Item == 5){
				BrickGroup.add(new LargeBrick());
			}
		}
		
		private function CheckBuyScreen():void{
			//BuyingGroup members 1 - 10: item display and buy buttons
			//BuyingGroup members 11 - 15: Amount of each item bought
			//BuyingGroup members 16 - 20: price of items
			//BuyingGroup member 21: "Start Wave"
			//BuyingGroup members 22 - end: Status indicators
		
			//check for mouse clicks on items
			if((ClickOnSprite(BuyingGroup.members[1]) || ClickOnSprite(BuyingGroup.members[6])) && Cash >= CityCost && CityAmount < 10){
				//City
				BuyScreen = false;
				HideBuyScreen();
				PlaceItem(1);
				Cash -= CityCost;
			}else if((ClickOnSprite(BuyingGroup.members[2]) || ClickOnSprite(BuyingGroup.members[7])) && Cash >= FactoryCost && FactoryAmount < 10){
				//Factory
				BuyScreen = false;
				HideBuyScreen();
				PlaceItem(2);
				Cash -= FactoryCost;
			}else if((ClickOnSprite(BuyingGroup.members[3]) || ClickOnSprite(BuyingGroup.members[8])) && Cash >= HospitalCost && HospitalAmount < 10){
				//Hospital
				BuyScreen = false;
				HideBuyScreen();
				PlaceItem(3);
				Cash -= HospitalCost;
			}else if((ClickOnSprite(BuyingGroup.members[4]) || ClickOnSprite(BuyingGroup.members[9])) && Cash >= SBrickCost && SBrickAmount < 10){
				//Bricks
				BuyScreen = false;
				HideBuyScreen();
				PlaceItem(4);
				Cash -= SBrickCost;
			}else if((ClickOnSprite(BuyingGroup.members[5]) || ClickOnSprite(BuyingGroup.members[10])) && Cash >= LBrickCost && LBrickAmount < 10){
				//Large Bricks
				BuyScreen = false;
				HideBuyScreen();
				PlaceItem(5);
				Cash -= LBrickCost;
			}else if(ClickOnSprite(BuyingGroup.members[21])){
				//don't buy anYthing, start the wave
				HideBuyScreen();
				BuyScreen = false;
				ItemPlacing = false;
				GenerateWave();
			}
			MoneyGroup.members[0] = new FlxText(8,8, 256, "Cash: "+Cash);
			MoneyGroup.members[1] = (new FlxText(FlxG.width/2 - 50, 8, FlxG.width/2, "Score: "+Score));
			MoneyGroup.members[1].alignment = "right";
		}
		
		private function CheckLose():void{
			if(Health <= 0){
				if(FlxG.kong){
					FlxG.kong.API.stats.submitArray ( [	{
						name:"Total Cash Earned", value:TotalCash,
						name:"Score", value:Score,
						name:"Enemies Killed", value:EnemiesKilled,
						name:"Waves", value:Waves,
						name:"CitiesBuilt", value:CitiesBuilt,
						name:"FactoriesBuilt", value:FactoriesBuilt,
						name:"HospitalsBuilt", value:HospitalsBuilt,
						name:"BuildingsBuilt", value:BuildingsBuilt,
						name:"SmallBricksBuilt", value:SmallBricksBuilt,
						name:"LargeBricksBuilt", value:LargeBricksBuilt,
						name:"TotalBricksBuilt", value:TotalBricksBuilt}] );
				}
				//load game over state
				StartGameOver();
			}
		}
		
		private function CheckBricks():void{

			//go if a bullet hits a brick, do shit about it
			for(var i:uint = 0;i < BulletGroup.members.length; i++){
				for(var j:uint = 0;j < BrickGroup.members.length; j++){

					//check collision
					if((BulletGroup.members[i].bottom > BrickGroup.members[j].top) && (BulletGroup.members[i].bottom < BrickGroup.members[j].bottom) && (BulletGroup.members[i].left < BrickGroup.members[j].right) && (BulletGroup.members[i].right > BrickGroup.members[j].left)){
						//damage bricks
						BrickGroup.members[j].HitMe();
						if(BrickGroup.members[j].life <=  0){
							BrickGroup.members[j].x = 500;
							BrickGroup.members[j].kill();
							if(BrickGroup.members[j].GetName() == "Small") {
								SBrickAmount--;
							}else{
								LBrickAmount--;
							}
						}
						//destroy bullet
						BulletGroup.members[i].x = 600;
						BulletGroup.members[i].kill();
					}
				}
			}
		}
		
		private function IncreaseThing(Current:uint, Group:FlxGroup):uint {
			if(Current < Group.members.length - 1){
				return ++Current;
			}else{
				return 0;
			}		
		}
		
		//creating new items
		private function NewCity(X:Number, Y:Number):void {
			CityGroup.members[CurrentCity].restart(X, Y);
			CurrentCity = IncreaseThing(CurrentCity, CityGroup);
		}
		
		private function NewFactory(X:Number, Y:Number):void {
			FactoryGroup.members[CurrentFactory].restart(X, Y);
			CurrentFactory = IncreaseThing(CurrentFactory, FactoryGroup);
		}
		
		private function NewHospital(X:Number, Y:Number):void {
			HospitalGroup.members[CurrentHospital].restart(X, Y);
			CurrentHospital = IncreaseThing(CurrentHospital, HospitalGroup);
		}
		
		//creating new bricks
		
		private function NewSmallBrick(X:Number, Y:Number):void {
			SmallBrickGroup.members[CurrentSmallBrick].restart(X, Y);
			CurrentSmallBrick = IncreaseThing(CurrentSmallBrick, SmallBrickGroup);
		}
		
		private function NewLargeBrick(X:Number, Y:Number):void {
			LargeBrickGroup.members[CurrentLargeBrick].restart(X, Y);
			CurrentLargeBrick = IncreaseThing(CurrentLargeBrick, LargeBrickGroup);
		}
		
		//creating new bullets
		
		private function NewBouncy(X:Number, Y:Number):void{
			BouncyGroup.members[CurrentBouncyBullet].restart(X, Y);
			CurrentBouncyBullet = IncreaseThing(CurrentBouncyBullet, BouncyGroup);			
		}
		
		private function NewHurty(X:Number, Y:Number, S:Number):void{
			BulletGroup.members[CurrentHurtyBullet].restart(X, Y, S);
			CurrentHurtyBullet = IncreaseThing(CurrentHurtyBullet, BulletGroup);	
		}
		
		//etc
		
		private function DoTheShootCheckSortaThing(Group:FlxGroup):void {		
			for(var i:uint = 0;i<Group.members.length;i++){
				if(Group.members[i].CheckShooting()){
					//shoot !!
					//decide which type of bullet to shoot
					var bX:Number	= Group.members[i].x + Group.members[i].width/2;
					var bY:Number	= Group.members[i].y + Group.members[i].height/2;
					var bS:Number	= Group.members[i].GetSpeed()*2;
					if(!HardMode){
						if((FlxU.random()) > (.1 + (Waves * .025))){
							NewBouncy(bX, bY);
						}else{
							NewHurty(bX, bY, bS);
						}
					}else{
						NewHurty(bX, bY, bS);
					}
					//make it stop shooting
					Group.members[i].StopShooting();
				}
			}			
		}
		
		private function HealThePlanet():void{
			Health += Healing * .05;
			if(Health >= 1){
				Health = 1;
			}
			PlayerGroup.members[5].loadGraphic(ImgPlanetHealthFull, false, false, (Health * 100), 16);
			//show visual notification of healing
			
			//recycle code
			if(CurrentMN < MoneyNotifierGroup.members.length - 1){
				CurrentMN++;
			}else{
				CurrentMN = 0;
			}
			//add new notifier
			var AString:String = new String("+"+(uint)((Healing * 0.05)*100)+"%");
			MoneyNotifierGroup.members[CurrentMN] = new FlxText((PlayerGroup.members[5].right), (PlayerGroup.members[5].y), 320, AString);
			MoneyNotifierGroup.members[CurrentMN].alignment = "left";
			MoneyNotifierGroup.members[CurrentMN].shadow = "left";
			MoneyNotifierGroup.members[CurrentMN].color = 0xFFFF0000;
		}
		
		private function CheckEnemyDepth(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length;i++){
				//check that shit
				if((Group.members[i].top > PlayerGroup.members[0].bottom) && Group.members[i].exists){
					//explosions!
					Explodey((Group.members[i].x), (Group.members[i].y));
					//kill enemy, but damage planet too
					killed++;
					Group.members[i].kill();
					Health -= .1;
					CheckLose();
					DamagePlanet = true;
					//update visual health bar
					var HW:uint = (uint)(Health * 100);
					if(HW <= 1){ HW = 1; }
					PlayerGroup.members[5].loadGraphic(ImgPlanetHealthFull, false, false, HW, 16);
				}
			}		
		}
		
		private function DrawPowerBar():void{
			//if the counter isn't full
			if(PlayerGroup.members[0].GetBulletCounter() < 10){
				//draw whatever width it is
				var NewWidth:uint = (uint)((PlayerGroup.members[0].GetBulletCounter() * 0.1) * 16);
				if(NewWidth == 0){ NewWidth = 1; }
				PlayerGroup.members[3].loadGraphic(ImgShotFull, false, false, NewWidth, 4);
					PlayerGroup.members[3].play("Stop");
			}else{
				//if not, and if its not drawn fully, draw it fully - make it shine
				if(PlayerGroup.members[3].width != 16){
					PlayerGroup.members[3].loadGraphic(ImgShotFull, false, false, 16, 4);
					PlayerGroup.members[3].play("Flash");
				}
			}
		}
		
		private function EnemyCanMove(Group:FlxGroup):void {
			for(var i:uint = 0; i < Group.members.length;i++){
				//set movement
				if(Group.members[i].exists){
					Group.members[i].CanMove = true;
				}
			}		
		}
		
		private function FadeOutMN():void{
			for(var i:uint = 0;i < MoneyNotifierGroup.members.length; i++){
				if(MoneyNotifierGroup.members[i].exists){
					//only do this if it exists!
					MoneyNotifierGroup.members[i].alpha -= .01;
					MoneyNotifierGroup.members[i].y -= .1;
					if(MoneyNotifierGroup.members[i].alpha <= 0){
						MoneyNotifierGroup.members[i].kill();
					}
				}
			}
		}
		
		private function CheckPlanetDamage():void{
			for(var i:uint = 0;i < BulletGroup.members.length;i++){
				if(BulletGroup.members[i].exists && BulletGroup.members[i].y >= FlxG.height){
					//damage!
					Health -= .01;
					CheckLose();
					DamagePlanet = true;
					//kill bullet
					BulletGroup.members[i].kill();
					//update graphic
					var HW:uint = (uint)(Health * 100);
					if(HW <= 1){ HW = 1; }
					PlayerGroup.members[5].loadGraphic(ImgPlanetHealthFull, false, false, HW, 16);
				}
			}
		}
		
		private function LightStars():void{
			if(UnlitStars > 0){
				StarsGroup.members[LastLitStar].alpha += 0.02;
				if(StarsGroup.members[LastLitStar].alpha == 1){
					UnlitStars--;
					LastLitStar++;
				}
			}
		}
		
		private function DoEndGame():void{
			//Game Over Stuff
			//Game is over, fade shit out
			if(StarsFalling){
				//The stars are still falling. Drop them!
				if(StarsGroup.members[CurrentStar].acceleration.y	< 2){
					StarsGroup.members[CurrentStar].acceleration.y	= StarSpeed;
				}
				CurrentStar++;
				StarSpeed = FlxU.random()*500+10;
				if(CurrentStar >= StarsGroup.members.length){
					//All done with the stars. Ontop the planet!
					CurrentStar 	= 0;
					StarsFalling	= false;
					PlanetFading	= true;
				}
			}else if(PlanetFading){
				//Fade out the planet
				BackgroundGroup.members[3].alpha -= .01;
				if(BackgroundGroup.members[3].alpha <= .25){
					//all done
					PlanetFading = false;
				}
			}else{
				//Game is over!
				FlxG.log("All Done!");
			
			}
		}

		private function StartGameOver():void{
			EndGame			= true;
			StarsFalling	= true;
			//Kill All Enemies
			for(var i:uint = 0; i < SquiddyGroup.members.length; i++){
				SquiddyGroup.members[i].kill();
				Explodey((SquiddyGroup.members[i].x), (SquiddyGroup.members[i].y));
			}
			for(i = 0; i < LeggyGroup.members.length; i++){
				LeggyGroup.members[i].kill();
				Explodey((LeggyGroup.members[i].x), (LeggyGroup.members[i].y));
			}
			for(i = 0; i < UFOGroup.members.length; i++){
				UFOGroup.members[i].kill();
				Explodey((UFOGroup.members[i].x), (UFOGroup.members[i].y));
			}
			//Kill Player
			PlayerGroup.members[0].Kill();
			
			//Create and show game over overlays
			//Semi-Transparant Black Box
			var GOBG:FlxSprite	= new FlxSprite(16, 16)
			GOBG.createGraphic(FlxG.width-32, FlxG.height-32, 0x80000000);
			
			//Add to group
			GameOverGroup = new FlxGroup();
			GameOverGroup.add(GOBG);
			GameOverGroup.add(new PixelFont(ImgBigFont, 0, 32, "Game Over", "Center", 16, 16));
			GameOverGroup.add(new PixelFont(ImgBigFont, 0, FlxG.height-56, "Back to Title", "Center", 16, 16));
			GameOverGroup.add(new PixelFont(ImgBigFont, 0, FlxG.height-40, "More Games", "Center", 16, 16));
			
			//Show Stats
			
			/*
					private var Score:uint						= 0;
					private var EnemiesKilled:uint				= 0;
					private var Waves:uint						= 1;
					private var TotalCash:uint					= 0;
					private var CitiesBuilt:uint				= 0;
					private var FactoriesBuilt:uint				= 0;
					private var HospitalsBuilt:uint				= 0;
					private var BuildingsBuilt:uint				= 0;
					private var SmallBricksBuilt:uint			= 0;
					private var LargeBricksBuilt:uint			= 0;
					private var TotalBricksBuilt:uint			= 0;
		*/
			GameOverGroup.add(new FlxText(0,  56, 320, "Waves Cleared: "+Waves));
			GameOverGroup.add(new FlxText(0,  72, 320, "Score: "+Score));
			
			GameOverGroup.add(new FlxText(0, 120, 320, "Total Cash: "+TotalCash));
			GameOverGroup.add(new FlxText(0, 128, 320, "Enemies Killed: "+EnemiesKilled));
			GameOverGroup.add(new FlxText(0, 136, 320, "Bricks Built: "+TotalBricksBuilt));
			GameOverGroup.add(new FlxText(0, 144, 320, "Buildings Built: "+BuildingsBuilt));
			
			//format some strings
			GameOverGroup.members[4].setFormat(null, 16, 0xFFFFAA, "center");
			GameOverGroup.members[5].setFormat(null, 16, 0xFFFFAA, "center");
			GameOverGroup.members[6].setFormat(null, 8, 0xFFFFAA, "center");
			GameOverGroup.members[7].setFormat(null, 8, 0xFFFFAA, "center");
			GameOverGroup.members[8].setFormat(null, 8, 0xFFFFAA, "center");
			GameOverGroup.members[9].setFormat(null, 8, 0xFFFFAA, "center");
			
			//show
			add(GameOverGroup);
			
			//change mouse icon
			FlxG.mouse.cursor = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y, ImgMouse);
			FlxG.mouse.show();
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
		
		override public function update():void{
			if(EndGame){
				DoEndGame();
				PlayerGroup.members[2].alpha	= 0;
				PlayerGroup.members[3].alpha 	= 0;
				//do highlights
				Dim(GameOverGroup.members[2]);
				Dim(GameOverGroup.members[3]);
				if(MouseOverGroup(GameOverGroup.members[2])){
					Highlight(GameOverGroup.members[2]);
					if(FlxG.mouse.justPressed()){
						//Go back to the title screen
						FlxG.state = new Title();
						
					}
				}else if(MouseOverGroup(GameOverGroup.members[3])){
					Highlight(GameOverGroup.members[3]);
					if(FlxG.mouse.justPressed()){
						//load up sponsor
						var request:URLRequest = new URLRequest("http://www.splixel.com");
						navigateToURL (request);
						
					}
				}
			}else{
				LightStars();
				CheckPlanetDamage();
				if(DamagePlanet){
					if(DamagingPlanet <= 1){
						//set color dependent on time and yeah
						var HexCol:uint = 0xFF0000+(DamagingPlanet * 0xFFFF);
						BackgroundGroup.members[2].color = HexCol;
						DamagingPlanet += .2;
					}else{
						BackgroundGroup.members[2].color = 0xFFFFFFFF;	
						DamagePlanet = false;
						DamagingPlanet = 0;
					}
				}
			
			
				//fade out money notifiers
				DrawPowerBar();
				if(BuyScreen){
					if(Waves == 1){
						//skip the first buy screen
					}
					//show the buy screen
					//you can only buy one item per turn
					//check for mouse clicks
					CheckBuyScreen();
				}else if(ItemPlacing){
					//handle placing items
					DoTheItemPlacement();
				}else if(FadingOutWaveNotifier){
					if(MoneyGroup.members[3].alpha > 0){
						MoneyGroup.members[3].alpha -= (FlxG.elapsed * .5);
					}else{
						FadingOutWaveNotifier = false;
						//make it so enemies can move
						EnemyCanMove(UFOGroup);
						EnemyCanMove(SquiddyGroup);
						EnemyCanMove(LeggyGroup);
						//allow player to shoot
						PlayerGroup.members[0].CanShoot = true;
					}
				}else{
					CheckBricks();
					if(!Lost){
						CheckWin();
					
						//handle shooting
					
						//Check UFOs, Squiddys, Leggys separate, because I suck at coding and need to remove memory leaks
						DoTheShootCheckSortaThing(UFOGroup);
						DoTheShootCheckSortaThing(SquiddyGroup);
						DoTheShootCheckSortaThing(LeggyGroup);
					
						//if an enemy makes it pats you, planet takes a hit
						CheckEnemyDepth(UFOGroup);
						CheckEnemyDepth(SquiddyGroup);
						CheckEnemyDepth(LeggyGroup);
					
						//check kills
						KillCheck();
					
						//check to see if a UFO is the last one
						if((killgoal - killed) == 1){
							//getFirstAlive is being gay, so find it yourself
							for(var asdf:uint = 0; asdf < UFOGroup.members.length;asdf++){
								if(UFOGroup.members[asdf].dead == false){
									UFOGroup.members[asdf].SetLastOne();
									asdf = UFOGroup.members.length;
								}
							}
						}
					}
				}
					
				//check for coins
				DropGetCheck();
				//move shot counter
				PlayerGroup.members[2].x = PlayerGroup.members[0].x + 7;
				PlayerGroup.members[3].x = PlayerGroup.members[0].x + 7;
			}
			//update screen
			FadeOutMN();
			super.update();

		}
		
		private function AddPoints(Enemy:String):void {
			switch(Enemy){
				case "UFO":
					//UFOs are worth 1000 points
					Score += 1000;
					break;
				case "Squiddy":
					//squiddy's are worth 1250 points
					Score += 1250;
					break;
				case "Leggy":
					//Leggy's are worth 1500 points
					Score += 1500;
					break;
				case "End of Wave":
					//end of round point bonus
					Score += 1000 * Waves;
					break;
			}
			MoneyGroup.members[1] = (new FlxText(FlxG.width/2 - 50, 8, FlxG.width/2, "Score: "+Score));
			MoneyGroup.members[1].alignment = "right";
		}
		
		private function DoBouncyBulletHit(Object1:Object, Object2:Object):void{
			//only work if the bullet is going up
			if(Object1.GetYDirection() < 0){
				//play sound effect
				FlxG.play(DieSFX, .5);
				//kill the objects
				Object1.kill();
				Object2.kill();
				//tech shit
				killed++;
				EnemiesKilled++;
				//cool stuff
				SpawnDrop((Object2.x + (Object2.width / 2) - 8), (Object2.y + (Object2.height/2) - 8));
				AddPoints(Object2.GetString());			
				//play explosion
				Explodey((Object2.x), (Object2.y));
				//Add stars every 10 kills
				if(EnemiesKilled % 10 == 0){
					AddStars(1);
				}
			}
		}
		
		private function DoPlayerBulletHit(Object1:Object, Object2:Object):void{
			//play sound effect
			FlxG.play(DieSFX, .5);
			//kill the objects
			Object1.kill();
			Object2.kill();
			//tech shit
			killed++;
			EnemiesKilled++;
			//cool stuff
			SpawnDrop((Object2.x + (Object2.width / 2)), (Object2.y + (Object2.height/2)));
			AddPoints(Object2.GetString());	
			//play explosion
			Explodey((Object2.x), (Object2.y));
		}
		
		private function CheckBouncyBulletThing(Group:FlxGroup):void {
			var CB:Function = DoBouncyBulletHit;
			FlxU.overlap(BouncyGroup, Group, CB);
		}
		
		private function CheckPlayerBullet(Group:FlxGroup):void{
			var CB:Function = DoPlayerBulletHit;
			FlxU.overlap(PlayerBulletGroup, Group, CB);
		}
		
		private function SpawnDrop(nx:uint, ny:uint):void {
			//first, see what should drop: randomly of course!
			var Rand:Number = FlxU.random()*1000;
			if(Rand >= 990){
				//1% chance of a health power up
				P_Health.restart(nx, ny);
			}else if(Rand >= 980){
				//2% chance of a recovery power up
				P_Recovery.restart(nx, ny);
			}else if(Rand >= 970){
				//3% chance of a better money drop
				P_Cash.restart(nx, ny);
			}else{
				//drop dat coin yo!
				CoinGroup.members[CurrentCoin].restart(nx, ny);
				CurrentCoin = IncreaseThing(CurrentCoin, CoinGroup);
			}
		}
		
		private function Explodey(nx:Number, ny:Number):void{
			//make shit explode
			BoomGroup.add(new Boom(nx, ny));
		}
		
		private function GetCoin(Object1:Object, Object2:Object):void {
			Object2.kill();
			AddCash(100);
			//play sound effect
			FlxG.play(CoinGetSFX, .5);
		}
		
		private function GetPowerup(Object1:Object, Object2:Object):void {
			//figure out what type of powerup it is
			switch(Object2.GetType()){
				case "Health":
					HealThePlanet();
					break;
				case "Cash":
					AddCash(500);
					break;
				case "Recovery":
					PlayerGroup.members[0].StartAwesome();
					break;
			}
			Object2.kill();
			//play sound effect
			FlxG.play(PowerUpSFX, .5);
		}
		
		private function DropGetCheck():void {
			//TOUCH COIN
			//GET MONIES
			var CB:Function = GetCoin;
			var PB:Function = GetPowerup;
			FlxU.overlap(PlayerGroup.members[0], CoinGroup, CB);
			FlxU.overlap(PlayerGroup.members[0], PowerUpGroup, PB);
		}
		
		private function AddCash(Increasement:uint):void {
			//increase cash and total cash
			Cash += 		(Increasement * Multiplier);
			TotalCash += 	(Increasement * Multiplier);
			//update cash counter on the screen
			MoneyGroup.members[0] = new FlxText(8,8, 256, "Cash: "+Cash);
			//visual notification of how much cash was recieved
			MoneyNotifier(Increasement * Multiplier);
		}
		
		private function MoneyNotifier(Amount:uint):void{
			//recycle code
			if(CurrentMN < MoneyNotifierGroup.members.length - 1){
				CurrentMN++;
			}else{
				CurrentMN = 0;
			}
			//add new notifier
			var AString:String = new String("+$"+Amount);
			MoneyNotifierGroup.members[CurrentMN] = new FlxText((PlayerGroup.members[0].x + 8), (PlayerGroup.members[0].y - 8), 320, AString);
			MoneyNotifierGroup.members[CurrentMN].alignment = "left";
			MoneyNotifierGroup.members[CurrentMN].shadow = "left";
			MoneyNotifierGroup.members[CurrentMN].color = 0xFF00FF00;
		}
		
		private function DoPlayerHit(a:Object, b:Object):void{
			//this happens when the player gets hit
			//play a sound effect
			b.kill();
			FlxG.play(DieSFX, .5);
			PlayerGroup.members[0].Stunned();
		}
		
		private function KillCheck():void{
			//check to see if a hurtybullet hurts player
			var CB:Function = DoPlayerHit;
			FlxU.overlap(PlayerGroup.members[0], BulletGroup, CB);
			//check to see if a bouncybullet kills an enemy
			CheckBouncyBulletThing(UFOGroup);
			CheckBouncyBulletThing(SquiddyGroup);
			CheckBouncyBulletThing(LeggyGroup);
			//check to see if a playerbullet kills an enemy
			CheckPlayerBullet(UFOGroup);
			CheckPlayerBullet(SquiddyGroup);
			CheckPlayerBullet(LeggyGroup);
		}
		
		private function CheckWin():void{
			//make sure all elements are gone
			if(killgoal <= killed){
				//make sure all coins are gone
				if(CoinGroup.getFirstAlive() == null){
					//add Points
					AddPoints("End of Wave");
					//you beat the wave, start the next one	
					WaveNumber++;
					Waves++;
					if(Waves > 10){
						WaveNumber = (uint)((FlxU.random() * 10) + 1);
						//HardMode = true;
					}
					BuyScreen = true;
					ShowBuyScreen();
				}
			}
		}
		
		private function NewUFO(X:Number, Y:Number):void{
			UFOGroup.members[CurrentUFO].restart(X, Y);
			CurrentUFO = IncreaseThing(CurrentUFO, UFOGroup);	
		}
		
		private function NewSquiddy(X:Number, Y:Number):void{
			SquiddyGroup.members[CurrentSquiddy].restart(X, Y);
			CurrentSquiddy = IncreaseThing(CurrentSquiddy, SquiddyGroup);	
		}
		
		private function NewLeggy(X:Number, Y:Number):void{
			LeggyGroup.members[CurrentLeggy].restart(X, Y);
			CurrentLeggy = IncreaseThing(CurrentLeggy, LeggyGroup);	
		}
		
		private function AddStars(NewStars:uint = 3):void{
			//this function adds stars to the background
			
			//Only add stars if you have less than 255
			if(StarsGroup.members.length < 255){
			
				//1 - 10 random amount of stars in the background
				var StarsAmount:uint = (Math.random()*NewStars) + 1;
				UnlitStars += StarsAmount;
			
				for(var i:uint = 0; i < StarsAmount; i++){
					var RandX:uint				= Math.random()*(FlxG.width - 8);
					var RandY:uint				= Math.random()*(FlxG.height - 8);
					var RandS:uint				= Math.random()*5;
					var NewStar:FlxSprite = new FlxSprite(RandX, RandY);
					NewStar.loadGraphic(ImgSmallStars, false, false, 8, 8);
					NewStar.frame					= RandS;
					var NRed:uint 				= 0xC00000	+ ((int(Math.random()*0x40)) * 0x10000);
					var NGreen:uint 			= 0xC000 		+ (int(Math.random()*0x40)) * 0x100;
					var NBlue:uint 				= 0xC0 			+ (int(Math.random()*0x40));
					var NColor:uint				= NRed + NGreen + NBlue;
					NewStar.color					= NColor;
					NewStar.alpha					= 0;
					StarsGroup.add(NewStar);
				}
			}else{
			}
		}
		
		private function GenerateWave():void{
			AddStars();
			//show wave notifier
			FadingOutWaveNotifier = true;
			EnemyMovement = false;
			MoneyGroup.members[3] = new FlxText(0, 50, FlxG.width, "Wave "+Waves);
			MoneyGroup.members[3].alignment = "center";
			MoneyGroup.members[3].shadow = "center";
			MoneyGroup.members[3].size = 32;
			MoneyGroup.members[3].color = 0xFFFFFFDD;
			
			//heal the planet some
			HealThePlanet();
			
			//do wave shit
			killed = 0;
			switch(WaveNumber){
				case 1:
					//set up wave 1
					//just a bunch of UFOs
					for(var i:uint = 0; i < 9;i++){
						for(var j:uint = 0; j < 2; j++){
							var nX:uint = 16 + (i * 32);
							var nY:uint = 16 + (j * 32);
							NewUFO(nX, nY);
						}

					}
					killgoal = 18;
					break;
				case 2:
					//set up wave 2
					for(i = 0; i < 9;i++){
						for(j = 0; j < 3; j++){
							nX = 16 + (i * 32);
							nY = 16 + (j * 32);
							NewUFO(nX, nY);
						}
					}
					killgoal = 27;
					break;
				case 3:
					//set up wave 3
					for(i = 0; i < 7;i++){
						for(j = 0; j < 2; j++){
							nX = 48 + (i * 32);
							nY = 64 + (j * 32);
							NewUFO(nX, nY);
						}
					}
					for(i = 0;i < 4;i++){
						for(j = 0;j < 1;j++){
							nX = 64 + (i * 48);
							nY = 16;
							NewSquiddy(nX, nY);
						}
					}
					killgoal = 18;
					break;
				case 4:
					//set up wave 4					
					for(i = 0; i < 5;i++){
						for(j = 0; j < 3; j++){
							nX = 40 + (i * 48);
							nY = 16 + (j * 50);
							NewSquiddy(nX, nY)
						}
					}
					killgoal = 15;
					break;
				case 5:
					//set up wave 5			
					for(i = 0; i < 4;i++){
						for(j = 0; j < 3; j++){
							nX = 96 + (i * 32);
							nY = 16 + (j * 44);
							NewLeggy(nX, nY);
						}
					}
					killgoal = 12;
					break;
				case 6:
					//set up wave 6		
					for(i = 0; i < 9;i++){
						for(j = 0; j < 1; j++){
							nX = 16 + (i * 32);
							nY = 62 + (j * 32);
							NewUFO(nX, nY);
						}
					}				
					for(i = 0; i < 5;i++){
						for(j = 0; j < 1; j++){
							nX = 62 + (i * 39);
							nY = 16 + (j * 46);
							NewLeggy(nX, nY)
						}
					}
					killgoal = 14;
					break;
				case 7:
					//set up wave 7
					for(i = 0; i < 9;i++){
						for(j = 0; j < 2; j++){
							nX = 16 + (i * 32);
							nY = 62 + (j * 32);
							NewUFO(nX, nY);
						}
					}					
					for(i = 0; i < 7;i++){
						for(j = 0; j < 1; j++){
							nX = 23 + (i * 39);
							nY = 16 + (j * 46);
							NewLeggy(nX, nY)
						}
					}
					killgoal = 25;
					break;
				case 8:
					//set up wave 8		
					for(i = 0; i < 9;i++){
						for(j = 0; j < 3; j++){
							nX = 16 + (i * 32);
							nY = 16 + (j * 32);
							NewUFO(nX, nY);
						}
					}	
					killgoal = 27;
					break;
				case 9:
					//set up wave 9			
					for(i = 0; i < 6;i++){
						for(j = 0; j < 3; j++){
							nX = 0 + (i * 48);
							nY = 16 + (j * 50);
							NewSquiddy(nX, nY)
						}
					}
					killgoal = 18;
					break;
				case 10:
					//set up wave 10				
					for(i = 0; i < 8;i++){
						for(j = 0; j < 3; j++){
							nX = 4 + (i * 39);
							nY = 16 + (j * 46);
							NewLeggy(nX, nY)
						}
					}
					killgoal = 24;
					break;
			}
		}
	}
}
