Shader "Marker"
{
    Properties
    {
        _MainTex ("Inactive (RGBA)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Overlay"}
        LOD 200
        ZTest Always
        ZWrite Off

        CGPROGRAM
        #pragma surface surf Standard alpha:blend
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Emission = c.rgb;
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = c.a;
            
        }
        ENDCG
    }
}
