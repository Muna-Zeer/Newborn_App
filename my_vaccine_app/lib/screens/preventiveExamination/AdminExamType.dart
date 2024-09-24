class AdminExamType {
  int id;
  String examType;
  String description;

  AdminExamType({
    required this.id,
    required this.examType,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_type': examType,
      'description': description,
    };
  }

  factory AdminExamType.fromJson(Map<String, dynamic> json) {
    return AdminExamType(
      id: json['id'] ?? 0,
      examType: json['exam_type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
