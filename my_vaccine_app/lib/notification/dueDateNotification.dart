import 'package:flutter/material.dart';

class VaccineDatePicker extends StatefulWidget {
  @override
  _VaccineDatePickerState createState() => _VaccineDatePickerState();
}

class _VaccineDatePickerState extends State<VaccineDatePicker> {
  TextEditingController dueDateController = TextEditingController();

  Future<void> datePickerVaccine(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime firstSelectableDate = currentDate.add(const Duration(days: 1));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: firstSelectableDate,
      firstDate: firstSelectableDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (mounted) {
        setState(() {
          dueDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              'تاريخ التطعيم',
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
            child: Center(
                child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 800,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'التاريخ',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: dueDateController,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'اختر التاريخ',
                                    ),
                                    readOnly: true,
                                    onTap: () => datePickerVaccine(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => datePickerVaccine(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}
