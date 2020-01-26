using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    private static UIManager _instance;
    public static UIManager Instance { get { return _instance; } }
    [SerializeField] public Button SaveButton, ResetButton;
    [SerializeField] public InputField cityInputField, latitudeInputField, longitudeInputField;
    [SerializeField] private Toggle RotateGlobe;
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
        SaveButton.onClick.AddListener(SaveButtonListener);
        ResetButton.onClick.AddListener(ResetButtonListener);
    }

    private void SaveButtonListener()
    {
        if(!IsInputFieldsEmpty())
        {
            string cityName = cityInputField.text;
            float latitudeValue = float.Parse(latitudeInputField.text);
            float longitudeValue = float.Parse(longitudeInputField.text);
            
            //Sending the Data for evaluation
            GameController.Instance.LatitudeLongitudeToVectorValues(cityName, latitudeValue, longitudeValue);
            ResetButtonListener();
        }
        else
        {
            Debug.LogWarning("Complete the fields");
        }

    }
    private void ResetButtonListener()
    {
        cityInputField.text = "";
        latitudeInputField.text = "";
        longitudeInputField.text = "";
    }

    public void ToogleChanged()
    {
        GameController.Instance.rotateGlobeCheck = RotateGlobe.isOn;
    }

    private bool IsInputFieldsEmpty()
    {
        return (cityInputField.text == "" || latitudeInputField.text == "" || longitudeInputField.text == "");
    }

    
}
