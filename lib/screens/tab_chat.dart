import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabChat extends StatefulWidget {
  const TabChat({Key? key}) : super(key: key);

  @override
  State<TabChat> createState() => _TabChatState();
}

class _TabChatState extends State<TabChat> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Chat> _chatList = [];
  String? _idLoggedUser;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  @override
  void initState() {
    super.initState();
    _recoverUserData();

    Chat chat = Chat();
    chat.name = "Ana Clara";
    chat.message = "Olá, tudo bem?";
    chat.photoPath =
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-48bc6.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=4a56c072-45c8-40df-b3d7-aaa334d96129";

    _chatList.add(chat);
  }

  Stream<QuerySnapshot> _addChatListener() {
    final stream = db
        .collection("chat")
        .doc(_idLoggedUser)
        .collection("last_chat")
        .snapshots();
    stream.listen((chatData) {
      _controller.add(chatData);
    });
    return _controller.stream;
  }

  void _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;
    _idLoggedUser = loggedUser!.uid;

    _addChatListener();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas..."),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar os dados.");
              } else {
                QuerySnapshot querySnapshot = snapshot.requireData;
                if (querySnapshot.docs.length == 0) {
                  return Center(
                    child: Text(
                      "Você ainda não tem nenhuma mensagem :(",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: _chatList.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> chatList =
                          querySnapshot.docs.toList();
                      DocumentSnapshot item = chatList[index];
                      String imageUrl = item["photoPath"];
                      String messageType = item["messageType"];
                      String message = item["message"];
                      String name = item["name"];
                      return ListTile(
                        contentPadding:
                            EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        leading: CircleAvatar(
                          maxRadius: 30.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : null,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          messageType == "texto"
                              ? message
                              : "Imagem...",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      );
                    });
              }
          }
        });
  }
}
