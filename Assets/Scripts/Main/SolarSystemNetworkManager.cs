using Characters;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

namespace Main
{
    public class SolarSystemNetworkManager : NetworkManager
    {
        [SerializeField] private string playerName;
        [SerializeField] private TMPro.TMP_InputField _InputFieldNamaClient;
        [SerializeField] private Canvas _uiNameUser;
        Dictionary<int, ShipController> _players = new Dictionary<int, ShipController>();
        public override void OnServerAddPlayer(NetworkConnection conn, short playerControllerId)
        {
            var spawnTransform = GetStartPosition();
            var player = Instantiate(playerPrefab, spawnTransform.position, spawnTransform.rotation);
            var needController = player.GetComponent<ShipController>();
            needController.PlayerName = (!string.IsNullOrEmpty(_InputFieldNamaClient.text)) ? _InputFieldNamaClient.text : $"player{conn.connectionId}";
            _players.Add(conn.connectionId, needController);
            NetworkServer.AddPlayerForConnection(conn, player, playerControllerId);
       
        }

        public override void OnStartServer()
        {
            base.OnStartServer();
            NetworkServer.RegisterHandler(100, ReceiveName);
        }

        public class MessageLogin : MessageBase
        {
            public string login;

            public override void Deserialize(NetworkReader reader)
            {
                login = reader.ReadString();
            }

            public override void Serialize(NetworkWriter writer)
            {
                writer.Write(login);
            }
        }

        public override void OnClientConnect(NetworkConnection conn)
        {
            base.OnClientConnect(conn);
            MessageLogin login = new MessageLogin();
            login.login = _InputFieldNamaClient.text;
            conn.Send(100, login);
        }

        public void ReceiveName(NetworkMessage networkMessage)
        {
            var id = networkMessage.conn.connectionId;
            _players[id].PlayerName = networkMessage.reader.ReadString();
            _players[id].gameObject.name = _players[id].PlayerName;
            Debug.Log(_players[id]);
        }
        private void OffUiNameUser() =>_uiNameUser.gameObject.SetActive(false);
       
    }
}
