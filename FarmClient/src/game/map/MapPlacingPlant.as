package game.map
{
  import flash.events.EventDispatcher;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import game.elements.Element;
  import game.elements.Elements;
  
  import global.GlobalVars;
  import global.ServerQueries;
  import game.plants.Plant;

  public class MapPlacingPlant extends EventDispatcher
  {
    private var _map : Map;
    
    private var _placingPlant : Plant = null;

    private var _isMovingPlant : Boolean = false;
    
    private var _isPlacingPlant : Boolean = false;
    
    public function MapPlacingPlant(initMap:Map)
    {
      this._map = initMap;
    }
    
    /**Ссылка на карту*/
    public function get map() : Map
    {
      return this._map;
    }
    
    /**Размещаемое растение*/
    public function get placingPlant() : Plant
    {
      return this._placingPlant;
    }
    
    public function getElement(element : Element, plant : Plant = null) : void
    {
      if (_placingPlant)	
      {
        _map.removeChild(_placingPlant);
        _placingPlant = null;
      }
      
      _map.addEventListener(MouseEvent.MOUSE_UP, onMapMouseUp, false, 1);
      _map.addEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove, false, 1);
      
      if (!plant)
      {
        _placingPlant = new Plant(_map,_map.plants,element);
      }
      else
      {
        _placingPlant = plant;
      }
      
      _placingPlant.x = _map.mouseX - _placingPlant.width/2;
      _placingPlant.y = _map.mouseY - _placingPlant.height/2;
    }
    
    /**Удалить элемент (отменить поставку)*/
    public function freeElement() : void
    {
      var i: int;
      
      _map.removeEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
      _map.removeEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
      
      if (_placingPlant)
      {				
        _map.removePlant(_placingPlant);
        _placingPlant = null;
      }
    }
    
    /**Отпустили кнопку мыши*/
    private function onMapMouseUp(e:MouseEvent) : void
    {
      if (!_map.mapDrag.isDrag)
      {
        var pos : Point = new Point(_map.mouseX - _placingPlant.width/2,
          _map.mouseY - _placingPlant.height/2);
        if (_placingPlant)
        {
          if (pos)
          {
            //Поставить растение
            _placingPlant.x = pos.x;
            _placingPlant.y = pos.y;
            
            placePlant(_placingPlant);
          }
        }
      }
    }
    
    /**Срабатывает при движении мыши*/
    private function onMapMouseMove(e:MouseEvent) : void
    {
      if (!_map.mapDrag.isDrag)
      {
        if (_placingPlant)
        {					
          //Если идет установка растения
          var pos : Point = new Point(_map.mouseX - _placingPlant.width/2,
            _map.mouseY - _placingPlant.height/2);
          if (pos)
          {					
            if ((pos.x != _placingPlant.x) || (pos.y != _placingPlant.y))
            {
              _placingPlant.x = pos.x;
              _placingPlant.y = pos.y;
            }
            else
            {
              _placingPlant.alpha = 0;
            }
          }
        }
      }
    }
    
    /**Поставить элемент*/
    public function placePlant(placingPlant:Plant) : void
    {
      var plant:Plant = new Plant(this._map, this._map.plants, placingPlant.element);
      var updatePlant:Function = function(answer:XML) : void{
        plant.id = answer.attribute("id");
        plant.x = answer.attribute("x");
        plant.y = answer.attribute("y");
        plant.element = Elements.getElemByTypeAndGrowth(answer.attribute("element_type_id"),
          answer.attribute("growth_stage_id"));
      }
      
      ServerQueries.createPlant(new Point(placingPlant.x, placingPlant.y), placingPlant.typeId, 
        GlobalVars.minGrowth, updatePlant);
      freeElement();
    }
  }
}
