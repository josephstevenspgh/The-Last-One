package{

	import org.flixel.*;
	
	public class PixelFont extends FlxGroup{
		//variables
		private var OrigX:uint;
		private var OrigY:uint;
		private var content:String;
		private var WaveSpeed:Number = 0;
	
		//constructor
		public function PixelFont(FontImg:Class, X:Number, Y:Number, Content:String, Alignment:String = "None", Width:Number = 8, Height:Number = 8){
			//initialize for use
			width = Width;
			height = Height;
			
			//calculate X/Y based off alignment
			switch(Alignment){
				default:
					//this is the default, "None", or "Left" are specifically meant for this
					OrigX = X;
					OrigY = Y;
					break;
				case "Right":
					//align text to the right edge of the screen, use X as padding
					OrigX = (FlxG.width - (Content.length*width)) - X;
					OrigY = Y;
					break;
				case "Center":
					//center text horizontally on the screen, don't even use X
					OrigX = (FlxG.width - ((FlxG.width + Content.length*width)/2));
					OrigY = Y;
					break;
			}
			
			//start the loop - generate members
			var i:int;
			for(i=0; i<Content.length;i++){
				//add a FlxSprite representing the current letter
				var CurrentLetter:FlxSprite = new FlxSprite();
				//set the coords, draw from left to right
				CurrentLetter.x = (OrigX+(width*i));
				CurrentLetter.y = (OrigY);
				//load the letter to display
				CurrentLetter.loadGraphic(FontImg, true);
				CurrentLetter.width = width;
				CurrentLetter.height = height;
				//show the current letter
				CurrentLetter.frame = GetCharAt(Content.charAt(i));
				//add it to the group
				add(CurrentLetter);
			}
			//	~fin~
		}
		
		//draw something using the Classic Font
		static public function DrawFont(FontImg:Class, X:Number, Y:Number, Content:String, Alignment:String = "None", Width:Number = 8, Height:Number = 8):FlxGroup{
			//these are some temporary things for when i create a better library out of this function
			var width:uint = Width;
			var height:uint = Height;

			var x:uint;
			var y:uint;
			
			//calculate X/Y based off alignment
			switch(Alignment){
				default:
					//this is the default, "None", or "Left" are specifically meant for this
					x = X;
					y = Y;
					break;
				case "Right":
					//align text to the right edge of the screen, use X as padding
					x = (FlxG.width - (Content.length*width)) - X;
					y = Y;
					break;
				case "Center":
					//center text horizontally on the screen, don't even use X
					x = (FlxG.width - ((FlxG.width + Content.length*width)/2));
					y = Y;
					break;
			}
			
			//create the group
			var ReturnGroup:FlxGroup = new FlxGroup();
			
			//start the loop
			var i:int;
			for(i=0; i<Content.length;i++){
				//add a FlxSprite representing the current letter
				var CurrentLetter:FlxSprite = new FlxSprite();
				//set the coords, draw from left to right
				CurrentLetter.x = (x+(width*i));
				CurrentLetter.y = (y);
				//load the letter to display
				CurrentLetter.loadGraphic(FontImg, true);
				CurrentLetter.width = width;
				CurrentLetter.height = height;
				//show the current letter
				CurrentLetter.frame = GetCharAt(Content.charAt(i));
				//add it to the group
				ReturnGroup.add(CurrentLetter);
			}
			//return the group
			return ReturnGroup;
		}
		
		//handle letter checking
		private static function GetCharAt(CurrentChar:String):uint{
			switch(CurrentChar){
				case 'a':
					return 0;
				case 'A':
					return 0;
				case 'b':
					return 1;
				case 'B':
					return 1;
				case 'c':
					return 2;
				case 'C':
					return 2;
				case 'd':
					return 3;
				case 'D':
					return 3;
				case 'e':
					return 4;
				case 'E':
					return 4;
				case 'f':
					return 5;
				case 'F':
					return 5;
				case 'g':
					return 6;
				case 'G':
					return 6;
				case 'h':
					return 7;
				case 'H':
					return 7;
				case 'i':
					return 8;
				case 'I':
					return 8;
				case 'j':
					return 9;
				case 'J':
					return 9;
				case 'k':
					return 10;
				case 'K':
					return 10;
				case 'l':
					return 11;
				case 'L':
					return 11;
				case 'm':
					return 12;
				case 'M':
					return 12;
				case 'n':
					return 13;
				case 'N':
					return 13;
				case 'o':
					return 14;
				case 'O':
					return 14;
				case 'p':
					return 15;
				case 'P':
					return 15;
				case 'q':
					return 16;
				case 'Q':
					return 16;
				case 'r':
					return 17;
				case 'R':
					return 17;
				case 's':
					return 18;
				case 'S':
					return 18;
				case 't':
					return 19;
				case 'T':
					return 19;
				case 'u':
					return 20;
				case 'U':
					return 20;
				case 'v':
					return 21;
				case 'V':
					return 21;
				case 'w':
					return 22;
				case 'W':
					return 22;
				case 'x':
					return 23;
				case 'X':
					return 23;
				case 'y':
					return 24;
				case 'Y':
					return 24;
				case 'z':
					return 25;
				case 'Z':
					return 25;
				case ':':
					return 26;
				case '.':
					return 27;
				case '!':
					return 28;
				case '-':
					return 29;				
				case ',':
					return 30;				
				case '(':
					return 31;				
				case ')':
					return 32;				
				case '|':
					return 33;				
				case '?':
					return 34;				
				case '<':
					return 35;				
				case '>':
					return 36;				
				case '"':
					return 37;				
				case '+':
					return 38;				
				case '0':
					return 39;				
				case '1':
					return 40;				
				case '2':
					return 41;				
				case '3':
					return 42;				
				case '4':
					return 43;				
				case '5':
					return 44;				
				case '6':
					return 45;				
				case '7':
					return 46;				
				case '8':
					return 47;				
				case '9':
					return 48;				
				case ' ':
					return 49;
			}
			return 0;
		}
	}
}
