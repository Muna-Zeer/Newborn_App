import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/controller/simpleController.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? _role;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());
  final kLoginSubtitleStyle = TextStyle(
    color: Colors.grey,
    fontSize: 16,
  );
  void save() async {
    // Get the user input values
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final role = _role;

    // Create a map with the user data
    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };

    try {
      // Send a request to the backend to save the user data
      final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/register'),
          body: jsonEncode(userData),
          headers: {'Content-Type': 'application/json'});

      // Check if the request was successful
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(
        //       content: Text('Sign up successful!'),
        //       backgroundColor: Colors.green,
        //     ))
        //     .closed
        //     .then((value) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
        // });

// Clear the form fields
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          _role = null;
        });

        // Clear the form fields
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          _role = null;
        });
      } else {
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign up failed. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController, theme);
            } else {
              return _buildSmallScreen(size, simpleUIController, theme);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Center(
            child: CircleAvatar(
              radius: size.width > 600 ? 100.0 : 50.0,
              backgroundImage: AssetImage('lib/assets/capture.png'),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: size.width > 600
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.09,
              ),
              // Circular image
              SizedBox(height: 16.0), // Add some vertical spacing
              Center(
                child: CircleAvatar(
                  radius: size.width > 600
                      ? 150.0
                      : 80.0, // Adjust the width of the image
                  backgroundImage: AssetImage('lib/assets/newborn.png'),
                ),
              ),

              // SizedBox(
              //   height: size.height * 0.03,
              // ), // Header with Register Mother button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MyVaccine',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(
                    //   width: 120.0,
                    //   child: Center(
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // handle button press
                    //       },
                    //       child: Text(
                    //         'logIn Mother',
                    //         style: TextStyle(fontSize: 16.0),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Sign Up',
                  style: kLoginSubtitleStyle,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Create Account',
                  style: kLoginSubtitleStyle,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Adjust the horizontal padding
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: size.height * 0.03,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Colors.deepPurple, // Set the button color to purple
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.03,
              ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: TextButton(
//                   onPressed: () {
// // handle button press
//                   },
//                   child: Text(
//                     'Already have an account? Sign in',
//                     style: TextStyle(fontSize: 16.0, color: theme.accentColor),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: size.height * 0.05,
//               ),
            ]),
      ),
    );
  }
}
