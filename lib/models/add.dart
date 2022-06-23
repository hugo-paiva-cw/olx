import 'package:cloud_firestore/cloud_firestore.dart';

class Add {

  late String _id;
  late String _estado;
  late String _categorie;
  late String _title;
  late String _price;
  late String _phone;
  late String _description;
  late List<String> _photos;

  Add();

  Add.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {

    id = documentSnapshot.id;
    estado = documentSnapshot['estado'];
    categorie = documentSnapshot['categorie'];
    title = documentSnapshot['title'];
    price = documentSnapshot['price'];
    phone = documentSnapshot['phone'];
    description = documentSnapshot['description'];
    photos = List<String>.from(documentSnapshot['photos']);

  }

  Add.generateId() {

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference adds = db.collection('my_adds');
    id = adds.doc().id;

    photos = [];

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'id': id,
      'estado': estado,
      'categorie': categorie,
      'title': title,
      'price': price,
      'phone': phone,
      'description': description,
      'photos': photos,
    };

    return map;

  }

  List<String> get photos => _photos;

  set photos(List<String> value) {
    _photos = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get categorie => _categorie;

  set categorie(String value) {
    _categorie = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}