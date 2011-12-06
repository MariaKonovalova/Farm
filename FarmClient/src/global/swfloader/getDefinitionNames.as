/**
* getDefinitionNames by Denis Kolyako. August 13, 2008. Updated March 9, 2010.
* Visit http://etcs.ru for documentation, updates and more free code.
*
* You may distribute this class freely, provided it is not modified in any way (including
* removing this header or changing the package path).
* 
*
* Please contact etc[at]mail.ru prior to distributing modified versions of this class.
*/
package global.swfloader 
{
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	/**
	 * getDefinitionNames function
	 * 
	 * @author					etc
	 * @version					2.1
	 * @playerversion			Flash 9.0.45+
	 * @langversion				3.0
	 */
	/**
	 * Return an array of class names in LoaderInfo object.
	 * 
	 * @param	data		Associated LoaderInfo object or a ByteArray, which contains swf data.
	 * 
	 * @param	extended	If false, function returns only classes.
	 * 						If true, function return all visible definitions (classes, interfaces, functions, namespaces, variables, constants, vectors, etc.).
	 * 						Extended mode is slightly slower than a regular search.
	 * 
	 * @param	linkedOnly	If true, function returns only linked classes (objects with linkage), MUCH faster than regular or extended search.
	 * 						This mode is preferable if you need only graphic resources (sprites, bitmaps, fonts, etc.).
	 * 						NB: "extended" parameter will be ignored if this argument is true.	
	 */ 
	public function getDefinitionNames(data:Object, extended:Boolean = false, linkedOnly:Boolean = false):Array {
		var bytes:ByteArray;
		
		if (data is LoaderInfo) {
			bytes = (data as LoaderInfo).bytes;
		} else if (data is ByteArray) {
			bytes = data as ByteArray;
		} else throw new ArgumentError('Error #1001: The specified data is invalid');
		
		var position:uint = bytes.position;
		var finder:Finder = new Finder(bytes);
		bytes.position = position;
		return finder.getDefinitionNames(extended, linkedOnly);
	}
}