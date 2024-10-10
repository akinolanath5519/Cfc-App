class Commodity {
  final String id;
  final String name;
  final double rate; // Use double for rate, as it may involve decimals
  // Include adminEmail if needed

  Commodity({
    required this.id,
    required this.name,
    required this.rate,
  // Optional: Include if you want to manage by admin
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      id: json['id'] ?? json['_id'], // Adjust based on your API response
      name: json['name'],
      rate: json['rate'].toDouble(), // Convert to double if it's a numeric string
      // Include if your API returns it
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rate': rate
    // Optional: Include if needed for serialization
    };
  }
}
