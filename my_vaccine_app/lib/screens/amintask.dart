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
import 'package:my_vaccine_app/screens/preventiveExamination/adminAdd.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/adminTable.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExaminationHealthCenter.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveList.dart';
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
          backgroundColor: Colors.lightBlue,
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
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRieYY9PeLO3Q36el6jjPsR_7S5S4hf7E8jxw&usqp=CAU.jpg',
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
                width: size.width * 0.7,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.vaccines, color: Colors.white),
                      Text(
                        'قائمة التطعيمات',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.7,
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
                              builder: (context) =>
                                  PreventiveExaminationForm()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.medical_services,
                            color: Colors.white,
                          ),
                          Text(
                            'الفحوصات الوقائية',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreventiveExaminationCenter(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 118, 78, 97)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.local_hospital, color: Colors.white),
                        Text(
                          'مركز الفحوصات الوقائية',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.7,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.child_care, color: Colors.white),
                        Text(
                          'تغذية الطفل',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.08,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GuildlineForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink, // Set the desired background color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.feedback, color: Colors.white),
                        Text(
                          'الإرشادات الصحية',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ),
              Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VaccineList()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 229, 84,
                              88), // Set the desired background color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.vaccines_rounded, color: Colors.white),
                            Text(
                              'تطعيمات الاطفال',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VaccineInstructionScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 145, 46,
                              163), // Set the desired background color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.integration_instructions,
                                color: Colors.white),
                            Text(
                              'تعليمات التطعيم',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.7,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.list_alt, color: Colors.white),
                            Text(
                              'قائمة تطعيمات الاطفال',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.7,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.feed_rounded, color: Colors.white),
                            Text(
                              'قائمة تغذية الاطفال',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    width: size.width * 0.7,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.assignment, color: Colors.white),
                            Text(
                              'قائمة ارشادات الاطفال',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 8.0),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreventiveListView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 241, 55, 3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.assignment, color: Colors.white),
                            Text(
                              'قائمة الفحوصات الوقائية ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminAddPrevExam()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 86, 21, 239),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.assignment, color: Colors.white),
                            Text(
                              'اضافةمعلومات الفحوصات الوقائية ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminPreventiveListView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 251, 33, 5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.assignment, color: Colors.white),
                            Text(
                              'ةمعلومات الفحوصات الوقائية',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ],
          )),
        ));
  }
}
