class Feeding {
  int id;
  String? feedingType;
  double? quantity;
  DateTime? date; // Nullable DateTime

  String? month;
  String? instructions;
  int? ministryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Feeding({
    required this.id,
    required this.feedingType,
    required this.quantity,
    required this.date,
    required this.month,
    required this.instructions,
    required this.ministryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Feeding.fromJson(Map<String, dynamic> json) {
    return Feeding(
      id: json['id'] as int ?? 0,
      feedingType: json['feeding_type'] as String ?? '',
      quantity: double.tryParse(json['quantity'].toString() ?? ''),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      month: json['month'] as String?,
      instructions: json['instructions'] as String?,
      ministryId: json['ministry_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
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
