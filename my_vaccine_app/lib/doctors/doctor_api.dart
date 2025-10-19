import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/Alert_Dialog/doctorAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final baseUrl = ApiService.getBaseUrl();
File? _imageFile; // for mobile
Uint8List? _webImageFile;
//get info of doctor by doctorId
Future<Doctor> fetchDoctor(int doctorId) async {
  final response = await http.get(Uri.parse('$baseUrl/doctors/$doctorId'));
  if (response.statusCode == 200) {
    return Doctor.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load doctor');
  }
}

Future<List<dynamic>> fetchDoctors() async {
  final response = await http.get(Uri.parse('$baseUrl/fetchDoctors'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  } else {
    throw Exception('Failed to fetch doctors');
  }
}

Future<bool> createDoctor(
  Doctor doctor,
  dynamic imageInput, // File (mobile) or Uint8List (web)
  BuildContext context,
) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/doctors'),
    )..fields.addAll({
        'name': doctor.name,
        'salary': doctor.salary.toString(),
        'nurseName': doctor.nurseName,
        'midwifeName': doctor.midwifeName,
        'specialization': doctor.specialization,
        'country': doctor.country,
        'city': doctor.city,
        'email': doctor.email,
        'phone': doctor.phone,
        'ministry_of_health_id': doctor.ministryOfHealthId.toString(),
        'hospital_id': doctor.hospitalId.toString(),
        'about': doctor.about,
        'startTime': doctor.startTime,
        'endTime': doctor.endTime,
      });

    // Schedule
    for (int i = 0; i < doctor.schedule.length; i++) {
      final s = doctor.schedule[i];
      request.fields['schedule[$i][day]'] = s['day'] ?? '';
      request.fields['schedule[$i][start]'] = s['start'] ?? '';
      request.fields['schedule[$i][end]'] = s['end'] ?? '';
    }

    // ✅ Image upload (works both on Web and Mobile)
    if (imageInput != null) {
      if (kIsWeb && imageInput is Uint8List) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageInput,
          filename: 'doctor.png',
        ));
      } else if (imageInput is File) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageInput.path,
        ));
      } else {
        print('⚠️ Unknown image type: ${imageInput.runtimeType}');
      }
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      DoctorAlert.showSuccessAlert(context, doctor);
      return true;
    } else {
      print('❌ Error ${response.statusCode}: $body');
      DoctorAlert.showError(context);
    }
  } catch (e) {
    print('❌ Exception: $e');
    DoctorAlert.showError(context);
  }
  return false;
}

Future<void> deleteDoctor(int id, BuildContext context) async {
  final response = await http.delete(Uri.parse('$baseUrl/doctors/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete doctor record.'),
      ),
    );
  }
}

Future<bool> editDoctor(int id, BuildContext context) async {
  final response = await http.put(Uri.parse('$baseUrl/doctors/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateSchedule(int id, List<Map<String, String>> schedule) async {
  final scheduleFields = List.generate(schedule.length, (i) {
    final scheduleItem = schedule[i];
    return {
      'schedule[$i][day]': scheduleItem['day'],
      'schedule[$i][start]': scheduleItem['start'],
      'schedule[$i][end]': scheduleItem['end'],
    };
  });

  final response = await http.put(
    Uri.parse('$baseUrl/doctors/$id'),
    body: {
      ...scheduleFields.reduce((value, element) => value..addAll(element)),
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateDoctor(
    int id, Doctor doctorData, BuildContext context) async {
  // Convert schedule list to string representation
  final scheduleString = jsonEncode(doctorData.schedule);

  final response = await http.put(Uri.parse('$baseUrl/doctors/$id'), body: {
    'name': doctorData.name,
    'specialization': doctorData.specialization,
    'country': doctorData.country,
    'city': doctorData.city,
    'email': doctorData.email,
    'phone': doctorData.phone,
    'salary': doctorData.salary,
    'about': doctorData.about,
    // 'HospitalName': doctorData.HospitalName,
    'schedule': scheduleString,
    'nurseName': doctorData.nurseName,
    'midwifeName': doctorData.midwifeName,
    'ministryOfHealthName': doctorData.ministryOfHealthName,
    'startTime': doctorData.startTime,
    'endTime': doctorData.endTime,
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List<Map<String, dynamic>>> fetchHospitals() async {
  final response = await http.get(Uri.parse('$baseUrl/hospitals/'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> hospitals =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return hospitals;
  } else {
    throw Exception('Failed to fetch hospitals');
  }
}

Future<List<Map<String, dynamic>>> fetchDoctorHospital() async {
  final response = await http.get(Uri.parse('$baseUrl/doctors'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> doctors =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return doctors;
  } else {
    throw Exception('Failed to fetch doctors');
  }
}

Future<List<Map<String, dynamic>>> fetchMidwives() async {
  final response = await http.get(Uri.parse('$baseUrl/midwivesForm'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> doctors =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return doctors;
  } else {
    throw Exception('Failed to fetch doctors');
  }
}

Future<List<Map<String, dynamic>>> fetchMinistriesOfHealth() async {
  final response = await http.get(Uri.parse('$baseUrl/ministryofhealths'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> ministriesOfHealth =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return ministriesOfHealth;
  } else {
    throw Exception('Failed to fetch ministries of health');
  }
}

Future<List<Map<String, dynamic>>> fetchNurses() async {
  final response = await http.get(Uri.parse('$baseUrl/fetchNurse'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> ministriesOfHealth =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return ministriesOfHealth;
  } else {
    throw Exception('Failed to fetch ministries of health');
  }
}

Future<List<Map<String, dynamic>>> fetchVaccines() async {
  final response = await http.get(Uri.parse('$baseUrl/fetchVaccines'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> ministriesOfHealth =
        data.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'],
        'name': item['name'].toString(),
      };
    }).toList();
    return ministriesOfHealth;
  } else {
    throw Exception('Failed to fetch ministries of health');
  }
}
