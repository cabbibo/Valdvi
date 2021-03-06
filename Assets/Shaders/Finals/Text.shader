﻿Shader "Final/Text" {
  Properties {

    _Color ("Color", Color) = (1,1,1,1)
    
       _TextMap ("Textmap", 2D) = "white" {}
       _ColorMap ("ColorMap", 2D) = "white" {}
    
  }

	SubShader {
		// COLOR PASS

     GrabPass
        {
            "_BackgroundTexture"
        }


        Tags
        { 
            "Queue" = "Transparent"
        }

		Pass {
			//Tags{ "LightMode" = "ForwardBase" }
			Cull Off
      Blend OneMinusDstColor One // Soft Additive

			CGPROGRAM
			#pragma target 4.5
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"    

			struct Vert{
    	  float3 pos;
    	  float3 vel;
    	  float3 nor;
    	  float3 lock;
    	  float2 uv;
    	  float2 debug;
    	};

    	StructuredBuffer<Vert> _TransferBuffer;
      uniform sampler2D _TextMap;
      uniform sampler2D _ColorMap;
      uniform sampler2D _BackgroundTexture;

      float3 _Color;


			struct varyings {
				float4 pos 		: SV_POSITION;
				float3 nor 		: TEXCOORD0;
				float2 uv  		: TEXCOORD1;
				float3 eye      : TEXCOORD5;
				float3 worldPos : TEXCOORD6;
				float3 debug    : TEXCOORD7;
				float3 closest    : TEXCOORD8;
        float4 screenPos : TEXCOORD9;
				UNITY_SHADOW_COORDS(2)
			};

			varyings vert(uint id : SV_VertexID) {

        float3 fPos   = _TransferBuffer[id].pos;
        float3 fLock  = _TransferBuffer[id].lock;
				float3 fVel 	= _TransferBuffer[id].vel;
				float3 fNor 	= _TransferBuffer[id].nor;
        float2 fUV 		= _TransferBuffer[id].uv;
				float2 debug 	= _TransferBuffer[id].debug;

				varyings o;

				UNITY_INITIALIZE_OUTPUT(varyings, o);

				o.pos = mul(UNITY_MATRIX_VP, float4(fPos,1));
				o.worldPos = fPos;
        o.screenPos = ComputeScreenPos( mul(UNITY_MATRIX_VP, float4(fPos,1)));
				o.eye = _WorldSpaceCameraPos - fPos;
				o.nor = fNor;
				o.uv =  fUV;
				o.debug = float3(debug.x,debug.y,length(fVel));

				UNITY_TRANSFER_SHADOW(o,o.worldPos);

				return o;
			}

			float4 frag(varyings v) : COLOR {
		
				fixed shadow = UNITY_SHADOW_ATTENUATION(v,v.worldPos -v.nor ) * .9 + .1 ;
				float d = tex2D(_TextMap,v.uv);

        float smoothing = .2;
        float lum = smoothstep( 0.4 - smoothing , 0.4 + smoothing , d.x );

        if( d < .1 ){discard;}
float3 bg = tex2Dproj(_BackgroundTexture, v.screenPos );
        float3 c = tex2D(_ColorMap,float2(v.debug.z * 10.1 + .7 ,0) ).xyz;
        

         //if( length(bg)/3 < .4 ){ c = 1; }else{
         //c = 0;
         //}//1-d;

          c *= lum;
        return float4(  c * 1.4 , lum);
			}

			ENDCG
		}


   // SHADOW PASS

    Pass
    {
      Tags{ "LightMode" = "ShadowCaster" }


      Fog{ Mode Off }
      ZWrite On
      ZTest LEqual
      Cull Off
      Offset 1, 1
      CGPROGRAM

      #pragma target 4.5
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest
      #include "UnityCG.cginc"
      #include "../Chunks/StructIfDefs.cginc"
sampler2D _TextMap;
      struct v2f {
        V2F_SHADOW_CASTER;

        float2 uv : TEXCOORD1;
      };


      v2f vert(appdata_base v, uint id : SV_VertexID)
      {
        v2f o;
                o.uv =  _TransferBuffer[id].uv;
        o.pos = mul(UNITY_MATRIX_VP, float4(_TransferBuffer[id].pos, 1));
        return o;
      }

      float4 frag(v2f i) : COLOR
      {

        float4 col = tex2D(_TextMap,i.uv);
        if( col.a < .4){discard;}
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG
    }
  


	}

}
