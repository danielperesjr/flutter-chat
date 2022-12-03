class Message {
  late String _userId;
  late String _message;
  late String _imageUrl;
  late String _messageType;

  Message();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "userId": this.userId,
      "message": this.message,
      "imageUrl": this.imageUrl,
      "messageType": this.messageType,
    };
    return map;
  }

  String get messageType => _messageType;

  set messageType(String value) {
    _messageType = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }
}