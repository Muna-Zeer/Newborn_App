import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/screens/vaccine/VaccineDetails.dart';

class NewbornDetailsPage extends StatefulWidget {
  final Map<String, dynamic> newbornData;

  NewbornDetailsPage({required this.newbornData});

  @override
  _NewbornDetailsPageState createState() => _NewbornDetailsPageState();
}

class _NewbornDetailsPageState extends State<NewbornDetailsPage> {
  // List<Map<String, dynamic>> vaccines = [];

  @override
  // void initState() {
  //   super.initState();
  //   fetchVaccines();
  // }

  // Future<void> fetchVaccines() async {
  //   final url = Uri.parse(
  //       'http://127.0.0.1:8000/api/vaccines/${widget.newbornData['id']}');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       // Check if the 'vaccines' field is null
  //       if (data['vaccines'] == null) {
  //         throw Exception("Received null value for 'vaccines'");
  //       }

  //       final vaccinesData = data['vaccines'];

  //       setState(() {
  //         // vaccines = List<Map<String, dynamic>>.from(vaccinesData);
  //       });
  //     } else {
  //       throw Exception('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     throw Exception('Request failed with error: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Newborn Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Newborn Identity Number: ${widget.newbornData['identity_number']}'),
              Text('ID: ${widget.newbornData['id']}'),
              Text('First Name: ${widget.newbornData['firstName']}'),
              Text('Last Name: ${widget.newbornData['lastName']}'),
              Text('Date of Birth: ${widget.newbornData['date_of_birth']}'),
              Text('Gender: ${widget.newbornData['gender']}'),
              Text('Mother Name: ${widget.newbornData['motherName']}'),
              SizedBox(height: 20),
              Text(
                'Vaccine Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VaccineTable(
                        identityNumber: widget.newbornData['identity_number'],
                        newbornName: widget.newbornData['firstName'] +
                            ' ' +
                            widget.newbornData['lastName'],
                      ),
                    ),
                  );
                },
                child: Text('Vaccines Table'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
