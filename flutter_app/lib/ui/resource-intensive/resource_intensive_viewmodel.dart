import 'package:flutter/material.dart';
import 'package:flutter_app/domain/item.dart';

import 'package:flutter_app/domain/item_usecase.dart';

class ResourceIntensiveViewModel extends ChangeNotifier {
  ResourceIntensiveViewModel({required ItemUsecase itemUsecase})
    : _itemUsecase = itemUsecase;

  final ItemUsecase _itemUsecase;

  List<Item> _items = <Item>[];
  List<Item> get items => _items;

  Future<void> getItems() async {
    _items = await _itemUsecase.get100Items();
    notifyListeners();
  }
}
