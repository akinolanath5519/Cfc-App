class Transaction {
  final String commodityName;
  final double weight; 
  final String unit;
  final String supplierName;
  final double price; 
  final DateTime? transactionDate;

  Transaction({
    required this.commodityName,
    required this.weight,
    required this.unit,
    required this.supplierName,
    required this.price,
    this.transactionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      commodityName: json['commodityName'],
      weight: (json['weight'] is int) ? (json['weight'] as int).toDouble() : json['weight'], // Convert int to double
      unit: json['unit'],
      supplierName: json['supplierName'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'], // Convert int to double
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodityName': commodityName,
      'weight': weight,
      'unit': unit,
      'supplierName': supplierName,
      'price': price,
      'transactionDate': transactionDate?.toIso8601String(),
    };
  }
}
