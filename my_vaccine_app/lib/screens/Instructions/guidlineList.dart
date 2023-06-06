import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'dart:convert';

import 'package:my_vaccine_app/screens/Instructions/guildlineClass.dart';

class GuidelineList extends StatefulWidget {
  @override
  _GuidelineListState createState() => _GuidelineListState();
}

class _GuidelineListState extends State<GuidelineList> {
  final url = Uri.parse('http://127.0.0.1:8000/api/guidelines');
  TextEditingController preventionMethodController = TextEditingController();
  TextEditingController careInstructionsController = TextEditingController();
  TextEditingController sideEffectsController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();

  List<Widget> guidelineList = [];

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

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vaccine Name: ${guideline.vaccineName ?? ''}'),
                  Text('Side Effects: ${guideline.sideEffects ?? ''}'),
                  Text('Instructions: ${guideline.careInstructions ?? ''}'),
                  Text(
                      'Preventive Method: ${guideline.preventionMethod ?? ''}'),
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
        title: Text('Guidelines'),
      ),
      body: ListView.builder(
        itemCount: guidelineList.length,
        itemBuilder: (context, index) {
          return Card(
            child: guidelineList[index],
          );
        },
      ),
    );
  }
}
