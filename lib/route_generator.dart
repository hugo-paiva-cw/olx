import 'package:flutter/material.dart';
import 'package:olx/views/advertisement.dart';
import 'package:olx/views/login.dart';
import 'package:olx/views/my_adds.dart';
import 'package:olx/views/new_add.dart';
import 'package:olx/views/widgets/details_add.dart';

import 'models/add.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Advertisement());
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/my-adds':
        return MaterialPageRoute(builder: (_) => const MyAdds());
      case '/new-add':
        return MaterialPageRoute(builder: (_) => const NewAdd());
      case '/details-add':
        return MaterialPageRoute(builder: (_) => DetailsAdd(add: args as Add,));
      default:
        _errorRoute();
    }
  }

  static Route<dynamic>? _errorRoute() {

    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tela não encontrada!'),
            ),
            body: const Center(
              child: Text('Tela não encontrada!'),
            ),
          );
        }
    );
  }
}
