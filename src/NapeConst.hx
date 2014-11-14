package ;
import nape.callbacks.CbType;

/**
 * Tony DiPerna
 * Setup what interacts with what
 * @author ...
 */
class NapeConst
{

	public static inline var COLLISION_GROUP_BULLET:Int = 0x01;	//bullets
	public static inline var COLLISION_GROUP_STATIC:Int = 0x02;	//walls,shapes,etc
	
	public static inline var COLLISION_MASK_BULLET:Int = COLLISION_GROUP_BULLET | COLLISION_GROUP_STATIC;	//Bullets collide with statics
	public static inline var COLLISION_MASK_STATIC:Int = COLLISION_GROUP_STATIC;	//Statics collide with bullets
	
	public static var CbTypeBullet:CbType = new CbType();
	public static var CbTypeStatic:CbType = new CbType();
	
}