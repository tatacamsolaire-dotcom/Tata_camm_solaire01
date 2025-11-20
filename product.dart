class Product {
  int? id;
  String name;
  String description;
  int purchasePrice;
  int salePrice;
  int initialStock;
  int stock;

  Product({
    this.id,
    required this.name,
    this.description = '',
    required this.purchasePrice,
    required this.salePrice,
    required this.initialStock,
    required this.stock,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'purchasePrice': purchasePrice,
    'salePrice': salePrice,
    'initialStock': initialStock,
    'stock': stock,
  };

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    id: m['id'],
    name: m['name'],
    description: m['description'] ?? '',
    purchasePrice: m['purchasePrice'] ?? 0,
    salePrice: m['salePrice'] ?? 0,
    initialStock: m['initialStock'] ?? 0,
    stock: m['stock'] ?? 0,
  );
}
