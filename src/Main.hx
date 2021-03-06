package ;

import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.barrage.instancing.RunningBarrage;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
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
		
		//To show physics interactions we generate some random shapes and
		//place them in our "world"
		createStaticPhysicsObjects();
		
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
		
		//add listener for bullet->wall/object
		_space.listeners.add(new InteractionListener(
            CbEvent.BEGIN,
            InteractionType.COLLISION,
            NapeConst.CbTypeBullet,
            NapeConst.CbTypeStatic,
            onBulletHitStatic
        ));
		
	}
	
	/**
	 * What happens when a bullet hits an object
	 * @param	cb - the interaction callback object...holds collision information
	 */
	private function onBulletHitStatic(cb:InteractionCallback):Void 
	{
		// Bullet is first body since the parameter is first when creating
		// the interaction listener
        var bullet:IBullet = cb.int1.castBody.userData.bullet;
       
		//kill off the bullet since it hit something
		emitter.kill(bullet);
	}
	
	/**
	 * Helper function to group the Nape Debug objects
	 */
	private function createStaticPhysicsObjects():Void
	{
		//Create some random objects to hit
		// Generate some random objects!
        for (i in 0...10) 
		{
			var body = new Body(BodyType.STATIC);

			// Add a random Circle, Box or Pentagon.
			if (Math.random() < 0.33) {
				body.shapes.add(new Circle(20));
			}
			else if (Math.random() < 0.5) {
				body.shapes.add(new Polygon(Polygon.box(40, 40)));
			}
			else {
				body.shapes.add(new Polygon(Polygon.regular(20, 20, 5)));
			}

			// Set to random position on stage and add to Space.
			body.position.setxy(Std.random(600), 350+Std.random(250));
			body.space = _space;
			body.cbTypes.add(NapeConst.CbTypeStatic);
			body.setShapeMaterials(Material.steel());
			
			//Tell nape this is a static object
			body.cbTypes.add(NapeConst.CbTypeStatic);
			
			//setup how the bullets interact with other objects
			body.setShapeFilters(new InteractionFilter(NapeConst.COLLISION_GROUP_STATIC, NapeConst.COLLISION_MASK_STATIC));
		}
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		//Update
		var deltaSeconds = 1 / 60; //30fps
		
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
		//clear old emitter data
		emitter.reset();
		
		var str = Assets.getText("examples/inchworm.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete2);
		runningBarrage.start();
	}
	
	private function onBarrageComplete2(inBarrage:RunningBarrage):Void 
	{
		//clear old emitter data
		emitter.reset();
	
		var str = Assets.getText("examples/swarm.brg");
		var b = com.furusystems.barrage.Barrage.fromString(str);
		
		//Create the barrage runner (logic to actually move the bullets)
		runningBarrage = b.run(emitter);
		runningBarrage.onComplete.add(onBarrageComplete3);
		runningBarrage.start();
	}
	
	private function onBarrageComplete3(inBarrage:RunningBarrage):Void 
	{
		//clear old emitter data
		emitter.reset();
		
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
		
		//clear old emitter data
		emitter.reset();
		
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
