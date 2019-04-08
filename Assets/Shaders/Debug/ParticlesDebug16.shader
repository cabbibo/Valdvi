Shader "Debug/Particles16" {
	Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _Size ("Size", float) = .01
	}


  SubShader{

    Cull Off
    
    Pass{

      CGPROGRAM


      #pragma target 4.5

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"


    struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };


      uniform int _Count;
      
      uniform float _Size;
      uniform float3 _Color;


      StructuredBuffer<Vert> _VertBuffer;


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
          float  id       : TEXCOORD1;
      };


      /*

      for( int id = 0; id < count *3 *2; id++){
        runShader(id);
      }

      for( pId = 0; pID < count; pID++){
        for( idInTri = 0; idInTri < 3 * 2; idInTri++){
          doSTuff(pID, idInTri );
        }
      }

      */







       varyings vert (uint id : SV_VertexID){

        varyings o;

        int vertID = id / 6;
        int whichTriID = id %6;
        if( vertID < _Count ){

        	float3 extra = float3(0,0,0);


          float3 left = UNITY_MATRIX_V[0].xyz;
          float3 up   = UNITY_MATRIX_V[1].xyz;
          float2 uv = float2(0,0);

          Vert v = _VertBuffer[vertID % _Count];

          float3 finalPosition = v.pos;
        	if( whichTriID == 0 ){ finalPosition += v.debug.x * _Size * ( -left - up ); uv = float2(0,0); }
          if( whichTriID == 1 ){ finalPosition += v.debug.x * _Size * (  left - up ); uv = float2(1,0); }
          if( whichTriID == 2 ){ finalPosition += v.debug.x * _Size * (  left + up ); uv = float2(1,1); }
          if( whichTriID == 3 ){ finalPosition += v.debug.x * _Size * ( -left - up ); uv = float2(0,0); }
          if( whichTriID == 4 ){ finalPosition += v.debug.x * _Size * (  left + up ); uv = float2(1,1); }
        	if( whichTriID == 5 ){ finalPosition += v.debug.x * _Size * ( -left + up ); uv = float2(0,1); }


          o.id = v.debug.x;

	        o.pos = mul (UNITY_MATRIX_VP, float4(finalPosition,1.0f));

       	}

        return o;

      }




      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {
          return v.id;// * .01 ) * float4(_Color,1 );
      }

      ENDCG

    }
  }

  Fallback Off


}
