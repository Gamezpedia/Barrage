package ;
import com.furusystems.barrage.instancing.IBullet;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

class MiniParticle implements IBullet
{
	//collision occurred?  Use this for nape to signify a bullet hit something and was removed
	public var collision:Bool;
	
	//position of the particle - specified by IOrigin
	public var pos:Vec2;
	
	//IBullet related 
	public var acceleration:Float;
	
	//Change to set function so we can catch angle changes and set
	//instant velocity
	@:isVar public var angle(get, set):Float;
	public var active:Bool;
	public var id:Int;
	
	//Change to set function so we can catch angle changes and set
	//instant velocity
	@:isVar public var speed(get, set):Float;
	
	//Extras
	public var color:Int;
	
	//Unique Counter for each particle
	public static var UniqueID:Int = 0;
	
	//Nape
	public var body:Body;
	
    public function new(inX:Float,inY:Float,inAngle:Float,inSpeed:Float,inAccel:Float,inSpace:Space):Void
    {
		//store off params
		acceleration = inAccel;
		active = false;
		id = MiniParticle.UniqueID++;
		
		//random color
		color = Std.random(0xFFFFFF);
		
		//Setup for nape use
		initPhysicsBody(inX, inY, getVelX(inSpeed, inAngle), getVelY(inSpeed, inAngle), inSpace);
		
		collision = false;
    }
	
	private inline function getVelX(inSpeed:Float, inAngle:Float):Float
	{
		return inSpeed * Math.cos(inAngle);
	}
	private inline function getVelY(inSpeed:Float, inAngle:Float):Float
	{
		return inSpeed * Math.sin(inAngle);
	}
	private inline function updateVel(inSpeed:Float, inAngle:Float):Void
	{
		body.velocity.x = getVelX(inSpeed, inAngle);
		body.velocity.y = getVelY(inSpeed, inAngle);
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
		body.velocity = Vec2.get(inVelocityX, inVelocityY);
		
		//init barrage vars
		pos = body.position;
		
		//add the bullet to they physics world
		body.space = inSpace;
		
		//Tell nape this is a bullet
		body.cbTypes.add(NapeConst.CbTypeBullet);
		
		//special data dynamically added to the nape body to allow us to lookup this bullet
		//after a nape collision occurs
		body.userData.bullet = this;
	}
	
	/**
	 * Properly clean up / deconstruct
	 */
	public inline function destroy():Void
	{
		if (!collision)
		{
			collision = true;
			body.space = null;
			body.velocity.dispose();
			body.position.dispose();
			body = null;
			//pos = null;
		}
	}
	/**
	 * Helper for debugging
	 * @return Particle properties in string form
	 */
	public function toString():String
	{
		return "speed: " + speed + " angle: " + angle + " acceleration: " + acceleration + " velocity: " + body.velocity.toString() + "position: " + pos.toString();
	}
	
	function get_speed():Float 
	{
		return speed;
	}
	
	/**
	 * Reset velocity when Barrage changes the velocity of the bullet
	 * @Note - Needed to support instant velocity changes from Barrage scripts
	 * @param	value	The new speed that will be broken into x/y parts
	 * @return	the new speed value
	 */
	function set_speed(value:Float):Float 
	{
		//update velocity ...AJD does this also change nape velocity?
		speed = value;
		
		if (!collision)
			updateVel(value, angle);						   
		
		return value;
	}
	
	function get_angle():Float 
	{
		return angle;
	}
	
	/**
	 * Reset velocity when Barrage changes the angle of the bullet
	 * @Note - Needed to support instant velocity changes from Barrage scripts
	 * @param	value	The new speed that will be broken into x/y parts
	 * @return	the new speed value
	 */
	function set_angle(value:Float):Float 
	{
		//update angle
		angle = value;
		
		if (!collision)
			updateVel(speed, value);
		
		return value;
	}
}