import 'package:flutter/material.dart';
import 'package:my_vaccine_app/Auth/login.dart';
import 'package:my_vaccine_app/Auth/register.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingForm.dart';
import 'package:my_vaccine_app/screens/Instructions/guidlineList.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineForm.dart';
import 'package:my_vaccine_app/screens/Newborns/allNewborns.dart';
import 'package:my_vaccine_app/screens/instruction.dart';
import 'package:my_vaccine_app/screens/mother/motherLogin.dart';
import 'package:my_vaccine_app/screens/mother/motherRegister.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExaminationHealthCenter.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineForm.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineList.dart';

class DropdownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double avatarRadius = size.height * 0.15;

    bool isPhone = size.width < 600; // Set the breakpoint for phone screen size

    return Scaffold(
      appBar: AppBar(
        title: Text('Who are you?'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          if (isPhone)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: isPhone ? size.width * 0.8 : 250,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: 'Mother',
                    dropdownColor: Colors.blue,
                    onChanged: (newValue) {
                      if (newValue == 'Login') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MotherLoginPage(),
                          ),
                        );
                      } else if (newValue == 'Register') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MotherForm(motherId: 0),
                          ),
                        );
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text('Mother'),
                        value: 'Mother',
                      ),
                      DropdownMenuItem(
                        child: Text('Login'),
                        value: 'Login',
                      ),
                      DropdownMenuItem(
                        child: Text('Register'),
                        value: 'Register',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: isPhone ? size.width * 0.8 : 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: 'Admin',
                  dropdownColor: Colors.blue,
                  onChanged: (newValue) {
                    if (newValue == 'Login') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginView(),
                        ),
                      );
                    } else if (newValue == 'Register') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpView(),
                        ),
                      );
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text('Admin'),
                      value: 'Admin',
                    ),
                    DropdownMenuItem(
                      child: Text('Login'),
                      value: 'Login',
                    ),
                    DropdownMenuItem(
                      child: Text('Register'),
                      value: 'Register',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: isPhone ? size.width * 0.8 : 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: 'Doctor',
                  dropdownColor: Colors.blue,
                  onChanged: (newValue) {
                    if (newValue == 'Login') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              isPhone ? LoginView() : SignUpView(),
                        ),
                      );
                    } else if (newValue == 'Register') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              isPhone ? SignUpView() : LoginView(),
                        ),
                      );
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text('Doctor'),
                      value: 'Doctor',
                    ),
                    DropdownMenuItem(
                      child: Text('Login'),
                      value: 'Login',
                    ),
                    DropdownMenuItem(
                      child: Text('Register'),
                      value: 'Register',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VaccineForm()),
              );
            },
            child: Text(
              'Vaccine',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreventiveExaminationForm()),
              );
            },
            child: Text(
              'preventive Examination',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreventiveExaminationCenter()),
              );
            },
            child: Text(
              'preventive Examination Center',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedingForm()),
              );
            },
            child: Text(
              'feeding',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuildlineForm()),
              );
            },
            child: Text(
              'guildline',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuidelineList()),
              );
            },
            child: Text(
              'guildlineList',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VaccineList()),
              );
            },
            child: Text(
              'vaccineList',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VaccineInstructionScreen()),
              );
            },
            child: Text(
              'instructions',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewbornVaccinePage()),
              );
            },
            child: Text(
              'Newborn Page',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
