package com.furusystems.barrage.instancing;
import nape.geom.Vec2;
/**
 * ...
 * @author Andreas Rønning
 */
interface IBullet extends IOrigin
{
	var acceleration:Float;
	var angle(get, set):Float;
	var speed(get, set):Float;
	var active:Bool;
	var id:Int;
}