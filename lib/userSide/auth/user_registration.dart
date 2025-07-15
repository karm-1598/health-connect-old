import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:flutter/material.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> { 
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  final _formkey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();

  var api=baseApi();

  void signUpData() async {
    if (_formkey2.currentState!.validate()) {
      String uname = nameController.text;
      String uemail = emailController.text;
      String uaddress = addressController.text;
      String umobile = mobileController.text;
      String upass = passController.text;

      var response = await api.post('user_insert.php',{
        'sname': uname,
        'semail': uemail,
        'smobile': umobile,
        'saddress': uaddress,
        'spassword': upass
      });

      try {
        

        var decodeData = response;

        

        if (decodeData['flag'] == "1") {
          toastMessage.show(decodeData['message']);

          nameController.clear();
          emailController.clear();
          passController.clear();
          addressController.clear();
          mobileController.clear();

          goto.openUserLogin();
        } else {
          toastMessage.show("registration failed: ${decodeData['message']}");
        }
      } catch (e) {
        print('error: $e');
        toastMessage.show("error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey2,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    customFormField(
                      hintText: 'Please enter your name',
                      controller: nameController,
                      labelText: 'Name',
                      icon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customFormField(
                      hintText: 'Enter valid email address',
                      controller: emailController,
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20,),

                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.black),
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
                      controller: passConfirmController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: !_isPasswordVisible2,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible2 =
                                  !_isPasswordVisible2; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      controller: passController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Password';
                        }
                        if (value != passConfirmController.text) {
                          return 'password not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    customFormField(
                      hintText: 'Enter your Address', 
                      controller: addressController,
                      labelText: 'Address',
                      icon: Icon(Icons.location_city),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    customFormField(
                      hintText: 'Enter your Mobile Number',
                      controller: mobileController,
                      labelText: 'Mobile',
                      keyboardType:TextInputType.number ,
                      icon: Icon(Icons.phone_android),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signUpData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(4, 63, 140, 1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('Sign Up'),
                    ),
                  ])),
            ),
          )),
    );
  }
}
