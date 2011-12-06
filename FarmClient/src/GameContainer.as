package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.elements.Elements;
	import game.map.Map;
	
	import global.ServerQueries;
	
	import game.plants.Plant;
	
	/**
	 * Класс содержит слои с картой и интерфейсом
	 * */
	public class GameContainer extends Sprite
	{
		public static var instance:GameContainer = new GameContainer();
		
		private var _map : Map;
		
		public function GameContainer()
		{
		}
		
		public function init():void
		{
			loadMap();
      
      try
      {
        var plant:Plant;
        ServerQueries.getUserField(function(answer:XML) : void{
          for each (var pl:XML in answer.*)
          {
            plant = new Plant(_map, _map.plants, Elements.getElemByTypeAndGrowth(
              pl.attribute("element_type_id"), pl.attribute("growth_stage_id")));
            plant.id = pl.attribute("id");
            plant.x = pl.attribute("x");
            plant.y = pl.attribute("y");
          }
          trace(answer);
          trace(_map.plants.plants.length);
        });
      }
      catch (err:Error)
      {
        trace("Error load User field");
      }
		}
		
		private function loadMap():void
		{
			_map = new Map(FarmClient.mainMovie);
			this.addChild(_map);
      _map.center();
			
			this.addChild(GInterface.instance);
		}
    
    public function get map() : Map
    {
      return _map;
    }
	}
}