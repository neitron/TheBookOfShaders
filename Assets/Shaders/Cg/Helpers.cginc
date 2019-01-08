float plot(float arg, float f, float width)
{
    return smoothstep(f - width, f, arg) - smoothstep(f, f  + width, arg);
}


float plotStep(float arg, float f, float width)
{
    return step(f, arg) - step(f + width, arg);
}


fixed3 coordGrid(float2 st, float stp, float size, float width)
{
    fixed3 cx = (step(-width, st.y) - step(width, st.y)) * float3(1.0f, 0.0f, 0.0f);
    fixed3 cy = (step(-width, st.x) - step(width, st.x)) * float3(0.0f, 1.0f, 0.0f);
    
    fixed g = 0;
    for (float i = -size; i <= size; i += stp)
    {
        g += (step(i - width, st.y) - step(i + width, st.y));
        g += (step(i - width, st.x) - step(i + width, st.x));
    }
    fixed3 cg = g * float3(1.0f, 0.5f, 0.0f) * (1.0f - cx.r) * (1.0f - cy.g) * 0.3f;
    return (cx + cy + cg);
}