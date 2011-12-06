package game.map
{
  import flash.events.Event;
  
  import game.elements.Element;
  import game.plants.Plant;

  public class MapEditEvent extends Event
  {
    /**Срабатывает когда взяли какой-либо элемент растения для постановки его на карте*/
    public static const GET_ELEMENT : String = "Start placing plant. Plant is moving with cursor";
    /**Срабатывает когда установили элемент на карту*/
    public static const PLACE_ELEMENT : String = "Placing plant on map";
    /**Срабатывает когда отменяем установку элемента*/
    public static const FREE_ELEMENT : String = "When cancel placing plant";
    public static const DELETE_PLANT : String = "Deleted plant";
    
    private var _element : Element;
    private var _plant : Plant;
    
    public function MapEditEvent(type:String,
                                 initElement : Element = null,
                                 initPlant : Plant = null,
                                 bubbles:Boolean=false,
                                 cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      if (initElement)
      {
        this._element = initElement;
      }
      if (initPlant)
      {
        this._plant = initPlant;
      }
    }
    
    /**Возвращает элемент, установка которого идет в данный момент*/
    public function get element() : Element
    {
      return this._element;
    }
    
    public function get plant() : Plant
    {
      return this._plant;
    }
  }
}