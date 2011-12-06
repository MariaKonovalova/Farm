package controllers
{
  import flash.system.System;
  import flash.utils.ByteArray;
  import flash.geom.Point;
  import flash.utils.setInterval;
  import flash.net.LocalConnection;
  import flash.utils.setTimeout;
  
  public class MemoryController
  {
    private var mInterval:int; //Интервал обновления, в милисекундах
    private var mWarningMemoryLimit:int; // Размер порога памяти, при котором начинается форсированное очищение
    private var mCriticalMemoryLimit:int; // Размер порога памяти, который является критическим
    private var mAbortFunction:Function; // Функция, вызываемая при достижени критического порога
    private var mWarningFunction:Function; // Функция, вызываемая при достежении опасного порога
    private var mForcedIterationsNum:int;  // Количество принудительных итераций GC, при достижении порога
    private var mForcedCleanInterval:int;  // мин. интервал в милисекундах между принудительными очистками
    private var mIsAbleToForce:Boolean;
    
    public function MemoryController(refreshInterval:int = 1000, warningMemoryLimit:int = 1024*1024*60, 
                                     criticalMemoryLimit:int = 1024*1024*100, forcedCleanInterval:int = 60000, 
                                     forcedIterationsNum:int = 1,
                                     abortFunction:Function = null, warningFunction:Function = null):void
    {
      mInterval = refreshInterval;
      mWarningMemoryLimit = warningMemoryLimit;
      mCriticalMemoryLimit = criticalMemoryLimit;
      mAbortFunction = abortFunction;
      mWarningFunction = warningFunction;
      mForcedIterationsNum = forcedIterationsNum;
      mForcedCleanInterval = forcedCleanInterval;
      mIsAbleToForce = true;
      setInterval(checkMemoryUsage, mInterval);
    }
    
    private function doSimpleClean():void
    {
      var A:Point = new Point();
      A = null;
      var B:String = new String('1234567812345678');
      B = null;
      var C:Array = new Array();			
      var i:int = 0;
      
      for (i=0; i<256; i++)
        C.push(new String('a'));
      
      for (i=0; i<256; i++)
        delete C[i];				
      
      C = null;
    }
    
    private function MakeAbleToForce():void
    {
      mIsAbleToForce = true;
    }
    
    private function doForcedClean():void
    { //HACK - позволяет вызвать принудительную итерацию GC
      if (!mIsAbleToForce)
        return;
      
      var i:int = 0;
      for (i=0; i<mForcedIterationsNum; i++)
      {
        try {
          new LocalConnection().connect('Crio');
          new LocalConnection().connect('Crio');
        } catch (e:*) {}
      }
      
      mIsAbleToForce = false;
      setTimeout(MakeAbleToForce, mForcedCleanInterval);
    }
    
    private function checkMemoryUsage():void
    {
      if (System.totalMemory > mWarningMemoryLimit) 
      {
        doForcedClean();
        if (mWarningFunction)
          mWarningFunction();		      
      } else if (System.totalMemory > mCriticalMemoryLimit) 
      {
        if (mAbortFunction)		      
          mAbortFunction();
        doForcedClean();
      }
    }		
  }
}