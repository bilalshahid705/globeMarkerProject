using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleDragRotation : MonoBehaviour
{
    private Touch touch;
    private Vector2 touchPosition;
    private Quaternion rotationY;
    [SerializeField] private float rotateSpeedModifier = 1f;
    private float rotateSpeed = 200f;

    private void Update()
    {
        if(GameController.Instance.rotateGlobeCheck)
        {
            if(Input.touchCount > 0)
            {
                touch = Input.GetTouch(0);

                if(touch.phase == TouchPhase.Moved)
                {
                    rotationY = Quaternion.Euler(
                        0f,
                        - touch.deltaPosition.x * rotateSpeedModifier,
                        0f);
                    
                    transform.rotation = rotationY * transform.rotation;
                }
            }
        }
        
    }

    private void OnMouseDrag() 
    {
        float rotX = Input.GetAxis("Mouse X") * rotateSpeed * Mathf.Deg2Rad;

        transform.Rotate(Vector3.up, -rotX);
    }
}
