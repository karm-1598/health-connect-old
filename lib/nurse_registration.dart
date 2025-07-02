import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:flutter/material.dart';

class NurseRegistration extends StatefulWidget {
  const NurseRegistration({super.key});

  @override
  State<NurseRegistration> createState() => _NurseRegistrationState();
}

class _NurseRegistrationState extends State<NurseRegistration> {
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final experienceController = TextEditingController();
  final qualificationController = TextEditingController();
  final shiftTimeController = TextEditingController();
  final shiftDaysController = TextEditingController();
  final consultationFeeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var api=baseApi();

  void registerNurse() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String lastname = lastnameController.text;
      String experience = experienceController.text;
      String qualification = qualificationController.text;
      String shiftTime = shiftTimeController.text;
      String shiftDays = shiftDaysController.text;
      String consultationFee = consultationFeeController.text;
      String email = emailController.text;
      String password = passwordController.text;

      

      var response =await api.post('nurse_insert.php', {
        'name': name,
        'lastname': lastname,
        'experience': experience,
        'qualification': qualification,
        'shift_time': shiftTime,
        'shift_days': shiftDays,
        'consultation_fee': consultationFee,
        'email': email,
        'password': password,
      });

      try {
        var decodedResponse = response;

        if (decodedResponse['flag'] == "1") {
          toastMessage.show(decodedResponse['message']);

          nameController.clear();
          lastnameController.clear();
          experienceController.clear();
          qualificationController.clear();
          shiftTimeController.clear();
          shiftDaysController.clear();
          consultationFeeController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          goto.openProviderLogin();
        } else {
          toastMessage.show("Registration failed: ${decodedResponse['message']}");
        }
      } catch (e) {
        print('Error: $e');
        toastMessage.show("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nurse Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sign Up for Nurses',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 40),
                
                customFormField(
                    labelText: 'Name',
                    hintText: 'Enter your first name',
                    icon: Icon(Icons.person),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    icon: Icon(Icons.person),
                  controller: lastnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                  keyboardType: TextInputType.number,
                    labelText: 'Years of Experience',
                    hintText: 'Enter your years of experience',
                    icon: Icon(Icons.work),
                  controller: experienceController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter years of experience';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                    labelText: 'Qualifications',
                    hintText: 'Enter your qualifications',
                    icon: Icon(Icons.book),
                  controller: qualificationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid qualification';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                    labelText: 'Shift Time',
                    hintText: 'Enter your shift time',
                    icon: Icon(Icons.access_time),
                  controller: shiftTimeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid shift time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                    labelText: 'Shift Days',
                    hintText: 'Enter your shift days',
                    icon: Icon(Icons.calendar_today),
                  controller: shiftDaysController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid shift days';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                  keyboardType: TextInputType.number,
                    labelText: 'Consultation Fee',
                    hintText: 'Enter your consultation fee',
                    icon: Icon(Icons.money),
                  controller: consultationFeeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid consultation fee';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                customFormField(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                   icon: Icon(Icons.email),
                  controller: emailController,
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                TextFormField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                TextFormField(
                  obscureText: !_isPasswordVisible2,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                    ),
                  ),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                
                ElevatedButton(
                  onPressed: registerNurse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Register Nurse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
