import 'item.dart';

abstract class ItemState {
  List<Item> items;

  ItemState({
    required this.items,
});
}

class ItemInitialState extends ItemState {
  ItemInitialState() : super(items: []);
}

class ItemSuccessState extends ItemState {
  ItemSuccessState({required List<Item> items}) : super(items: items);
}