import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';

class NewbornExaminationAlert {
  static void showSuccessAlert(
      BuildContext context, NewbornExamination newborn) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('newborn Examination was saved'),
              content: Text(
                  'the information for ${newborn.newbornName} has been saved'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text('OK'))
              ]);
        });
  }

  static void showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred while saving the newborn examination. Please try again.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
