import 'package:flutter/material.dart';
import 'package:health_connect2/provider_home.dart';
import 'package:health_connect2/select_category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

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

      var url = Uri.parse('http://192.168.255.215/api/providers_login.php');

      var myData = {
        'semail': uemail,
        'spassword': upassword,
        'profession_type': selectedRole ?? '',  // Send selected role data to the server
      };

      try {
        var response = await http.post(
          url,
          body: jsonEncode(myData),
          headers: {"content-Type": "application/json"},
        );

        var decodeData = jsonDecode(response.body);

        print("response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (decodeData['flag'] == "1") {
          var sharedName = decodeData['provider_name'];
          var sharedEmail = decodeData['provider_email'];
          var sharedId = decodeData['provider_id'];
          var sharedProvider = decodeData['profession'];

          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', sharedName);
          await prefs.setString('email', sharedEmail);
          await prefs.setBool('keepLogedIn2', true);
          await prefs.setString('id', sharedId);
          await prefs.setString('provider', sharedProvider);
          

          Fluttertoast.showToast(
            msg: decodeData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          emailController.clear();
          passController.clear();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProviderHome()));
        } else {
          Fluttertoast.showToast(
            msg: "Login Failed: ${decodeData['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print('error: $e');
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'email should special symbol'
                    ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const select_category()));
                        print('hello');
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
