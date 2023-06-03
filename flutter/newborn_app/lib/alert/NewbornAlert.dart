import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/Newborn.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';

class NewbornAlert {
  static void showSuccessAlert(BuildContext context, Newborn newborn) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('newborn  was saved'),
              content: Text(
                  'the information for ${newborn.firstName} has been saved'),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: Navigator.of(context).pop, child: Text('OK'))
              ]);
        });
  }

  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
