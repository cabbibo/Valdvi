using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class LifeForm : Cycle {

 // public bool active;

public bool auto;
  
[ HideInInspector ] public List<Life> Lifes;
[ HideInInspector ] public List<Form> Forms;




public void OnUpdating(){
  if( birthing ){ _WhileBirthing(1);}
  if( living ){ _WhileLiving(1); }
  if( dying ){ _WhileDying(1); }
}

public void OnDebugging(){

  if( created ){ _WhileDebug(); }
}

public void OnCreation(){
    _Create(); 
    _OnGestate();
    _OnGestated();
    _OnBirth(); 
    _OnBirthed();
    _OnLive(); 
}

public void OnDestruction(){
  _Destroy();
}




public void Start(){
  if( auto ){ OnCreation(); }
}

public void OnDisable(){
  if( auto ){  OnDestruction(); } 
}


public void Update(){
  if( auto ){
    OnUpdating();
  }
}

public void OnRenderObject(){
  if( auto ){
    OnDebugging();
  }
}



}
