import 'package:flutter/material.dart';

class VaccineDatePicker extends StatefulWidget {
  @override
  _VaccineDatePickerState createState() => _VaccineDatePickerState();
}

class _VaccineDatePickerState extends State<VaccineDatePicker> {
  TextEditingController identityController = TextEditingController();
  TextEditingController vaccineController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  Future<void> datePickerVaccine(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate.isAfter(currentDate)) {
      setState(() {
        dueDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'اشعارات التطعيم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          )
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: identityController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: "رقم هوية الطفل",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: TextField(
                    controller: vaccineController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: "اسم التطعيم",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: TextField(
                    controller: dueDateController,
                    textAlign: TextAlign.right,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "تاريخ التطعيم",
                      border: InputBorder.none,
                    ),
                    onTap: () => datePickerVaccine(context),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: VaccineDatePicker()));
}
