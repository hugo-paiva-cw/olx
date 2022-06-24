import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/views/widgets/item_add.dart';
import '../models/add.dart';

class MyAdds extends StatefulWidget {
  const MyAdds({Key? key}) : super(key: key);

  @override
  State<MyAdds> createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _idLoggedUser;

  _getDataLoggedUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    _idLoggedUser = user.uid;
  }

  Future<Stream<QuerySnapshot>?> _addListenerOfAdds() async {
    await _getDataLoggedUser();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Stream<QuerySnapshot> stream = db
        .collection('my_adds')
        .doc(_idLoggedUser)
        .collection('adds')
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  removeAdd(String idAdd) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('my_adds')
        .doc(_idLoggedUser)
        .collection('adds')
        .doc(idAdd)
        .delete()
        .then((_) {
      db
          .collection('adds')
          .doc( idAdd ).delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _addListenerOfAdds();
  }

  @override
  Widget build(BuildContext context) {
    var loadingData = Center(
      child: Column(
        children: const [
          Text('Carregando anúncios'),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus anúncios'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        onPressed: () {
          Navigator.pushNamed(context, '/new-add');
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return loadingData;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('Erro ao carregar os dados!');
              }

              QuerySnapshot querySnapshot = snapshot.data!;

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> adds = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = adds[index];
                    Add add = Add.fromDocumentSnapshot(documentSnapshot);

                    return ItemAdd(
                      add: add,
                      onPressedRemove: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirmar'),
                                content: const Text(
                                    'Deseja realmente excluir o anúncio?'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                  FlatButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        removeAdd(add.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Remover',
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              );
                            });
                      },
                    );
                  });
              break;
          }
          return Container();
        },
      ),
    );
  }
}
