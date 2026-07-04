package funkin.mobile;

import haxe.io.Bytes;

import openfl.utils.AssetType;
import openfl.Assets;
/**
 * backend for retrieving and caching assets
 */
@:nullSafety(Strict)
class FunkinAssets
{
	/**
	 * Reads a given directory and returns all file names inside.
	 * 
	 * if it could not be found, an empty array will be returned.
	 */
	public static function readDirectory(directory:String):Array<String>
	{
		if (directory.trim().length == 0) return [];
		var dir = Assets.list().filter(string -> string.contains(directory));
		return dir.map(string -> string.replace(directory, '').replace('/', ''));
	}
	
	public static function isDirectory(directory:String):Bool
	{
		// this method is a bit chopped...
		if (directory.trim().length == 0) return false;
		return Assets.list().filter(path -> path != directory && path.startsWith(directory)).length != 0;
	}
}
