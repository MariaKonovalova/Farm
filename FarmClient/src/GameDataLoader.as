package
{
  import game.elements.Element;
  import game.elements.ElementType;
  import game.elements.Elements;
  import game.map.Map;
  
  import global.GlobalVars;
  import global.Server;
  import global.ServerQueries;
  import game.elements.ElementTypes;

  public class GameDataLoader
  {
    private var _callback : Function;
    
    public function GameDataLoader(callBack : Function)
    {
      this._callback = callBack;
    }
    
    public function loadAll() : void
    {
      loadElementTypes();
    }
    
    private function loadElementTypes() : void
    {
      try
      {
        ServerQueries.getTypes(function(answer:XML):void{
          for each (var type:XML in answer.*)
          {
            ElementTypes.all.push(new ElementType(type.attribute("id"), type.attribute("name")));
          }
          
          loadElements();
          trace(ElementTypes.all.length);
        });
      }
      catch (err:Error)
      {
        trace("Error load ElementTypes");
      }
    }

    private function loadElements() : void
    {
      try
      {
        ServerQueries.getElements(function(answer:XML) : void{
          for each (var el:XML in answer.*)
          {
            Elements.all.push(new Element(el.attribute("id"), el.attribute("element_type_id"),
              el.attribute("growth_id"), GlobalVars.connectionData.plantsFolder + el.attribute("url_pic")));
          }
          trace(Elements.all.length);
          
          _callback();
        });
      }
      catch (err:Error)
      {
        trace("Error load Elements");
      }
    }
  }
}