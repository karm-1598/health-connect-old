import 'package:get/get.dart';

class Ratingcontroller extends GetxController{
  var ratingStar=0.obs;

  void clearRating(){
    ratingStar.value=0;
  }
  
}