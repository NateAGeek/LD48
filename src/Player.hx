package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import flash.geom.Point;

/**
 * ...
 * @author NateAGeek
 */

class Player extends Entity
{

	var sprite:Spritemap;
	
	var scale:Int = 2;
	var Width:Int = 32;
	var Height:Int = 32;
	var GridWidth:Int = 32;
	var GridHeight:Int = 32;
	var xOffSet:Int = 0;
	var yOffSet:Int = 0;
	
	var onGround:Bool = false;
	var canMove:Bool = true;
	
	var Movspeed:Float;
	var vel:Point;
	var acc:Point;
	var mov:Point;	
	
	public function new(x:Int, y:Int, grav:Int, speed:Float) {
		super(x, y);
		
		Movspeed = speed;
		
		mov = new Point();
		vel = new Point();
		acc = new Point();
		
		acc.y = grav;
		
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("space", [Key.SPACE]);
		
		sprite = new Spritemap("gfx/Entities/Player.png", 32, 32);
		
		sprite.add("stand", [0], 1);
		
		sprite.scale = scale;
		graphic = sprite;
		
		setHitbox(Width*scale, Height*scale, -(xOffSet*scale), -(yOffSet*scale));
		
		layer = 1;
		
		type = "Player";
	}
	
	public override function update() {
		
		updateCollision();
		updateMove();
		
	}
	
	public function updateMove() {
		mov.x = 0;
		
		if (canMove){
			if(onGround){
				if (Input.check("right")) {
					mov.x++;
					sprite.play("right");
				}
				if (Input.check("left")) {
					mov.x--;
					sprite.play("left");	
				}
			}else {
				if (Input.check("right")) {
					mov.x++;
					sprite.play(inv+"falling_right");
				}
				if (Input.check("left")) {
					mov.x--;
					sprite.play("falling_left");	
				}
			}
			if ((Input.check("space") || Input.check("up"))  && onGround) {
				jump();
			}
		
		}
			
		vel.x = 150 * Movspeed * HXP.elapsed * mov.x;
		vel.y += acc.y;
		
	}
	
	public function updateCollision() {
		
		y += Math.floor(vel.y * HXP.elapsed * Movspeed);
		
		if (collide("Level", x, y) != null) {
			if (HXP.sign(vel.y) > 0) {
				vel.y = 0;
				y = Math.floor((y + height + (yOffSet * scale)) / GridHeight) * GridHeight - (height + (yOffSet * scale));
				if(acc.y > 0){
					onGround = true;
				}
			} else {
				vel.y = 0;
				y = Math.floor((y + yOffSet * scale) / GridHeight) * GridHeight + GridHeight - (yOffSet * scale);
				if(acc.y < 0){
					onGround = true;
				}
			}	
		}
		
		x += vel.x;
		
		if (collide("Level", x, y) != null) {
			if (HXP.sign(vel.x) > 0) {
				vel.x = 0;
				x = Math.floor((x + width + (xOffSet*scale)) / GridWidth) * GridWidth - (width + (xOffSet*scale));
			} else {
				vel.x = 0;
				x = Math.floor((x + xOffSet*scale) / GridWidth) * GridWidth + GridWidth - (xOffSet*scale);
			}
		}
		
	}
	
	private function jump() {
		onGround = false;
		if(acc.y >= 0){
			vel.y = -500;
		}else {
			vel.y = 500;
		}
	}
	
	public function getX() {
		return x;
	}
	
	public function getY() {
		return y;
	}
	
	public function getWidth() {
		return Width;
	}
	
	public function getHeight() {
		return Height;
	}
	
	public function getHealth() {
		return Health;
	}

	public function getcanMove() {
		return canMove;
	}
	
	public function getVelx() {
		return vel.x;
	}
	
	public function getVely() {
		return vel.y;
	}
	
	public function setGrav(g:Int) {
		acc.y = g;
	}
	
	public function setHealth(h:Int) {
		Health = h;
	}
	
	public function setcanMove(move:Bool) {
		canMove = move;
	}
	
	public function setScale(size:Int) {
		scale = size;
		sprite.scale = scale;
		setHitbox(Width*scale, Height*scale, -(xOffSet*scale), -(yOffSet*scale));
	}
	
	public function GetXOffset() {
		return xOffSet * scale;
	}
	
	public function getonGround() {
		return onGround;
	}
}