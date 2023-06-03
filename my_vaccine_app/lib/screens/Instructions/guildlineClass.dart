class Guideline {
  int id;
  String? vaccineName;
  String? sideEffects;
  String? careInstructions;
  String? preventionMethod;
  int? ministryId;

  Guideline({
    required this.id,
    required this.vaccineName,
    required this.sideEffects,
    required this.careInstructions,
    required this.preventionMethod,
    required this.ministryId,
  });

  factory Guideline.fromJson(Map<String, dynamic> json) {
    return Guideline(
      id: json['id'],
      vaccineName: json['vaccine_name'],
      sideEffects: json['side_effects'],
      careInstructions: json['care_instructions'],
      preventionMethod: json['prevention_method'],
      ministryId: json['ministry_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccine_name': vaccineName,
      'side_effects': sideEffects,
      'care_instructions': careInstructions,
      'prevention_method': preventionMethod,
      'ministry_id': ministryId,
    };
  }
}
