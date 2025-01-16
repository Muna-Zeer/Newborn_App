import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/Newborns/newbornDetails.dart';
import 'package:my_vaccine_app/screens/Newborns/newbornView.dart';
import 'package:my_vaccine_app/screens/mother/mother_api.dart';

class NewbornsWidget extends StatefulWidget {
  final String motherIdentityNumber;
  final String motherName;

  NewbornsWidget(
      {required this.motherIdentityNumber, required this.motherName});

  @override
  _NewbornsWidgetState createState() => _NewbornsWidgetState();
}

class _NewbornsWidgetState extends State<NewbornsWidget> {
  List<Map<String, dynamic>> newborns = [];

  @override
  void initState() {
    super.initState();
    fetchNewborns(widget.motherIdentityNumber).then((data) {
      setState(() {
        newborns = data;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  void navigateToNewbornDetails(
      Map<String, dynamic> newborn, String motherName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NewbornDetailsPage(newbornData: newborn, motherName: motherName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: newborns.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              color: Colors.grey[300],
              child: const Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'معلومات الطفل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'رقم هوية الطفل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'اسم الطفل',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'الرقم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final newborn = newborns[index - 1];

          return GestureDetector(
            onTap: () {
              navigateToNewbornDetails(newborn, widget.motherName);
            },
            child: Container(
              color: index % 2 == 0
                  ? const Color.fromARGB(255, 190, 191, 193)
                  : Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () => navigateToNewbornDetails(
                            newborn, widget.motherName),
                        child: const Text(
                          "معلومات الطفل",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        newborn['identity_number'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        newborn['firstName'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        index.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
