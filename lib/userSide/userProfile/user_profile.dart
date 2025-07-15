import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var api = baseApi();
    final response = await api.post('user_single_data.php', {'sid': id});

    List<dynamic> jsonResponse = response;
    if (jsonResponse.isNotEmpty) {
      return jsonResponse[0];
    } else {
      throw Exception('No User found with this ID');
    }
  }

  Future<void> deleteStudent(String id) async {
    var api=baseApi();
    final response = await api.post('user_delete.php',{'sid': id});
   
      var responseData = response;
      if (responseData['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        goto.gobackHome();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed')),
        );
      }
    
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLogedIn');
    setState(() {
      goto.openUserLogin();
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
                color: Theme.of(context).colorScheme.surfaceContainer,
                
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
                          style: Theme.of(context).textTheme.headlineLarge
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          users['email'],
                          style: Theme.of(context).textTheme.bodyMedium,
                          
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey.shade400),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.blue),
                        title: Text(
                          users['mobile'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.red),
                        title: Text(
                          users['address'] ?? 'No Address',
                          style: Theme.of(context).textTheme.bodyLarge
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              goto.openUserUpdate(users['id'], users['name'], users['email'], users['address'], users['mobile']);
                              
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text(
                              'Update',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 197, 54, 44),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
