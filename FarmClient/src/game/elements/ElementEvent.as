package game.elements
{
  import flash.events.Event;

  public class ElementEvent extends Event
  {
    /**Элемент загружен*/
    public static const LOAD_ELEM : String = "load_elem";
    /**Ошибка загрузки элемента*/
    public static const ERROR_LOAD_ELEM : String = "error_load_elem";
    
    public function ElementEvent(type:String, element:Element, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}