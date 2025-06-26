import 'package:flutter/material.dart';
import 'package:health_connect2/config/colors.dart';

class customFormField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final bool passWord;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Icon? icon;
  final String? Function(String?)? validator;
  const customFormField({
    super.key, 
    this.labelText,
    required this.hintText,
    this.keyboardType,
    required this.controller,
     this.passWord=false,
     this.icon,
     this.validator,
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: passWord,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: icon,        
      ),
      style: TextStyle(
        color: lightFontColor
      ),
    );
  }
}