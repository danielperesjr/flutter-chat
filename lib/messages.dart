import 'package:flutter/material.dart';
import 'package:flutter_chat/model/chat_user.dart';

class Messages extends StatefulWidget {

  ChatUser contact;

  Messages(this.contact, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Container(),
    );
  }
}
