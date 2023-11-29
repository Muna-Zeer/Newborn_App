import 'package:flutter/material.dart';

import 'package:my_vaccine_app/Alert_Dialog/motherAlert.dart';
import 'package:my_vaccine_app/screens/mother/motherClass.dart';
import 'package:my_vaccine_app/screens/mother/motherUser.dart';
import 'package:my_vaccine_app/screens/mother/mother_api.dart';

import './MotherAutoProfile.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


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

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var mother = Mother(
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
        ministryName: _MinistryHealthController.text,
        hospitalCenterName: _hospitalNameController.text,
        doctorName: _doctorNameController.text,
        nurseName: _nurseNameController.text,
        newbornName: _newbornNameController.text,
      );

      try {
        var created = await createMother(mother);
        if (created) {
          MotherAlerts.showSuccess(context, mother);

          // Create the MotherAutoProfile instance and call createAutoProfile()
          var motherAutoProfile = MotherAutoProfile(motherData: {
            'identity_number': mother.identityNumber,
          });

          // Call the createMotherUser function
          var motherUser = MotherUser(
            password: '', // Set the appropriate password
            phone: _phoneController.text,
            username: _firstNameController.text, // Set the appropriate username
            identityNumber: _identityNumberController.text, device_token: '',
          );

          // Call the createMotherUser function
          await createMotherUser(motherUser);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => motherAutoProfile,
            ),
          );

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
        } else {
          MotherAlerts.showError(context, 'Failed to create mother.');
        }
      } catch (e) {
        MotherAlerts.showError(context, e.toString());
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
                SizedBox(height: 16),
                TextFormField(
                    controller: _newbornNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of newborn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter name of responsible newborn ';
                      }
                      return null;
                    }),
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
