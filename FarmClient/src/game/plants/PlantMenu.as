package game.plants
{
	import fl.motion.easing.Back;
	import fl.transitions.Tween;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import game.elements.Element;
	import game.elements.ElementType;
	import game.elements.ElementTypes;
	import game.elements.Elements;
	import game.map.MapEditEvent;
	
	import global.GlobalVars;
	import global.swfloader.getDefinitionNames;
	
	public class PlantMenu extends Sprite
	{
		private const INDENT:int = 10;
		private const DIFF:int = 5;
		
		private var bgColor : uint;
		private var _size : Point;
		private var arrayIcons : Array = [];
    private var icons : Array = [];
		private var loader : Loader;
		private var menuTween : Tween;
    private var iconCancel : MovieClip;
		
		public function PlantMenu(color:uint, size:Point, urlIconSWF:String)
		{
			bgColor = color;
			_size = size;
			
			loadIconsSWF(urlIconSWF);
		}
		
		private function loadIconsSWF(urlSWF : String) : void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(urlSWF));
		}
		
		private function onComplete(e:Event) : void
		{
			freeListnr();
			
			var ar:Array = getDefinitionNames(e.target.content.loaderInfo);
			var i:int;
			
			//Выбрасываем TimeLine
			for (i = 0; i < ar.length; i++)
			{
				if ( (ar[i] as String).indexOf("MainTimeline") != -1 )
				{
					ar.splice(i,1);
					break;
				}
			}
			
			for (i = 0; i < ar.length; i++)
			{
				var appDomain:Object = e.target.content.loaderInfo.applicationDomain;
				arrayIcons.push(appDomain.getDefinition(ar[i] as String) as Class);
			}
			
			draw();
		}
    
    
    private function onError(e:Event) : void
    {
      freeListnr();
      trace("PlantMenu");
    }
    
    private function freeListnr() : void
    {
      loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
      loader.contentLoaderInfo.removeEventListener(ErrorEvent.ERROR, onError);
      loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
    }
		
		private function draw() : void
		{
			this.graphics.beginFill(bgColor, 0.5);
			this.graphics.drawRoundRect(0, 0, _size.x, _size.y, 10, 10);
			this.graphics.endFill();

      var icon:MovieClip;
			for (var j:int = 0; j < arrayIcons.length; j++)
			{
				icon = new arrayIcons[j]();
				icon.x = INDENT + (icon.width + DIFF) * j;
				icon.y = (_size.y - icon.height) / 2;
        icons.push(icon);
				this.addChild(icon);
			}
      
      this.addEventListener(Event.ADDED_TO_STAGE, addListeners);
      this.addEventListener(Event.REMOVED_FROM_STAGE, freeListeners);
		}
    
    private function addListeners(e:Event) : void
    {
      for (var i:int = 0; i < icons.length; i++)
      {
        icons[i].addEventListener(MouseEvent.ROLL_OVER, onRollOver);
        icons[i].addEventListener(MouseEvent.ROLL_OUT, onRollOut);
        icons[i].addEventListener(MouseEvent.CLICK, onClick);
      }
    }
    
    private function freeListeners(e:Event) : void
    {
      for (var i:int = 0; i < icons.length; i++)
      {
        icons[i].removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
        icons[i].removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
        icons[i].removeEventListener(MouseEvent.CLICK, onClick);
      }
    }
    
    private function onRollOver(e:MouseEvent) : void
    {
      e.target.filters = [new GlowFilter(0xFFFFFFFF, 1, 20, 20, 3.2, 3, false, false)];
    }
    
    private function onRollOut(e:MouseEvent) : void
    {
      e.target.filters = null;
    }
    
    private function onClick(e:MouseEvent) : void
    {
      var name : String = e.target.toString();
      var element : Element;
      
      if (iconCancel && iconCancel == MovieClip(e.target))
      {
        FarmClient.mainMovie.dispatchEvent(new MapEditEvent(MapEditEvent.FREE_ELEMENT));
        iconCancel = null;
      }
      else
      {
        iconCancel = MovieClip(e.target);
        
        for each(var type:ElementType in ElementTypes.all)
        {
          if (e.target.toString().search(type.typeName) != -1)
          {
            element = Elements.getElemByTypeAndGrowth(type.id, GlobalVars.maxGrowth);
            break;
          }
        }
        
        FarmClient.mainMovie.dispatchEvent(new MapEditEvent(MapEditEvent.GET_ELEMENT,element));
      }
    }
		
		public function get size() : Point
		{
			return _size;
		}
	}
}