Shader "Neitron/Perlin Noise"
{
    Properties
    {
		[ScaleOffset] _ScaleOffset("ST", Vector) = (1.0, 1.0, 0.0, 0.0)
		_B("Scale (x, y), Speed (z), Width (w)", Vector) = (0.01, 0.0, 0.0, 0.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "../Cg/Helpers.cginc"
			#include "Perlin Noise.cginc"
            
            ENDCG
        }
    }
}
