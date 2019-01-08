Shader "Neitron/SiFi Fire"
{
	Properties
	{
		[Toogle]_Grid("Grid", Float) = 0
		_FireSettings("Pixel Size, Speed, Fire Height, Rand", Vector) = (10.0, 1.0, 1.0, 0.0)
		_Color0("Color 0", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color1("Color 1", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color2("Color 2", Color) = (1.0, 1.0, 1.0, 1.0)
		_Color3("Color 3", Color) = (1.0, 1.0, 1.0, 1.0)
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "../Cg/Helpers.cginc"
			#include "SiFi Fire.cginc"

			ENDCG
		}
	}
}

