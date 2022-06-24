import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/models/add.dart';
import 'package:olx/views/widgets/item_add.dart';

import '../util/configurations.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  List<String> itemsMenu = ['Menu1', 'menu2'];
  late List<DropdownMenuItem<String>> _listItemsDropCategories;
  late List<DropdownMenuItem<String>> _listItemsDropEstados;

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _selectedItemEstado;
  String? _selectedItemCategorie;

  _chooseMenuItem(String chosenItem) {

    switch( chosenItem ) {
      case 'Meus anúncios':
        Navigator.pushNamed(context, '/my-adds');
        break;
      case 'Entrar / Cadastrar':
        Navigator.pushNamed(context, '/login');
        break;
      case 'Deslogar':
        _signOutUser();
        break;
    }
  }

  _signOutUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    Navigator.pushNamed(context, '/login');
  }

  Future _verifyIfUserIsLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;

    if ( loggedUser == null ) {
      itemsMenu = [
        'Entrar / Cadastrar'
      ];
    } else {
      itemsMenu = [
        'Meus anúncios', 'Deslogar'
      ];
    }
  }

  _loadItemsDropdown() {

    _listItemsDropCategories = Configurations.getCategories();

    _listItemsDropEstados = Configurations.getEstados();
  }

  Future<Stream<QuerySnapshot>?> filterAdds() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = db.collection('adds');

    if ( _selectedItemEstado != null) {
      query = query.where('estado', isEqualTo: _selectedItemEstado);
    }
    if ( _selectedItemCategorie != null) {
      query = query.where('categorie', isEqualTo: _selectedItemCategorie);
    }


    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  Future<Stream<QuerySnapshot>?> _addListenerOfAdds() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
    .collection('adds')
    .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItemsDropdown();
    _verifyIfUserIsLogged();
    _addListenerOfAdds();
  }

  @override
  Widget build(BuildContext context) {

    var loadingData = Center(
      child: Column(children: const [

        Text('Carregando anúncios'),
        CircularProgressIndicator()

      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('OLX'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
              onSelected: _chooseMenuItem,
              itemBuilder: (context) {
                return itemsMenu.map((String item) {
                  return PopupMenuItem<String>(value: item, child: Text(item));
                }).toList();
              })
        ],
      ),
      body: Container(
        child: Column(children: [
            Row(children: [
              Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: defaultThemeAndroid.colorScheme.primary,
                        value: _selectedItemEstado,
                        items: _listItemsDropEstados,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black
                        ),
                        onChanged: (estado) {
                          setState(() {
                            _selectedItemEstado = estado as String?;
                            filterAdds();
                          });
                        },
                      ),
                    ),
                  )
              ),

              Container(
                color: Colors.grey.shade200,
                width: 2,
                height: 60,
              ),

              Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: defaultThemeAndroid.colorScheme.primary,
                        value: _selectedItemCategorie,
                        items: _listItemsDropCategories,
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black
                        ),
                        onChanged: (categorie) {
                          setState(() {
                            _selectedItemCategorie = categorie as String?;
                            filterAdds();
                          });
                        },
                      ),
                    ),
                  )
              )

            ],),

          StreamBuilder<QuerySnapshot>(
            stream: _controller.stream,
              builder: (context, snapshot) {
              switch( snapshot.connectionState) {

                case ConnectionState.none:
                case ConnectionState.waiting:
                  return loadingData;
                case ConnectionState.active:
                case ConnectionState.done:

                  QuerySnapshot? querySnapshot = snapshot.data;

                  if (querySnapshot == null) return Container();

                  if ( querySnapshot.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(25),
                      child: const Text(
                          'Nenhum anúncio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  }

                  return Expanded(
                      child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, index) {
                            List<DocumentSnapshot> adds = querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot = adds[index];
                            Add add = Add.fromDocumentSnapshot(documentSnapshot);

                            return ItemAdd(
                                add: add,
                              onTapItem: () {
                                  Navigator.pushNamed(
                                      context,
                                      '/details-add',
                                    arguments: add
                                  );
                              },
                            );

                          }
                      )
                  );

              }
              return Container();
              }
          )

          ],
        ),
      ),
    );
  }
}
