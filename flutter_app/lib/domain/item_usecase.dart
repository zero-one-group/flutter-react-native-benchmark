import 'package:flutter_app/data/repositories/item_repository.dart';
import 'package:flutter_app/domain/item.dart';

class ItemUsecase {
  ItemUsecase({required ItemRepository itemRepository})
    : _itemRepository = itemRepository;

  final ItemRepository _itemRepository;

  Future<List<Item>> get10KItems() async {
    return await _itemRepository.get10KItems();
  }

  Future<List<Item>> get100Items() async {
    return await _itemRepository.get100Items();
  }
}
