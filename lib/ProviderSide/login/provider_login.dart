import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/custom_textformfield.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class providerLogin extends StatefulWidget {
  const providerLogin({super.key});

  @override
  State<providerLogin> createState() => _providerLoginState();
}

class _providerLoginState extends State<providerLogin> {
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final locationController = TextEditingController();
  final idController = TextEditingController();
  String address = '';
  
  // Dropdown related variables
  String? selectedRole; // Stores selected role
  List<String> roles = ['Doctor', 'Nurse', 'Physiotherapist', 'Lab']; // Role options
  

  void loginUpData() async {
    if (_formkey.currentState!.validate()) {
      String uemail = emailController.text;
      String upassword = passController.text;

      var api=baseApi();

      var response= await api.post('providers_login.php', {
        'semail': uemail,
        'spassword': upassword,
        'profession_type': selectedRole ?? '',  
      });
      

      try {
        

        var decodeData = response;
        if(selectedRole== null){
          toastMessage.show('Please select a role', );
        }

        if (decodeData['flag'] == "1") {
          final String sharedName = decodeData['provider_name'];
          final String sharedEmail = decodeData['provider_email'];
          final String sharedId = decodeData['provider_id'];
          final String sharedProvider = decodeData['profession'];

          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', sharedName);
          await prefs.setString('email', sharedEmail);
          await prefs.setBool('keepLogedIn2', true);
          await prefs.setString('id', sharedId);
          await prefs.setString('provider', sharedProvider);
          

          toastMessage.show(decodeData['message']);

          emailController.clear();
          passController.clear();

          goto.gobackProviderHome();
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
        child:Container(
            margin: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Sign In as Healthcare Provider',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  customFormField(
                        labelText: 'Email',
                        hintText: 'email should special symbol',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
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
                  const SizedBox(height: 20,),
                  
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    value: selectedRole,
                    hint: Text('Select Role'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Enter your details above OR '),
                      TextButton(onPressed: () {
                        goto.goSelectCategory();
                      }, child: const Text('Sign Up')),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          loginUpData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(4, 63, 140, 1),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text('Sign In'),
                      ),
                    ),
                ],
              ),
            ),
            )
          ),
      ),
    );
  }
}
