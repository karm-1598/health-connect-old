import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect2/provider_login.dart';
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

      var url = Uri.parse('http://192.168.60.215/api/doc_insert.php');

      var mydata = {
        'name': uname,
        'lastname': ulastname,
        'experience': uyearExe,
        'availability_slot_days': uslotday,
        'availability_slot_time': uslottime,
        'qualification': uquli,
        'avg_consultation_fee': ufee,
        'password': upass,
        'email': uemail
      };

      try {
        var response = await http.post(
          url,
          body: jsonEncode(mydata),
          headers: {"Content-Type": "application/json"},
        );

        var decodeData = jsonDecode(response.body);

        print('response status: ${response.statusCode}');
        print('response body: ${response.body}');
        print('decode data: $decodeData');

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

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const providerLogin()));
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
        title: const Text('Doctor Registration',style: TextStyle(color: Colors.white),),
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
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'Please enter your name',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.person),
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Please enter your last name',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.person),
                            ),
                            controller: lastnameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Last Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Year of Experience',
                              hintText: 'Please enter your years of experience',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.work),
                            ),
                            controller: yearExeController,
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

                          TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter a valid email address',
                  suffixIcon: const Icon(Icons.email)
                ),
                controller: emailController,
                validator: (value) {
                if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email';
                }else{
                  return null;
                }
              },
              ),
                          SizedBox( height: 20 ),
                          
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Qualifications',
                              hintText: 'Enter your qualifications',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.book),
                            ),
                            controller: qualificationController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Qualification';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Availability Slot (Time)',
                              hintText: 'Enter possible time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            controller: slottimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Slot Time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Availability Slot (Day)',
                              hintText: 'Enter possible days',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: slotdayController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Slot Day';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Average Consultation Fee',
                              hintText: 'Enter fee',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.money),
                            ),
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
