class Sale {
  int? id;
  int productId;
  String productName;
  int quantity;
  int amount;
  String clientName;
  String clientPhone;
  String city;
  String date;

  Sale({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.clientName,
    required this.clientPhone,
    required this.city,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'quantity': quantity,
    'amount': amount,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'city': city,
    'date': date,
  };
}
