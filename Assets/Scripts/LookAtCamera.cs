using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCamera : MonoBehaviour
{
    private Transform target;
    private void Start()
    {
        target = GameObject.FindWithTag("MainCamera").transform;
    }

    private void Update()
    {
        transform.LookAt(target);
    }
}
