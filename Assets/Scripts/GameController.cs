using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    private static GameController _instance;
    public static GameController Instance { get { return _instance; } }
	[SerializeField] private float _Radius;
    [SerializeField] private Transform Marker;
    [SerializeField] private GameObject Globe;
	private float xPos, yPos, zPos;
    private float DegreeToRadian = 1.57079f;
    public bool rotateGlobeCheck = false;
    
    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        } else {
            _instance = this;
        }
    }
    private void Start()
    {

    }
    public void LatitudeLongitudeToVectorValues(string _cityName, float _latitude, float _longitude)
    {
        float latitude = Mathf.PI  * _latitude / 180;
		float longitude = Mathf.PI  * _longitude / 180;
       	
		latitude -= DegreeToRadian;

		xPos = (_Radius) * Mathf.Sin(latitude) * Mathf.Cos(longitude);
		zPos = (_Radius) * Mathf.Sin(latitude) * Mathf.Sin(longitude);
		yPos = (_Radius) * Mathf.Cos(latitude); 

        Marker.transform.position = new Vector3(xPos, yPos, zPos);
        Marker.transform.GetChild(0).GetComponent<TextMesh>().text = _cityName;
        
        //Unity doesn't support the nested prefab property
        // Marker.transform.SetParent(Globe.transform);
    }   
}
