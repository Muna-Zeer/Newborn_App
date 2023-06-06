import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/alert/doctorAlert.dart';
import 'package:newborn_app/constant/models/Doctor.dart';
import 'package:path/path.dart';

//get info of doctor by doctorId
Future<Doctor> fetchDoctor(int doctorId) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/doctors/$doctorId'));
  if (response.statusCode == 200) {
    return Doctor.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load doctor');
  }
}

Future<List<dynamic>> fetchDoctors() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/fetchDoctors'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  } else {
    throw Exception('Failed to fetch doctors');
  }
}

Future<bool> createDoctor(
    Doctor doctor, String imageString, BuildContext context) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/api/doctors'),
  );
  File? image;
  if (image != null) {}
  // Add fields for the Doctor object
  request.fields['name'] = doctor.name;
  request.fields['salary'] = doctor.salary.toString();
  request.fields['nurseName'] = doctor.nurseName;
  request.fields['midwifeName'] = doctor.midwifeName;
  request.fields['specialization'] = doctor.specialization;
  request.fields['country'] = doctor.country;
  request.fields['city'] = doctor.city;
  request.fields['email'] = doctor.email;
  request.fields['phone'] = doctor.phone;
  request.fields['image'] = imageString;
  request.fields['ministry_of_health_id'] =
      doctor.ministryOfHealthId.toString();
  request.fields['hospital_id'] = doctor.hospitalId.toString();

  request.fields['schedule'] = json.encode(doctor.schedule);
  for (int i = 0; i < doctor.schedule.length; i++) {
    request.fields['schedule[$i][day]'] = doctor.schedule[i]['day']!;
    request.fields['schedule[$i][start]'] = doctor.schedule[i]['start']!;
    request.fields['schedule[$i][end]'] = doctor.schedule[i]['end']!;
  }

  request.fields['about'] = doctor.about;
  request.fields['startTime'] = doctor.startTime;
  request.fields['endTime'] = doctor.endTime;

  // Add the image file to the request

  var response = await request.send();

  if (response.statusCode == 201) {
    print('value of response is $response');
    DoctorAlert.showSuccessAlert(context, doctor);
    return true;
  } else {
    print('Request: $request');
    DoctorAlert.showError(context);
    return false;
  }
}

Future<void> deleteDoctor(int id, BuildContext context) async {
  final response =
      await http.delete(Uri.parse('http://127.0.0.1:8000/api/doctors/$id'));

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
  final response =
      await http.put(Uri.parse('http://127.0.0.1:8000/api/doctors/$id'));

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
    Uri.parse('http://127.0.0.1:8000/api/doctors/$id'),
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

  final response =
      await http.put(Uri.parse('http://127.0.0.1:8000/api/doctors/$id'), body: {
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/hospitals'));
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/doctors'));
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/midwivesForm'));
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/ministryofhealths'));
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/fetchNurse'));
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
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/fetchVaccines'));
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
