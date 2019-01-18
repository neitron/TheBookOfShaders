using RockVR.Video;
using UnityEngine;



public class ScreenCapturer : MonoBehaviour
{


#pragma warning disable 649
	[SerializeField] private KeyCode _startKey;
	[SerializeField] private KeyCode _stopKey;
#pragma warning restore 649



	private void Update()
    {
	    if (Input.GetKeyUp(_startKey))
	    {
		    GetComponent<VideoCaptureCtrl>().StartCapture();
		    Debug.Log("Start Capture");
	    }

	    if (Input.GetKeyUp(_stopKey))
	    {
		    GetComponent<VideoCaptureCtrl>().StopCapture();
		    Debug.Log("Stop Capture");
	    }
    }


}
