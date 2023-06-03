import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';

class MotherExaminationAlert {
  static void showSuccessAlert(
      BuildContext context, MotherExaminations mother) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Mother Examination was saved'),
              content: Text(
                  'the information for ${mother.nameOfMother} has been saved'),
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
              'An error occurred while saving the mother examination. Please try again.'),
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
