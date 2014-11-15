package ;
import com.furusystems.barrage.instancing.IBullet;
import com.furusystems.flywheel.geom.Vector2D;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

class MiniParticle implements IBullet
{
	//position of the particle - specified by IOrigin
	public var pos:Vector2D;
	
	//IBullet related 
	public var acceleration:Float;
	public var velocity:Vector2D;
	@:isVar public var angle(get, set):Float;
	public var active:Bool;
	public var id:Int;
	@:isVar public var speed(get, set):Float;
	
	//Extras
	public var color:Int;
	
	//Unique Counter for each particle
	public static var UniqueID:Int = 0;
	
	//Nape
	public var body:Body;
	
    public function new(inX:Float,inY:Float,inAngle:Float,inSpeed:Float,inAccel:Float,inSpace:Space):Void
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
		
		//Init nape body
		body = new Body(BodyType.DYNAMIC, new Vec2(pos.x, pos.y));
		
		//4px by 4px collision box for the bullet (matches graphics size)
		var collisionShape = Polygon.rect(0.0, 0.0, 4.0, 4.0, true);
		body.shapes.add(new Polygon(collisionShape, new Material(99999, .03, .1, .9, .001))); //bouncy bullets
		body.allowRotation = false;
		
		//setup how the bullets interact with other objects
		body.cbTypes.add(NapeConst.CbTypeBullet);
		body.setShapeFilters(new InteractionFilter(NapeConst.COLLISION_GROUP_BULLET, NapeConst.COLLISION_MASK_BULLET));
		
		//init position and velocity for nape
		body.position.x = pos.x;
		body.position.y = pos.y;
		body.velocity.x = velocity.x;
		body.velocity.y = velocity.y;
		
		//add the bullet to they physics world
		body.space = inSpace;
		
		//type for callback filtering
		//AJD todo
		//body.cbTypes.add(PhysicsCollision.CbTypeBullet);
		//body.group = PhysicsCollision.InteractionGroupBullets; //use a group with ignore=true so bullets never hit each other, faster than collision masks/filters
		
		//add this bullet to the dynamic userData object, so we can access it from the callbacks
		//body.userData.controller = this;
    }
	
	/**
	 * Properly clean up / deconstruct
	 */
	public inline function destroy():Void
	{
		body.space = null;
		body = null;
		velocity = null;
		pos = null;
	}
	/**
	 * Helper for debugging
	 * @return Particle properties in string form
	 */
	public function toString():String
	{
		return "speed: " + speed + " angle: " + angle + " acceleration: " + acceleration + " velocity: " + velocity.toString() + "position: " + pos.toString();
	}
	
	function get_speed():Float 
	{
		return speed;
	}
	
	function set_speed(value:Float):Float 
	{
		//reset velocity
		velocity 	= new Vector2D(value * Math.cos(angle),
								   value * Math.sin(angle));  
								   
		return speed = value;
	}
	
	function get_angle():Float 
	{
		return angle;
	}
	
	function set_angle(value:Float):Float 
	{
		//reset velocity
		velocity 	= new Vector2D(speed * Math.cos(value),
								   speed * Math.sin(value));  
								   
		return angle = value;
	}
}