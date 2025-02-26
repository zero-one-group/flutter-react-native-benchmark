class ItemResponse {
  final int id;
  final String name;

  ItemResponse({required this.id, required this.name});

  factory ItemResponse.fromJson(Map<String, dynamic> json) {
    return ItemResponse(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
