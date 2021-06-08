using System;
using UnityEngine;
using LitJson;

public class TransformApplier : MonoBehaviour
{
    private UDPServer _udpServer;
    public Matrix4x4 matrix;
    
    // Start is called before the first frame update
    private void Start()
    {
        
        matrix = Matrix4x4.zero;
        _udpServer = new UDPServer(41234);
        _udpServer.Received += ReceiveUdp;
        _udpServer.ListenStart();
    }

    // Update is called once per frame
    private void Update()
    {
        // Debug.Log(Matrix);
        // transform.localPosition = new Vector3(matrix.m03, matrix.m13, matrix.m23);
        var t = transform;
        t.localRotation = matrix.rotation;
        t.localScale = matrix.lossyScale;
    }

    private void ReceiveUdp(string strMsg)
    {
        var jsonData = JsonMapper.ToObject(strMsg);
        var m = Matrix4x4.zero;
        for (var i = 0; i < 4; i++)
        {
            for (var j = 0; j < 4; j++)
            {
                m[i,j] = (float)(double)(jsonData["matrix"][i][j]);
            }
        }
        matrix = m;
    }
    
}
