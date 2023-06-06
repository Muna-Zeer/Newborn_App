enum if_yes { Repaired, Hysterectomy_Done }

enum Lochia_Color { White, Yellow, Red }

enum Breasts { pain, redness, Hot, Abnormal_Secretions }

enum Incision { Clean, Infected }

class PostnatalExaminations {
  int id;
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
  String motherName;
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
    required this.motherName,
  });

  // JSON Serialization/Deserialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_after_delivery': dayAfterDelivery ?? 0,
      'date_of_visit': dateOfVisit?.toIso8601String() ?? '',
      'Temp': temp ?? '',
      'Pulse': pulse ?? '',
      'B_P': bp ?? '',
      'bleeding_after_delivery': bleedingAfterDelivery ?? false,
      'Hb': hb ?? '',
      'DVT': dvt ?? false,
      'Rupture_Uterus': ruptureUterus ?? false,
      'if_yes': ifYes?.toString().split('.').last ?? '',
      'Lochia_color': lochiaColor?.toString().split('.').last ?? '',
      'Incision': incision?.toString().split('.').last ?? '',
      'Seizures': seizures ?? false,
      'Blood_Transfusion': bloodTransfusion ?? false,
      'Breasts': breasts?.toString().split('.').last ?? '',
      'Fundal_Height': fundalHeight ?? 0,
      'Family_Planing_Counseling': familyPlanningCounseling ?? '',
      'FP_Appointment': fpAppointment?.toIso8601String() ?? '',
      'Recommendations': recommendations ?? '',
      'Remarks': remarks ?? '',
      'doctor_id': doctorName ?? '',
      'midwife_id': midwifeName ?? '',
      'nurse_id': nurseName ?? '',
      'mother_name': motherName ?? '',
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
      bleedingAfterDelivery: json['bleeding_after_delivery'] == 0,
      hb: json['Hb'] ?? '',
      dvt: json['DVT'] == 0,
      ruptureUterus: json['Rupture_Uterus'] == 0,
      ifYes: if_yes.values.firstWhere(
        (element) => element.toString().split('.').last == json['if_yes'],
        orElse: () => if_yes.Repaired,
      ),
      lochiaColor: Lochia_Color.values.firstWhere(
        (element) => element.toString().split('.').last == json['Lochia_color'],
        orElse: () => Lochia_Color.Red,
      ),
      incision: Incision.values.firstWhere(
        (element) => element.toString().split('.').last == json['Incision'],
        orElse: () => Incision.Clean,
      ),
      seizures: json['Seizures'] == 0,
      bloodTransfusion: json['Blood_Transfusion'] == 0,
      breasts: Breasts.values.firstWhere(
        (element) => element.toString() == 'Breasts.' + json['Breasts'],
        orElse: () => Breasts.Hot,
      ),
      fundalHeight: json['Fundal_Height'] ?? 0,
      familyPlanningCounseling: json['Family_Planing_Counseling'] ?? '',
      fpAppointment: DateTime.parse(json['FP_Appointment']),
      recommendations: json['Recommendations'] ?? '',
      remarks: json['Remarks'] ?? '',
      doctorid: json['doctor_id'] ?? 0,
      midwifeid: json['midwife_id'] ?? 0,
      nurseid: json['nurse_id'] ?? 0,
      motherName: json['mother_name'] ?? 'Reem',
      doctorName: '',
      midwifeName: '',
      nurseName: '',
    );
  }
  Map<String, String> validate() {
    final errors = <String, String>{};

    if (dayAfterDelivery == null) {
      errors['day_after_delivery'] =
          'The day after delivery field is required.';
    }

    if (dateOfVisit == null) {
      errors['date_of_visit'] = 'The date of visit field is required.';
    }

    if (temp.isEmpty) {
      errors['Temp'] = 'The temp field is required.';
    }

    if (pulse.isEmpty) {
      errors['Pulse'] = 'The pulse field is required.';
    }

    if (bp.isEmpty) {
      errors['B_P'] = 'The b p field is required.';
    }

    if (hb.isEmpty) {
      errors['Hb'] = 'The hb field is required.';
    }

    return errors;
  }
}
