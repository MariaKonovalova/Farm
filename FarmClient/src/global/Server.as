package global
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import game.elements.ElementType;

	public class Server
	{
		private var loader : URLLoader;
    		private var _callback : Function = null;
		
		public static var instance:Server = new Server();
		
		public function getXMl(rUrl:String, 
					rMethod:String = "", 
					rVars:URLVariables = null,
                 			callback:Function = null) : void
		{
      			if (callback as Function)
      			{
        			_callback = callback;
      			}

			loader = new URLLoader();
			var request:URLRequest = new URLRequest(rUrl);
			
			if (rMethod) 
			{
				request.method = rMethod;
			}
			
			if (rVars)
			{
				request.data = rVars;
			}
			
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(ErrorEvent.ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
      
      			loader.load(request);
		}
	
		private function onComplete(e:Event):void
		{
			freeListeners();

      			if (_callback as Function)
      			{
        			this._callback(new XML(e.target.data));
      			}
		}
		
		private function onError(e:Event):void
		{
      			freeListeners();
      			trace(e);
		}
    
    		private function freeListeners() : void
    		{
      			loader.removeEventListener(Event.COMPLETE, onComplete);
      			loader.removeEventListener(ErrorEvent.ERROR, onError);
      			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
      			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
    		}
	}
}