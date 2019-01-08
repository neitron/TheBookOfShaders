
struct appdata
{
    float4 vertex : POSITION;
};


struct v2f
{
    float4 vertex : SV_POSITION;
    float4 objPos : TEXCOORD0;
};


v2f vert (appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.objPos = v.vertex;
    return o;
}

bool _Grid;
float4 _FireSettings;

fixed4 _Color0;
fixed4 _Color1;
fixed4 _Color2;
fixed4 _Color3;


fixed4 frag (v2f i) : SV_Target
{
    float2 st = i.objPos.xy + 0.5;

    float pixSize = _FireSettings.x;
    float iPixSize = 1.0f / pixSize;
    float speed = iPixSize * _FireSettings.y;

    float rand = frac( sin( floor( st.x * pixSize ) ) * 999);
    
    float f = floor( frac( _Time.y * speed + rand * _FireSettings.w ) * pixSize ) * iPixSize; 
    float cf = plotStep(st.y, f, iPixSize * _FireSettings.z);
    fixed3 fireColor = cf * lerp( _Color0.rgb, lerp(_Color1.rgb, lerp(_Color2.rgb, _Color3.rgb, f * _Color2.a), f * 2.0f * _Color1.a), f * 4.0f * _Color0.a);

    for (float i = iPixSize; i < 1.0f; i = saturate(i + iPixSize))
    {
        f = floor( frac( _Time.y * speed + i + rand * _FireSettings.w ) * pixSize ) * iPixSize; 
        cf = plotStep(st.y, f, iPixSize * _FireSettings.z);
        f = saturate(f + i * 0.4);
        fireColor += cf * lerp( _Color0.rgb, lerp(_Color1.rgb, lerp(_Color2.rgb, _Color3.rgb, f * _Color2.a), f * 2.0f * _Color1.a), f * 4.0f * _Color0.a);
    }

    fixed3 cc = coordGrid(st, iPixSize, 1.0f, 0.001f) * _Grid; 
    fixed3 finalColor = fireColor * (1 - cc.r) * (1 - cc.g) + cc;

    return fixed4(finalColor, 1.0f);
}