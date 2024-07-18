class GroupStock {
  String id;
  String name;
  List<dynamic> listStock;

  GroupStock({
    required this.id,
    required this.name,
    required this.listStock,
  });

  factory GroupStock.fromJson(Map<String, dynamic> json) {
    return GroupStock(
      id: json['id'].toString(),
      name: json['name'].toString(),
      listStock: json['listStock'],
    );
  }
}
