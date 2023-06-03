import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VaccineList extends StatefulWidget {
  @override
  _VaccineListState createState() => _VaccineListState();
}

class _VaccineListState extends State<VaccineList> {
  final url = Uri.parse('http://127.0.0.1:8000/api/vaccines');
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
      final response = await http.get(url);
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
        title: Text('Vaccine List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: filterVaccines,
              decoration: InputDecoration(
                labelText: 'Search',
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
                return ListTile(
                  title: Text(vaccine['name'].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doses: ${vaccine['doses']}'),
                      Text('Place: ${vaccine['place']}'),
                      Text('Diseases: ${vaccine['diseases']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
