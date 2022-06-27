import 'package:flutter/material.dart';

import 'item.dart';

class ItemRepository {
  final List<Item> _items = [];

  List<Item> loadItems() {
    _items.addAll([
      Item(nome: 'Automóvel', valor: 'auto'),
      Item(nome: 'Imóvel', valor: 'imovel'),
      Item(nome: 'Eletrônicos', valor: 'eletro'),
      Item(nome: 'Moda', valor: 'moda'),
      Item(nome: 'Esportes', valor: 'esportes'),
    ]);
    return _items;
  }

  List<Item> addItem(Item item) {
    _items.add(item);
    return _items;
  }

  List<Item> removeItem(Item item) {
    _items.remove(item);
    return _items;
  }






  List<DropdownMenuItem<String>> getCategories() {
    List<DropdownMenuItem<String>> itemsDropCategories = [];

    itemsDropCategories.add(const DropdownMenuItem(
      value: null,
      child: Text(
        'Categoria',
        style: TextStyle(color: Color(0xff9c27b0)),
      ),
    ));

    const categories = {
      'Automóvel': 'auto',
      'Imóvel': 'imovel',
      'Eletrônicos': 'eletro',
      'Moda': 'moda',
      'Esportes': 'esportes',
    };

    categories.forEach((key, value) {
      itemsDropCategories.add(DropdownMenuItem(
        value: value,
        child: Text(key),
      ));
    });

    return itemsDropCategories;
  }

}