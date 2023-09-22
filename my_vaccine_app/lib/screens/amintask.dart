import 'package:flutter/material.dart';
import 'package:my_vaccine_app/Auth/login.dart';
import 'package:my_vaccine_app/Auth/register.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingForm.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingView.dart';
import 'package:my_vaccine_app/screens/Instructions/guidlineList.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineForm.dart';
import 'package:my_vaccine_app/screens/Newborns/allNewborns.dart';
import 'package:my_vaccine_app/screens/instruction.dart';
import 'package:my_vaccine_app/screens/mother/motherLogin.dart';
import 'package:my_vaccine_app/screens/mother/motherRegister.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExaminationHealthCenter.dart';
import 'package:my_vaccine_app/screens/sidebar.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineForm.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineList.dart';

class AdnminTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double avatarRadius = size.height * 0.15;

    bool isPhone = size.width < 600; // Set the breakpoint for phone screen size

    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoleUser()),
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تسجيل الدخول',
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Image.asset(
                '/images.jpeg', // Replace with the URL of your image
                width: size.width * 0.8, // Set the desired width
                height: size.height * 0.3, // Set the desired height
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'أهلاً بكم في تطبيق التطعيمات', // Replace with your desired text
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VaccineForm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.redAccent, // Set the desired background color
                  ),
                  child: Text(
                    'قائمة التطعيمات',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.08,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue, // Set the desired background color
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreventiveExaminationForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .transparent, // Set the button background color to transparent
                      elevation: 0, // Remove the button's elevation
                    ),
                    child: Text(
                      'الفحوصات الوقائية',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.6, // Set the desired width
                height: size.height * 0.08, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreventiveExaminationCenter(),
                      ),
                    );
                  },
                  child: Text(
                    'مركز الفحوصات الوقائية',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedingForm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.lightGreen, // Set the desired background color
                  ),
                  child: Text(
                    'تغذية الطفل',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GuildlineForm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink, // Set the desired background color
                  ),
                  child: Text(
                    'الإرشادات الصحية',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.6, // Set the desired width
                    height: size.height * 0.08, // Set the desired height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VaccineList()),
                        );
                      },
                      child: Text(
                        'تطعيمات الاطفال',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VaccineInstructionScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.purple, // Set the desired background color
                      ),
                      child: Text(
                        'تعليمات التطعيم',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedingListView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors
                            .lightBlue, // Set the desired background color
                      ),
                      child: Text(
                        'قائمة تطعيمات الاطفال',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedingListView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.lime, // Set the desired background color
                      ),
                      child: Text(
                        'قائمة تغذية الاطفال',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.6,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuidelineList()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.pink, // Set the desired background color
                      ),
                      child: Text(
                        'قائمة ارشادات الاطفال',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}
