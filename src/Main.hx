package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import com.furusystems.barrage.instancing.RunningBarrage;
import openfl.Assets;

/**
 * ...
 * @author Tony
 */

class Main extends Sprite 
{
	var inited:Bool;
	var emitter:MiniEmitter;
	var runningBarrage:RunningBarrage;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		//Init
		
		//Create the barrage type
		var str = Assets.getText("examples/waveburst.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create emitter for graphic display
		emitter = new MiniEmitter();
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete);
		runningBarrage.start();

		Lib.current.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		//Update
		var deltaSeconds = 1 / 30; //30fps
		runningBarrage.update(deltaSeconds);
		emitter.update(deltaSeconds);
		
		Lib.current.graphics.clear();
		Lib.current.graphics.beginFill(0x00FF00);
		Lib.current.graphics.drawRect(0, 0, 500, 500);
		Lib.current.graphics.endFill();
		emitter.mTilesheet.drawTiles(Lib.current.graphics, emitter.getDrawTilesData());
	}
	
	private function onBarrageComplete(inBarrage:RunningBarrage):Void 
	{
		trace("barrageComplete");
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
