import 'package:flutter_app/data/repositories/item_repository.dart';
import 'package:flutter_app/domain/item.dart';

class ItemUsecase {
  ItemUsecase({required ItemRepository itemRepository})
    : _itemRepository = itemRepository;

  final ItemRepository _itemRepository;

  Future<List<Item>> getItems() async {
    return await _itemRepository.getItems();
  }
}
