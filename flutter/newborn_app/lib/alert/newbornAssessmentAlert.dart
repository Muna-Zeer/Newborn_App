import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/newbornAssessments.dart';

class NewbornAssessmentAlert {
  static void showSuccessAlert(
      BuildContext context, NewbornAssessments Newborn) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Newborn Examination was saved'),
              content: Text('the information for ${Newborn.id} has been saved'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text('OK'))
              ]);
        });
  }

  static void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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
