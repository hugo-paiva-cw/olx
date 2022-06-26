import 'item.dart';

abstract class ItemEvent {}

class LoadItemEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  Item item;

  AddItemEvent({
    required this.item
  });
}

class RemoveItemEvent extends ItemEvent {
  Item item;

  RemoveItemEvent({
    required this.item
});
}
