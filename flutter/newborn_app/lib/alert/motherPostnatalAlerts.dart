import 'package:flutter/material.dart';
import 'package:newborn_app/widgets/postnatalExamination.dart';

class MotherPostnatalAlert {
  static void showSuccessAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Mother Postnatal was saved'),
              content: Text('the information for  has been saved'),
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
              'An error occurred while saving the mother Postnatal. Please try again.'),
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
