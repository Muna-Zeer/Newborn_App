import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingView.dart';
import 'package:my_vaccine_app/screens/Instructions/guidlineList.dart';
import 'package:my_vaccine_app/screens/Newborns/allNewborns.dart';
import 'package:my_vaccine_app/screens/instruction.dart';
import 'package:my_vaccine_app/screens/sidebar.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineList.dart';

class DoctorTask extends StatelessWidget {
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
              Align(
                alignment: Alignment.centerRight,
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsVSOS2Cjzz0gwoQ6MuypqVVaKfj6ERqLzTg&usqp=CAU',
                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'أهلاً بكم في تطبيق التطعيمات',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.6,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewbornVaccinePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.lightBlue, // Set the desired background color
                  ),
                  child: Text(
                    'قائمة تطعيمات الاطفال',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
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
