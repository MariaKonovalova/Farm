package global.swfloader
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;

	public class SWFByteArray extends ByteArray 
	{	
		/**
		 * @private
		 */
		private static const TAG_SWF:String = 'FWS';
		
		/**
		 * @private
		 */
		private static const TAG_SWF_COMPRESSED:String = 'CWS';
		
		public function SWFByteArray(data:ByteArray=null):void {
			super();
			super.endian = Endian.LITTLE_ENDIAN;
			var endian:String;
			var tag:String;
			
			if (data) {
				endian = data.endian;
				data.endian = Endian.LITTLE_ENDIAN;
				
				if (data.bytesAvailable > 26) {
					tag = data.readUTFBytes(3);
					
					if (tag == SWFByteArray.TAG_SWF || tag == SWFByteArray.TAG_SWF_COMPRESSED) {
						this._version = data.readUnsignedByte();
						data.readUnsignedInt();
						data.readBytes(this);
						if (tag == SWFByteArray.TAG_SWF_COMPRESSED) super.uncompress();
					} else throw new ArgumentError('Error #2124: Loaded file is an unknown type.');
					
					this.readHeader();
				}
				
				data.endian = endian;
			}
		}
		
		/**
		 * @private
		 */
		private var _bitIndex:uint;
		
		/**
		 * @private
		 */
		private var _version:uint;
		
		public function get version():uint {
			return this._version;
		}
		
		/**
		 * @private
		 */
		private var _frameRate:Number;
		
		public function get frameRate():Number {
			return this._frameRate;    
		}
		
		/**
		 * @private
		 */
		private var _rect:Rectangle;
		
		public function get rect():Rectangle {
			return this._rect;
		}
		
		public function writeBytesFromString(bytesHexString:String):void {
			var length:uint = bytesHexString.length;
			
			for (var i:uint = 0;i<length;i += 2) {
				var hexByte:String = bytesHexString.substr(i, 2);
				var byte:uint = parseInt(hexByte, 16);
				writeByte(byte);
			}
		}
		
		public function readRect():Rectangle {
			var pos:uint = super.position;
			var byte:uint = this[pos];
			var bits:uint = byte >> 3;
			var xMin:Number = this.readBits(bits, 5) / 20;
			var xMax:Number = this.readBits(bits) / 20;
			var yMin:Number = this.readBits(bits) / 20;
			var yMax:Number = this.readBits(bits) / 20;
			super.position = pos + Math.ceil(((bits * 4) - 3) / 8) + 1;
			return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
		}
		
		public function readBits(length:uint, start:int = -1):Number {
			if (start < 0) start = this._bitIndex;
			this._bitIndex = start;
			var byte:uint = this[super.position];
			var out:Number = 0;
			var shift:Number = 0;
			var currentByteBitsLeft:uint = 8 - start;
			var bitsLeft:Number = length - currentByteBitsLeft;
			
			if (bitsLeft > 0) {
				super.position++;
				out = this.readBits(bitsLeft, 0) | ((byte & ((1 << currentByteBitsLeft) - 1)) << (bitsLeft));
			} else {
				out = (byte >> (8 - length - start)) & ((1 << length) - 1);
				this._bitIndex = (start + length) % 8;
				if (start + length > 7) super.position++;
			}
			
			return out;
		}
		
		public function readASInt():int {
			var result:uint = 0;
			var i:uint = 0, byte:uint;
			do {
				byte = super.readUnsignedByte();
				result |= ( byte & 0x7F ) << ( i*7 );
				i+=1;
			} while ( byte & 1<<7 );
			return result;            
		}
		
		public function readString():String {
			var i:uint = super.position;
			while (this[i] && (i+=1)){};
			var str:String = super.readUTFBytes(i - super.position);
			super.position = i+1; 
			return str;
		}
		
		public function traceArray(array:ByteArray):String { // for debug
			var out:String = '';
			var pos:uint = array.position;
			var i:uint = 0;
			array.position = 0;
			
			while (array.bytesAvailable) {
				var str:String = array.readUnsignedByte().toString(16).toUpperCase();
				str = str.length < 2 ? '0'+str : str;
				out += str+' ';
			}
			
			array.position = pos;
			return out;
		}
		
		/**
		 * @private
		 */
		private function readFrameRate():void {
			if (this._version < 8) {
				this._frameRate = super.readUnsignedShort();
			} else {
				var fixed:Number = super.readUnsignedByte() / 0xFF;
				this._frameRate = super.readUnsignedByte() + fixed;
			}
		}
		
		/**
		 * @private
		 */
		private function readHeader():void {
			this._rect = this.readRect();
			this.readFrameRate();        
			super.readShort(); // num of frames
		}
	}
}