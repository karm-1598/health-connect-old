import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class UserProfile extends StatefulWidget {
  final String studentId;
  const UserProfile({super.key, required this.studentId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> users;
  XFile? imageFile;
  String? imagePath;
  final ImagePicker picker = ImagePicker();
  bool isLoading= false;
  var api = baseApi();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        imagePath = pickedFile.path;
      });
    }
    uploadImage(imageFile!, widget.studentId);
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        imagePath = pickedFile.path;
      });
    }
    uploadImage(imageFile!, widget.studentId);
  }

  Future<void> fetchImage() async{
    setState(() {
      isLoading = true;
    });
    try{
    var fetchformdata=FormData.fromMap({
      'user_id':widget.studentId.toString(),
      'action':'get'
    });
    final responsee= await api.post('user_profile_photo.php', fetchformdata);

    
      if(responsee['status']==200){
      setState(() {
        // ignore: prefer_interpolation_to_compose_strings
        imagePath ='http://192.168.1.10/api/'+responsee['photo_url'];
      });
      print('->->->->->->->->->->->->->->$imagePath<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-');
    }else{
      setState(() {
        imagePath=null;
      });
    }
    } catch(e){
      print('++++++++++++++++++$e++++++++++++++++++++++++++++++++++++++++');
    }finally{
      if(mounted){
      setState(() {
      isLoading=false;
    });}
    }

    
  }

  ImageProvider? _getImageProvider() {
  if (imageFile != null) {
    return FileImage(File(imageFile!.path));
  } else if (imagePath != null && imagePath!.isNotEmpty) {
    if (imagePath!.startsWith('http')) {
      return NetworkImage(imagePath!);
    } else if (File(imagePath!).existsSync()) {
      return FileImage(File(imagePath!));
    }
  }
  return null;
}

  Future<void> uploadImage(XFile uploadImage, String userId) async {
    String ext = p.extension(imagePath!);
    final formData = FormData.fromMap({
      'user_id': userId,
      'action': 'upload',
      'photo': await MultipartFile.fromFile(uploadImage.path,
          filename: 'profile_photo_$userId$ext')
    });
    final response = await api.post('user_profile_photo.php', formData);
    if (response['status'] == 200) {
      fetchImage();
    }
  }

  @override
  void initState() {
    super.initState();
    users = fetchUsers(widget.studentId);
    fetchImage();
  }

  Future<Map<String, dynamic>> fetchUsers(String id) async {
    final response = await api.post('user_single_data.php', {'sid': id});

    List<dynamic> jsonResponse = response;
    if (jsonResponse.isNotEmpty) {
      return jsonResponse[0];
    } else {
      throw Exception('No User found with this ID');
    }
  }

  Future<void> deleteStudent(String id) async {
    var api = baseApi();
    final response = await api.post('user_delete.php', {'sid': id});

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
                        child: InkWell(
                          
                          onTap: () {
                            showBottomSheet(
                              constraints: BoxConstraints.expand(width: 400,height: 300),
                              backgroundColor: Theme.of(context).colorScheme.outline,
                              enableDrag: true,
                              showDragHandle: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                                            minimumSize: const Size(double.infinity, 50),
                                          ),
                                          onPressed: () {
                                            getImageFromGallery();
                                          },
                                          label: Text('Choose from Gallery'),
                                          icon: Icon(Icons.browse_gallery),
                                        ),
                                        SizedBox(height: 20,),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                                            minimumSize: const Size(double.infinity, 50),
                                          ),
                                          onPressed: () {getImageFromCamera();},
                                          label: Text('Click from Camera'),
                                          icon: Icon(Icons.camera_alt),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Stack(children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:isLoading?Colors.transparent :Theme.of(context).inputDecorationTheme.fillColor,
                              backgroundImage:isLoading?null: _getImageProvider(),
                              child: (!isLoading && _getImageProvider()==null)?
                              Icon(Icons.person, size: 50, color: Colors.grey[600],):null,
                            ),
                            Positioned(
                                bottom: 10,
                                right: 4,
                                child: Icon(Icons.add_a_photo_rounded)),
                              if(isLoading)
                                Positioned.fill(child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.outline,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.white),),),
                                ))
                              
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(users['name'],
                            style: Theme.of(context).textTheme.headlineLarge),
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
                        title: Text(users['address'] ?? 'No Address',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              goto.openUserUpdate(
                                  users['id'],
                                  users['name'],
                                  users['email'],
                                  users['address'],
                                  users['mobile']);
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
