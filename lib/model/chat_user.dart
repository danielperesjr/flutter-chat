class ChatUser {

  late String _name;
  late String _email;
  late String _pass;

  ChatUser();

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
}
