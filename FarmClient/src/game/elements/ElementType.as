package game.elements
{
  public class ElementType
  {
    private var _id : int = 1;
    private var _typeName : String = "";
    
    public function ElementType(id:int, type:String)
    {
      this._id = id;
      this._typeName = type;
    }
    
    public function get id() : int
    {
      return this._id;
    }
    
    public function get typeName() : String
    {
      return this._typeName;
    }
  }
}