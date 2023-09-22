import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/Newborns/newbornDetails.dart';
import 'package:my_vaccine_app/screens/mother/mother_api.dart';

class NewbornsWidget extends StatefulWidget {
  final String motherIdentityNumber;

  NewbornsWidget({required this.motherIdentityNumber});

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
      print(error);
    });
  }

  void navigateToNewbornDetails(Map<String, dynamic> newbornData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewbornDetailsPage(newbornData: newbornData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set a specific height
      child: ListView.builder(
        itemCount: newborns.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              color: Colors.grey[300],
              child: Row(
                children: const <Widget>[
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
                ],
              ),
            );
          }

          final newborn = newborns[index - 1];

          return GestureDetector(
            onTap: () {
              navigateToNewbornDetails(newborn);
            },
            child: Container(
              color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        index.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        newborn['identity_number'],
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
