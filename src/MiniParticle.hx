package ;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.flywheel.geom.Vector2D;

class MiniParticle implements IBullet
{
	public var acceleration:Float;
	public var velocity:Vector2D;
	public var pos:Vector2D;
	public var speed:Float;
	public var angle:Float;
	public var active:Bool;
	public var id:Int;
	public var startTime:Float;
	public var color:Int;
	
	//x and y used for display...other values for calcs
	public var x:Float;
	public var y:Float;
	
    public static var UniqueID:Int = 0;
	
    public function new(inX:Float,inY:Float,inAngle:Float,inSpeed:Float,inAccel:Float,inStartTime:Float):Void
    {
		id = MiniParticle.UniqueID++;
		
		//start velocity (vx0 and vy0)
		velocity 	= new Vector2D(inSpeed * Math.cos(inAngle),
								   inSpeed * Math.sin(inAngle));  
		
		//start pos (x0 and y0)
		pos 		= new Vector2D(inX, inY);
		
		acceleration = inAccel;
		angle = inAngle;
		active = false;
		startTime = inStartTime;
		x = inX;
		y = inY;
		
		//random color
		color = Std.random(0xFFFFFF);
    }
	
	public function toString():String
	{
		return "speed: " + speed + " angle: " + angle + " acceleration: " + acceleration + "x/y: " + x + " : " + y + " velocity: " + velocity.toString() + "position: " + pos.toString();
	}
}