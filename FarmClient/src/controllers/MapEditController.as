package controllers
{
  import flash.events.EventDispatcher;
  
  import game.map.Map;
  import game.map.MapEditEvent;
  

  public class MapEditController extends SimpleController implements IController
  {
    private var _map : Map;
    private var _dispatcher : EventDispatcher;
    private var _mapEditController : MapEditController;
    
    public function MapEditController(initMap:Map, 
                                      initDispatcher:EventDispatcher)
    {
      this._map = initMap;
      this._dispatcher = initDispatcher;
      super();
    }
    
    public override function init() : void
    {
      super.init();
      addEventListeners();
    }
    
    private function addEventListeners() : void
    {
      this._dispatcher.addEventListener(MapEditEvent.GET_ELEMENT, onGetElement, false, 0, true);
      this._dispatcher.addEventListener(MapEditEvent.FREE_ELEMENT, onFreeElement, false, 0, true);
      this._dispatcher.addEventListener(MapEditEvent.DELETE_PLANT, onDeletePlant, false, 0, true);
    }
    
    private function onGetElement(e:MapEditEvent) : void
    {
      this._map.mapPlacingPlant.getElement(e.element);
    }
    
    private function onFreeElement(e:MapEditEvent) : void
    {
      this._map.mapPlacingPlant.freeElement();
    }
    
    private function onDeletePlant(e:MapEditEvent) : void
    {
      this._map.plants.deletePlant(e.plant);
    }
  }
}