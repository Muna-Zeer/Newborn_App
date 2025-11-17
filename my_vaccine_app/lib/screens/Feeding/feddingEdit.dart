import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/Alert_Dialog/feedingAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingClass.dart';
import 'package:my_vaccine_app/screens/Feeding/feedingTable.dart';

class FeedingEdit extends StatefulWidget {
  final int feedingId;

  const FeedingEdit({
    Key? key,
    required this.feedingId,
  }) : super(key: key);
  @override
  _FeedingEditState createState() => _FeedingEditState();
}

class _FeedingEditState extends State<FeedingEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedingTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController ministryIdController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedFeeding = Feeding(
        id: widget.feedingId,
        feedingType: feedingTypeController.text,
        quantity: double.parse(quantityController.text),
        month: monthController.text,
        instructions: instructionsController.text,
        date: DateTime.parse(dateController.text),
        ministryId: 1,
      );

      updateFeeding(updatedFeeding);
    }
  }

  Future<void> updateFeeding(Feeding feeding) async {
    final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse('$baseUrl/feedings/${feeding.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(feeding.toJson());

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Response: ${response.statusCode} ${response.reasonPhrase}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);
      final updatedFeeding = Feeding.fromJson(responseData['data']);
      feedingTypeController.text = updatedFeeding.feedingType ?? '';
      quantityController.text = updatedFeeding.quantity?.toString() ?? '';
      dateController.text = updatedFeeding.date?.toString() ?? '';
      monthController.text = updatedFeeding.month ?? '';
      monthController.text = updatedFeeding.month ?? '';
      FeedingDialog.showSuccessDialog(context);
    } else {
      print('Unexpected status code: ${response.statusCode}');
      FeedingDialog.showErrorDialog(context, response.statusCode);
    }

    feedingTypeController.clear();
    instructionsController.clear();
    ministryIdController.clear();
    dateController.clear();
    monthController.clear();
    quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('قائمة التغذية'),
        ]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: const Color.fromARGB(255, 2, 31, 54),
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/feed2.jpg',
                    width: 150.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
           const   SizedBox(
                height: 16.0,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 2, 31, 54),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3)),
                    ]),
                child: Column(children: [
             const     Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        ' نوع الغذاء',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: feedingTypeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the feeding type';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
          const    SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ' الكمية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      textAlign: TextAlign.right,
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0.0',
                      ),
                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                    ),
                  ]
                  )
                  ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'التاريخ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: dateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        if (pickedDate != null) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ])),
              SizedBox(
                height: 16.0,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 2, 31, 54),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3)),
                    ]),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        ' الشهر',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: monthController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the month';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ' التعليمات',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: instructionsController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the instructions';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(height: 16.0),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'رقم  الصحة',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: ministryIdController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the ministry ID';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(
                height: 16.0,
              ),
              Column(children: [
                ElevatedButton(
                  onPressed: () {
                    submitForm();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                  ),
                  child: Text(
                    '  تحديث   القائمة',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedingTable()),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue)),
                  child: Text(
                    'الاطلاع ع الجدول',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
