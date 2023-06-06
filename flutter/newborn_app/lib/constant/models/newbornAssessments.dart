enum Congenital_Malformation { Yes, No, Referred }

enum Jaundice { Yes, No, Referred }

enum Cyanosis { Yes, No, Referred }

enum Umbilical_stump { Clean, Infected, Referred }

enum Feeding { Mixed, Artificial, Exclusive }

enum mode_of_delivery { C_S, V_D }

enum Sex { Male, Female }

class NewbornAssessments {
  int id;
  String birthWeight;
  DateTime dateOfDelivery;
  mode_of_delivery modeOfDelivery;
  String gestationalAgeAtDelivery;
  String temp;
  String pulse;
  String respRate;
  int weight;
  int height;
  int hc;
  Sex sex;
  Congenital_Malformation congenitalMalformation;
  Jaundice jaundice;
  Cyanosis cyanosis;
  String umbilicalStump;
  Feeding feeding;
  String remarks;
  String doctorName;
  String midwifeName;
  String nurseName;
  int doctorid;
  int midwifeid;
  int nurseid;

  NewbornAssessments({
    required this.id,
    required this.birthWeight,
    required this.dateOfDelivery,
    required this.modeOfDelivery,
    required this.gestationalAgeAtDelivery,
    required this.temp,
    required this.pulse,
    required this.respRate,
    required this.weight,
    required this.height,
    required this.hc,
    required this.sex,
    required this.congenitalMalformation,
    required this.jaundice,
    required this.cyanosis,
    required this.umbilicalStump,
    required this.feeding,
    required this.remarks,
    required this.doctorName,
    required this.midwifeName,
    required this.nurseName,
    required this.doctorid,
    required this.midwifeid,
    required this.nurseid,
  });

  factory NewbornAssessments.fromJson(Map<String, dynamic> json) {
    return NewbornAssessments(
      id: json['id'],
      birthWeight: json['Birth_Weight'] ?? '',
      dateOfDelivery: DateTime.parse(json['date_of_delivery']),
      modeOfDelivery: mode_of_delivery.values.firstWhere((element) =>
          element.toString() == 'mode_of_delivery.' + json['mode_of_delivery']),
      gestationalAgeAtDelivery: json['Gestational_age_at_delivery'] ?? '',
      temp: json['Temp'] ?? '',
      pulse: json['Pulse'] ?? '',
      respRate: json['Resp_rate'] ?? '',
      weight: json['Weight'] ?? 0,
      height: json['height'] ?? 0,
      hc: json['HC'] ?? 0,
      sex: Sex.values
          .firstWhere((element) => element.toString() == 'Sex.' + json['Sex']),
      congenitalMalformation: Congenital_Malformation.values.firstWhere(
          (element) =>
              element.toString() ==
              'Congenital_Malformation.' + json['Congenital_Malformation']),
      jaundice: Jaundice.values.firstWhere(
          (element) => element.toString() == 'Jaundice.' + json['Jaundice']),
      cyanosis: Cyanosis.values.firstWhere(
          (element) => element.toString() == 'Cyanosis.' + json['Cyanosis']),
      umbilicalStump: json['Umbilical_stump'] ?? '',
      feeding: Feeding.values.firstWhere(
          (element) => element.toString() == 'Feeding.' + json['Feeding']),
      remarks: json['Remarks'] ?? '',
      doctorName: '',
      midwifeName: '',
      nurseName: '',
      doctorid: json['doctor_id'] ?? 0,
      midwifeid: json['midwife_id'] ?? 0,
      nurseid: json['nurse_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Birth_Weight': birthWeight,
      'date_of_delivery': dateOfDelivery.toString(),
      'mode_of_delivery': modeOfDelivery.toString().split('.').last,
      'Gestational_age_at_delivery': gestationalAgeAtDelivery,
      'Temp': temp,
      'Pulse': pulse,
      'Resp_rate': respRate,
      'Weight': weight,
      'height': height,
      'HC': hc,
      'Sex': sex.toString().split('.').last,
      'Congenital_Malformation':
          congenitalMalformation.toString().split('.').last,
      'Jaundice': jaundice.toString().split('.').last,
      'Cyanosis': cyanosis.toString().split('.').last,
      'Umbilical_stump': umbilicalStump,
      'Feeding': feeding.toString().split('.').last,
      'Remarks': remarks,
      'doctor_name': doctorName,
      'midwife_name': midwifeName,
      'nurse_name': nurseName,
    };
  }
}
