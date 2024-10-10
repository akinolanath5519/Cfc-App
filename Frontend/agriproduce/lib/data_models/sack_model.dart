

class SackRecord {
  final String id;
  final String supplierName;
  final String date;
  final int bagsCollected;
  final int bagsReturned;

  SackRecord({
    required this.id,
    required this.supplierName,
    required this.date,
    required this.bagsCollected,
    required this.bagsReturned,
  });

  int get bagsRemaining => bagsCollected - bagsReturned;

  factory SackRecord.fromJson(Map<String, dynamic> json) {
    return SackRecord(
      id: json['_id'],
      supplierName: json['supplierName'],
      date: json['date'],
      bagsCollected: json['bagsCollected'],
      bagsReturned: json['bagsReturned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierName': supplierName,
      'date': date,
      'bagsCollected': bagsCollected,
      'bagsReturned': bagsReturned,
    };
  }
}
