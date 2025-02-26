import 'package:flutter_app/data/services/local_data_service.dart';
import 'package:flutter_app/domain/item.dart';

class ItemRepository {
  ItemRepository({required LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  Future<List<Item>> getItems() async {
    final items = await _localDataService.getItems();
    return items.map((e) => Item.fromJson(e.toJson())).toList();
  }
}
