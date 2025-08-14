import 'package:flutter/material.dart';

class UserProfilePhoto extends StatefulWidget {
  const UserProfilePhoto({super.key});

  @override
  State<UserProfilePhoto> createState() => _UserProfilePhotoState();
}

class _UserProfilePhotoState extends State<UserProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            maxRadius: 52,
          )
        ],
      ),
    );
  }
}