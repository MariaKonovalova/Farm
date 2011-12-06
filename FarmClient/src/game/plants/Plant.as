package game.plants
{
  import flash.display.Bitmap;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import game.elements.Element;
  import game.elements.ElementEvent;
  import game.elements.ElementState;
  import game.elements.Elements;
  import game.map.Map;

  public class Plant extends Sprite
  {
    public var id : int;
    private var _typeId : int;
    private var _growthId : int;
    private var _element : Element;
    private var _map : Map;
    private var _container : PlantContainer;
    
    public function Plant(initMap : Map, container : PlantContainer, element : Element)
    {
      this._map = initMap;
      this._container = container;
      this.element = element;
      
      if (this._container)
      {
        this._container.registerPlant(this);
      }
    }
    
    public function set element(element : Element) : void
    {
      if (this._element)
      {
        this._element.removeEventListener(ElementEvent.LOAD_ELEM, onLoadElement);
      }
      if (element)
      {
        if (this._element != element)
        {
          this._element = element;
          
          if (this.numChildren)
          {
            this.removeChildAt(0);
          }
          
          this._typeId = element.typeId;
          this._growthId = element.growthId;
          
          if (_element.loadingState != ElementState.LOADED)
          {
            this._element.addEventListener(ElementEvent.LOAD_ELEM, onLoadElement);
            _element.loadElement();
          }
          else
          {
            this.addChild(new Bitmap(_element.picture.bitmapData));
          }
        }
      }
    }
    
    private function onLoadElement(e:Event) : void
    {
      this.removeEventListener(ElementEvent.LOAD_ELEM, onLoadElement);
      this.addChild(new Bitmap(_element.picture.bitmapData));
    }

    /**Деструктор*/
    public function free() : void
    {
      this._map = null;			
      if (this._container) this._container.unregisterPlant(this);
      this._container = null;
    }
    
    public function get element() : Element
    {
      return this._element;
    }
    public function get container() : PlantContainer
    {
      return this._container;
    }
    public function get typeId() : int
    {
      return _typeId;
    }
    public function get growthId() : int
    {
      return _growthId;
    }
  }
}