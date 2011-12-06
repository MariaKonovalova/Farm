package game.elements
{
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLRequest;
  
  import global.GlobalVars;

  public class Element extends Loader
  {
    public static var MAX_ERROR_IN_LOADING : int = 3;
    
    public var id : int;
    public var typeId : int;
    public var growthId : int;
    public var url : String;
    /**Состояние загрузки элемента*/
    private var _loadingState : int = ElementState.NOT_LOADED;
    /**Картинка элемента*/
    private var _picture : Bitmap;
    /**Кол-во ошибочных загрузок*/
    private var loadingErrorsOccured : int = 0;
    
    public function Element(id:int, 
                            typeId:int, 
                            growthId:int, 
                            url:String)
    {
      this.id = id;
      this.typeId = typeId;
      this.growthId = growthId;
      this.url = url;
    }
    
    public function loadElement():void
    {
      var urlRequest:URLRequest = new URLRequest(this.url);
      contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadElem);
      contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
      contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      load(urlRequest);
    }
    
    /**Убить всех слушателей*/
    private function freeListeners() : void
    {
      this.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeLoadElem);
      this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
      this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }
    
    private function completeLoadElem(e:Event) : void
    {
      this._loadingState = ElementState.LOADED;
      freeListeners();
      _picture = Bitmap(this.content);
      dispatchEvent(new ElementEvent(ElementEvent.LOAD_ELEM,this));
    }
    
    private function onError(e:Event) : void
    {
      freeListeners();
      
      if (loadingErrorsOccured <= Element.MAX_ERROR_IN_LOADING)
      {
        loadingErrorsOccured++;
        loadElement();
      }
      else
      {
        this.dispatchEvent(new ElementEvent(ElementEvent.ERROR_LOAD_ELEM,this));
      }		
    }

    public function get loadingState() : int
    {
      return this._loadingState;
    }
    public function get picture() : Bitmap
    {
      return this._picture;
    }
  }
}