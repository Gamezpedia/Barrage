package ;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.barrage.instancing.IBulletEmitter;
import com.furusystems.flywheel.geom.Vector2D;
import openfl.geom.Rectangle;

class MiniEmitter implements IBulletEmitter
{
   private var _mParticles : Array<MiniParticle>;
   public var mTilesheet:Tilesheet;
   
   //test variables
   public var pos:Vector2D;
   private var testPlayerOrigin:Vector2D;
   var elapsedTime:Float;
   
   public function new()
   {
	   //Create tilesheet
	  mTilesheet = new Tilesheet(new BitmapData(20,20,false,0xFF0000));
	  var r = new Rectangle(0, 0, 4, 4);
	  mTilesheet.addTileRect(r);
	  
	  //init data structure
	  _mParticles = new Array<MiniParticle>();
	  
	  //test data
	  pos = new Vector2D(900,500);
	  testPlayerOrigin = new Vector2D(0, 0);
	  elapsedTime = 0;
   }
   
   public function emit(inX:Float, inY:Float, inAngleRad:Float, inSpeed:Float, inAcceleration:Float, inDelta:Float):IBullet
   {
	   var p = new MiniParticle(inX, inY, inAngleRad,inSpeed,inAcceleration,inDelta);
	   _mParticles.push(p);
	   return p;
   }
	
	public function getAngleToEmitter(inPosition:Vector2D):Float
	{
		trace("pos1: " + inPosition.angleTo(pos));
		trace("pos2: " + pos.angleTo(inPosition));
		//return inPosition.angleTo(pos);
		return pos.angleTo(inPosition);
		
	}
	
	public function getAngleToPlayer(inPosition:Vector2D):Float
	{
		trace("pos1x: " + inPosition.angleTo(testPlayerOrigin));
		trace("pos2x: " + testPlayerOrigin.angleTo(inPosition));
		//return inPosition.angleTo(testPlayerOrigin);
		return testPlayerOrigin.angleTo(inPosition);
	}
	
	public function kill(inBullet:IBullet):Void
	{
		_mParticles.remove(cast inBullet);
		inBullet = null;
	}
	
	/**
	 * Periodic Updates
	 * @param	inDeltaSeconds
	 */
	public function update(inDeltaSeconds:Float):Void
	{
		elapsedTime += inDeltaSeconds;
		
		var debugOnce = false;
		var diffTime = 0.0;
		
		for (p in _mParticles)
		{
			/*
			//This kinda works
			p.pos.x += p.velocity.x;
			p.pos.y += p.velocity.y;
			p.velocity.x = Math.cos(p.angle*Math.PI/180*p.speed);
			p.velocity.y = Math.sin(p.angle*Math.PI/180*p.speed);
			*/
			
			/*
			//total time the particle has been alive
			diffTime = elapsedTime - p.startTime;
			
			//x(t) =  1/2at^2 + v0t + x0
			var accelX = p.acceleration * Math.cos(p.angle * Math.PI / 180) * diffTime * diffTime * 0.5;
			var accelY = p.acceleration * Math.sin(p.angle * Math.PI / 180) * diffTime * diffTime * 0.5;
			
			p.x = accelX + p.velocity.x * diffTime + p.pos.x;
			p.y = accelY + p.velocity.y * diffTime + p.pos.y;
			
			
			if (!debugOnce)
			{
				trace(p.toString());
				debugOnce = true;
			}
			*/
			
			var xAngle = Math.cos(p.angle * Math.PI / 180);
			var yAngle = Math.sin(p.angle * Math.PI / 180);
			
			var xAccel = p.acceleration * inDeltaSeconds * inDeltaSeconds * xAngle * 0.5;
			var yAccel = p.acceleration * inDeltaSeconds * inDeltaSeconds * yAngle * 0.5;
			
			var xVelocity = p.speed * inDeltaSeconds * xAngle;
			var yVelocity = p.speed * inDeltaSeconds * yAngle;
			
			p.velocity.x = xVelocity;
			p.velocity.y = yVelocity;
			
			p.pos.x += xVelocity + xAccel;
			p.pos.y += yVelocity + yAccel;
			
			
			
		}
		trace("diffTime: " + diffTime);
			
	}
	public function getDrawTilesData():Array<Float>
	{
		var arr = new Array<Float>();
		
		for (p in _mParticles)
		{
			arr.push(p.pos.x);
			arr.push(p.pos.y);
			arr.push(0);//only one tile ID
		}
		
		return arr;
	}
}