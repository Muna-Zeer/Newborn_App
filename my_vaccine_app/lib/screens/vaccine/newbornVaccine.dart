import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/Newborns/NewbornClass.dart';
import 'package:my_vaccine_app/screens/provider/newbornProvider.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineModel.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine_api.dart';
import 'package:provider/provider.dart';

class NewbornVaccineScreen extends StatefulWidget {
  const NewbornVaccineScreen({Key? key}) : super(key: key);

  @override
  _NewbornVaccineScreenState createState() => _NewbornVaccineScreenState();
}

class _NewbornVaccineScreenState extends State<NewbornVaccineScreen> {
  Future<List<VaccineData>>? futureVaccines;

  @override
  void initState() {
    super.initState();
    // Fetch the identity number once the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NewbornProvider>(context, listen: false);
      if (provider.identityNumber != null) {
        fetchVaccines(provider.identityNumber!);
      }
    });
  }

  void fetchVaccines(String identityNumber) {
    setState(() {
      futureVaccines = fetchNewbornVaccine(identityNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewbornProvider>(
      builder: (context, provider, child) {
        if (provider.identityNumber == null) {
          return const Center(child: Text("No Identity Number is available"));
        }

        return FutureBuilder<List<VaccineData>>(
          future: futureVaccines,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No vaccination records found."));
            }

            final vaccines = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vaccines.length,
              itemBuilder: (context, index) {
                final vaccine = vaccines[index];

                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 800,
                      ),
                      child: SizedBox(
                        width: double
                            .infinity, 
                        child: ListTile(
                          title: Text(
                            "Vaccine Name: ${vaccine.vaccineName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Doctor Name: ${vaccine.doctorName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "Vaccination Date: ${vaccine.vaccinateDate}"),
                              Text("Due Date: ${vaccine.dueDate}"),
                              Text("Overdue Days: ${vaccine.overdueDays}"),
                              Text(
                                  "Notified: ${vaccine.notified ? "Yes" : "No"}"),
                            ],
                          ),
                          trailing: vaccine.overdueDays > 0
                              ? const Icon(Icons.warning, color: Colors.red)
                              : const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
