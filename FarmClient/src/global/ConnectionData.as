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
				bgFolder = "D:/workspace/FarmClient/data/bg/";
				iconsFolder = "D:/workspace/FarmClient/data/icons/";
        plantsFolder = "D:/workspace/FarmClient/data/plants/";
			}
			else
			{
			}
		}
	}
}