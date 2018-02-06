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
	
	public class Preloader extends FlxPreloader{
        // Keep track to see if an ad loaded or not
        private var did_load:Boolean;

        // Change this class name to your main class
        public static var MAIN_CLASS:String = "TLO";

        // Substitute these for what's in the MochiAd code
        public static var GAME_OPTIONS:Object = {id: "07160ffdeb912623", res:"640x480"};
	
		[Embed(source="Images/BGTile1.png")] 			protected var ImgBG:Class;
//		[Embed(source="Images/Logo.png")] 				protected var ImgMyLogo:Class;
		[Embed(source="Images/PowerBar_Empty.png")]		protected var ImgEmptyBar:Class;
		[Embed(source="Images/Loader_Bar.png")] 		protected var ImgFullBar:Class;
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG.png")]				private var ImgMyLogo:Class;
		[Embed(source="Sponsor/Accolade_Games_Large_BlackBG_Mouse_Over.png")]	private var ImgAG_MouseOver:Class;
	
		public function Preloader(){
			MochiServices.connect("07160ffdeb912623", root);		
			className = "TLO";
		}
		
		private function DoMochiAd():void{
            var opts:Object = {};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }

            opts.ad_started = function ():void {
                did_load = true;
            }

            opts.ad_finished = function ():void {
                // don't directly reference the class, otherwise it will be
                // loaded before the preloader can begin
                var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
                var app:Object = new mainClass();
                addChild(app as DisplayObject);
            }

            opts.clip = this;
            //opts.skip = true;

            MochiAd.showPreGameAd(opts);		
		}
		
		override protected function create():void {
			DoMochiAd();
		
			//Buffer
			_buffer 		= new Sprite();
			_buffer.width	= 640;
			_buffer.height	= 480;
			_buffer.scaleX	= 1;
			_buffer.scaleY	= 1;
			addChild(_buffer);
			
			//Background
			_width			= 640;
			_height			= 480;
			
			var b:Bitmap;
			
			for (var i:uint = 0; i < 10; i++){
				for(var j:uint = 0; j < 8; j++){
					b = new ImgBG();
					b.width = b.height = 64;			
					b.x = i*64;
					b.y = j*64;
					_buffer.addChild(b);
				}
			}
			
			//Logo
			b = new ImgMyLogo();
			b.width 	= 296;
			b.height	= 121;
			b.x			= (_width/2) - (b.width/2) - (b.width/2);
			b.y			= 40;
			b.scaleX	= 2;
			b.scaleY	= 2;
			_buffer.addChild(b);
			
			//Empty Bar
			
			b = new ImgEmptyBar();
			b.width		= 100;
			b.height	= 16;
			b.scaleX	= 3;
			b.scaleY	= 3;
			b.x			= (_width/2) - (b.width/2);
			b.y			= _height - 160;
			_buffer.addChild(b);
			
		}
		
		override protected function update(Percent:Number):void {
			//Update the graphics...			
			var b:Bitmap = new ImgFullBar();
			b.width		= 100;
			b.height	= 16;
			b.scaleX	= Percent*3;
			b.scaleY	= 3;
			b.x			= (_width/2) - (b.width/2);
			b.y			= _height - 160;
			_buffer.addChild(b);
		}
	}
}
