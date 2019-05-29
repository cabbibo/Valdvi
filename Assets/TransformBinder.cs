using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformBinder : Cycle {

  public Life toBind;
  public Transform t;


  public float[] transformFloats;



  // Use this for initialization
  public override void Bind() {
    toBind.BindAttribute( "_Transform" , "transformFloats" , this );
  }

  public override void WhileLiving( float v ){
    transformFloats = HELP.GetMatrixFloats( t.localToWorldMatrix );
  }
  


}
