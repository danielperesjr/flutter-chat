import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat.dart';

class TabContacts extends StatefulWidget {
  const TabContacts({Key? key}) : super(key: key);

  @override
  State<TabContacts> createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {
  List<Chat> chatList = [
    Chat("Ana Clara", "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-48bc6.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=4a56c072-45c8-40df-b3d7-aaa334d96129"),
    Chat("Pedro Silva", "Me passa o nome daquela série!",
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-48bc6.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=64c6b87a-bbe7-42e7-b49a-93fcf7487852"),
    Chat("Marcela Almeida", "Vamos sair hoje?",
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-48bc6.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=6df2a5b4-70e4-46ab-856f-e6f0db50ebc3"),
    Chat("José Renato", "Você não vai acreditar...",
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-48bc6.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=7d5250a7-a452-4864-894d-6a80a135e0d3"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          Chat chat = chatList[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            leading: CircleAvatar(
              maxRadius: 30.0,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(chat.photoPath),
            ),
            title: Text(
              chat.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        });
  }
}
