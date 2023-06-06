import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/methods/doctor_api.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../methods/mother_api.dart';
import 'package:newborn_app/constant/models/mother.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../alert/motherAlert.dart';

class MotherForm extends StatefulWidget {
  final int motherId;

  const MotherForm({Key? key, required this.motherId}) : super(key: key);
  @override
  _MotherFormState createState() => _MotherFormState();
}

class _MotherFormState extends State<MotherForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _husbandNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _husbandPhoneNumber = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _identityNumberController = TextEditingController();
  final _HRController = TextEditingController();
  RhesusFactor? _rhesusFactor;
  final _bloodTypeController = TextEditingController();
  BloodType? _bloodType;
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _number_of_newbornsController = TextEditingController();
  final _husband_phone_numberController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _MinistryHealthController = TextEditingController();
  final _nurseNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _newbornNameController = TextEditingController();
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ministriesOfHealth = [];

  String? selectedHospital;
  String? selectedMinistry;

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> midwives = [];

  String? selectedDoctor;
  String? selectedMidwife;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedHospitals = await fetchHospitals();
      List<Map<String, dynamic>> fetchedDoctors = await fetchDoctorHospital();
      List<Map<String, dynamic>> fetchedMidwives = await fetchMidwives();
      List<Map<String, dynamic>> fetchedMinistriesOfHealth =
          await fetchMinistriesOfHealth();

      setState(() {
        hospitals = fetchedHospitals;
        doctors = fetchedDoctors;
        midwives = fetchedMidwives;
        ministriesOfHealth = fetchedMinistriesOfHealth;

        selectedHospital = fetchedHospitals.isNotEmpty
            ? fetchedHospitals[0]['id'].toString()
            : null;

        selectedMidwife = fetchedMidwives.isNotEmpty
            ? fetchedMidwives[0]['id'].toString()
            : null;

        selectedDoctor = fetchedDoctors.isNotEmpty
            ? fetchedDoctors[0]['id'].toString()
            : null;

        selectedMinistry = fetchedMinistriesOfHealth.isNotEmpty
            ? fetchedMinistriesOfHealth[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4(); // generate a unique ID
      var mother = Mother(
        id: 0,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        age: int.parse(_ageController.text),
        address: _addressController.text,
        phoneNumber: _phoneController.text,
        husbandName: _husbandNameController.text,
        email: _emailController.text,
        dateOfBirth: DateTime.parse(_dateOfBirthController.text),
        husbandPhoneNumber: _husband_phone_numberController.text,
        numberOfNewborns: int.parse(_number_of_newbornsController.text),
        city: _cityController.text,
        country: _countryController.text,
        bloodType: BloodType.A,
        rhesusFactor: RhesusFactor.Negative,
        identityNumber: _identityNumberController.text,
        hospitalName: selectedHospital ?? '',
        ministryName: selectedMinistry ?? '',
        hospitalId: int.parse(selectedHospital ?? '0'),
        ministryId: int.parse(selectedMinistry ?? '0'),
        doctorName: selectedDoctor ?? '',
        midwifeName: selectedMidwife ?? '',
        midwifeId: int.parse(selectedMidwife ?? '0'),
        doctorId: int.parse(selectedDoctor ?? '0'),
        newbornIDNumber: _newbornNameController.text,
        hospitalCenterName: '',
      );
      // Call the createMother function to submit the data to the server
      try {
        await createMother(mother);
        // Show success alert
        MotherAlerts.showSuccess(context, mother);
        // Clear form
        _formKey.currentState!.reset();
        _firstNameController.clear();
        _lastNameController.clear();
        _ageController.clear();
        _addressController.clear();
        _phoneController.clear();
        _husbandNameController.clear();
        _emailController.clear();
        _dateOfBirthController.clear();
        _husband_phone_numberController.clear();
        _number_of_newbornsController.clear();
        _cityController.clear();
        _countryController.clear();
        _identityNumberController.clear();
        _MinistryHealthController.clear();
        _hospitalNameController.clear();
        _doctorNameController.clear();
        _nurseNameController.clear();
        _newbornNameController.clear();
      } catch (e) {
        // Show error alert
        MotherAlerts.showError(context);
      }
    }
  }

  final Map<RhesusFactor, String> rhesusFactorString = {
    RhesusFactor.Negative: 'Positive',
    RhesusFactor.Positive: 'Negative',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mother Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'firstName'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'lastName'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _husbandNameController,
                  decoration: InputDecoration(labelText: 'husbandName'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'age of mother',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _number_of_newbornsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'number of Newborns',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone of Mother',
                    hintText: '(000) 000-0000',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a phone number';
                    }
                    final phoneRegExp = RegExp(r'^\d{10}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _identityNumberController,
                  decoration: InputDecoration(labelText: 'Identity Number'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a Identity number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'mother@mother.com',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'please enter valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a date of birth';
                    }
                    return null;
                  },
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    if (pickedDate != null) {
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        _dateOfBirthController.text = formattedDate;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<BloodType>(
                  decoration: InputDecoration(
                    labelText: 'Blood Type',
                    hintText: 'Select an option',
                  ),
                  value: _bloodType,
                  onChanged: (newValue) {
                    setState(() {
                      _bloodType = newValue;
                    });
                  },
                  items: BloodType.values.map((value) {
                    return DropdownMenuItem<BloodType>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<RhesusFactor>(
                  decoration: InputDecoration(
                    labelText: 'Rhesus Factor',
                    hintText: 'Select an option',
                  ),
                  value: _rhesusFactor,
                  onChanged: (newValue) {
                    setState(() {
                      _rhesusFactor = newValue;
                    });
                  },
                  items: RhesusFactor.values.map((value) {
                    return DropdownMenuItem<RhesusFactor>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      labelText: 'Country',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter country of mother';
                      }
                      return null;
                    }),
                SizedBox(height: 16),
                TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter blood type';
                      }
                      return null;
                    }),
                SizedBox(height: 16),
                TextFormField(
                    controller: _husband_phone_numberController,
                    decoration: InputDecoration(
                      labelText: 'husband phone number',
                      hintText: '(000) 000-0000',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter correct phone number ';
                      }
                      final phoneRegExp = RegExp(r'^\d{10}$');
                      if (!phoneRegExp.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    }),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedHospital,
                        onChanged: (value) {
                          setState(() {
                            selectedHospital = value!;
                          });
                        },
                        items: hospitals.map((hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital['id'].toString(),
                            child: Text(hospital['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Hospital',
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedMinistry,
                        onChanged: (value) {
                          setState(() {
                            selectedMinistry = value!;
                          });
                        },
                        items: ministriesOfHealth.map((ministry) {
                          return DropdownMenuItem<String>(
                            value: ministry['id'].toString(),
                            child: Text(ministry['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Ministry of Health',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDoctor,
                        onChanged: (value) {
                          setState(() {
                            selectedDoctor = value!;
                          });
                        },
                        items: doctors.map((doctor) {
                          return DropdownMenuItem<String>(
                            value: doctor['id'].toString(),
                            child: Text(doctor['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Doctor',
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedMidwife,
                        onChanged: (value) {
                          setState(() {
                            selectedMidwife = value!;
                          });
                        },
                        items: midwives.map((midwife) {
                          return DropdownMenuItem<String>(
                            value: midwife['id'].toString(),
                            child: Text(midwife['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Midwife',
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: _saveKey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
