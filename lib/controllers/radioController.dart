import 'package:get/get.dart';

class radioController extends GetxController{

  var selectedOption='best_offer'.obs;

  List<String> offers=[
    'Best Offer',
    'Offer 20% - 40%',
    'Offer 40% - 60%',
    '60% Above'
  ];

  List<String> offersValue=[
    'best_offer',
    '20_40',
    '40_60',
    '60'
  ];

  

  void selectOption(String value){
    selectedOption.value=value;
  }

  void ondispose(){
    selectedOption.value=offersValue[0];
  }
}