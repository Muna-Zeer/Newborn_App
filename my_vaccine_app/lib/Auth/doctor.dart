import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_vaccine_app/Auth/register.dart';
import 'package:my_vaccine_app/Methods/Auth_api.dart';
import 'package:my_vaccine_app/controller/simpleController.dart';
import 'package:my_vaccine_app/doctorTAsk.dart';
import 'package:my_vaccine_app/doctors/DoctorForm.dart';

class LoginViewDoctor extends StatefulWidget {
  const LoginViewDoctor({Key? key}) : super(key: key);

  @override
  State<LoginViewDoctor> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginViewDoctor> {
  // TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthService authService;

  final kLoginSubtitleStyle = const TextStyle(
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
          const SnackBar(
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
        // Expanded(
        //   flex: 4,
        //   child: RotatedBox(
        //     quarterTurns: 3,
        //     child: Center(
        //       child: CircleAvatar(
        //         radius: size.width > 600 ? 100.0 : 50.0,
        //         backgroundImage: AssetImage('/images.jpeg'),
        //       ),
        //     ),
        //   ),
        // ),
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
      children: [
        // size.width > 600
        //     ? Container()
        //     : Center(
        //         child: CircleAvatar(
        //           radius: size.width > 600 ? 100.0 : 50.0,
        //           // backgroundImage: AssetImage('/images.jpeg'),
        //         ),
        //       ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'تسجيل الدخول',
            style: kLoginSubtitleStyle,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'اهلا بك في تطبيق التطعيمات',
            style: kLoginSubtitleStyle,
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
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'الايميل',
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
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
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
                        MaterialPageRoute(
                          builder: (context) =>const DoctorProfilePage(
                            doctorId: 1,
                          ),
                        ));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'لا تملك حساب?',
                      style: kLoginSubtitleStyle,
                      children: [
                        TextSpan(
                            text: "انشاء حساب", style: kLoginSubtitleStyle),
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
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorTask()),
          );
        },
        child: Text('تسجيل الدخول'),
      ),
    );
  }
}
