import 'dart:convert';

import 'package:flutter/services.dart';

import 'item_response.dart';

class LocalDataService {
  Future<List<ItemResponse>> getItems() async {
    final response = await rootBundle.loadString('assets/big-data.json');
    final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;
    return jsonList
        .map((json) => ItemResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
