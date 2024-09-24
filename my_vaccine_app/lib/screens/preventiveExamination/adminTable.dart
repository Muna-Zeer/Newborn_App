import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/Alert_Dialog/adminPrev.dart';
import 'package:my_vaccine_app/Alert_Dialog/prevAdminAlerrt.dart';
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/AdminExamType.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/adminAdd.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/adminEdit.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination_api.dart';

class AdminPreventiveListView extends StatefulWidget {
  @override
  _PreventiveListViewState createState() => _PreventiveListViewState();
}

class _PreventiveListViewState extends State<AdminPreventiveListView> {
  List<AdminExamType> Examinations = [];
  int activePage = 0;
  int cardPerPage = 4;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final baseUrl = ApiService.getBaseUrl();
      final response =
          await http.get(Uri.parse('$baseUrl/admin_prevExaminations'));
      debugPrint("response of preventiveExamination of admin $response");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final prevExamination = responseData['data'];

        setState(() {
          Examinations = prevExamination
              .map<AdminExamType>(
                  (examinationData) => AdminExamType.fromJson(examinationData))
              .toList();
        });
      }
    } catch (error) {
      print('$error');
    }
  }

  bool isNumeric(String? strText) {
    if (strText == null) {
      return false;
    }
    return double.tryParse(strText) != null || int.tryParse(strText) != null;
  }

  Future<void> performAction(
      BuildContext context, AdminExamType examination, String action) async {
    if (action == "insert") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminAddPrevExam()),
      );
    } else if (action == 'edit') {
      await HelperDialogAdmin.showEditDialog(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AdminEditPrevExam(examinationId: examination.id)),
      );
    } else if (action == 'delete') {
      bool? confirmDelete = await HelperDialogAdmin.showDeleteDialog(context);
      if (confirmDelete != null && confirmDelete) {
        try {
          await deletePreventiveExamAdmin(examination.id, context);

          setState(() {
            Examinations.remove(examination);
          });
        } catch (e) {
          print('Error: $e');
        }
      }
    }
  }

  List<AdminExamType> examination = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'قائمة الفحوصات الوقائية ',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Image.asset('assets/vaccine7.jpg', width: 120.0, height: 150.0),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: (Examinations.length / cardPerPage).ceil(),
              onPageChanged: (index) {
                setState(() {
                  activePage = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * cardPerPage;
                final end = (pageIndex + 1) * cardPerPage;
                final currentList = Examinations.sublist(start,
                    end > Examinations.length ? Examinations.length : end);
                return ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 3.0,
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      color: Colors.lightBlue, width: 2.0)),
                              child: Column(children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/vaccine2.jpg'),
                                  ),
                                  title: Text(currentList[index].examType,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  subtitle: Text(
                                    currentList[index].description,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color:
                                              Color.fromARGB(255, 66, 70, 252)),
                                      onPressed: () {
                                        performAction(context,
                                            currentList[index], 'edit');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add,
                                          color:
                                              Color.fromARGB(255, 240, 52, 9)),
                                      onPressed: () {
                                        performAction(context,
                                            currentList[index], 'insert');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.black),
                                      onPressed: () {
                                        performAction(context,
                                            currentList[index], 'delete');
                                      },
                                    ),
                                  ],
                                ),
                              ])));
                    });
              },
            ),
          ),
          SizedBox(height: 10),
          buildPageIndicator(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildPageIndicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate((Examinations.length / cardPerPage).ceil(), (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: 8.0,
            width: 8.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activePage == index ? Colors.lightBlue : Colors.grey),
          );
        }));
  }
}
