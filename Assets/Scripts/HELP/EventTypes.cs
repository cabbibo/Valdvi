using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;




[System.Serializable] public class Vector2Event : UnityEvent<Vector2>{}
[System.Serializable] public class Vector3Event : UnityEvent<Vector3>{}
[System.Serializable] public class FloatEvent : UnityEvent<float>{}

[System.Serializable] public class RayEvent : UnityEvent<Ray>{}

[System.Serializable] public class GameObjectEvent : UnityEvent<GameObject>{}
[System.Serializable] public class Moon2Event : UnityEvent<GameObject,GameObject>{}
[System.Serializable] public class TransformEvent : UnityEvent<Transform>{}
[System.Serializable] public class TransformTransformEvent : UnityEvent<Transform,Transform>{}
[System.Serializable] public class FloatTransformTransformEvent : UnityEvent<float,Transform,Transform>{}



public class EventTypes : MonoBehaviour {}
