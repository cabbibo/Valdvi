﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlacedDynamicMeshParticles: Particles {

  public bool AutoEmbody;
  public float noiseSize;
  public string noiseType;
  public MeshFilter mesh;

  struct Vert{

  
    public Vector3 pos;
    public Vector3 vel;
    public Vector3 nor;
    public Vector3 tan;
    public Vector2 uv;
    public float used;
    public Vector3 triIDs;
    public Vector3 triWeights;
    public Vector3 debug;

  };

  public override void SetStructSize(){ structSize = 24; }



  /*
    
    if we want to place them automagically

  */

public virtual void Embody( MeshFilter mesh ){

  if(AutoEmbody){

    int[] triangles = mesh.mesh.triangles;
    Vector3[] verts = mesh.mesh.vertices;
    Vector2[] uvs = mesh.mesh.uv;
    Vector4[] tans = mesh.mesh.tangents;
    Vector3[] nors = mesh.mesh.normals;

    float[] triangleAreas = new float[triangles.Length / 3];
    float totalArea = 0;

    int tri0;
    int tri1;
    int tri2;

    for (int i = 0; i < triangles.Length / 3; i++) {
    
      tri0 = i * 3;
      tri1 = tri0 + 1;
      tri2 = tri0 + 2;
     
      tri0 = triangles[tri0];
      tri1 = triangles[tri1];
      tri2 = triangles[tri2];
     
      float area = 1;

      if( noiseType=="even"){ 
        area = HELP.AreaOfTriangle (verts[tri0], verts[tri1], verts[tri2]);
      }else if( noiseType =="fractal" ){
        area = HELP.NoiseTriangleArea(noiseSize, verts[tri0],  verts[tri1], verts[tri2]);
        area = Mathf.Pow( area, 10);
      }else{
        print( "incorrect noise type selected");
      }

      triangleAreas[i] = area;
      totalArea += area;
    
    }

    for (int i = 0; i < triangleAreas.Length; i++) {
      triangleAreas[i] /= totalArea;
    }

    float[] values = new float[count*structSize];

    int index = 0;


    Vector3 pos;
    Vector3 uv;
    Vector3 tan;
    Vector3 nor;
    int baseTri;

    for( int i = 0; i < count; i ++ ){

      baseTri = 3 * HELP.getTri (Random.value, triangleAreas);
      tri0 = baseTri + 0;
      tri1 = baseTri + 1;
      tri2 = baseTri + 2;

      tri0 = triangles[tri0];
      tri1 = triangles[tri1];
      tri2 = triangles[tri2];

      pos = HELP.GetRandomPointInTriangle(i, verts[tri0], verts[tri1], verts[tri2]);

      float a0 = HELP.AreaOfTriangle(pos, verts[tri1], verts[tri2]);
      float a1 = HELP.AreaOfTriangle(pos, verts[tri0], verts[tri2]);
      float a2 = HELP.AreaOfTriangle(pos, verts[tri0], verts[tri1]);

      float aTotal = a0 + a1 + a2;

      float p0 = a0 / aTotal;
      float p1 = a1 / aTotal;
      float p2 = a2 / aTotal;


      nor = (nors[tri0] * p0 + nors[tri1] * p1 + nors[tri2] * p2).normalized;
      uv = uvs[tri0] * p0 + uvs[tri1] * p1 + uvs[tri2] * p2;
      tan = (HELP.ToV3(tans[tri0]) * p0 + HELP.ToV3(tans[tri1]) * p1 + HELP.ToV3(tans[tri2]) * p2).normalized;


//            print( pos);
      values[ index ++ ] = pos.x;
      values[ index ++ ] = pos.y;
      values[ index ++ ] = pos.z;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = nor.x;
      values[ index ++ ] = nor.y;
      values[ index ++ ] = nor.z;

      values[ index ++ ] = tan.x;
      values[ index ++ ] = tan.y;
      values[ index ++ ] = tan.z;

      values[ index ++ ] = uv.x;
      values[ index ++ ] = uv.y;

      values[ index ++ ] = 1;

      values[ index ++ ] = tri0;
      values[ index ++ ] = tri1;
      values[ index ++ ] = tri2;

      values[ index ++ ] = p0;
      values[ index ++ ] = p1;
      values[ index ++ ] = p2;

      values[ index ++ ] = i;
      values[ index ++ ] = i/count;
      values[ index ++ ] = 0;

    }


    SetData( values );
}
  }


/*

  For Saving and Loading Efficiently!

*/

  public override float[] GetDNA(){
    float[] d = GetData();


    float[] output = new float[count * 7];
    for( int i = 0; i < count; i++ ){
      
      if( d[ i * 24 + 14 ] != 0 ){
        
        output[ i * 7 + 0] = d[i*24+14];
        // IDs
        output[ i * 7 + 1] = d[i*24+15];
        output[ i * 7 + 2] = d[i*24+16];
        output[ i * 7 + 3] = d[i*24+17];

        // Weights
        output[ i * 7 + 4] = d[i*24+18];
        output[ i * 7 + 5] = d[i*24+19];
        output[ i * 7 + 6] = d[i*24+20];

      }

      //id OF THING TO STORE;


    }

    return output;

  }


  public override void SetDNA(float[] dna){

    float[] data = new float[count*structSize];

    for( int i = 0; i < (dna.Length/7); i++ ){
      data[i*24+14] = dna[i*7+0];
      data[i*24+15] = dna[i*7+1];
      data[i*24+16] = dna[i*7+2];
      data[i*24+17] = dna[i*7+3];
      data[i*24+18] = dna[i*7+4];
      data[i*24+19] = dna[i*7+5];
      data[i*24+20] = dna[i*7+6];
    }

    SetData(data);
  }

}
