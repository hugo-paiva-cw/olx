import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  List<String> itemsMenu = ['Menu1', 'menu2'];

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

  @override
  void initState() {
    super.initState();
    _verifyIfUserIsLogged();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Text('anuncios'),
      ),
    );
  }
}
