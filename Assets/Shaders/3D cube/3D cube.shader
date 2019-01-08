Shader "Neitron/3D Cube"
{
	Properties
	{
		[Toogle]_Grid("Grid", Float) = 0
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
			#include "3D Cube.cginc"

			ENDCG
		}
	}
}

