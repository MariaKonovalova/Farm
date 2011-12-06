package global
{
	public class ConnectionData
	{
		public static const LOCAL : int = 0;
		public static const SERVER : int = 1;
		
		public var urlConnection : String = "http://localhost:3000/";
		public var bgFolder : String;
		public var iconsFolder : String;
    public var plantsFolder : String;
		
		public function ConnectionData(networkType:int)
		{
			if (networkType == ConnectionData.LOCAL)
			{
				urlConnection = "http://localhost:3000/";
				bgFolder = "data/bg/";
				iconsFolder = "data/icons/";
        plantsFolder = "data/plants/";
			}
			else
			{
			}
		}
	}
}