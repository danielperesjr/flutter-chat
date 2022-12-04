import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late String _idSender;
  late String _idReceiver;
  late String _name;
  late String _message;
  late String _messageType;
  late String _photoPath;

  Chat();

  Future saveChat() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("chat")
        .doc(this.idSender)
        .collection("last_chat")
        .doc(this.idReceiver)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idSender": this.idSender,
      "idReceiver": this.idReceiver,
      "name": this.name,
      "message": this.message,
      "messageType": this.messageType,
      "photoPath": this.photoPath,
    };
    return map;
  }

  String get photoPath => _photoPath;

  set photoPath(String value) {
    _photoPath = value;
  }

  String get messageType => _messageType;

  set messageType(String value) {
    _messageType = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get idReceiver => _idReceiver;

  set idReceiver(String value) {
    _idReceiver = value;
  }

  String get idSender => _idSender;

  set idSender(String value) {
    _idSender = value;
  }
}