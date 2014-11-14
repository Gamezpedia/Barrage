package ;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.barrage.instancing.IBulletEmitter;
import com.furusystems.flywheel.geom.Vector2D;
import openfl.geom.Rectangle;
import openfl.Lib;

/**
 * Tony DiPerna
 * A Simple particle system that implements IBulletEmitter in order
 * to get Barrage up and running
 */
class MiniEmitter implements IBulletEmitter
{
   //All particles in the system
   private var _particles : Array<MiniParticle>;
   
   //Needed to use drawTiles() for graphics
   public var tilesheet:Tilesheet;
   
   //IOrigin - source point of the emitter
   public var pos:Vector2D;
   
   //drawTiles() tile data for graphics
   public var drawData:Array<Float>;
   
   public function new()
   {
	  //Create tilesheet - for graphics
	  tilesheet = new Tilesheet(new BitmapData(20,20,false,0xFFFFFF));
	  var r = new Rectangle(0, 0, 4, 4);
	  tilesheet.addTileRect(r);
	  
	  //init data structure to hold particles
	  _particles = new Array<MiniParticle>();
	  
	  //test data - emitter position
	  pos = new Vector2D(300,300);
   }
   
    /**
	 * Create a new particle
	 * @param	inX				start x position
	 * @param	inY				start y position
	 * @param	inAngleRad		angle of start velocity
	 * @param	inSpeed			magnitude of start velocity
	 * @param	inAcceleration	starting acceleration
	 * @param	inDelta			time between updates (no use yet)
	 * @return	newly created and initialized particle
	 */
	public function emit(inX:Float, inY:Float, inAngleRad:Float, inSpeed:Float, inAcceleration:Float, inDelta:Float):IBullet
	{
	   var p = new MiniParticle(inX, inY, inAngleRad,inSpeed,inAcceleration);
	   _particles.push(p);
	   return p;
	}
	
    /**
	 * Angle from a particle to the source emitter
	 * @param	inPosition 	a particles position
	 * @return	angle in radians
	 */
	public function getAngleToEmitter(inPosition:Vector2D):Float
	{
		return inPosition.angleTo(pos);
	}
	
	/**
	 * Angle from a particle to the target player
	 * @param	inPosition 	a particles position
	 * @return	angle in radians
	 */
	public function getAngleToPlayer(inPosition:Vector2D):Float
	{
		return inPosition.angleTo(new Vector2D(Lib.current.stage.mouseX,Lib.current.stage.mouseY));
	}
	
	/**
	 * Remove a bullet from the particle system
	 * @param	inBullet		The bullet to remove from the particle system
	 */
	public function kill(inBullet:IBullet):Void
	{
		_particles.remove(cast inBullet);
		inBullet = null;
	}
	
	/**
	 * Periodic Updates to control the particles
	 * @param	inDeltaSeconds	how much time has passed since the last iteration
	 */
	public function update(inDeltaSeconds:Float):Void
	{
		//AJD - dont keep creating new arrays each update
		drawData = new Array<Float>();
		
		for (p in _particles)
		{
			var xAngle = Math.cos(p.angle);
			var yAngle = Math.sin(p.angle);
			
			//x(t) =  1/2at^2 + v0t + x0
			p.velocity.x += p.acceleration * xAngle * inDeltaSeconds;
			p.velocity.y += p.acceleration * yAngle * inDeltaSeconds;
			
			p.pos.x += p.velocity.x*inDeltaSeconds;
			p.pos.y += p.velocity.y*inDeltaSeconds;
		
			drawData.push(p.pos.x);
			drawData.push(p.pos.y);
			drawData.push(0);//only one tile ID
			drawData.push(((p.color&0xFF0000)>>16)/0xFF);//r
			drawData.push(((p.color&0x00FF00)>>8)/0xFF);//g
			drawData.push((p.color&0x0000FF)/0xFF);//b
		}	
	}
}