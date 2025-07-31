import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class themeData extends GetxController {
  RxBool isDark = false.obs;
  ThemeMode get theme => isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    loadtheme();
  }

  void changeTheme() async {
    isDark.value = !isDark.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ThemeDataa', isDark.value);

    
      Get.changeThemeMode(theme);
    
  }

  void loadtheme() async{
    var prefs=await SharedPreferences.getInstance();
    bool? themeData=prefs.getBool('ThemeDataa');
    if(themeData!=null){
      isDark.value=themeData;
      Get.changeThemeMode(theme);
    }
  }
}


