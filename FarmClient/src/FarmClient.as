package
{
	import controllers.MemoryController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import global.ConnectionData;
	import global.GlobalVars;
	import global.Server;
	import global.ServerQueries;
	
	[SWF(width ='900', height='590', backgroundColor='#6f9e21')]
	public class FarmClient extends Sprite
	{
		//Откуда загружаем ресурсы (локально или с сервера)
		public static var NETWORK : int = ConnectionData.LOCAL;
    public static var gameDataLoader : GameDataLoader;
    
    public static var mainMovie : Sprite;
    
    private static var memoryController : MemoryController;
    
		public function FarmClient()
		{
			if (!stage)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init); 
			}
			else
			{
				init();
			}
		}
	
		private function init(e : Event = null):void
		{
      FarmClient.memoryController = new MemoryController();
      FarmClient.mainMovie = this;
			GlobalVars.connectionData = new ConnectionData(FarmClient.NETWORK);
      
      loadUserData();
		}
    
    private function loadUserData() : void
    {
      try
      {
        ServerQueries.userStart("Marya.Konovalova@gmail.com", "auto12345", startLoadData);
      }
      catch(err:Error)
      {
        trace("Error load user");
      }
    }
    
    private function startLoadData(answer:XML = null) : void
    {
      if (answer)
      {
        if (answer.name().toString() == "Error")
        {
          trace(answer.children().toString());
        }
        else
        {
          gameDataLoader = new GameDataLoader(startGame);
          gameDataLoader.loadAll();
        }
      }
    }
    
    private function startGame() : void
    {
      this.stage.addChild(GameContainer.instance);
      GameContainer.instance.init();
    }
	}
}