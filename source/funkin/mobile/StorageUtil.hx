/*
 * Copyright (C) 2026 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package funkin.mobile;

/**
 * A storage class for mobile.
 * @author Karim Akra and Homura Akemi (HomuHomu833)
 */
 
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

import haxe.io.Path;
import haxe.Exception;

import lime.utils.Assets;

import openfl.system.System;
 
class StorageUtil
{
	#if sys
	public static function getStorageDirectory():String
	{
	    #if android
	    return haxe.io.Path.addTrailingSlash(AndroidContext.getExternalFilesDir());
	    #elseif ios
	    return lime.system.System.documentsDirectory;
	    #else 
	    return Sys.getCwd();
	    #end
	}
	
	public static function getExternalStorageDirectory():String
		return '/sdcard/.ImpostorLegacy/';
	
	#if android
	public static function requestPermissions():Void
	{
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			AndroidPermissions.requestPermissions(['READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO', 'READ_MEDIA_AUDIO']);
		else
			AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
	}
	#end
	
	public static function copyNecessaryFiles():Void
	{
		#if MODS_ALLOWED
		for (dir in ['data', 'lang', 'mobile', 'stages'])
		{
			for (file in Assets.list().filter(folder -> folder.startsWith('assets/$dir')))
			{
				if (Path.extension(file) == 'json')
				{
					// Ment for FNF's libraries system...
					final shit:String = file.replace(file.substring(0, file.indexOf('/', 0) + 1), '');
					final library:String = shit.replace(shit.substring(shit.indexOf('/', 0), shit.length), '');

					@:privateAccess
					StorageUtil.copyFile(Assets.libraryPaths.exists(library) ? '$library:$file' : file, file);
				}
			}
		}
		
		for (dir in ['data', 'scripts', 'songs', 'stages'])
		{
			for (file in Assets.list().filter(folder -> folder.startsWith('assets/$dir')))
			{
				if (Path.extension(file) == 'hx' || Path.extension(file) == 'hscript' || Path.extension(file) == 'hxs')
				{
					// Ment for FNF's libraries system...
					final shit:String = file.replace(file.substring(0, file.indexOf('/', 0) + 1), '');
					final library:String = shit.replace(shit.substring(shit.indexOf('/', 0), shit.length), '');

					@:privateAccess
					StorageUtil.copyFile(Assets.libraryPaths.exists(library) ? '$library:$file' : file, file);
				}
			}
		}
		
		for (dir in ['data'])
		{
			for (file in Assets.list().filter(folder -> folder.startsWith('assets/$dir')))
			{
				if (Path.extension(file) == 'txt')
				{
					// Ment for FNF's libraries system...
					final shit:String = file.replace(file.substring(0, file.indexOf('/', 0) + 1), '');
					final library:String = shit.replace(shit.substring(shit.indexOf('/', 0), shit.length), '');

					@:privateAccess
					StorageUtil.copyFile(Assets.libraryPaths.exists(library) ? '$library:$file' : file, file);
				}
			}
		}
		#end
		
		#if VIDEOS_ALLOWED
		for (file in Assets.list().filter(folder -> folder.startsWith('assets/videos')))
		{
			if (Path.extension(file) == 'mp4')
			{
				// Ment for FNF's libraries system...
				final shit:String = file.replace(file.substring(0, file.indexOf('/', 0) + 1), '');
				final library:String = shit.replace(shit.substring(shit.indexOf('/', 0), shit.length), '');

				@:privateAccess
				StorageUtil.copyFile(Assets.libraryPaths.exists(library) ? '$library:$file' : file, file);
			}
		}
		#end

		System.gc();
	}

	/**
	 * This is mostly a fork of https://github.com/openfl/hxp/blob/master/src/hxp/System.hx#L595
	 */
	public static function mkDirs(directory:String):Void
	{
		var total:String = '';

		if (directory.substr(0, 1) == '/')
			total = '/';

		final parts:Array<String> = directory.split('/');

		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part.length > 0)
			{
				if (total != '/' && total.length > 0)
					total += '/';

				total += part;

				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
			}
		}
	}

	public static function copyFile(copyPath:String, savePath:String):Void
	{
		try
		{
			if (!FileSystem.exists(savePath) && Assets.exists(copyPath))
			{
				if (!FileSystem.exists(Path.directory(savePath)))
					StorageUtil.mkDirs(Path.directory(savePath));

				File.saveBytes(savePath, Assets.getBytes(copyPath));
			}
		}
		catch (e:Exception)
			trace(e.message);
	}
	#end
}