import 'dart:async';
import 'package:olx/bloc/item_state.dart';
import 'item.dart';
import 'item_event.dart';
import 'package:olx/bloc/item_repo.dart';

class ItemBloc {
  final _itemRepo = ItemRepository();

  final StreamController<ItemEvent> _inputItemController = StreamController<ItemEvent>();

  final StreamController<ItemState> _outputItemController = StreamController<ItemState>();

  Sink<ItemEvent> get inputItem => _inputItemController.sink;
  Stream<ItemState> get stream => _outputItemController.stream;

  ItemBloc() {
    _inputItemController.stream.listen(_mapEventToState);
  }

  _mapEventToState(ItemEvent event) {
    List<Item> items = [];
    if (event is LoadItemEvent) {
      items = _itemRepo.loadItems();
    } else if ( event is AddItemEvent ) {
      items = _itemRepo.addItem(event.item);
    } else if (event is RemoveItemEvent) {
      items = _itemRepo.removeItem(event.item);
    }
    _outputItemController.add(ItemSuccessState(items: items));
  }

}