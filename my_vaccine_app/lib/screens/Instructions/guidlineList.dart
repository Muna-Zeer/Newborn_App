import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'dart:convert';

import 'package:my_vaccine_app/screens/Instructions/guildlineClass.dart';

class GuidelineList extends StatefulWidget {
  @override
  _GuidelineListState createState() => _GuidelineListState();
}

class _GuidelineListState extends State<GuidelineList> {
  TextEditingController preventionMethodController = TextEditingController();
  TextEditingController careInstructionsController = TextEditingController();
  TextEditingController sideEffectsController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Widget> guidelineList = [];
  List<Widget> filterList = [];

  @override
  void initState() {
    super.initState();
    fetchGuidelines();
  }

  Future<void> fetchGuidelines() async {
    try {
      final baseUrl = ApiService.getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/guidelines'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final guidelines = responseData['data'];

        setState(() {
          guidelineList = guidelines.map<Widget>((guidelineData) {
            final guideline = Guideline.fromJson(guidelineData);

            //add icon card

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'اسم التطعيم: ${guideline.vaccineName ?? ''}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'الاثارالجانبية: ${guideline.sideEffects ?? ''}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'التعليمات: ${guideline.careInstructions ?? ''}',
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    'طريقة الوقاية: ${guideline.preventionMethod ?? ''}',
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              onTap: () {
                preventionMethodController.text =
                    guideline.preventionMethod ?? '';
                sideEffectsController.text = guideline.sideEffects ?? '';
                vaccineNameController.text = guideline.vaccineName ?? '';
                careInstructionsController.text =
                    guideline.careInstructions ?? '';
              },
            );
          }).toList();
          filterList = List.from(guidelineList);
        });
      }
    } catch (error) {
      print('Failed to fetch guidelines: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: ListView(
          shrinkWrap: true,
          children: [
            Text(
              ' الارشادات الصحية',
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'الأعراض الرئيسية للتطعيمات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(35, 20, 120, 0.992),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) {
                      filterGuidelines(query);
                    },
                    decoration: InputDecoration(
                      hintText: '...بحث',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Card(
                        color: Color.fromARGB(255, 189, 222, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Color.fromARGB(79, 0, 0, 0),
                            width: 4.0,
                          ),
                        ),
                        child: ListTile(
                          title: filterList[index],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterGuidelines(String query) {
    setState(() {
      filterList = guidelineList.where((element) {
        final guildLine = (element as ListTile).title as Column;
        final vaccineName = guildLine.children[0].toString().toLowerCase();
        final sideEffects = guildLine.children[1].toString().toLowerCase();
        final careInstruction = guildLine.children[2].toString().toLowerCase();
        final preventiveMethod = guildLine.children[3].toString().toLowerCase();

        return vaccineName.contains(query.toLowerCase()) ||
            sideEffects.contains(query.toLowerCase()) ||
            careInstruction.contains(query.toLowerCase()) ||
            preventiveMethod.contains(query.toLowerCase());
      }).toList();
    });
  }
}
