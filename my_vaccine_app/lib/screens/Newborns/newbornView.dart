import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/provider/newbornProvider.dart';
import 'package:my_vaccine_app/screens/vaccine/VaccineDetails.dart';
import 'package:my_vaccine_app/screens/vaccine/newbornVaccine.dart';
import 'package:provider/provider.dart';

class NewbornDetailsPage extends StatefulWidget {
  final Map<String, dynamic> newbornData;
  final String motherName;
  const NewbornDetailsPage({
    required this.newbornData,
    required this.motherName,
  });

  @override
  _NewbornDetailsPageState createState() => _NewbornDetailsPageState();
}

class _NewbornDetailsPageState extends State<NewbornDetailsPage> {
  List<Map<String, dynamic>> vaccines = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewbornProvider>(context, listen: false)
          .setIdentityNumber(widget.newbornData['identity_number']);
      fetchVaccines();
    });
  }

  Future<void> fetchVaccines() async {
    final baseUrl = ApiService.getBaseUrl();
    final url =
        Uri.parse('$baseUrl/vaccines/${widget.newbornData['identity_number']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure vaccines data exists and is a list
        if (data['data'] == null ||
            data['data'][0]['vaccines'] == null ||
            data['data'][0]['vaccines'] is! List) {
          throw Exception("Invalid 'vaccines' data format in the response");
        }

        final vaccinesData = data['data'][0]['vaccines'];

        setState(() {
          vaccines = List<Map<String, dynamic>>.from(vaccinesData);
        });
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Debugging error
      print('FetchVaccines Error: $error');
      throw Exception('Request failed with error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

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
                  maxWidth: 800,
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
                      Center(
                          child: Text("Vaccination Schedule",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6)),
                      const SizedBox(height: 8),
                      DataTable(
                        border: TableBorder.all(),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Doses')),
                          DataColumn(label: Text('Place')),
                          DataColumn(label: Text('Diseases')),
                          DataColumn(label: Text('Method')),
                          DataColumn(label: Text('Months')),
                        ],
                        rows: vaccines.map((vaccine) {
                          return DataRow(
                            cells: [
                              DataCell(
                                  Text(vaccine['id']?.toString() ?? 'N/A')),
                              DataCell(Flexible(
                                  child: Text(vaccine['name'] ?? 'N/A'))),
                              DataCell(Flexible(
                                  child: Text(
                                      vaccine['doses']?.toString() ?? 'N/A'))),
                              DataCell(Flexible(
                                  child: Text(vaccine['place'] ?? 'N/A'))),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 350,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      vaccine['diseases'] ?? 'N/A',
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Flexible(
                                  child: Text(vaccine['method'] ?? 'N/A'))),
                              DataCell(Flexible(
                                  child: Text(vaccine['month_vaccinations']
                                          ?.toString() ??
                                      'N/A'))),
                            ],
                          );
                        }).toList(),
                      )
                    ]),
              ),
            ),

            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VaccineTable(
                        identityNumber: widget.newbornData['identity_number'],
                        newbornName: widget.newbornData['firstName'] +
                            ' ' +
                            widget.newbornData['lastName'],
                      ),
                    ),
                  );
                },
                child:
                    const Text('معلومات التطعيم', textAlign: TextAlign.right),
              ),
            ),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Other newborn details here
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Vaccination Records",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          ),
                          
                ),
                NewbornVaccineScreen()
              ],
            ),
            const SizedBox(height: 16),
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
                    const SizedBox(height: 8),
                    const Text("Midwife: Jane Doe"),
                    const Text("Pediatrician: Dr. Smith"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                    const SizedBox(height: 8),
                    const Text(
                        "Remember to book the next vaccine appointment."),
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
