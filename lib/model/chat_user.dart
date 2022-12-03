class ChatUser {

  late String _name;
  late String _email;
  late String _pass;
  late String _imageUrl;

  ChatUser();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email
    };
    return map;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }
}
