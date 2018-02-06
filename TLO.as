package{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundcolor="#887090")]
	[Frame(factoryClass="Preloader")]

	public class TLO extends FlxGame{
		public function TLO(){
			super(320,240,TLO_Splash,2);
		}
	}
}
