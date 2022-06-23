import 'package:flutter/material.dart';
import 'package:olx/models/add.dart';

class DetailsAdd extends StatefulWidget {
  Add add;
  DetailsAdd({required this.add, Key? key}) : super(key: key);

  @override
  State<DetailsAdd> createState() => _DetailsAddState();
}

class _DetailsAddState extends State<DetailsAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anúncio'),
      ),
      body: Stack( children: [
        ListView(children: [
          Container()
        ],)
      ],

      ),
    );
  }
}
