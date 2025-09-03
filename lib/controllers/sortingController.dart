import 'package:get/get.dart';

class Sortingcontroller extends GetxController{
  var selectedOption= 'charges:low to high'.obs;

  List<String> sorting=[
    'Charges: Low to High',
    'Charges: High to Low',
    'Experience: Low to High',
    'Experience: High to Low'
  ];

  List<String> sortingValues=[
    'charges_low_to_high',
    'charges_high_to_low',
    'exp_low_to_high',
    'exp_high_to_low'
  ];

  void selectOption(String value){
    selectedOption.value=value;
  }
}