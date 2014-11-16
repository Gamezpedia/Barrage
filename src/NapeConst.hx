package ;
import nape.callbacks.CbType;

/**
 * Tony DiPerna
 * Setup what interacts with what in Nape
 */
class NapeConst
{

	public static inline var COLLISION_GROUP_BULLET:Int = 0x01;	//bullets
	public static inline var COLLISION_GROUP_STATIC:Int = 0x02;	//Statics (Shapes that dont move)
	
	public static inline var COLLISION_MASK_BULLET:Int = COLLISION_GROUP_STATIC;	//Bullets collide with statics
	public static inline var COLLISION_MASK_STATIC:Int = COLLISION_GROUP_BULLET;	//Statics collide with bullets
	
	public static var CbTypeBullet:CbType = new CbType();
	public static var CbTypeStatic:CbType = new CbType();
	
}