#define PI 3.14159265359

//____________________________________________________________________________________________


struct appdata
{
    float4 vertex : POSITION;
};


struct v2f
{
    float4 vertex : SV_POSITION;
    float4 objPos : TEXCOORD0;
};


//____________________________________________________________________________________________


float4 _ScaleOffset;
float4 _B;


//____________________________________________________________________________________________



v2f vert (appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.objPos = v.vertex;
    return o;
}


//____________________________________________________________________________________________



float2 tran(float2x2 tr, float2 p)
{
    return float2(p.x * tr._m11, p.y * tr._m01) / (tr._m00 + tr._m10);
}


void square(float2 st)
{
    float2 border = 0.1;
    
    border -= 0.5;
    float2 lb = smoothstep(border, border + 0.01, st);
    float2 lbm = smoothstep(border + 0.05, border + 0.05 + 0.01, st);
    border += 0.8;
    float2 rt = smoothstep( st, st + 0.01, border );
    float2 rtm = smoothstep(st - 0.01, st, border - 0.05);

    float pct = lb.x * lb.y * rt.x * rt.y - lbm.x * lbm.y * rtm.x * rtm.y;
}


float smooth01(float x)
{
    return x * x * (3 - 2 * x);
}


float perlin(float x)
{
    return x * x * x * ( x * (x * 6 - 15) + 10);
}


float stepRand(float x)
{
    return frac(sin(floor(x)) * 999);
}


float smoothSaw(float x)
{
    return perlin(frac(x));
}


float smoothSaw2D(float2 xy)
{
    return perlin(frac(xy.x + xy.y));
}


float rand2D(float2 p)
{
    float2x2 m = float2x2(
        1, 999, 
        0, 1);
    float2 sp = tran(m, p);

    return frac(sin(sp.x + sp.y) * 999);
}


float stepRand2D(float2 p)
{
    return rand2D(floor(p));
}


float noise2D(float2 p)
{
    float2x2 mh = float2x2(
        1, 0, 
        0, 1);

    float2x2 mv = float2x2(
        0, -1, 
        1, 0);

// -----------------------------------------------
    float2 ph = tran(mh, p);

    float f1 =  smoothSaw2D(ph) * stepRand2D(p);
    ph = tran(mh, p - float2(1, 0));
    float f2 = (smoothSaw2D(ph) * -1 + 1) * stepRand2D(p - float2(1, 0));

    float fh = f1 + f2;
    
    float2 pv = tran(mv, p);
    float sfh = fh * smoothSaw2D(pv);

// -----------------------------------------------

    p += float2(0, 1);
    ph = tran(mh, p);

    f1 =  smoothSaw2D(ph) * stepRand2D(p);
    ph = tran(mh, p - float2(1, 0));
    f2 = (smoothSaw2D(ph) * -1 + 1) * stepRand2D(p - float2(1, 0));

    float fv = f1 + f2;
    
    pv = tran(mv, p);
    float sfv = fv * (smoothSaw2D(pv - float2(0, 1)) * -1 + 1);

// -----------------------------------------------

    return sfv + sfh;
}


fixed4 frag (v2f i) : SV_Target
{
    float2 st = i.objPos.xy;
    float2 stTime = st  * _ScaleOffset.xy + _ScaleOffset.zw + _Time.x * float2(1.0, 1.0) * _B.z;
    
    float2 p = float2(stTime.x, -stTime.y);

    float f = noise2D(p);
    f += noise2D(p * 2) / 2;
    f += noise2D(p * 4) / 4;
    f += noise2D(p * 8) / 8;
    f += (noise2D(p * 16) / 16);
    f *= 0.5;

    fixed3 n = fixed3(0,0,1) * saturate(-f) + saturate(f);


    fixed3 cf = plot(st.y, f / _ScaleOffset.x + _ScaleOffset.z, _B.w)
        * float3(1.0f, 1.0f, 0.0f) * 1.0f;

    fixed3 finalColor = (1 - cf.r) * (n * 1) + cf;
    fixed3 cc = coordGrid(st, 0.1f, 0.5f, 0.001f);    
    finalColor = finalColor * (1 - cc.r) * (1 - cc.g) + cc;
    return fixed4(finalColor, 1.0f);
}


//____________________________________________________________________________________________









