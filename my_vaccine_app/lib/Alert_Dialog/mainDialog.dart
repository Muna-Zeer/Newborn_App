import 'package:flutter/material.dart';

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: const Color.fromARGB(255, 2, 31, 54),
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/delete.webp',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'هل تريد الحذف',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text('الغاء',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('حذف',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

// Function to show success dialog after deletion
  void showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تم بنجاج',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'لقد تم حذفها بنجاح .',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

