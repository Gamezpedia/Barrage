package ;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.barrage.instancing.IBulletEmitter;
import com.furusystems.flywheel.geom.Vector2D;
import openfl.geom.Rectangle;
import openfl.Lib;

class MiniEmitter implements IBulletEmitter
{
   private var _particles : Array<MiniParticle>;
   public var tilesheet:Tilesheet;
   
   //test variables
   public var pos:Vector2D;
   public var drawData:Array<Float>;
   
   public function new()
   {
	   //Create tilesheet
	  tilesheet = new Tilesheet(new BitmapData(20,20,false,0xFFFFFF));
	  var r = new Rectangle(0, 0, 4, 4);
	  tilesheet.addTileRect(r);
	  
	  //init data structure
	  _particles = new Array<MiniParticle>();
	  
	  //test data
	  pos = new Vector2D(300,300);
   }
   
   public function emit(inX:Float, inY:Float, inAngleRad:Float, inSpeed:Float, inAcceleration:Float, inDelta:Float):IBullet
   {
	   var p = new MiniParticle(inX, inY, inAngleRad,inSpeed,inAcceleration);
	   _particles.push(p);
	   return p;
   }
	
	public function getAngleToEmitter(inPosition:Vector2D):Float
	{
		return inPosition.angleTo(pos);
	}
	
	public function getAngleToPlayer(inPosition:Vector2D):Float
	{
		return inPosition.angleTo(new Vector2D(Lib.current.stage.mouseX,Lib.current.stage.mouseY));
	}
	
	public function kill(inBullet:IBullet):Void
	{
		_particles.remove(cast inBullet);
		inBullet = null;
	}
	
	/**
	 * Periodic Updates
	 * @param	inDeltaSeconds
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