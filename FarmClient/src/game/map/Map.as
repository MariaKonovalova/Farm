package game.map 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import global.GlobalVars;
	import game.plants.Plant;
	import game.plants.PlantContainer;
	import controllers.MapEditController;

  /**Класс, представляющий собой карту пользователя*/
	public class Map extends Sprite
	{
		private var _land : Land;
    private var _plants : PlantContainer;
		private var _mapDrag : MapDrag;
    private var _mapPlacingPlant : MapPlacingPlant;
    private var _mapEditController : MapEditController;
		
		public function Map(initInterface : EventDispatcher = null)
		{
      _mapDrag = new MapDrag(this, 0, 0);
      
      this._mapPlacingPlant = new MapPlacingPlant(this);
      this._land = new Land(this);
      this.addChild(_land);
      this._plants = new PlantContainer(this);
      this.addChild(_plants);
      
      if (initInterface)
      {
        this._mapEditController = new MapEditController(this, initInterface);
      }
		}
    
    public function center() : void
    {
      if (stage && _land.isLoaded)
      {
        _mapDrag.center(this.stage.stageWidth, this.stage.stageHeight);
      }
    }
    
    /**Полностью удалить объект*/
    public function removePlant(plant:Plant) : void
    {
      if (plant && plant.container)
      {
        plant.container.unregisterPlant(plant);
        plant.free();	
        
        trace(plants.plants.length);
      }
    }
    
    /**Установка растений*/
    public function get mapPlacingPlant() : MapPlacingPlant
    {
      return this._mapPlacingPlant;
    }
    
		public function get mapDrag() : MapDrag
		{
			return _mapDrag;
		}
		
		public function get land() : Land
		{
      return _land;
		}
    
    public function get plants() : PlantContainer
    {
      return _plants;
    }
    
    /**Контроллер редактирования карты*/
    public function get mapEditController() : MapEditController
    {
      return this._mapEditController;
    }
	}
}