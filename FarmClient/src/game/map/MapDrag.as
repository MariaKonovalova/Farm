package game.map 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Обеспечивает драг карты
	 **/
	public class MapDrag
	{
		/**Карта, которую перемещаем**/
		private var _map : Map;
		/**Положение карты по умолчанию*/
		private var defaultMapPosition : Point;
		/**Кол-во пикселей по x и y, которые необходимы чтобы начался drag*/
		private var deltaDrag : Point = new Point(5, 5);
		/**Минимальное положение карты*/
		private var minDrag : Point = new Point();
		/**Максимальное положение карты*/
		private var maxDrag : Point; 
		
		/**Идет ли драг в данный момент*/
		private var _isDrag : Boolean = false;
		/**Начальная позиция мышки до перемещения, нужна чтобы определить возможен ли драг**/
		private var firstPositionInDrag : Point = new Point(0, 0);
		/**Нажата ли кнопка мыши*/
		private var isMouseDown : Boolean = false;
		
		public function MapDrag(initMap : Map,
								maxDragX : int,
								maxDragY : int)
		{
			if (initMap)
			{
				_map = initMap;
				maxDrag = new Point(maxDragX, maxDragY);
				defaultMapPosition = new Point(maxDragX, maxDragY);
				_map.addEventListener(Event.ADDED_TO_STAGE, onMapAddedToStage);
			}
		}
				
		private function onMapAddedToStage(e : Event) : void
		{
			_map.removeEventListener(Event.ADDED_TO_STAGE, onMapAddedToStage);
			_map.removeEventListener(MouseEvent.ROLL_OVER, onMapRollOver);
			_map.removeEventListener(MouseEvent.ROLL_OUT, onMapRollOut);
			_map.addEventListener(MouseEvent.ROLL_OVER, onMapRollOver);
			_map.addEventListener(MouseEvent.ROLL_OUT, onMapRollOut);
		}
		
		private function onMapRollOver(e : MouseEvent) : void
		{
			if (_map.stage)
			{
				_map.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMapMouseDown);
				_map.stage.addEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
			}
		}
		
		private function onMapRollOut(e : MouseEvent) : void
		{
			if (_map.stage)
			{
				_map.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMapMouseDown);
				_map.stage.removeEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
			}
			onMapMouseLeave();
		}
		
		private function onMapMouseLeave() : void
		{
			if (isMouseDown)
			{
				_map.stopDrag();
				isMouseDown = false;
			}
		}
		
		private function onMapMouseDown(e : MouseEvent) : void
		{
			isMouseDown = true;
			firstPositionInDrag.x = e.target.x;
			firstPositionInDrag.y = e.target.y;
			
			_map.addEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
		}

		private function onMapMouseUp(e : MouseEvent) : void
		{
			if (_isDrag)
			{
				_map.stopDrag();
				_isDrag = false;
				_map.removeEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
			}
			
			isMouseDown = false;
		}
		
		private function onMapMouseMove(e : MouseEvent) : void
		{
			if (isMouseDown)
			{
				if (!_isDrag && canDrag())
				{
					setParameters(_map.stage.stageWidth, _map.stage.stageHeight);
					_map.startDrag(false, new Rectangle(minDrag.x * _map.scaleX,
													minDrag.y * _map.scaleY,
													(maxDrag.x - minDrag.x) * _map.scaleX,
													(maxDrag.y - minDrag.y) * _map.scaleY));
					_isDrag = true;
				}
			}
		}
		
		/**Проверка можно ли начать драг**/
		private function canDrag() : Boolean
		{
			if (Math.abs(firstPositionInDrag.x - _map.mouseX) > deltaDrag.x &&
				Math.abs(firstPositionInDrag.y - _map.mouseY) > deltaDrag.y)
			{
				return true;
			}
			else return false;
		}
		
		/**Задать параметры драга*/
		private function setParameters(screenWidth:Number, screenHeight:Number):void
		{	
			if (_map.land)
			{
				if (screenWidth <= _map.land.width)
				{
					maxDrag.x = defaultMapPosition.x;
					minDrag.x = maxDrag.x - (_map.land.width - screenWidth);
				}            
				else 
				{
					minDrag.x = Math.abs(screenWidth - _map.land.width) / 2 + defaultMapPosition.x;           	
					maxDrag.x = Math.abs(screenWidth - _map.land.width) / 2 + defaultMapPosition.x;         	           	
				}
				
				if (screenHeight <= _map.land.height)
				{
					maxDrag.y = defaultMapPosition.y;
					minDrag.y = maxDrag.y - (_map.land.height - screenHeight);
				}
				else 
				{
					minDrag.y = Math.abs(screenHeight - _map.land.height) / 2 + defaultMapPosition.y;           	
					maxDrag.y = Math.abs(screenHeight - _map.land.height) / 2 + defaultMapPosition.y;
				}
			}
		}
		
		/**Центрировать карту*/
		public function center(screenWidth:Number, screenHeight:Number) : void
		{
			if (_map.land)
			{
				if (screenWidth <= _map.land.width)
				{
					_map.x = maxDrag.x - (_map.land.width * _map.scaleX - screenWidth) / 2;
				}
				else
				{				
					_map.x = maxDrag.x
				}
				
				if (screenHeight <= _map.land.height)
				{
					_map.y = maxDrag.y - (_map.land.height * _map.scaleY - screenHeight) / 2;
				}
				else
				{
					_map.y = maxDrag.y;
				}
			}
		}
    
    public function get isDrag() : Boolean
    {
      return _isDrag;
    }
	}
}