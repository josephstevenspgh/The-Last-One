package{
	import org.flixel.*;
 
	public class GameOver extends FlxState{
		
		//I dont even know
		
		//images
		[Embed(source="Images/GameOver.png")] 			private var ImgBackground:Class;
		
		//initializing function
		public function GameOver(w:uint, s:uint){
			//flash
			//show bg
			var bg:FlxSprite = new FlxSprite();
			bg.loadGraphic(ImgBackground, false, false, 320, 240);
			add(bg);
			FlxG.log("Waves: "+w);
			FlxG.log("Score: "+s);
		}
		
		override public function update():void{
			if(FlxG.mouse.justPressed()){
				FlxG.state = new GameState();
			}
			super.update();
		}
	}
}
