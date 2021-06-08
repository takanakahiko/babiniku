using System.Net.Sockets;
using System.Threading;
using UnityEngine;
using System.Net;
public class UDPServer
{
    /// <summary>
    /// デリゲート 受信時イベント
    /// </summary>
    /// <param name="strMsg"></param>
    public delegate void ReceivedHandler(string strMsg);
    
    /// <summary>
    /// 受信時イベント
    /// </summary>
    public ReceivedHandler Received;
    
    /// <summary>
    /// 受信処理 スレッド
    /// </summary>
    private Thread _thread;
    
    /// <summary>
    /// リッスンポート
    /// </summary>
    private readonly int _nListenPort;
    
    /// <summary>
    /// UDPクライアント
    /// </summary>
    private UdpClient _client;
    
    //--------------------------------------------------------------------------
    
    /// <summary>
    /// UDPServer
    /// </summary>
    public UDPServer(int port = 20000)
    {
        _nListenPort = port;
        _client = null;
    }
    
    /// <summary>
    /// UDP受信 リッスン開始
    /// </summary>
    public void ListenStart()
    {
        _client = new UdpClient(_nListenPort);
        _thread = new Thread(new ThreadStart(Thread));
        _thread.Start();
        Debug.Log("UDP Receive thread start");
    }
    
    /// <summary>
    /// 解放処理
    /// </summary>
    public void Dispose()
    {
        if(_thread != null)
        {
            _thread.Abort();
            _thread = null;
        }
        if(_client != null)
        {
            _client.Close();
            _client.Dispose();
            _client = null;
        }
    }
    
    /// <summary>
    /// スレッド
    /// </summary>
    private void Thread()
    {
        while (true)
        {
            if (_client != null)
            {
                try
                {
                    IPEndPoint ep = null;
                    var rcvBytes = _client.Receive(ref ep);
                    var rcvMsg = System.Text.Encoding.UTF8.GetString(rcvBytes);
                    if (rcvMsg != string.Empty)
                    {
                        //Debug.Log("UDP受信メッセージ : " + rcvMsg);
                        Received?.Invoke(rcvMsg);
                    }
                }
                catch (System.Exception e)
                {
                    Debug.Log(e.Message);
                }
            }
            else
            {
                Debug.Log("Error:client = null");
            }
        }
    }
}