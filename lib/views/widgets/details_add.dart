import 'dart:ffi';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/add.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  _callPhone(String phone) async {

    var filtered = phone.replaceAll('-', '');
    filtered = phone.replaceAll('(', '');
    filtered = phone.replaceAll(')', '');
    var itCanLaunch = await canLaunchUrl(Uri(
      scheme: 'tel',
      path: filtered
    ));

    if (true) {
      await launchUrlString('tel:$filtered');
      print('o filttrado é $filtered');
    } else {
      print('Não pode fazer a ligação');
    }
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
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _add.price,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: defaultThemeAndroid.colorScheme.primary),
                    ),
                    Text(
                      _add.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _add.description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      'Contato',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 66),
                      child: Text(
                        _add.phone,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                _callPhone(_add.phone);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: defaultThemeAndroid.colorScheme.primary,
                    borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'Ligar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
