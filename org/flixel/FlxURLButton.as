// Copyright (C) 2009 - Martín Sebastíán Wain - http://www.tbam.com.ar
// Shared under the MIT permissive licence. Please do not remove this comment.

package org.flixel
{
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.events.*;
	import org.flixel.*;
	
	//@desc		A simple button class that calls a function when mouse-clicked
	public class FlxURLButton extends FlxButton
	{
		private var _urlCallback:Function;
		private var _overlapSprite:FlxSprite;
		private var _hooked:Boolean = false;
		private var _getsUpdates:uint = 0;		
		
		static private function bogusCallback():void { }		
		
		public function FlxURLButton(X:int,Y:int,Image:FlxSprite,Callback:Function,ImageOn:FlxSprite=null,Text:FlxText=null,TextOn:FlxText=null)
		{
//			super(X, Y, bogusCallback);
			super(X, Y, Callback);
			_urlCallback = Callback;
			_overlapSprite = Image;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if(_getsUpdates>0 && _overlapSprite.overlapsPoint(FlxG.mouse.x,FlxG.mouse.y))
			{			
				event.stopImmediatePropagation();	//Just click ONE button.
				_urlCallback();
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			//This gets called after Flixel's event listeners because it's registered later.
			//When Flixel get's the event, it will update the state updating the layer-tree
			//		and cores re-enabling _getsUpdates.
			
			//This even works if you update MANUALLY stuff.
			
			//Keep it fast.
			if(_getsUpdates > 0)
				_getsUpdates--;
		}		
		
		private function onRemoved(event:Event):void
		{
			//Clean up after ourselves
			if(FlxG.state.stage) {
				FlxG.state.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				FlxG.state.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				FlxG.state.stage.removeEventListener(Event.REMOVED, onRemoved);
				_hooked=false;
			}
		}		

	
		//@desc		Called by the game loop automatically, handles mouseover and click detection
		override public function update():void
		{
			//Stage is not present during initialization, so we must hook it later on.
			if(!_hooked && FlxG.state.stage) {
				_hooked = true;
				FlxG.state.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				FlxG.state.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				FlxG.state.stage.addEventListener(Event.REMOVED, onRemoved);
			}
			_getsUpdates = 2;

			super.update();
		}
	}
}

