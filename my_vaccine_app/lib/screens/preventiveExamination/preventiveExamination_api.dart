import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:http/http.dart' as http;

Future<void> deletePreventiveExamination(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();
  final response =
      await http.delete(Uri.parse('$baseUrl/preventiveExamination/$id'));
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('تم حذف الفحص بنجاح'),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('للأسف لم يتم حذف الفحص'),
      ),
    );
  }
}

Future<void> deletePreventiveExamAdmin(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();
  final response =
      await http.delete(Uri.parse('$baseUrl/admin_prevExamination/$id'));
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('تم حذف الفحص بنجاح'),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('للأسف لم يتم حذف الفحص'),
      ),
    );
  }
}

Future<bool> editPreventiveExam(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();
  final response =
      await http.put(Uri.parse('$baseUrl/preventiveExamination/$id'));
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
