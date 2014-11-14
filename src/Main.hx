package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import com.furusystems.barrage.instancing.RunningBarrage;
import nape.geom.Vec2;
import nape.space.Space;
import nape.util.Debug;
import nape.util.ShapeDebug;
import openfl.Assets;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Tony
 */

class Main extends Sprite 
{
	var inited:Bool;
	
	//Particle System
	var emitter:MiniEmitter;
	
	//Particle Govenor
	var runningBarrage:RunningBarrage;
	
	//Nape
	var _space:Space;
	var _debug:Debug;

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
		
		//Create the nape physics space
		_space = new Space(Vec2.get(0.0, 0.0, true));
		
		//Init Nape Debugging
		_debug = new ShapeDebug(600, 600);
		Lib.current.addChild(_debug.display);
		
		//Create emitter for graphic display
		emitter = new MiniEmitter(_space);
		
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
		
		//Physics Update
		_space.step(deltaSeconds);
		
		//Barrage Update
		runningBarrage.update(deltaSeconds);
		
		//Particle System Update
		emitter.update(deltaSeconds);
		
		//draw Nape physics debugging data
		_debug.clear();
		_debug.draw(_space);
		_debug.flush();
		
		//draw particles
		Lib.current.graphics.clear();
		emitter.tilesheet.drawTiles(Lib.current.graphics, emitter.drawData,false,Tilesheet.TILE_RGB);
	}
	
	private function onBarrageComplete(inBarrage:RunningBarrage):Void 
	{
		var str = Assets.getText("examples/inchworm.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete2);
		runningBarrage.start();
	}
	
	private function onBarrageComplete2(inBarrage:RunningBarrage):Void 
	{
		var str = Assets.getText("examples/swarm.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete3);
		runningBarrage.start();
	}
	
	private function onBarrageComplete3(inBarrage:RunningBarrage):Void 
	{
		var str = Assets.getText("examples/dev.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete4);
		runningBarrage.start();
	}
	
	private function onBarrageComplete4(inBarrage:RunningBarrage):Void 
	{
		var str = Assets.getText("examples/waveburst.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete);
		runningBarrage.start();
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
