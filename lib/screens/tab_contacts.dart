import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';
import 'package:flutter_chat/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabContacts extends StatefulWidget {
  const TabContacts({Key? key}) : super(key: key);

  @override
  State<TabContacts> createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {
  String? _emailLoggedUser;

  void _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = await auth.currentUser;
    _emailLoggedUser = loggedUser?.email;
  }

  Future<List<ChatUser>> _recoverContacts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").get();

    List<ChatUser> chatUserList = [];
    ChatUser chatUser = ChatUser();
    for (DocumentSnapshot item in querySnapshot.docs) {
      dynamic userData = item.data();

      if (userData["email"] == _emailLoggedUser) continue;

      chatUser.email = userData["email"];
      chatUser.name = userData["name"];
      chatUser.imageUrl = userData["url"];

      chatUserList.add(chatUser);
    }

    return chatUserList;
  }

  @override
  void initState() {
    super.initState();
    _recoverUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatUser>>(
      future: _recoverContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando contatos..."),
                  CircularProgressIndicator(),
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
              itemCount: snapshot.requireData.length,
              itemBuilder: (context, index) {
                  List<ChatUser> itenList = snapshot.requireData;
                  ChatUser chatUser = itenList[index];
                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    leading: CircleAvatar(
                      maxRadius: 30.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(chatUser.imageUrl),
                    ),
                    title: Text(
                      chatUser.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
              },
            );
        }
      },
    );
  }
}
