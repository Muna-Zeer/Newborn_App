enum if_yes { Repaired, Hysterectomy_Done }

enum Lochia_Color { White, Yellow, Red }

enum Breasts { pain, redness, Hot, Abnormal_Secretions }

enum Incision { Clean, Infected }

class PostnatalExaminations {
  String id;
  int dayAfterDelivery;
  DateTime dateOfVisit;
  String temp;
  String pulse;
  String bp;
  bool bleedingAfterDelivery;
  String hb;
  bool dvt;
  bool ruptureUterus;
  if_yes ifYes;
  Lochia_Color lochiaColor;
  Incision incision;
  bool seizures;
  bool bloodTransfusion;
  Breasts breasts;
  int fundalHeight;
  String familyPlanningCounseling;
  DateTime fpAppointment;
  String recommendations;
  String remarks;
  String doctorName;
  String midwifeName;
  String nurseName;
  int doctorid;
  int midwifeid;
  int nurseid;

  PostnatalExaminations({
    required this.id,
    required this.dayAfterDelivery,
    required this.dateOfVisit,
    required this.temp,
    required this.pulse,
    required this.bp,
    required this.bleedingAfterDelivery,
    required this.hb,
    required this.dvt,
    required this.ruptureUterus,
    required this.ifYes,
    required this.lochiaColor,
    required this.incision,
    required this.seizures,
    required this.bloodTransfusion,
    required this.breasts,
    required this.fundalHeight,
    required this.familyPlanningCounseling,
    required this.fpAppointment,
    required this.recommendations,
    required this.remarks,
    required this.doctorName,
    required this.midwifeName,
    required this.nurseName,
    required this.doctorid,
    required this.midwifeid,
    required this.nurseid,
  });

  // JSON Serialization/Deserialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_after_delivery': dayAfterDelivery,
      'date_of_visit': dateOfVisit.toIso8601String(),
      'Temp': temp,
      'Pulse': pulse,
      'B_P': bp,
      'bleeding_after_delivery': bleedingAfterDelivery,
      'Hb': hb,
      'DVT': dvt,
      'Rupture_Uterus': ruptureUterus,
      'if_yes': ifYes.toString().split('.').last,
      'Lochia_color': lochiaColor.toString().split('.').last,
      'Incision': incision.toString().split('.').last,
      'Seizures': seizures,
      'Blood_Transfusion': bloodTransfusion,
      'Breasts': breasts.toString().split('.').last,
      'Fundal_Height': fundalHeight,
      'Family_Planing_Counseling': familyPlanningCounseling,
      'FP_Appointment': fpAppointment.toIso8601String(),
      'Recommendations': recommendations,
      'Remarks': remarks,
      'doctor_id': doctorName,
      'midwife_id': midwifeName,
      'nurse_id': nurseName,
    };
  }

  factory PostnatalExaminations.fromJson(Map<String, dynamic> json) {
    return PostnatalExaminations(
      id: json['id'],
      dayAfterDelivery: json['day_after_delivery'] ?? 0,
      dateOfVisit: DateTime.parse(json['date_of_visit']),
      temp: json['Temp'] ?? '',
      pulse: json['Pulse'] ?? '',
      bp: json['B_P'] ?? '',
      bleedingAfterDelivery: json['bleeding_after_delivery'] ?? false,
      hb: json['Hb'] ?? '',
      dvt: json['DVT'] ?? false,
      ruptureUterus: json['Rupture_Uterus'] ?? false,
      ifYes: if_yes.values.firstWhere(
          (element) => element.toString() == 'if_yes.' + json['if_yes']),
      lochiaColor: Lochia_Color.values.firstWhere((element) =>
          element.toString() == 'Lochia_color.' + json['Lochia_color']),
      incision: Incision.values.firstWhere(
          (element) => element.toString() == 'Incision.' + json['Incision']),
      seizures: json['Seizures'] ?? false,
      bloodTransfusion: json['Blood_Transfusion'] ?? false,
      breasts: Breasts.values.firstWhere(
          (element) => element.toString() == 'Breasts.' + json['Breasts']),
      fundalHeight: json['Fundal_Height'] ?? 0,
      familyPlanningCounseling: json['Family_Planing_Counseling'] ?? '',
      fpAppointment: DateTime.parse(json['FP_Appointment']),
      recommendations: json['Recommendations'] ?? '',
      remarks: json['Remarks'] ?? '',
      doctorid: json['doctor_id'] ?? null,
      midwifeid: json['midwife_id'] ?? null,
      nurseid: json['nurse_id'] ?? null,
      doctorName: '',
      midwifeName: '',
      nurseName: '',
    );
  }
}
