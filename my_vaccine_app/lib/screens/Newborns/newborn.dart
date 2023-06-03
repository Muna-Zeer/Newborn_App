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
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text('Index'),
          ),
          DataColumn(
            label: Text('Newborn Identity Number'),
          ),
        ],
        rows: List<DataRow>.generate(
          newborns.length,
          (index) => DataRow(
            cells: [
              DataCell(
                Text((index + 1).toString()),
              ),
              DataCell(
                GestureDetector(
                  onTap: () {
                    navigateToNewbornDetails(newborns[index]);
                  },
                  child: Text(newborns[index]['identity_number']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
