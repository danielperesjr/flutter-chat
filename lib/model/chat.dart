class Chat {

  late String _name;
  late String _message;
  late String _photoPath;

  Chat(this._name, this._message, this._photoPath);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get photoPath => _photoPath;

  set photoPath(String value) {
    _photoPath = value;
  }

}