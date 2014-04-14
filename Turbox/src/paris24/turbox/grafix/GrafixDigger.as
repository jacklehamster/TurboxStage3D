package paris24.turbox.grafix
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import paris24.turbox.utils.Clock;

	public class GrafixDigger
	{
		private var infos:Object;
		private var infoObj:Dictionary = new Dictionary();
		private var isVerbose:Boolean = false;
		
		public function digGraphix(container:DisplayObjectContainer):Vector.<IBitmapDrawable> {
			var result:Vector.<IBitmapDrawable> = new Vector.<IBitmapDrawable>();
//			Clock.clockin('dig');
			dig(container,result);
//			Clock.clockout('dig');
			return result;
		}
		
		private function dig(container:DisplayObjectContainer,result:Vector.<IBitmapDrawable>):void {
			if(!infos) {
				verbose = true;
				infos = {};
				trace("Warning: call loadClassInfoXML to define cachable graphix");
				trace("code example:\nturbox.loadClassInfoXML(\n\
	<xml>\n\
		<classInfo>\n\
			<name>Smurf</name>\n\
			<atom>1</atom>\n\
		</classInfo>\n\
	</xml>);");
				trace("----------------------------");

			}
			for(var i:int=0;i<container.numChildren;i++) {
				var child:DisplayObject = container.getChildAt(i);
				if(child.visible) {
					var classObj:Class = Object(child).constructor;
					var classInfo:Object = infoObj[classObj];
					if(!classInfo)
					{
						classInfo = infos[getQualifiedClassName(classObj)];
						if(classInfo)
							infoObj[classObj] = classInfo;
					}
					if(classInfo && classInfo.atom) {
						result.push(child);
					}
					else if(child is DisplayObjectContainer) {
						if(!classInfo && classObj!=MovieClip && child is MovieClip) {
							infoObj[classObj] = {};
							if(isVerbose)
								trace("<classInfo>\n\t<name>"+getQualifiedClassName(classObj)+"</name>\n\t<atom>0</atom>\n</classInfo>");
						}
						dig(child as DisplayObjectContainer, result);
					}
				}
			}
		}
		
		public function loadClassInfoXML(xml:XML):void {
			if(!infos)
				infos = {};
			for each(var xmlItem:XML in xml.classInfo) {
				infos[xmlItem.name] = {atom:int(xmlItem.atom)};
			}
		}
		
		public function set verbose(value:Boolean):void {
			isVerbose = value;
		}
	}
}