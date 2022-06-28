import 'package:bloc/bloc.dart';
import 'package:olx/bloc/item_state.dart';
import 'item_event.dart';
import 'package:olx/bloc/item_repo.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final _itemRepo = ItemRepository();

  ItemBloc() : super(ItemInitialState()) {
    on<LoadItemEvent>(
        (event, emit) => emit(ItemSuccessState(items: _itemRepo.loadItems())),
    );

    on<AddItemEvent>(
        (event, emit) => emit(ItemSuccessState(items: _itemRepo.addItem(event.item)))
    );

    on<RemoveItemEvent>(
            (event, emit) => emit(ItemSuccessState(items: _itemRepo.removeItem(event.item)))
    );
  }

}