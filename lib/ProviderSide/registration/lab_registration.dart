import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class lab_registration extends StatefulWidget {
  const lab_registration({super.key});

  @override
  State<lab_registration> createState() => _lab_registrationState();
}

class _lab_registrationState extends State<lab_registration> {
  bool _isPasswordVisible = false;
  final _formkey3 = GlobalKey<FormState>();
  final labNameController = TextEditingController();
  final labDirectorController = TextEditingController();
  final operatingHoursController = TextEditingController();
  final labAddressController = TextEditingController();
  final pricingController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  final emailController = TextEditingController();

  String selectedLabType = 'Pathology'; // Default type

  void signUpData() async {
    if (_formkey3.currentState!.validate()) {
      String labName = labNameController.text;
      String labType = selectedLabType;
      String labDirector = labDirectorController.text;
      String operatingHours = operatingHoursController.text;
      String labAddress = labAddressController.text;
      String pricing = pricingController.text;
      String password = passController.text;
      String email = emailController.text;

      // var url = Uri.parse('http://192.168.60.215/api/lab_insert.php'); 

      // var mydata = {
        // 'lab_name': labName,
        // 'lab_type': labType,
        // 'lab_director': labDirector,
        // 'operating_hours': operatingHours,
        // 'lab_address': labAddress,
        // 'pricing': pricing,
        // 'email': email,
        // 'password': password
      // };
      var api=baseApi();
      var response = await api.post('lab_insert.php', {'lab_name': labName,
        'lab_type': labType,
        'lab_director': labDirector,
        'operating_hours': operatingHours,
        'lab_address': labAddress,
        'pricing': pricing,
        'email': email,
        'password': password});

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

          

          labNameController.clear();
          labDirectorController.clear();
          operatingHoursController.clear();
          labAddressController.clear();
          pricingController.clear();
          passController.clear();
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
        title: const Text('Laboratory Registration',),
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
                      'Sign Up for Laboratories',
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
                              labelText: 'Laboratory Name',
                              hintText: 'Enter laboratory name',
                              icon: Icon(Icons.local_hospital),
                            controller: labNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Laboratory Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedLabType,
                            decoration: const InputDecoration(
                              labelText: 'Lab Type',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              'Pathology', 'Radiology', 'Biochemistry', 'Microbiology', 'Hematology', 'Immunology'
                            ].map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedLabType = newValue!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a lab type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            
                              labelText: 'Lab Director',
                              hintText: 'Enter the lab director\'s name',
                              icon: Icon(Icons.person),
                            controller: labDirectorController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Lab Director';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                              labelText: 'Operating Hours',
                              hintText: 'Enter operating hours',
                              icon: Icon(Icons.access_time),
                            controller: operatingHoursController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Operating Hours';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                              labelText: 'Lab Address',
                              hintText: 'Enter laboratory address',
                              icon: Icon(Icons.location_on),
                            controller: labAddressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Lab Address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            keyboardType: TextInputType.number,                           
                              labelText: 'Pricing',
                              hintText: 'Enter pricing details',
                              icon: Icon(Icons.money),
                            controller: pricingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Pricing';
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
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                              labelText: 'Email',
                              hintText: 'Enter a valid email address',
                              icon: Icon(Icons.email),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Enter a valid email';
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
                    child: const Text('Sign Up as Laboratory'),
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
