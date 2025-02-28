import 'package:flutter_app/data/services/local_data_service.dart';
import 'package:flutter_app/domain/item.dart';

class ItemRepository {
  ItemRepository({required LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  Future<List<Item>> get10KItems() async {
    final items = await _localDataService.get10KItems();
    return items.map((e) => Item.fromJson(e.toJson())).toList();
  }

  Future<List<Item>> get100Items() async {
    final items = await _localDataService.get100Items();
    return items.map((e) => Item.fromJson(e.toJson())).toList();
  }
}
