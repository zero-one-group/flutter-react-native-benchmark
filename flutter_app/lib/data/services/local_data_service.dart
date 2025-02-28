import 'dart:convert';

import 'package:flutter/services.dart';

import 'item_response.dart';

class LocalDataService {
  Future<List<ItemResponse>> get10KItems() async {
    final response = await rootBundle.loadString('assets/10000-data.json');
    final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;
    return jsonList
        .map((json) => ItemResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<ItemResponse>> get100Items() async {
    final response = await rootBundle.loadString('assets/100-data.json');
    final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;
    return jsonList
        .map((json) => ItemResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
