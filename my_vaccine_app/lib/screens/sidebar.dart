//  if (isPhone)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       width: isPhone ? size.width * 0.8 : 250,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: DropdownButton<String>(
//                         value: 'Mother',
//                         dropdownColor: Colors.blue,
//                         onChanged: (newValue) {
//                           if (newValue == 'Login') {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MotherLoginPage(),
//                               ),
//                             );
//                           } else if (newValue == 'Register') {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MotherForm(motherId: 0),
//                               ),
//                             );
//                           }
//                         },
//                         items: [
//                           DropdownMenuItem(
//                             child: Text('Mother'),
//                             value: 'Mother',
//                           ),
//                           DropdownMenuItem(
//                             child: Text('Login'),
//                             value: 'Login',
//                           ),
//                           DropdownMenuItem(
//                             child: Text('Register'),
//                             value: 'Register',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               SizedBox(
//                 height: size.height * 0.01,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     width: isPhone ? size.width * 0.8 : 250,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: DropdownButton<String>(
//                       value: 'Admin',
//                       dropdownColor: Colors.blue,
//                       onChanged: (newValue) {
//                         if (newValue == 'Login') {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => LoginView(),
//                             ),
//                           );
//                         } else if (newValue == 'Register') {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SignUpView(),
//                             ),
//                           );
//                         }
//                       },
//                       items: [
//                         DropdownMenuItem(
//                           child: Text('Admin'),
//                           value: 'Admin',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Login'),
//                           value: 'Login',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Register'),
//                           value: 'Register',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: size.height * 0.01,
//               ),
//               SizedBox(
//                 height: size.height * 0.01,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     width: isPhone ? size.width * 0.8 : 250,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: DropdownButton<String>(
//                       value: 'Doctor',
//                       dropdownColor: Colors.blue,
//                       onChanged: (newValue) {
//                         if (newValue == 'Login') {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   isPhone ? LoginView() : SignUpView(),
//                             ),
//                           );
//                         } else if (newValue == 'Register') {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   isPhone ? SignUpView() : LoginView(),
//                             ),
//                           );
//                         }
//                       },
//                       items: [
//                         DropdownMenuItem(
//                           child: Text('Doctor'),
//                           value: 'Doctor',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Login'),
//                           value: 'Login',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Register'),
//                           value: 'Register',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               // )
import 'package:flutter/material.dart';
import 'package:my_vaccine_app/Auth/doctor.dart';
import 'package:my_vaccine_app/Auth/login.dart';
import 'package:my_vaccine_app/screens/mother/motherLogin.dart';

class RoleUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to My Page',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotherLoginPage()),
                    );
                  },
                  child: Container(
                    width: 200.0, // Adjust the width as desired
                    height: 50.0, // Adjust the height as desired
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment
                        .center, // Center the text within the container
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'الأم',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Container(
                    width: 80.0, 
                    height: 50.0, 
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment
                        .center, 
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'الطبيب',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginViewDoctor()),
                    );
                  },
                  child: Container(
                    width: 80.0, // Adjust the width as desired
                    height: 50.0, // Adjust the height as desired
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment
                        .center, // Center the text within the container
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'المشرف',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
