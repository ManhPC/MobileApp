class OrderType {
  final String code;
  final String name;
  OrderType({
    required this.code,
    required this.name,
  });
}

final List<OrderType> listMB = [
  OrderType(code: "", name: "Tất cả"),
  OrderType(code: "NB", name: "Mua"),
  OrderType(code: "NS", name: "Bán"),
];
