Shader "Neitron/RayMarch Surf"
{
    Properties
    {
		_Settings("Max Ray Steps, MinDistance, Radius, CamPosZ", Vector) = (10.0, 1.0, 1.0, 0.0)
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
		Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 200
		Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade
		#include "../Cg/Helpers.cginc"
		#include "RayMarch.cginc"
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float3 viewDir;
        };

        //half _Glossiness;
        //half _Metallic;
        //fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float3 p; // closest point
			float3 viewDir = normalize(-IN.viewDir);
			float res = trace(_WorldSpaceCameraPos, -viewDir, p);

            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed3 finalColor = _Color.rgb * res;
            o.Albedo = finalColor;
            o.Alpha = step(length(p), 200);
            
			float3 xDir = float3(_Settings.y, 0.0f, 0.0f);
			float3 yDir = float3(0.0f, _Settings.y, 0.0f);
			float3 zDir = float3(0.0f, 0.0f, _Settings.y);

			float3 norm = normalize(float3(
				sceneSDF(p + xDir) - sceneSDF(p - xDir),
				sceneSDF(p + yDir) - sceneSDF(p - yDir),
				sceneSDF(p + zDir) - sceneSDF(p - zDir)));

			o.Normal = norm;

			// Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
