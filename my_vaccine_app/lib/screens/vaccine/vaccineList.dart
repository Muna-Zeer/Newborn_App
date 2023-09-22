import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';

class VaccineList extends StatefulWidget {
  @override
  _VaccineListState createState() => _VaccineListState();
}

class _VaccineListState extends State<VaccineList> {
  final baseUrl = ApiService.getBaseUrl();

  late TextEditingController _searchController;
  List<dynamic> vaccineList = [];
  List<dynamic> filteredList = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchVaccines();
  }

  Future<void> fetchVaccines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/allVaccines'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          vaccineList = responseData['data'];
          filteredList = vaccineList;
        });
      }
    } catch (error) {
      print('Failed to fetch vaccines: $error');
    }
  }

  void filterVaccines(String searchQuery) {
    setState(() {
      filteredList = vaccineList.where((vaccine) {
        final name = vaccine['name'].toString().toLowerCase();
        final doses = vaccine['doses'].toString().toLowerCase();
        final place = vaccine['place'].toString().toLowerCase();
        final diseases = vaccine['diseases'].toString().toLowerCase();
        final arabicQuery = searchQuery.toLowerCase();

        return name.contains(arabicQuery) ||
            doses.contains(arabicQuery) ||
            place.contains(arabicQuery) ||
            diseases.contains(arabicQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'قائمة التطعيمات',
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Set the background color
        padding: EdgeInsets.all(16.0), // Add padding around the list
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align the column at the end of the page
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                onChanged: filterVaccines,
                decoration: InputDecoration(
                  labelText: 'بحث',
                  prefixIcon: Icon(Icons.search),
                ),
                textDirection: TextDirection.rtl, // For Arabic text input
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final vaccine = filteredList[index];
                  return Container(
                    margin: EdgeInsets.only(
                        bottom: 8.0), // Add margin between the lists
                    color: Colors.white, // Set the background color of the list
                    child: ListTile(
                      title: Text(
                        vaccine['name'].toString(),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('جرعة: ${vaccine['doses']}'),
                          Text('المكان: ${vaccine['place']}'),
                          Text('الامراض : ${vaccine['diseases']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
