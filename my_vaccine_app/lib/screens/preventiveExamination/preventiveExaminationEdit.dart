import 'package:flutter/widgets.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveEaminationClass.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamintationTable.dart';

class preventiveExamEdit extends StatefulWidget {
  final int examinationId;
  const preventiveExamEdit({
    Key? key,
    required this.examinationId,
  }) : super(key: key);
  @override
  _prevExaminationState createState() => _prevExaminationState();
}

class _prevExaminationState extends State<preventiveExamEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: 'yyyy,MM,dd');
  TextEditingController _timeController = TextEditingController(text: '12:00');
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _resultController = TextEditingController();
  TextEditingController _newbornIdController = TextEditingController();
  TextEditingController _healthCenterIdController = TextEditingController();
  TextEditingController _ministryIdController = TextEditingController();
  TextEditingController _nurseIdController = TextEditingController();
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      DateTime currentTime = DateTime.now();
      DateTime selectedDateTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      try {
        final updatedPrevExam = PreventiveExamination(
          id: widget.examinationId,
          examType: _examTypeController.text,
          date: DateTime.parse(_dateController.text),
          ministryId: 1,
          time: selectedDateTime,
          result: _resultController.text,
          newbornId: _newbornIdController.text,
          nurseId: int.tryParse(_nurseIdController.text) ??
              0,
        );
        print(updatedPrevExam);

        print("_timeController.text: ${_timeController.text}");

        // Format the time as 'HH:mm:ss'
        String formattedTime = DateFormat('HH:mm:ss').format(selectedDateTime);
        print("Formatted Time: $formattedTime");

        await updatePrevExam(updatedPrevExam);
      } catch (e) {
      
        print("Error creating PreventiveExamination: $e");
      }
    }
  }

  Future<void> updatePrevExam(PreventiveExamination examination) async {
    final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse('$baseUrl/preventiveExamination/${examination.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(examination.NewToJson());
    print('${body}');
    try {
      final response = await http.put(url, headers: headers, body: body);
      print('Response: ${response.statusCode} - ${response.body}');
      print('response${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedGuideline =
            PreventiveExamination.fromJson(responseData['data']);
        print(PreventiveExamination);
        _examTypeController.text = updatedGuideline.examType ?? '';
        _timeController.text = updatedGuideline.time?.toString() ?? '';
        _dateController.text = updatedGuideline.date?.toString() ?? '';
        _resultController.text = updatedGuideline.result ?? '';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 2, 31, 54),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/doneImg.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'تم التحديث بنجاح',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
                ));
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              content: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 2, 31, 54),
                        width: 2.0,
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/sadBaby.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'خطا',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: const Color.fromARGB(255, 2, 31, 54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'لم يتم التحديث',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: const Color.fromARGB(255, 2, 31, 54),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )));
        },
      );
    }
    _examTypeController.clear();
    _timeController.clear();
    _dateController.clear();
    _resultController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' تحديث الفحوصات الوقائية',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: 200.0,
                height: 200.0,
                child: Image.asset(
                  'assets/vaccineTime.jpg',
                  width: 300.0,
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
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
                          'نوع الفحص ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _examTypeController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an exam type';
                        }
                        return null;
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
                          'التاريخ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _dateController,
                      textAlign: TextAlign.right,
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
                            _dateController.text = formattedDate;
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
                          'الوقت',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _timeController,
                      textAlign: TextAlign.right,
                      onTap: () async {
                        final initialTime = TimeOfDay.now();
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        );

                        if (selectedTime != null) {
                          // Format the time as 'HH:mm'
                          final formattedTime =
                              "${selectedTime.hour}:${selectedTime.minute}";
                          _timeController.text = formattedTime;

                          // Optionally, you can also update the _selectedTime variable
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter time of delivery';
                        }
                        return null;
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
                          'النتيجة',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _resultController,
                      // keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a ministry ID';
                        }
                        return null;
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
                          'رقم وزارة الصحة ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _ministryIdController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a ministry ID';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(
                height: 16.0,
              ),
              Row(children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    submitForm();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>((Colors.lightBlue))),
                  child: Text(
                    'تحديث',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ))
              ]),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreventiveExaminationTable()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    child: Text(
                      'مشاهدة الجدول',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
