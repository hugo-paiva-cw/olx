import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configurations {
  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> listItemsDropEstados = [];

    listItemsDropEstados.add(const DropdownMenuItem(
      value: null,
      child: Text(
        'Região',
        style: TextStyle(color: Color(0xff9c27b0)),
      ),
    ));

    for (var estado in Estados.listaEstadosSigla) {
      listItemsDropEstados.add(DropdownMenuItem(
        value: estado,
        child: Text(estado),
      ));
    }

    return listItemsDropEstados;
  }

  static List<DropdownMenuItem<String>> getCategories() {
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
