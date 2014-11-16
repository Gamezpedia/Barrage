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
		
		//Setup for nape use
		initPhysicsBody(inX,inY,velocity.x,velocity.y,inSpace);
    }
	
	/**
	 * Just a method that takes care of setting up a physics body, starting pos and velocity
	 * need to match the data that barrage uses (pos and velocity)
	 * 
	 * @param	inPosX			Starting particle x position
	 * @param	inPosY			Starting particle y position
	 * @param	inVelocityX		Starting velocity x direction
	 * @param	inVelocityY		Starting velocity y direction
	 * @param	inSpace			The Nape space to add this body to
	 */
	private function initPhysicsBody(inPosX:Float,inPosY:Float,inVelocityX:Float,inVelocityY:Float,inSpace:Space):Void
	{
		//Init nape body type and position
		body = new Body(BodyType.DYNAMIC, new Vec2(inPosX, inPosY));
		
		//4px by 4px collision box for the bullet (matches graphics size)
		var collisionShape = Polygon.rect(0.0, 0.0, 4.0, 4.0, true);
		body.shapes.add(new Polygon(collisionShape, new Material(99999, .03, .1, .9, .001))); //bouncy bullets
		body.allowRotation = false;
		
		//setup how the bullets interact with other objects
		body.cbTypes.add(NapeConst.CbTypeBullet);				
		body.setShapeFilters(new InteractionFilter(NapeConst.COLLISION_GROUP_BULLET, NapeConst.COLLISION_MASK_BULLET));
		
		//init velocity for nape
		body.velocity.x = velocity.x;
		body.velocity.y = velocity.y;
		
		//add the bullet to they physics world
		body.space = inSpace;
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
	
	/**
	 * Reset velocity when Barrage changes the velocity of the bullet
	 * @param	value
	 * @return
	 */
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