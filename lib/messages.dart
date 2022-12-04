import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat_user.dart';
import 'package:flutter_chat/model/message.dart';

class Messages extends StatefulWidget {
  ChatUser contact;

  Messages(this.contact, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String? _idLoggedUser;
  String? _idReceiverUser;
  List<String> messageList2 = [
    "Olá, tudo bem?",
    "Me passa o nome daquela série!",
    "Vamos sair hoje?",
    "Você não vai acreditar...",
  ];

  TextEditingController controllerMessage = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  _sendMessage() {
    String textMessage = controllerMessage.text;
    if (textMessage.isNotEmpty) {
      Message message = Message();
      message.userId = _idLoggedUser!;
      message.message = textMessage;
      message.imageUrl = "";
      message.messageType = "texto";

      _saveMessage(_idLoggedUser!, _idReceiverUser!, message);
      _saveMessage(_idReceiverUser!, _idLoggedUser!, message);
    }
  }

  _sendImage() {}

  Future _saveMessage(String idSender, String idReceiver, Message msg) async {
    await db
        .collection("messages")
        .doc(idSender)
        .collection(idReceiver)
        .add(msg.toMap());

    controllerMessage.clear();
  }

  void _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;
    _idLoggedUser = loggedUser!.uid;
    _idReceiverUser = widget.contact.userId;
  }

  @override
  void initState() {
    super.initState();
    _recoverUserData();
  }

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: TextField(
                controller: controllerMessage,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () => _sendImage(),
                    icon: Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: const Color(0xff03a9f4),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: db
          .collection("messages")
          .doc(_idLoggedUser)
          .collection(_idReceiverUser!)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando mensagens..."),
                  CircularProgressIndicator(),
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.requireData;
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados."),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> messageList = querySnapshot.docs.toList();
                    DocumentSnapshot item = messageList[index];
                    double containerWidth =
                        MediaQuery.of(context).size.width * 0.8;
                    Alignment alignment = Alignment.centerRight;
                    Color color = Color(0xff03a9f4);
                    if(_idLoggedUser != item["userId"]){
                      alignment = Alignment.centerLeft;
                      color = Colors.white;
                    }
                    return Align(
                      alignment: alignment,
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Container(
                          width: containerWidth,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            item["message"],
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
        }
      },
    );

    var messageListView = Expanded(
      child: ListView.builder(
        itemCount: messageList2.length,
        itemBuilder: (context, index) {
          double containerWidth = MediaQuery.of(context).size.width * 0.8;
          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                width: containerWidth,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Text(
                  messageList2[index],
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20.0,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(widget.contact.imageUrl),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(widget.contact.name),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                stream,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
