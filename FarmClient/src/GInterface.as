package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.elements.Element;
	import game.elements.Elements;
	import game.map.Map;
	
	import global.GlobalVars;
	import global.ServerQueries;
	
	import org.osmf.composition.SerialElement;
	
	import ui.buttons.CustomButton;
	import game.map.MapEditEvent;
	import game.plants.Plant;
	import game.plants.PlantMenu;

	public class GInterface extends Sprite
	{
		public const LEFT_INDENT:int = 20;
		public const TOP_INDENT:int = 40;
		public const BTN_INDENT:int = 10;
		
		public const PLANT_TXT:String = "Посадить";
		public const DEL_PLANT_TXT:String = "Собрать";
		public const DO_GROWTH_TXT:String = "Ход";
		
		/**Кнопка посадить растение*/
		private var _plantBtn : SimpleButton;
		/**Кнопка собрать растение*/
		private var _delPlantBtn : SimpleButton;
		/**Кнопка сделать ход*/
		private var _doGrowthBtn : SimpleButton;
		
		private var plantMenu : PlantMenu;
		private var urlIconSWF : String = GlobalVars.connectionData.iconsFolder + "icons.swf";
		private var isVisibleMenu : Boolean = false;
		
		public static var instance : GInterface = new GInterface();
		
		public function GInterface()
		{
			if (stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function init(e:Event = null) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			//Создаем кнопки для действий пользователя
			//Посадить растение
			_plantBtn = new CustomButton(PLANT_TXT, new Point(60, 32));
			_plantBtn.x = this.stage.stageWidth - _plantBtn.width - LEFT_INDENT;
			_plantBtn.y = plantBtn.height + TOP_INDENT;
			//Собрать растение
			_delPlantBtn = new CustomButton(DEL_PLANT_TXT, new Point(60, 32));
			_delPlantBtn.x = _plantBtn.x;
			_delPlantBtn.y = _plantBtn.y + _plantBtn.height + BTN_INDENT;
			//Сделать ход
			_doGrowthBtn = new CustomButton(DO_GROWTH_TXT, new Point(60, 32));
			_doGrowthBtn.x = _plantBtn.x;
			_doGrowthBtn.y = _delPlantBtn.y + _delPlantBtn.height + BTN_INDENT;
			
			addBtnListeners();

			this.addChild(_plantBtn);
      this.addChild(_delPlantBtn);
      this.addChild(_doGrowthBtn);
			plantMenu = new PlantMenu(0xF8F8FF, new Point(147, _plantBtn.height), urlIconSWF);
			plantMenu.x = _plantBtn.x - plantMenu.size.x;
			plantMenu.y = _plantBtn.y;
		}
		private function addBtnListeners():void
		{
			_plantBtn.addEventListener(MouseEvent.CLICK, onBtnPlantClick, false, 0, true);
      _delPlantBtn.addEventListener(MouseEvent.CLICK, onBtnDelClick, false, 0, true);
      _doGrowthBtn.addEventListener(MouseEvent.CLICK, onBtnGrowthClick, false, 0, true);
		}
		private function onBtnPlantClick(e:MouseEvent) : void
		{
			if (!isVisibleMenu)
			{
				this.addChild(plantMenu);
			}
			else
			{
				this.removeChild(plantMenu);
			}
      
			isVisibleMenu = !isVisibleMenu;
		}
    
    private function onBtnDelClick(e:MouseEvent):void
    {
      var plant:Plant = GameContainer.instance.map.plants.selectedPlant;
      if (plant)
      {
        FarmClient.mainMovie.dispatchEvent(new MapEditEvent(MapEditEvent.DELETE_PLANT,
          null, plant));
      }
    }
    
    private function onBtnGrowthClick(e:MouseEvent):void
    {
      var map:Map = GameContainer.instance.map
      var plant:Plant;
      var element:Element;

      ServerQueries.growAll(function(answer:XML) : void{
        if (answer.name().toString() == "Error")
        {
          trace(answer.children().toString());
        }
        else
        {
          for each (var pl:XML in answer.*)
          {
            if (map)
            {
              if (map.plants)
              {
                plant = map.plants.getPlantById(pl.attribute("id"))
                if (plant)
                {
                  element = Elements.getElemByTypeAndGrowth(pl.attribute("element_type_id"),
                    pl.attribute("growth_stage_id"));
                  if (element)
                  {
                    plant.element = element;
                  }
                }
              }
            }
            GameContainer.instance.map
          }
        }
      }); 
    }
		public function get plantBtn():SimpleButton
		{
			return _plantBtn;
		}
		public function get delPlantBtn():SimpleButton
		{
			return _delPlantBtn;
		}
		public function get doGrowthBtn():SimpleButton
		{
			return _doGrowthBtn;
		}
	}
}