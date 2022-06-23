import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/add.dart';

import '../../main.dart';

class DetailsAdd extends StatefulWidget {
  Add add;
  DetailsAdd({required this.add, Key? key}) : super(key: key);

  @override
  State<DetailsAdd> createState() => _DetailsAddState();
}

class _DetailsAddState extends State<DetailsAdd> {
  late Add _add;

  List<Widget> _getImagesList() {
    List<String> listUrlImages = _add.photos;
    return listUrlImages.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _add = widget.add;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anúncio'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getImagesList(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  autoplay: false,
                  dotIncreasedColor: defaultThemeAndroid.colorScheme.primary,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
