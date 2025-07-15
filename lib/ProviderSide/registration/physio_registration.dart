import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:flutter/material.dart';

class PhysioRegistration extends StatefulWidget {
  const PhysioRegistration({super.key});

  @override
  State<PhysioRegistration> createState() => _PhysioRegistrationState();
}

class _PhysioRegistrationState extends State<PhysioRegistration> {
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

      

      var api=baseApi();

      var response= await api.post('physio_insert.php', {
        'name': uname,
        'lastname': ulastname,
        'experience': uyearExe,
        'availability_slot_days': uslotday,
        'availability_slot_time': uslottime,
        'qualification': uquli,
        'avg_consultation_fee': ufee,
        'password': upass,
        'email': uemail
      });

      try {
        

        var decodeData =response;

        if (decodeData['flag'] == "1") {
          toastMessage.show(decodeData['message']);

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
          toastMessage.show("Registration failed: ${decodeData['message']}");
        }
      } catch (e) {
        print('error: $e');
        toastMessage.show( "Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physiotherapist Registration', ),
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
                      'Sign Up for Physiotherapists',
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
                          // Name
                          customFormField(
                              labelText: 'Name',
                              hintText: 'Please enter your name',
                              icon: Icon(Icons.person),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          customFormField(
                              labelText: 'Last Name',
                              hintText: 'Please enter your last name',
                              icon: Icon(Icons.person),
                            controller: lastnameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Last Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                            keyboardType: TextInputType.number,
                              labelText: 'Year of Experience',
                              hintText: 'Please enter your years of experience',
                              icon: Icon(Icons.work),
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

                          customFormField(
                  labelText: 'Email',
                  hintText: 'Enter a valid email address',
                  icon: const Icon(Icons.email),
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
                          
                          customFormField(
                              labelText: 'Qualifications',
                              hintText: 'Enter your qualifications',
                              icon: Icon(Icons.book),
                            controller: qualificationController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Qualification';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                              labelText: 'Availability Slot (Time)',
                              hintText: 'Enter possible time',
                              icon: Icon(Icons.access_time),
                            controller: slottimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Invalid Slot Time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          customFormField(
                              labelText: 'Availability Slot (Day)',
                              hintText: 'Enter possible days',
                              icon: Icon(Icons.calendar_today),
                            controller: slotdayController,
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
                    onPressed: (){
                      signUpData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sign Up as Physiotherapist'),
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
