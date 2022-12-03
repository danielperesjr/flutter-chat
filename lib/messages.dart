import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat_user.dart';

class Messages extends StatefulWidget {
  ChatUser contact;

  Messages(this.contact, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<String> messageList = [
    "Olá, tudo bem?",
    "Me passa o nome daquela série!",
    "Vamos sair hoje?",
    "Você não vai acreditar...",
  ];

  TextEditingController controllerMessage = TextEditingController();

  _sendMessage() {}

  _sendImage() {}

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
                    onPressed: _sendImage(),
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
            onPressed: _sendMessage(),
          ),
        ],
      ),
    );

    var messageListView = Expanded(
      child: ListView.builder(
        itemCount: messageList.length,
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
                  messageList[index],
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
                messageListView,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
