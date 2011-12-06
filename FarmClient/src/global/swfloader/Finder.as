package global.swfloader
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	/**
	 * @private
	 */
	public class Finder {
		
		public function Finder(bytes:ByteArray) 
		{
			super();
			this._data = new SWFByteArray(bytes);
		}
		
		/**
		 * @private
		 */
		private var _data:SWFByteArray;
		
		/**
		 * @private
		 */
		private var _stringTable:Array;
		
		/**
		 * @private
		 */
		private var _namespaceTable:Array;
		
		/**
		 * @private
		 */
		private var _multinameTable:Array;
		
		public function getDefinitionNames(extended:Boolean, linkedOnly:Boolean):Array {
			var definitions:Array = new Array();
			var tag:uint;
			var id:uint;
			var length:uint;
			var minorVersion:uint;
			var majorVersion:uint;
			var position:uint;
			var name:String;
			var index:int;
			
			while (this._data.bytesAvailable) {
				tag = this._data.readUnsignedShort();
				id = tag >> 6;
				length = tag & 0x3F;
				length = (length == 0x3F) ? this._data.readUnsignedInt() : length;
				position = this._data.position;
				
				if (linkedOnly) {
					if (id == 76) {
						var count:uint = this._data.readUnsignedShort();
						
						while (count--) {
							this._data.readUnsignedShort(); // Object ID
							name = this._data.readString();
							index = name.lastIndexOf('.');
							if (index >= 0) name = name.substr(0, index) + '::' + name.substr(index + 1); // Fast. Simple. Cheat ;)
							definitions.push(name);
						}
					}
				} else {
					switch (id) {
						case 72:
						case 82:
							if (id == 82) {
								this._data.position += 4;
								this._data.readString(); // identifier
							}
							
							minorVersion = this._data.readUnsignedShort();
							majorVersion = this._data.readUnsignedShort();
							if (minorVersion == 0x0010 && majorVersion == 0x002E) definitions.push.apply(definitions, this.getDefinitionNamesInTag(extended));
							break;
					}
				}
				
				this._data.position = position + length;
			}
			
			return definitions;
		}
		
		/**
		 * @private
		 */
		private function getDefinitionNamesInTag(extended:Boolean):Array {
			var classesOnly:Boolean = !extended;
			var count:int;
			var kind:uint;
			var id:uint;
			var flags:uint;
			var counter:uint;
			var ns:uint;
			var names:Array = new Array();
			this._stringTable = new Array();
			this._namespaceTable = new Array();
			this._multinameTable = new Array();
			
			// int table
			count = this._data.readASInt() - 1;
			
			while (count > 0 && count--) {
				this._data.readASInt();
			}
			
			// uint table
			count = this._data.readASInt() - 1;
			
			while (count > 0 && count--) {
				this._data.readASInt();
			}
			
			// Double table
			count = this._data.readASInt() - 1;
			
			while (count > 0 && count--) {
				this._data.readDouble();
			}
			
			// String table
			count = this._data.readASInt()-1;
			id = 1;
			
			while (count > 0 && count--) {
				this._stringTable[id] = this._data.readUTFBytes(this._data.readASInt());
				id++;
			}
			
			// Namespace table
			count = this._data.readASInt() - 1;
			id = 1;
			
			while (count > 0 && count--) {
				kind = this._data.readUnsignedByte();
				ns = this._data.readASInt();
				if (kind == 0x16) this._namespaceTable[id] = ns; // only public
				id++;
			}
			
			// NsSet table
			count = this._data.readASInt() - 1;
			
			while (count > 0 && count--) {
				counter = this._data.readUnsignedByte();
				while (counter--) this._data.readASInt();
			}
			
			// Multiname table
			count = this._data.readASInt() - 1;
			id = 1;
			
			while (count > 0 && count--) {
				kind = this._data.readASInt();
				
				switch (kind) {
					case 0x07:
					case 0x0D:
						ns = this._data.readASInt();
						this._multinameTable[id] = [ns, this._data.readASInt()];
						break;    
					case 0x0F:
					case 0x10:
						this._multinameTable[id] = [0, this._stringTable[this._data.readASInt()]];
						break;    
					case 0x11:
					case 0x12:
						break;    
					case 0x09:
					case 0x0E:
						this._multinameTable[id] = [0, this._stringTable[this._data.readASInt()]];
						this._data.readASInt();
						break;    
					case 0x1B:
					case 0x1C:
						this._data.readASInt();
						break;
					case 0x1D: // Generic
						if (extended) {
							var multinameID:uint = this._data.readASInt(); // u8 or u30, maybe YOU know?
							var params:uint = this._data.readASInt(); // param count (u8 or u30), should always to be 1 in current ABC versions
							name = this.getName(multinameID);
							
							while (params--) {
								var paramID:uint = this._data.readASInt();
								
								if (name) { // not the best method, i know
									name = name + '.<' + this.getName(paramID) + '>';
									names.push(name);
								}
							}
							
							this._multinameTable[id] = [0, name];
						} else {
							this._data.readASInt();
							this._data.readASInt();
							this._data.readASInt();
						}
						break;    
				}
				
				id++;
			}
			
			// Method table
			count = this._data.readASInt();
			
			while (count > 0 && count--) {
				var paramsCount:int = this._data.readASInt();
				counter = paramsCount;
				this._data.readASInt();
				while (counter--) this._data.readASInt();
				this._data.readASInt();
				flags = this._data.readUnsignedByte();
				
				if (flags & 0x08) {
					counter = this._data.readASInt();
					
					while (counter--) {
						this._data.readASInt();
						this._data.readASInt();
					}
				}
				
				if (flags & 0x80) {
					counter = paramsCount;
					while (counter--) this._data.readASInt();
				}
			}
			
			// Metadata table
			count = this._data.readASInt();
			
			while (count > 0 && count--) {
				this._data.readASInt();
				counter = this._data.readASInt();
				
				while (counter--) {
					this._data.readASInt();
					this._data.readASInt();
				}
			}
			
			// Instance table
			count = this._data.readASInt();
			var classCount:uint = count;
			var name:String;
			var isInterface:Boolean;
			
			while (count > 0 && count--) {
				id = this._data.readASInt();
				this._data.readASInt();
				flags = this._data.readUnsignedByte();
				if (flags & 0x08) ns = this._data.readASInt();
				isInterface = Boolean(flags & 0x04);
				counter = this._data.readASInt();
				while (counter--) this._data.readASInt();
				this._data.readASInt(); // iinit
				this.readTraits();
				
				if (classesOnly && !isInterface) {
					name = this.getName(id);
					if (name) names.push(name);
				}
			}
			
			if (classesOnly) return names;
			
			// Class table
			count = classCount;
			
			while (count && count--) {
				this._data.readASInt(); // cinit
				this.readTraits();
			}
			
			// Script table
			count = this._data.readASInt();
			var traits:Array;
			
			while (count && count--) {
				this._data.readASInt(); // init
				traits = this.readTraits(true);
				if (traits.length) names.push.apply(names, traits);
			}
			
			return names;
		}
		
		/**
		 * @private
		 */
		private function readTraits(buildNames:Boolean = false):Array {
			var kind:uint;
			var counter:uint;
			var ns:uint;
			var id:uint;
			var traitCount:uint = this._data.readASInt();
			var names:Array;
			var name:String;
			if (buildNames) names = [];
			
			while (traitCount--) {
				id = this._data.readASInt(); // name
				kind = this._data.readUnsignedByte();
				var upperBits:uint = kind >> 4;
				var lowerBits:uint = kind & 0xF;
				this._data.readASInt();
				this._data.readASInt();
				
				switch (lowerBits) {
					case 0x00:
					case 0x06:
						if (this._data.readASInt()) this._data.readASInt();
						break;
				}
				
				if (buildNames) {
					name = this.getName(id);
					if (name) names.push(name);
				}
				
				if (upperBits & 0x04) {
					counter = this._data.readASInt();
					while (counter--) this._data.readASInt();
				}
			}
			
			return names;
		}
		
		/**
		 * @private
		 */
		private function getName(id:uint):String {
			if (!(id in this._multinameTable)) return null;
			var mn:Array = this._multinameTable[id] as Array;
			var ns:uint = mn[0] as uint;
			var nsName:String = this._stringTable[this._namespaceTable[ns] as uint] as String;
			var name:String = mn[1] is String ? mn[1] : (this._stringTable[mn[1] as uint] as String);
			if (nsName && nsName.indexOf('__AS3__') < 0 /* cheat! */) name = nsName + '::' + name;
			return name;
		}	
	}
}