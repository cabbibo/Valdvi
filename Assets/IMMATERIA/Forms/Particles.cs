using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particles : Form {


  /*
    struct Particle{
      float3 position;
      float3 velocity;
      float3 normal;
      float3 tangent;
      float2 uv;
      float2 debug;
    }
  */

  public override void SetStructSize(){ 
    structSize = 16; 
  }

}
