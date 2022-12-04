import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';
import 'package:flutter_chat/model/chat_user.dart';
import 'package:flutter_chat/model/message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Messages extends StatefulWidget {
  ChatUser contact;

  Messages(this.contact, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String? _idLoggedUser;
  String? _idReceiverUser;
  bool _isUploading = false;

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

      _saveChat(message);
    }
  }

  void _sendImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? selectedImage;
    selectedImage = await picker.pickImage(source: ImageSource.gallery);

    _isUploading = true;

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder
        .child("messages")
        .child(_idLoggedUser!)
        .child("$imageName.jpg");

    UploadTask task = file.putFile(File(selectedImage!.path));

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _isUploading = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _recoverImageUrl(taskSnapshot);
        setState(() {
          _isUploading = false;
        });
      }
    });
  }

  void _saveChat(Message msg) {
    Chat chatSender = Chat();
    chatSender.idSender = _idLoggedUser!;
    chatSender.idReceiver = _idReceiverUser!;
    chatSender.message = msg.message;
    chatSender.name = widget.contact.name;
    chatSender.photoPath = widget.contact.imageUrl;
    chatSender.messageType = msg.messageType;
    chatSender.saveChat();

    Chat chatReceiver = Chat();
    chatReceiver.idSender = _idReceiverUser!;
    chatReceiver.idReceiver = _idLoggedUser!;
    chatReceiver.message = msg.message;
    chatReceiver.name = widget.contact.name;
    chatReceiver.photoPath = widget.contact.imageUrl;
    chatReceiver.messageType = msg.messageType;
    chatReceiver.saveChat();
  }

  Future _recoverImageUrl(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();

    Message message = Message();
    message.userId = _idLoggedUser!;
    message.message = "";
    message.imageUrl = url;
    message.messageType = "imagem";

    _saveMessage(_idLoggedUser!, _idReceiverUser!, message);
    _saveMessage(_idReceiverUser!, _idLoggedUser!, message);
  }

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
                  prefixIcon: _isUploading == true
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () => _sendImage(),
                          icon: Icon(Icons.camera_alt)),
                ),
              ),
            ),
          ),
          Platform.isIOS
              ? CupertinoButton(
                  child: Text(
                    "Enviar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _sendMessage(),
                )
              : FloatingActionButton(
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
                    List<DocumentSnapshot> messageList =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = messageList[index];
                    double containerWidth =
                        MediaQuery.of(context).size.width * 0.8;
                    Alignment alignment = Alignment.centerRight;
                    Color color = Color(0xff03a9f4);
                    if (_idLoggedUser != item["userId"]) {
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
                          child: item["messageType"] == "texto"
                              ? Text(item["message"],
                                  style: TextStyle(fontSize: 18.0))
                              : Image.network(item["imageUrl"]),
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
