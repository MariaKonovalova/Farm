package game.elements
{
  import flash.events.EventDispatcher;

  public class Elements extends EventDispatcher
  {
    /**Все элементы*/
    public static var all : Array = [];
    
    public function Elements()
    {
    }
    
    public static function getElementById(id : int) : Element
    {
      var element:Element;
      for (var i:int = 0; i < elementsCount; i++)
      {
        if (Elements.all[i].id == id)	
        {
          element = Elements.all[i];
          break;
        }
      }

      return element;
    }
    
    public static function getElemByTypeAndGrowth(typeId:int, growthId:int) : Element
    {
      var element:Element;
      for (var i:int = 0; i < elementsCount; i++)
      {
        if (Elements.all[i].typeId == typeId && Elements.all[i].growthId == growthId)	
        {
          element = Elements.all[i];
          break;
        }
      }
      
      return element;
    }
    
    /**Возвращает кол-во элементов*/
    public static function get elementsCount() : int	
    {
      return Elements.all.length;
    }
  }
}