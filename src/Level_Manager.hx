package ;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.tweens.misc.VarTween;
import haxe.xml.Fast;
import openfl.Assets;

/**
 * ...
 * @author NateAGeek
 */
class Level_Manager extends Entity {

	var player:Player;
	var Cam:Camera;
	
	var MapGrid:Grid;
	
	var ForegroundTiles:Level_Foreground;
	var MiddlegroundTiles:Level_Middleground;
	var BackgroundTiles:Level_Background;
	
	var MapWidth:Int;
	var MapHeight:Int;
	var PSpawnx:Int = 0;
	var PSawny:Int = 0;
	var Level:Int = 0;
	
	var Gravity:Int = 1;
	var Speed:Float = 1.0;
	
	var Scene_Ref:Scene;
	
	public function new(Level:Int, Scene_Ref:Scene) {
		super(0 ,0);
		
		this.Scene_Ref = Scene_Ref;
		
		this.Level = Level;
		LoadLevel(Level);
		mask = MapGrid;
		
		player = new Player(PSpawnx, PSawny, Gravity, Speed);
		
		BackgroundTiles.Set_PlayerRef(player);
		BackgroundTiles.Set_Map_W_H(MapWidth, MapHeight);
		
		Scene_Ref.add(player);
		
		Cam = new Camera(MapWidth, MapHeight, player.getX(), player.getY(), player.getWidth(), player.getHeight());
		
		layer = 1;
		
		type = "Level";
		
	}
	
	public override function update() {
		
		Cam.update(player.getX(), player.getY(), player.getWidth(), player.getHeight());
		
	}
	
	private function LoadLevel(Level:Int) {
		
		ForegroundTiles = new Level_Foreground(Level);
		MiddlegroundTiles = new Level_Middleground(Level);
		BackgroundTiles = new Level_Background(Level);
		
		Scene_Ref.add(BackgroundTiles);
		Scene_Ref.add(MiddlegroundTiles);
		Scene_Ref.add(ForegroundTiles);
		
		var root = new Fast(Xml.parse(Assets.getText("levels/" + Level + "/level.oel")).firstElement());
		
		MapWidth = Std.parseInt(root.att.width);
		MapHeight = Std.parseInt(root.att.height);
		
		MapGrid = new Grid(Std.parseInt(root.att.width), Std.parseInt(root.att.height), 32, 32, 0, 0);
		
		var CollisionXML = root.node.Collision;
		var EntitesXML = root.node.Entities;
		
		for (Collision in CollisionXML.elements) {
			trace("X: " + Collision.att.x + " Y:" + Collision.att.y+" width:"+Collision.att.w+" Height:"+Collision.att.h);
			MapGrid.setRect(Std.int(Std.parseInt(Collision.att.x)), Std.int(Std.parseInt(Collision.att.y)), Std.int(Std.parseInt(Collision.att.w)), Std.int(Std.parseInt(Collision.att.h)), true);
		}
		
		for (Entities in EntitesXML.elements) {
			switch(Entities.name) {
				case "Player":
					PSpawnx = Std.parseInt(Entities.att.x); PSawny = Std.parseInt(Entities.att.y);
			}
		}
		
	}
	
	public function newLevel(newLevel:Int) {
		
	}
	
	public function getGrav() {
		return Gravity;
	}
	
	public function getMapGrid() {
		return MapGrid;
	}
	
	public function getWidth() {
		return MapWidth;
	}
	
	public function getHeight() {
		return MapHeight;
	}
	
}