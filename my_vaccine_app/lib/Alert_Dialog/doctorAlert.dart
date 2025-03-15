import 'package:flutter/material.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';


class DoctorAlert {
  static void showSuccessAlert(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Success'),
          content: Text('Doctor ${doctor.name} has been created successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Error creating doctor.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
