﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkinnedVerts : Form {
  
  public SkinnedMeshRenderer mesh;

  struct Vert{

    public Vector3 pos;
    public Vector3 vel;
    public Vector3 nor;
    public Vector3 tan;
    public Vector2 uv;
  
    public float used;
  
   
    public Vector3 targetPos;
    public Vector3 bindPos;
    public Vector3 bindNor;
    public Vector3 bindTan;

    public Vector4 boneWeights;
    public Vector4 boneIDs;

    public float debug;

  };

  private Mesh m;

  public override void SetStructSize(){ structSize = 36; }
  public override void SetCount(){ 
    m = mesh.sharedMesh;
    count = m.vertices.Length;
  }

  public override void Embody(){

    print( "embody" );

    Mesh m = mesh.sharedMesh;

    int[] triangles = m.triangles;
    Vector3[] verts = m.vertices;
    Vector2[] uvs = m.uv;
    Vector4[] tans = m.tangents;
    Vector3[] nors = m.normals;
    BoneWeight[] weights = m.boneWeights;


    int index = 0;


    //Vector3 pos;
    //Vector3 uv;
    //Vector3 tan;
    //Vector3 nor;
    //int baseTri;

    float[] values = new float[count*structSize];
    for( int i = 0; i < count; i ++ ){

     
      values[ index ++ ] = verts[i].x;
      values[ index ++ ] = verts[i].y;
      values[ index ++ ] = verts[i].z;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = nors[i].x;
      values[ index ++ ] = nors[i].y;
      values[ index ++ ] = nors[i].z;

      values[ index ++ ] = 0;//tans[i].x;
      values[ index ++ ] = 0;//tans[i].y;
      values[ index ++ ] = 0;//tans[i].z;

      values[ index ++ ] = uvs[i].x;
      values[ index ++ ] = uvs[i].y;

      values[ index ++ ] = (float)i/(float)count;

        // target pos
      values[ index++ ] = verts[i].x;
      values[ index++ ] = verts[i].y;
      values[ index++ ] = verts[i].z;

      // bindPositions
      values[ index++ ] = verts[i].x;
      values[ index++ ] = verts[i].y;
      values[ index++ ] = verts[i].z;


      // bindNor
      values[ index++ ] = nors[i].x;
      values[ index++ ] = nors[i].y;
      values[ index++ ] = nors[i].z;

      // bindNor
      values[ index++ ] = 0;//tans[i].x * tans[i].w;
      values[ index++ ] = 0;//tans[i].y * tans[i].w;
      values[ index++ ] = 0;//tans[i].z * tans[i].w;

      // bone weights
      values[ index++ ] = weights[i].weight0;
      values[ index++ ] = weights[i].weight1;
      values[ index++ ] = weights[i].weight2;
      values[ index++ ] = weights[i].weight3;

      // bone indices
      values[ index++ ] = weights[i].boneIndex0;
      values[ index++ ] = weights[i].boneIndex1;
      values[ index++ ] = weights[i].boneIndex2;
      values[ index++ ] = weights[i].boneIndex3;

      // Debug
      values[ index++ ] = 1;

    }


    SetData( values );

  }
}
