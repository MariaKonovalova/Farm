package ui.buttons
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ButtonSprite extends Sprite
	{
		private const DIFF_DIST:uint = 6;
		
		private var _bgColor:uint;
		private var _size:Point; 
		private var _text:String;
		
		public function ButtonSprite(bgColor:uint, size:Point, btnText:String)
		{
			this._bgColor = bgColor;
			this._size = size;
			this._text = btnText;
			
			var txtField:TextField = new TextField();
			txtField.text = _text;
			txtField.autoSize = TextFieldAutoSize.LEFT;
			if (txtField.width > _size.x)
			{
				_size.x = txtField.width + DIFF_DIST;
			}
			
			draw();
			
			txtField.x = (_size.x - txtField.width) / 2;
			txtField.y = (_size.y - txtField.height) / 2;
			this.addChild(txtField);
		}
		
		private function draw():void
		{
			this.graphics.beginFill(_bgColor);
			this.graphics.drawRoundRect(0, 0, _size.x, _size.y, 10, 10); 
			this.graphics.endFill();
		}
	}
}