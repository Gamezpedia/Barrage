package ;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.flywheel.geom.Vector2D;

class MiniParticle implements IBullet
{
	//position of the particle - specified by IOrigin
	public var pos:Vector2D;
	
	//IBullet related 
	public var acceleration:Float;
	public var velocity:Vector2D;
	public var speed:Float;
	public var angle:Float;
	public var active:Bool;
	public var id:Int;
	
	//Extras
	public var color:Int;
	
	//Unique Counter for each particle
	public static var UniqueID:Int = 0;
	
    public function new(inX:Float,inY:Float,inAngle:Float,inSpeed:Float,inAccel:Float):Void
    {
		acceleration = inAccel;
		speed = inSpeed;
		angle = inAngle;
		active = false;
		id = MiniParticle.UniqueID++;
		
		//start velocity (vx0 and vy0)
		velocity 	= new Vector2D(speed * Math.cos(inAngle),
								   speed * Math.sin(inAngle));  
		
		//start pos (x0 and y0)
		pos 		= new Vector2D(inX, inY);
		
		//random color
		color = Std.random(0xFFFFFF);
    }
	
	/**
	 * Helper for debugging
	 * @return Particle properties in string form
	 */
	public function toString():String
	{
		return "speed: " + speed + " angle: " + angle + " acceleration: " + acceleration + " velocity: " + velocity.toString() + "position: " + pos.toString();
	}
}