// ActionScript file
package global
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flashx.textLayout.elements.GlobalSettings;

	public class ServerQueries
	{	
		public static var userStartAction : String = "sessions";
		public static function userStart(email:String, password:String, callback:Function = null) : void
		{
			var vars:URLVariables = new URLVariables();
			vars['email'] = email;
			vars['password'] = password;
			Server.instance.getXMl(GlobalVars.connectionData.urlConnection + userStartAction,
				URLRequestMethod.POST, vars, callback);
		}
    
    public static var getTypesAction : String = "element_types";
    public static function getTypes(callback:Function) : void
    {
      Server.instance.getXMl(GlobalVars.connectionData.urlConnection + getTypesAction,
        URLRequestMethod.GET, null, callback);
    }
    
    public static var getElementsAction : String = "elements";
    public static function getElements(callback:Function) : void
    {
      Server.instance.getXMl(GlobalVars.connectionData.urlConnection + getElementsAction,
        URLRequestMethod.GET, null, callback);
    }
    
    public static var getUserFieldAction : String = "plants";
    public static function getUserField(callback:Function) : void
    {
      Server.instance.getXMl(GlobalVars.connectionData.urlConnection + getUserFieldAction,
        URLRequestMethod.GET, null, callback);
    }
		
		public static var createPlantAction : String = "plants";
		public static function createPlant(position:Point, typeId:int, growthStageId:int, callback:Function):void
		{
			var vars:URLVariables = new URLVariables();
			vars['x'] = position.x;
			vars['y'] = position.y;
			vars['element_type_id'] = typeId;
			vars['growth_stage_id'] = growthStageId;
			Server.instance.getXMl(GlobalVars.connectionData.urlConnection  + createPlantAction,
				URLRequestMethod.POST, vars, callback);
		}
		
		public static var qrowAllPlantAction : String = "plants/growth_all";
		public static function growAll(callback:Function) : void
		{
			Server.instance.getXMl(GlobalVars.connectionData.urlConnection + qrowAllPlantAction,
        URLRequestMethod.GET, null,callback);
		}
		
		public static var deletePlantAction : String = "plants";
		public static function deletePlant(plantId:int, callback:Function) : void
		{
			Server.instance.getXMl(GlobalVars.connectionData.urlConnection + deletePlantAction +
				"/" + plantId, URLRequestMethod.GET, null, callback);
		}
	}
}

	