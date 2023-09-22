import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingClass.dart';

class FeedingListView extends StatefulWidget {
  @override
  _FeedingListViewState createState() => _FeedingListViewState();
}

class _FeedingListViewState extends State<FeedingListView> {
  List<Map<String, dynamic>> feedings = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final baseUrl = ApiService.getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/feedings'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Iterable) {
        setState(() {
          feedings = List<Feeding>.from(data.map((json) {
            // Exclude the 'date' field when creating the Feeding object
            json.remove('date');
            return Feeding.fromJson(json);
          })).cast<Map<String, dynamic>>();
        });
      } else {
        // Handle error: Invalid data format
      }
    } else {
      // Handle error: HTTP request failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'قائمة التغذية',
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: feedings.length,
        itemBuilder: (context, index) {
          final feeding = feedings[index];

          return ListTile(
            title: Text(feeding['id']?.toString() ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نوع الغذاء: ${feeding['feedingType'] ?? ''}',
                  textAlign: TextAlign.right,
                ),
                Text(
                  'الكمية: ${feeding['quantity']?.toString() ?? ''}',
                  textAlign: TextAlign.right,
                ),
                Text(
                  'التعليمات: ${feeding['instructions'] ?? ''}',
                  textAlign: TextAlign.right,
                ),
                Text(
                  'الشهر: ${feeding['month'] ?? ''}',
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
