
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

fixed4 frag (v2f i) : SV_Target
{
    float4 st = i.objPos;
    
    //plot(

    fixed3 grid = coordGrid(st, 0.1f, 0.5f, 0.001f) * _Grid; 
    fixed3 finalColor = grid;
    return fixed4(finalColor, 1.0f);
}