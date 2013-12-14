package ;
import com.haxepunk.Mask.MaskCallback;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
/**
 * ...
 * @author NateAGeek
 */
class Game extends Scene
{
	
	var Level:Level_Manager;
	
	public function new() {
		super();
		
		Level = new Level_Manager(0, this);
		
	}
	
	public override function begin() {
		super.begin();
		
		add(Level);
	}
	
	public override function update() {
		super.update();
		
	}
	
}