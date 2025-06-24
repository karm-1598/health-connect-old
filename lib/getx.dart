// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class mytranslate extends Translations{
//   Map<String, Map<String,String>> get keys =>{
//     'en_US':{
//       'hello': 'Hello',
//       'welcome': 'welcome to gandhinagar'
//     },
//     'hi_In':{
//       'hello':'नमस्ते',
//       'welcome':'गांधीनगर में आपका स्वागत है',
//     },
//     'gu_In':{
//       'hello':'નમસ્તે',
//       'welcome':'ગાંધીનગરમાં આપનું સ્વાગત છે'
//     }
//   };
// }

// void main(){
//   runApp(GetMaterialApp(
//     translations: mytranslate(),
//     locale: Locale('en_US'),
//     fallbackLocale: Locale('en_US'),
//     home: Home(),
//   ));
// }

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Language'),
//       ),
//         child: Column(
//           children: [
//             Text('hello'.tr, style: TextStyle(fontSize: 30)),
//             Text('welcome'.tr, style: TextStyle(fontSize: 30)),
//             SizedBox(height: 20,),

//             ElevatedButton(onPressed: (){
//               Get.updateLocale(Locale('hi_In'));
//             }, child: Text('Hindi')),
//             SizedBox(height: 20,),
//             ElevatedButton(onPressed: (){
//               Get.updateLocale(Locale('gu_In'));
//             }, child: Text('Gujarati')),
//           ],
//         ),
//       ),
//     );
//   }
// }