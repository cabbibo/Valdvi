
Shader "Interface/Recepticle" {
    
  Properties {
  
    _NumberSteps( "Number Steps", Int ) = 3
    _TotalDepth( "Total Depth", Float ) = 0.16
    _NoiseSize( "Noise Size" , Float ) = 0.6
    _HueSize( "Hue Size" , Float ) = 2.45
    _BaseHue( "Base Hue" , Float ) = 1.67
    _Saturation( "Saturation" , Float ) = 1
    _NoiseSpeed( "Noise Speed" , Float ) = 0.8
    _Held( "Held" , Float ) = 0

  }

  SubShader {
    
    //Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

    Tags { "RenderType"="Opaque" }
    LOD 200
    Cull Front

    Pass {
 

      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      // Use shader model 3.0 target, to get nicer looking lighting
      #pragma target 3.0

      #include "UnityCG.cginc"


      uniform float _Held;
      uniform int _NumberSteps;
      uniform float _TotalDepth;

      uniform float _NoiseSize;
      uniform float _NoiseSpeed;

      uniform float _Saturation;

      uniform float _HueSize;
      uniform float _BaseHue;


      struct VertexIn{
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };


      struct VertexOut {
          float4 pos        : POSITION; 
          float3 normal     : NORMAL; 
          float4 uv         : TEXCOORD0; 
          float3 ro         : TEXCOORD1;
          float3 rd         : TEXCOORD2;
          float3 camPos     : TEXCOORD3;
          float3 lightPos : TEXCOORD4;
      };

      

      float3 hsv(float h, float s, float v){
        return lerp( float3( 1.0,1,1 ), clamp(( abs( frac(h + float3( 3.0, 2.0, 1.0 ) / 3.0 )
                             * 6.0 - 3.0 ) - 1.0 ), 0.0, 1.0 ), s ) * v;
      }


       //From IQ shaders
      float hash( float n )
      {
          return frac(sin(n)*43758.5453);
      }

      float noise( float3 x )
      {
          // The noise function returns a value in the range -1.0f -> 1.0f

          float3 p = floor(x);
          float3 f = frac(x);

          f       = f*f*(3.0-2.0*f);
          float n = p.x + p.y*57.0 + 113.0*p.z;

          return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
                         lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
                     lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
                         lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
      }

    

      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;
        
        o.uv = v.texcoord;

        o.camPos = mul( unity_WorldToObject , float4( _WorldSpaceCameraPos , 1. )).xyz;
        o.lightPos = mul( unity_WorldToObject , _WorldSpaceLightPos0 ).xyz ;
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        o.ro = v.position;

        o.rd = normalize( o.camPos - v.position.xyz );


        
        return o;

      }

      // Fragment Shader
      fixed4 frag(VertexOut i) : COLOR {


                float3 oldNorm = i.normal;  

        float3 ro           = i.ro;
        float3 rd           = i.rd; 
         
        float3 col = float3( 0.0 , 0.0 , 0.0 );

        float3 p;



        float acc = 0.;

        //float3 col = float3( 0, 0,0);



        for( int i = 0; i < _NumberSteps; i++ ){

          p = ro + -rd * float( i ) * _TotalDepth / _NumberSteps;

          float v = float( i );
          float val = noise( p * _NoiseSize +float3(0, _NoiseSpeed * _Time.y ,0));
          val +=  .5 *noise( p * _NoiseSize * 2 -float3(0, _NoiseSpeed * _Time.y ,0));
          val +=  .25 *noise( p * _NoiseSize * 6 -float3(0, _NoiseSpeed * _Time.y ,0));
           
            acc += val * .4;

            // uncomment this to make it 'layered'
            // DONT divide by steps if layered
            //if( val > .3){
              col += hsv( val * _HueSize + _BaseHue + float(i) / 6, 1,1);
            // break;
            //}
        }

        col /= _NumberSteps;
        //col *= 2;
        acc /= _NumberSteps;

        float3 bw = float3( acc ,acc ,acc);

        col = lerp( bw * bw * 4,col,_Held);

            fixed4 color;
        color = fixed4( col , 1. );
        return color;

      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}