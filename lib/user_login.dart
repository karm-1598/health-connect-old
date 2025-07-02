import 'package:flutter/material.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'user_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_connect2/network/commonApi_fun.dart';

class user_login extends StatefulWidget {
  const user_login({super.key});

  @override
  State<user_login> createState() => _user_loginState();
}

class _user_loginState extends State<user_login> {
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final locationController = TextEditingController();
  final idController = TextEditingController();
  String address = '';

  void loginUpData() async {
    if (_formkey.currentState!.validate()) {
      String uemail = emailController.text;
      String upassword = passController.text;

      final api = baseApi();
      var login = await api.post('user_login.php', {
        'semail': uemail,
        'spassword': upassword,
      });

      try {
        var decodeData = login;

        if (decodeData['flag'] == "1") {
          var sharedName = decodeData['user_name'];
          var sharedEmail = decodeData['user_email'];
          var sharedId = decodeData['user_id'];

          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', sharedName);
          await prefs.setString('email', sharedEmail);
          await prefs.setBool('keepLogedIn', true);
          await prefs.setString('id', sharedId);
          await prefs.setString('location', address);

          toastMessage.show(decodeData['message']);

          emailController.clear();
          passController.clear();

          goto.gobackHome();
        } else {
          toastMessage.show("Login Failed: ${decodeData['message']}");
        }
      } catch (e) {
        print('error: $e');
        toastMessage.show("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
            child: Container(
                margin: const EdgeInsets.only(top: 100),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      customFormField(
                        labelText: 'Email',
                        hintText: 'email should special symbol',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        icon: Icon(
                          Icons.email,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle visibility
                              });
                            },
                          ),
                        ),
                        controller: passController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Invalid Password';
                          } else {
                            return null;
                          }
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Enter your details above OR '),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const register()));
                                print('heloo');
                              },
                              child: const Text('Sign Up'))
                        ],
                      ),
                      //  ,

                      Expanded(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            loginUpData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(4, 63, 140, 1),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text('Sign In'),
                        ),
                      ))
                    ],
                  ),
                ))),
      ),
    );
  }
}
