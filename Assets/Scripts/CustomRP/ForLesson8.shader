Shader "Unlit/ForLesson8"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _Offset("Offset", Float) = (0,0,0,0)


        _AnimationSpeed("AminSpeed", Range(0,5)) = 0
        _OffsetSize("Offset size", Range(0,10)) = 0


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

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                fixed4 _Color;
                float4 _Offset;
                float _AnimationSpeed;
                float _OffsetSize;


                // https://t.me/EdwardElric
                            v2f vert(appdata v)
                            {
                                v2f o;
                        float angle = _Time.z * _AnimationSpeed;
                        float xx = v.vertex.x * cos(angle) + sin(angle) * v.vertex.z;
                        float zz = -v.vertex.x * sin(angle) + cos(angle) * v.vertex.z;
                        v.vertex.x = xx;
                        v.vertex.z = zz;
                               

                                o.vertex = UnityObjectToClipPos(v.vertex);
                                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                                return o;
                            }

                            fixed4 frag(v2f i) : SV_Target
                            {
                                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                                return col;
                            }
                            ENDCG
                        } }
    //Properties
    //{
    //    _MainTex ("Texture", 2D) = "white" {}
    //    _Color("Main Color", COLOR) = (1,1,1,1)
    //    _Speed("Speed" , Range(0,5)) = 0
    //}
    //SubShader
    //{
    //    Tags { "RenderType"="Opaque" }
    //    LOD 100

    //    Pass
    //    {
    //        CGPROGRAM
    //        #pragma vertex vert
    //        #pragma fragment frag
    //        //// make fog work
    //        //#pragma multi_compile_fog

    //        #include "UnityCG.cginc"

    //        struct appdata
    //        {
    //            float4 vertex : POSITION;
    //            float2 uv : TEXCOORD0;
    //        };

    //        struct v2f
    //        {
    //            float2 uv : TEXCOORD0;
    //            //UNITY_FOG_COORDS(1)
    //            float4 vertex : SV_POSITION;
    //        };

    //        sampler2D _MainTex;
    //        float4 _MainTex_ST;
    //        float4 _Color;
    //        float _Spped;

    //        v2f vert (appdata v)
    //        {
    //            v2f o;
    //            float angle = _Time.z ;
    //            float xx = v.vertex.x * cos(angle) + sin(angle) * v.vertex.z;
    //            float zz = - v.vertex.x * cos(angle) + sin(angle) * v.vertex.z;
    //            v.vertex.x = xx;
    //            v.vertex.z = zz;
    //            o.vertex = UnityObjectToClipPos(v.vertex);
    //            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    //            //UNITY_TRANSFER_FOG(o,o.vertex);
    //            return o;
    //        }

    //        fixed4 frag (v2f i) : SV_Target
    //        {
    //            // sample the texture
    //            fixed4 col = tex2D(_MainTex, i.uv);
    //            //// apply fog
    //            //UNITY_APPLY_FOG(i.fogCoord, col);
    //            col = col * _Color;
    //            return col;
    //        }
    //        ENDCG
    //    }
    //}
}
