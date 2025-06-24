import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_connect2/user_update.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_login.dart';

class UserProfile extends StatefulWidget {
  final String studentId;
  const UserProfile({super.key, required this.studentId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = fetchUsers(widget.studentId);
  }

  Future<Map<String, dynamic>> fetchUsers(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.255.215/api/user_single_data.php'),
      body: jsonEncode({'sid': id}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        return jsonResponse[0];
      } else {
        throw Exception('No User found with this ID');
      }
    } else {
      throw Exception('Failed to load User details');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.255.215/api/user_delete.php'),
      body: jsonEncode({'sid': id}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home_screen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student')),
      );
    }
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLogedIn');
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const user_login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(46, 68, 176, 1),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No user found'),
            );
          } else {
            final users = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          users['name'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          users['email'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Divider(color: Colors.grey.shade400),

                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.blue),
                        title: Text(
                          users['mobile'],
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.red),
                        title: Text(
                          users['address'] ?? 'No Address',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserUpdate(
                                id: users['id'],
                                name: users['name'],
                                email: users['email'],
                                mobile: users['mobile'],
                                address: users['address'],
                              )));
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text('Update',style: TextStyle(color: Colors.black),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteStudent(users['id']);
                              logout();
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                            label: Text('Delete',style: TextStyle(color: Colors.black),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 197, 54, 44),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );

          }
        },
      ),
    );
  }
}
