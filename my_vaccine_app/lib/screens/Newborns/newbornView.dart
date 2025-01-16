import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';

class NewbornDetailsPage extends StatefulWidget {
  final Map<String, dynamic> newbornData;
  final String motherName;

  const NewbornDetailsPage(
      {required this.newbornData, required this.motherName});

  @override
  _NewbornDetailsPageState createState() => _NewbornDetailsPageState();
}

class _NewbornDetailsPageState extends State<NewbornDetailsPage> {
  List<Map<String, dynamic>> vaccines = [];

  @override
  void initState() {
    super.initState();
    fetchVaccines();
  }

  Future<void> fetchVaccines() async {
    final baseUrl = ApiService.getBaseUrl();
    final url = Uri.parse('$baseUrl/vaccines/${widget.newbornData['id']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the 'vaccines' field is null
        if (data['vaccines'] == null) {
          throw Exception("Received null value for 'vaccines'");
        }

        final vaccinesData = data['vaccines'];

        setState(() {
          vaccines = List<Map<String, dynamic>>.from(vaccinesData);
        });
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Request failed with error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mother = widget.newbornData['mother'];
    print(mother);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Newborn Details"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 143, 194, 236),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "معلومات الطفل",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/girlprofile.jpg',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "اسم الأم: ${widget.motherName}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      " الاسم: ${widget.newbornData['firstName']}   ${widget.newbornData['lastName']}"),
                                  Text(
                                      "تاريخ الميلاد:${widget.newbornData['date_of_birth']}"),
                                  Text(" ${widget.newbornData['gender']}جنس:"),
                                  Text(
                                      "الوزن: ${widget.newbornData['weight']}"),
                                  Text(
                                      "الطول:  ${widget.newbornData['length']}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Vaccination Schedule
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vaccination Schedule",
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Vaccine"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Date"),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Hepatitis B"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("24-Dec-2024"),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("BCG"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("01-Jan-2025"),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Medical Team
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Medical Team",
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 8),
                    Text("Midwife: Jane Doe"),
                    Text("Pediatrician: Dr. Smith"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Parent Notes
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Parent Notes",
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 8),
                    Text("Remember to book the next vaccine appointment."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
