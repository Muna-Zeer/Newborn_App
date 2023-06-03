class Feeding {
  int id;
  String? feedingType;
  double? quantity;
  DateTime? date; // Nullable DateTime

  String? month;
  String? instructions;
  int? ministryId;

  Feeding({
    required this.id,
    required this.feedingType,
    required this.quantity,
    required this.date,
    required this.month,
    required this.instructions,
    required this.ministryId,
  });

  factory Feeding.fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'] as int,
      feedingType: json['feeding_type'] as String?,
      quantity: double.tryParse(json['quantity'] ?? ''),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      month: json['month'] as String?,
      instructions: json['instructions'] as String?,
      ministryId: json['ministry_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feeding_type': feedingType,
      'quantity': quantity,
      'date': date?.toIso8601String(),
      'month': month,
      'instructions': instructions,
      'ministry_id': ministryId,
    };
  }
}
