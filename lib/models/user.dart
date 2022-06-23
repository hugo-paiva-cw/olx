class User {

  late String _idUser;
  late String _name;
  late String _email;
  late String _password;

  User();

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'idUser': idUser,
      'name': name,
      'email': email,
    };

    return map;

  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }
}