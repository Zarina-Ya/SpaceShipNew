Shader "Unlit/Ring"
{
    Properties
    {
              _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
         Tags { "RenderType" = "Opaque" }
        LOD 200
            Stencil
            {
                Ref 10
                Comp NotEqual
            }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;


            half _Glossiness;
            half _Metallic;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                float angle = _Time.z ;
                float xx = v.vertex.x * cos(angle) + sin(angle) * v.vertex.z;
                float zz = -v.vertex.x * sin(angle) + cos(angle) * v.vertex.z;
                v.vertex.x = xx;
                v.vertex.z = zz;
                v.vertex.y = 0.0;
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
