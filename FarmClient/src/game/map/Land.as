package game.map
{
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLRequest;
  
  import global.GlobalVars;

  public class Land extends Loader
  {
    private var _map : Map
    private var loader : Loader;
    private var _isLoaded : Boolean = false;
    
    public function Land(initMap : Map)
    {
      this._map = initMap;
      loader = new Loader();
      
      contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete); 
      contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError);
      contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
      load(new URLRequest(GlobalVars.connectionData.bgFolder + "BG.jpg"));
    }
    
    private function onComplete(e:Event) : void
    {
      freeListeners(); 
      _isLoaded = true;
      
      if (_map.stage)
      {
        _map.mapDrag.center(_map.stage.stageWidth, _map.stage.stageHeight);
      }
    }
    
    private function freeListeners() : void
    {
      contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
      contentLoaderInfo.removeEventListener(ErrorEvent.ERROR, onError);
      contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
    }
    
    private function onError(e:Event) : void
    {
      freeListeners();
      trace(e);
    }
    
    public function get isLoaded() : Boolean
    {
      return _isLoaded;
    }
  }
}