// supplier.dart
class Supplier {
  final String id;
  final String name;
  final String contact;
  final String address;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] ?? json['_id'], // Adjust based on your API response
      name: json['name'],
      contact: json['contact'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
    };
  }
}
