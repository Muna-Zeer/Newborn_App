import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/Auth/register.dart';
import 'package:my_vaccine_app/Methods/Auth_api.dart';
import 'package:my_vaccine_app/controller/simpleController.dart';
import 'package:my_vaccine_app/screens/amintask.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthService authService;

  final kLoginSubtitleStyle = TextStyle(
    color: Colors.grey,
    fontSize: 16,
  );
  final _formKey = GlobalKey<FormState>();
  late SimpleUIController simpleUIController;

  @override
  void initState() {
    super.initState();
    simpleUIController = Get.put(SimpleUIController());
    authService = AuthService();
  }

  @override
  void dispose() {
    // nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var response = await authService.login(
        emailController
            .text, // <-- Use emailController.text instead of nameController.text
        passwordController.text,
      );
      if (response.statusCode == 200) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect email or password'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Center(
              child: CircleAvatar(
                radius: size.width > 600 ? 100.0 : 50.0,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsVSOS2Cjzz0gwoQ6MuypqVVaKfj6ERqLzTg&usqp=CAU'),
              ),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      //create header here
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.blue, // Customize the color as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_back,
                size: 24.0,
                color: Colors.white,
              ),
              Text(
                'تسجيل الدخول',
                style: kLoginSubtitleStyle.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: size.width <= 600 ? 20.0 : 0.0),
          child: Center(
            child: size.width > 600
                ? Container() // Handle the case when size.width > 600
                : CircleAvatar(
                    radius: size.width > 600 ? 100.0 : 50.0,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsVSOS2Cjzz0gwoQ6MuypqVVaKfj6ERqLzTg&usqp=CAU',
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 20.0),
        //   child: Text(
        //     'تسجيل الدخول',
        //     textAlign: TextAlign.right,
        //     textDirection: TextDirection.rtl,
        //     style: kLoginSubtitleStyle,
        //   ),
        // ),

        const SizedBox(
          height: 10,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'اهلا بك في تطبيق التطعيمات',
                textAlign: TextAlign.center,
                style: kLoginSubtitleStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),

        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username or Gmail
                TextFormField(
                  style: kLoginSubtitleStyle,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'الايميل',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: emailController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kLoginSubtitleStyle,
                    controller: passwordController,
                    textAlign: TextAlign.right,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'الرقم السري',
                      hintStyle: TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length < 7) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 10) {
                        return 'maximum character is 10';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'لا تملك حساب?',
                      style: kLoginSubtitleStyle.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                            text: "انشاء حساب",
                            style: kLoginSubtitleStyle.copyWith(
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 2, 178, 247)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdnminTask()),
          );
        },
        child: Text('تسجيل الدخول'),
      ),
    );
  }
}
