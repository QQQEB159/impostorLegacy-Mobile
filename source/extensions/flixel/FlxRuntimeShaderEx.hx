package extensions.flixel;

import flixel.addons.display.FlxRuntimeShader;

import openfl.display.ShaderInput;

class FlxRuntimeShaderEx extends FlxRuntimeShader    
{
    public function setBitmapData(name:String, value:openfl.display.BitmapData):Void
	{
		var prop:ShaderInput<openfl.display.BitmapData> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader sampler2D property ${name} not found.');
			return;
		}
		prop.input = value;
	}
}