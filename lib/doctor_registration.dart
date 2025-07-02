import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class doc_registration extends StatefulWidget {
  const doc_registration({super.key});

  @override
  State<doc_registration> createState() => _doc_registrationState();
}

class _doc_registrationState extends State<doc_registration> {
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  final _formkey3 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final yearExeController = TextEditingController();
  final qualificationController = TextEditingController();
  final slottimeController = TextEditingController();
  final slotdayController = TextEditingController();
  final feeController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  final emailController = TextEditingController();

  void signUpData() async {
    if (_formkey3.currentState!.validate()) {
      String uname = nameController.text;
      String ulastname = lastnameController.text;
      String uyearExe = yearExeController.text;
      String uquli = qualificationController.text;
      String uslottime = slottimeController.text;
      String uslotday = slotdayController.text;
      String ufee = feeController.text;
      String upass = passController.text;
      String uemail = emailController.text;

      // var url = Uri.parse('http://192.168.60.215/api/doc_insert.php');

      // var mydata = {
        // 'name': uname,
        // 'lastname': ulastname,
        // 'experience': uyearExe,
        // 'availability_slot_days': uslotday,
        // 'availability_slot_time': uslottime,
        // 'qualification': uquli,
        // 'avg_consultation_fee': ufee,
        // 'password': upass,
        // 'email': uemail
      // };

      var api=baseApi();
      var response= await api.post(
        'doc_insert.php',
         {'name': uname,
        'lastname': ulastname,
        'experience': uyearExe,
        'availability_slot_days': uslotday,
        'availability_slot_time': uslottime,
        'qualification': uquli,
        'avg_consultation_fee': ufee,
        'password': upass,
        'email': uemail}
        );

      try {
        

        var decodeData = response;

        if (decodeData['flag'] == "1") {
          Fluttertoast.showToast(
            msg: decodeData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16,
          );

          nameController.clear();
          lastnameController.clear();
          passController.clear();
          slotdayController.clear();
          slottimeController.clear();
          yearExeController.clear();
          qualificationController.clear();
          feeController.clear();
          emailController.clear();

          goto.openProviderLogin();
        } else {
          Fluttertoast.showToast(
            msg: "Registration failed: ${decodeData['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16,
          );
        }
      } catch (e) {
        print('error: $e');
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Sign Up for Doctors',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Card wrapping all the TextFormFields
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          customFormField(
                            hintText: 'Please enter your name',
                            controller: nameController,
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            hintText: 'Please enter your last name',
                            controller: lastnameController,
                            labelText: 'Last Name',
                            icon: Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Last Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            hintText: 'Please enter your years of experience',
                            controller: yearExeController,
                            labelText: 'Year of Experience',
                            icon: Icon(Icons.work),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Year of Experience';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            controller: passController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: !_isPasswordVisible2,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible2 = !_isPasswordVisible2;
                                  });
                                },
                              ),
                            ),
                            controller: passConfirmController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              } else if (value != passController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                              hintText: 'Enter a valid email address',
                              controller: emailController,
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                              validator: (value) {
                                if (value == null ||
                                    !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                  return 'Enter a valid email';
                                } else {
                                  return null;
                                }
                              }),
                          SizedBox(height: 20),
                          customFormField(
                            hintText: 'Enter your qualifications',
                            controller: qualificationController,
                            labelText: 'qualification',
                            icon: Icon(Icons.book),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Qualification';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            hintText: 'Enter possible time',
                            controller: slotdayController,
                            labelText: 'Availability Slot (Day)',
                            icon: Icon(Icons.access_time),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Slot Time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            labelText: 'Availability Slot (Time)',
                            hintText: 'Enter possible time',
                            icon: Icon(Icons.calendar_today),
                            controller: slottimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Slot Day';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            keyboardType: TextInputType.number,
                            labelText: 'Average Consultation Fee',
                            hintText: 'Enter fee',
                            icon: Icon(Icons.money),
                            controller: feeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Amount';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      signUpData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sign Up as Doctor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
