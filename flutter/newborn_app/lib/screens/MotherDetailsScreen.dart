import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../methods/mother_api.dart';
import 'package:newborn_app/constant/models/mother.dart';

class MotherDetailsScreen extends StatefulWidget {
  final int motherId;

  const MotherDetailsScreen({Key? key, required this.motherId})
      : super(key: key);
  @override
  _MotherDetailsScreenState createState() => _MotherDetailsScreenState();
}

class _MotherDetailsScreenState extends State<MotherDetailsScreen> {
  Map<String, dynamic>? _motherData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mother Details'),
        ),
        body: Center(
          child: FutureBuilder<Mother>(
            future: fetchMother(widget.motherId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final mother = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${mother.firstName}'),
                    Text('Age: ${mother.age}'),
                    Text('Address: ${mother.address}'),
                    Text('Phone: ${mother.husbandPhoneNumber}'),
                    Text('Email: ${mother.email}'),
                    Text('Date of Birth: ${mother.dateOfBirth}'),
                    Text('HR: ${mother.rhesusFactor}'),
                    Text('Blood Type: ${mother.bloodType}'),
                    Text('Country: ${mother.country}'),
                    Text('City: ${mother.city}'),
                    Text('Number of Newborns: ${mother.numberOfNewborns}'),
                    Text('Husband Phone Number: ${mother.husbandPhoneNumber}'),
                    Text('Hospital Name: ${mother.hospitalCenterName}'),
                    Text('Ministry of Health: ${mother.ministryName}'),
                    Text('Nurse Name: ${mother.midwifeName}'),
                    Text('Doctor Name: ${mother.doctorName}'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
