import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class UserUpdate extends StatefulWidget {
  final String id, name, email, mobile, address;
  const UserUpdate({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.mobile,
  });

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController idController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id); 
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    mobileController = TextEditingController(text: widget.mobile);
    addressController = TextEditingController(text: widget.address);
  }

  void updateUser() async {
    if (_formKey.currentState!.validate()) {
      String uid = idController.text; 
      String uname = nameController.text;
      String uemail = emailController.text;
      String umobile = mobileController.text;
      String uaddress = addressController.text;

      var url = Uri.parse('http://192.168.255.215/api/user_update.php');
      var myData = {
        'sid': uid, 
        'sname': uname,
        'semail': uemail,
        'smobile': umobile,
        'saddress': uaddress
      };

      try {
        var response = await http.post(
          url,
          body: jsonEncode(myData),
          headers: {"Content-Type": "application/json"},
        );

        var decodedData = jsonDecode(response.body);

        if (decodedData['status'] == true) {
          Fluttertoast.showToast(
            msg: decodedData['message'],
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          if (mounted) {
            goto.gobackHome();
          }
        } else {
          Fluttertoast.showToast(
            msg: "Update failed: ${decodedData['message']}",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error: $e",
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(46, 68, 176, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Update User Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(46, 68, 176, 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your Name',
                        prefixIcon: Icon(Icons.person, color: Color.fromRGBO(46, 68, 176, 1)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
                        prefixIcon: Icon(Icons.email, color: Color.fromRGBO(46, 68, 176, 1)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: 'Enter your Mobile Number',
                        prefixIcon: Icon(Icons.phone, color: Color.fromRGBO(46, 68, 176, 1)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Mobile Number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your Address',
                        prefixIcon: Icon(Icons.location_on, color: Color.fromRGBO(46, 68, 176, 1)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid Address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: updateUser,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          backgroundColor: Color.fromRGBO(46, 68, 176, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
