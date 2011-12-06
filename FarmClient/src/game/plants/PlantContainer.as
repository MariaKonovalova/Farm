package game.plants
{
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  import flash.filters.GlowFilter;
  
  import game.map.Map;
  
  import global.ServerQueries;

  public class PlantContainer extends MovieClip
  {
    private var _map : Map;
    private var _plants : Array = [];
    private var _selectedPlant : Plant;
    
    public function PlantContainer(initMap : Map)
    {
      this._map = initMap;
      this.x = 0;
      this.y = 0;
    }
    
    public function registerPlant(plant:Plant) : void
    {
      _plants.push(plant);
      plant.addEventListener(MouseEvent.CLICK, onPlantClick, false, 1, true);
      _map.addChild(plant);
    }
    
    public function unregisterPlant(plant:Plant) : void
    {
      if (_plants.indexOf(plant) != -1)
      {
        _plants.splice(_plants.indexOf(plant),1);
        plant.removeEventListener(MouseEvent.CLICK, onPlantClick, false);
        _map.removeChild(plant);
      }
    }
    
    public function deletePlant(plant:Plant) : void
    {
      var deletePlant:Function = function (answer:XML) : void{
        if (answer.toString() != "Error")
        {
          plant.free();
          _selectedPlant = null;
        }
        else
        {
          trace(answer.children().toString());
        }
      };
      
      ServerQueries.deletePlant(plant.id, deletePlant);
    }
    
    private function onPlantClick(e:MouseEvent) : void
    {
      if (_selectedPlant)
      {
        _selectedPlant.filters = null;
        _selectedPlant = null;
      }
      
      _selectedPlant = Plant(e.target);
      e.target.filters = [new GlowFilter(0xFFFFFFFF, 1, 20, 20, 3.2, 3, false, false)]; 
    }

    public function get plants() : Array
    {
      return _plants;
    }
    
    public function getPlantById(initId : int) : Plant
    {
      var plant:Plant;
      for each (var pl:Plant in plants)
      {
        if (pl.id == initId)
        {
          plant = pl;
          break;
        }
      }
      
      return plant;
    }
    
    public function get selectedPlant() : Plant
    {
      return _selectedPlant;
    }
  }
}