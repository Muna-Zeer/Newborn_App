enum Sex { Female, Male }

enum Birth_outcome {
  Alive,
  Abortion,
  Stillbirth,
  Late_Neonatal,
  Early_Neonatal
}

class NewbornExamination {
  String id;
  Sex sex;
  Birth_outcome birthOutcome;
  String newbornName;
  String headCircumference;
  String length;
  String weight;
  String pulse;
  String temperature;
  String respiratoryRate;
  double apgarScore;
  String breastfeeding;
  String congenitalMalformation;
  String medication;
  String complicationAfterBirth;
  String diagnosis;
  String referred;
  String vaccineName;
  String doctorName;
  String midwifeName;
  String nurseName;
  int doctorid;
  int vaccineid;
  int midwifeid;
  int nurseid;

  NewbornExamination({
    required this.id,
    required this.sex,
    required this.newbornName,
    required this.birthOutcome,
    required this.headCircumference,
    required this.length,
    required this.weight,
    required this.pulse,
    required this.temperature,
    required this.respiratoryRate,
    required this.apgarScore,
    required this.breastfeeding,
    required this.congenitalMalformation,
    required this.medication,
    required this.complicationAfterBirth,
    required this.diagnosis,
    required this.referred,
    required this.doctorName,
    required this.midwifeName,
    required this.nurseName,
    required this.doctorid,
    required this.vaccineName,
    required this.vaccineid,
    required this.midwifeid,
    required this.nurseid,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'Sex': sex.toString().split('.').last,
        'Birth_outcome': birthOutcome.toString().split('.').last,
        'H_C': headCircumference,
        'newbornName': newbornName,
        'Length': length,
        'Weight_gr': weight,
        'Pulse': pulse,
        'Temp': temperature,
        'Respiratory_Rate': respiratoryRate,
        'Apgar_score': apgarScore,
        'breastfeeding_ft': breastfeeding,
        'Congenital_Malformation': congenitalMalformation,
        'Medication': medication,
        'vaccine_name': vaccineName,
        'Complication_after_birth': complicationAfterBirth,
        'Diagnosis': diagnosis,
        'Referred': referred,
        'doctor_name': doctorName,
        'midwife_name': midwifeName,
        'nurse_name': nurseName,
        'vaccine_name': vaccineName,
      };

  factory NewbornExamination.fromJson(Map<String, dynamic> json) {
    return NewbornExamination(
      id: json['id'],
      sex: Sex.values
          .firstWhere((element) => element.toString() == 'Sex.' + json['Sex']),
      birthOutcome: Birth_outcome.values.firstWhere((element) =>
          element.toString() == 'Birth_outcome.' + json['Birth_outcome']),
      headCircumference: json['H_C'],
      length: json['Length'],
      newbornName: json['newbornName'],
      weight: json['Weight_gr'],
      pulse: json['Pulse'],
      temperature: json['Temp'],
      respiratoryRate: json['Respiratory_Rate'],
      apgarScore: json['apgar_score'].toDouble(),
      breastfeeding: json['breastfeeding_ft'],
      congenitalMalformation: json['Congenital_Malformation'],
      medication: json['Medication'],
      complicationAfterBirth: json['complication_after_birth'],
      diagnosis: json['Diagnosis'],
      referred: json['Referred'],
      doctorid: json['doctor_id'] ?? null,
      midwifeid: json['midwife_id'] ?? null,
      nurseid: json['nurse_id'] ?? null,
      vaccineid: json['vaccine_id'] ?? null,
      vaccineName: '',
      doctorName: '',
      midwifeName: '',
      nurseName: '',
    );
  }
}
