package com.furusystems.barrage.instancing;
import nape.geom.Vec2;
/**
 * ...
 * @author Andreas Rønning
 */
interface IBulletEmitter extends IOrigin
{
	function emit(x:Float, y:Float, angleRad:Float, speed:Float, acceleration:Float, delta:Float):IBullet;
	function getAngleToEmitter(pos:Vec2):Float;
	function getAngleToPlayer(pos:Vec2):Float;
	function kill(bullet:IBullet):Void;
}