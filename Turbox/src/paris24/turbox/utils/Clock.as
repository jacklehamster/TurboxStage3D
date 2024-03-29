package paris24.turbox.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	public class Clock
	{
		static private var clocks:Object = {};
		static private var interval:int = start();
		static private var lastCheck:int = 0;
		static private var sprite:Sprite;
		
		static private function start():int {
			sprite = new Sprite();
			sprite.addEventListener(Event.ENTER_FRAME,clear);
			return 0;
		}

		static public function clockin(id:String):void {
			if(!clocks[id])
				clocks[id] = {time:0,count:0};
			clocks[id].time -= getTimer();
			clocks[id].count++;
		}
		
		static public function clockout(id:String):void {
			clocks[id].time += getTimer();
		}
		
		static private function clear(e:Event):void {
			var now:int = getTimer();
			var diffTimer:int = now-lastCheck;
			trace('==================================');
			if(diffTimer>1000/24){
				for(var id:String in clocks) {
					trace(id,clocks[id].time,"/",clocks[id].count);
					delete clocks[id];
				}
				lastCheck = now;
			}
		}
	}
}