    Shader "Earth"
    {
        Properties
        {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _BumpMap ("Bumpmap", 2D) = "bump" {}
            
            _AtmoColor("Atmosphere Color", Color) = (0.5, 0.5, 1.0, 1)
            _Size("Size", Float) = 0.1
            _Falloff("Falloff", Float) = 5
            _FalloffPlanet("Falloff Planet", Float) = 5
            _Transparency("Transparency", Float) = 15
            _TransparencyPlanet("Transparency Planet", Float) = 1
            _CloudSpeed("Cloud Speed", Float) = 0.1
        }
       
        SubShader
        {
            Tags { "Queue" = "Geometry+1" "RenderType" = "Opaque" }
     
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex, _BumpMap, _MetallicGlossMap;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };
        
        uniform float4 _AtmoColor;
        uniform float _FalloffPlanet;
        uniform float _TransparencyPlanet;
        uniform float _CloudSpeed;
        
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_MainTex));
 
            float4 atmo = _AtmoColor;
            atmo.a = pow(1.0-saturate(dot(IN.viewDir, o.Normal)), _FalloffPlanet);
            atmo.a *= _TransparencyPlanet;

            float2 cloudUV = IN.uv_MainTex;
            cloudUV.x += _Time.x * _CloudSpeed;
            float clouds = tex2D(_MainTex, cloudUV).a;
                    
            float4 color = lerp(tex2D(_MainTex, IN.uv_MainTex), 1, clouds);
            color.rgb = lerp(color.rgb, atmo.rgb, atmo.a);

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = color.rgb;
            //o.Emission = atmo.rgb;
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
        }
        ENDCG
     
          Pass
            {
              Tags { "LightMode" = "Always" }
              //Name "FORWARD"
            Cull Front
            Blend SrcAlpha One
			ZWrite Off
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
 
                #pragma fragmentoption ARB_fog_exp2
                #pragma fragmentoption ARB_precision_hint_fastest
 
                #include "UnityCG.cginc"
 
                uniform float4 _Color;
                uniform float4 _AtmoColor;
                uniform float _Size;
                uniform float _Falloff;
                uniform float _Transparency;
 
                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float3 normal : TEXCOORD0;
                    float3 worldvertpos : TEXCOORD1;
                };
 
                v2f vert(appdata_base v)
                {
                    v2f o;
 
                    v.vertex.xyz += v.normal*(_Size);
                    o.pos = UnityObjectToClipPos (v.vertex);
                    o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
                    o.worldvertpos = mul(unity_ObjectToWorld, v.vertex);
 
                    return o;
                }
 
                float4 frag(v2f i) : COLOR
                {
                    i.normal = normalize(i.normal);
                    float3 viewdir = normalize(i.worldvertpos-_WorldSpaceCameraPos);
 
                    float4 color = _AtmoColor;
					color.a = dot(viewdir, i.normal);
					color.a *=dot(i.normal, _WorldSpaceLightPos0);
					color.a = saturate(color.a);
					color.a = pow(color.a, _Falloff);
					color.a *= _Transparency;
                    return color;
                }
            ENDCG          
           }
   
        }
     
     
       
        Fallback " Glossy", 0
     
    }
