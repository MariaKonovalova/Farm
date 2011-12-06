package game.plants
{
  import flash.events.Event;

  public class PlantEvent extends Event
  {
    public static const PLANT_OVER : String = "plant over";
    public static const PLANT_OUT : String = "plant out";
    public static const PLANT_CLICK : String = "plant click";
    public static const PLANT_PLACING : String = "plant placing";
    public static const PLANT_PLACING_FREE : String = "not plant placing";
    public static const PLANT_DELETED : String = "plant deleted";
    
    private var _plant : Plant;
    
    public function PlantEvent(type:String, initPlant : Plant, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      
      this._plant = initPlant;
    }
    
    /**Растение, с которым произошло событие*/
    public function get plant() : Plant
    {
      return this._plant;
    }
  }
}