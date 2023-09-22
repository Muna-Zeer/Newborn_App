// import 'package:flutter/material.dart';
// import 'package:newborn_app/constant/models/Measurement.dart';
// import 'package:newborn_app/screens/MotherDetailsScreen.dart';
// import 'package:newborn_app/widgets/HomeMother.dart';
// import 'package:newborn_app/widgets/Newborn.dart';
// import 'package:newborn_app/widgets/NewbornAssessment.dart';
// import 'package:newborn_app/widgets/NewbornExaminationForm.dart';
// import 'package:newborn_app/widgets/chart.dart';
// import 'package:newborn_app/widgets/doctor.dart';
// import 'package:newborn_app/widgets/measurementChart.dart';
// import 'package:newborn_app/widgets/newborns_table.dart';
// import 'package:newborn_app/widgets/postnatalExamination.dart';
// import './widgets/motherExaminationForm.dart';
// import 'screens/DoctorTable.dart';
// import './screens/HomeScreen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:newborn_app/Nurse/NurseTable.dart';
import 'package:newborn_app/constant/models/Measurement.dart';
import 'package:newborn_app/midwife/Midwife/MidwifeTable.dart';
import 'package:newborn_app/midwife/Midwife/midwife.dart';
import 'package:newborn_app/mother/motherTable.dart';
import 'package:newborn_app/nurse/NurseForm.dart';
import 'package:newborn_app/postnatalExamination.dart/postnatalTable.dart';
import 'package:newborn_app/screens/DoctorTable.dart';
import 'package:newborn_app/screens/MotherDetailsScreen.dart';
import 'package:newborn_app/widgets/HomeMother.dart';
import 'package:newborn_app/widgets/Newborn.dart';
import 'package:newborn_app/widgets/NewbornAssessment.dart';
import 'package:newborn_app/widgets/NewbornExaminationForm.dart';
import 'package:newborn_app/widgets/chart.dart';
import 'package:newborn_app/widgets/doctor.dart';
import 'package:newborn_app/widgets/measurementChart.dart';
import 'package:newborn_app/widgets/motherExaminationForm.dart';
import 'package:newborn_app/widgets/motherForm.dart';
import 'package:newborn_app/widgets/newbornTable.dart';
import 'package:newborn_app/widgets/newborns_table.dart';
import 'package:newborn_app/widgets/postnatalExamination.dart';
// import './widgets/motherExaminationForm.dart';
// import 'screens/DoctorTable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        title: 'Newborn App',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newborn App'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: EdgeInsets.all(8),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotherExaminationForm(motherId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Mother Examination Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(
                    doctorId: 1,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Doctor Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewbornExaminationForm(NewbornId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Newborn Examination Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewbornAssessmentForm(motherId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Newborn Assessment Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotherForm(motherId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('mother Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MotherPostnatalExaminationForm(motherId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Mother Postnatal Examination'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewbornForm(newbornId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Newborn Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NurseFormPage(nurseId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('nurse Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MidwifeProfilePage(midwifeId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('midwife Form'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('View midwife Details'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MidwifeTablePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('View midwives'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NursePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text('Nurse table'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewbornsTable(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View doctor Details'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostnatalExaminationPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View postnatal Details'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View doctor Details'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotherDetailsScreen(motherId: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View mother neewborn'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MotherTablePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View mother tabel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewbornPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View newborn tabel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => BabyMeasurementChartPage(),
              //   ),
              // );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            child: Text('View measurement Details'),
          ),
        ],
      ),
    );
  }
}
 