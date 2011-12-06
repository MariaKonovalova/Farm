package ui.buttons
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class CustomButton extends SimpleButton
	{
		private var _text:String;
		private var _upColor:uint = 0xF8F8FF;
		private var _overColor:uint = 0xE8E8E8;
		private var _downColor:uint = 0xCFCFCF;
		private var _size:Point = new Point(60, 40);
		
		public function CustomButton(btnText:String, size:Point = null)
		{
			_text = btnText;
			
			if (size)
			{
				_size = size;
			}
			
			downState = new ButtonSprite(_downColor, _size, _text);
			overState = new ButtonSprite(_overColor, _size, _text);
			upState = new ButtonSprite(_upColor, _size, _text);
			hitTestState = new ButtonSprite(_overColor, _size, _text);
		}
		
		public function get text():String
		{
			return _text;
		}
	}
}