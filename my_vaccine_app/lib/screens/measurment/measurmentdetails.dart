import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/measurment/measurment.dart';

class MeasurementForm extends StatefulWidget {
  final void Function(Measurement) onSubmit;

  MeasurementForm({required this.onSubmit});

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  late double _height;
  late double _weight;
  late double _headCircumference;
  late DateTime _date;
  late String _time;
  late String _nurseName;
  late String _remarks;
  late int _age;
  late String _tonics;
  late int _newbornId;
  late int _nurseId;
  late int _midwifeId;
  late int _healthCenterId;
  late int _ministryId;
  late int _hospitalId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Measurement Form'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/your_image.png',
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the height';
                        }
                        return null;
                      },
                      onSaved: (value) => _height = double.parse(value!),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Weight'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the weight';
                        }
                        return null;
                      },
                      onSaved: (value) => _weight = double.parse(value!),
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Head Circumference'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the head circumference';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _headCircumference = double.parse(value!),
                    ),
                    // Add more TextFormField widgets for other attributes
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final measurement = Measurement(
                            height: _height,
                            weight: _weight,
                            headCircumference: _headCircumference,
                            date: _date,
                            time: _time,
                            nurseName: _nurseName,
                            remarks: _remarks,
                            age: _age,
                            tonics: _tonics,
                            newbornId: _newbornId,
                            nurseId: _nurseId,
                            midwifeId: _midwifeId,
                            healthCenterId: _healthCenterId,
                            ministryId: _ministryId,
                            hospitalId: _hospitalId,
                          );
                          widget.onSubmit(measurement);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
