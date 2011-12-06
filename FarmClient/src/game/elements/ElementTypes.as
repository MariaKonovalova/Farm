package game.elements
{

  public class ElementTypes
  {
    public static var all : Array = new Array();
    
    public function ElementTypes()
    {
    }
    
    public static function getTypeByName(typeName:String) : ElementType
    {
      var type:ElementType;
      for (var i:int = 0; i < ElementTypes.all.length; i++)
      {
        if (ElementTypes.all[i].typeName == typeName)
        {
          type = ElementTypes.all[i];
          break;
        }
      }
      
      return type;
    }
  }
}