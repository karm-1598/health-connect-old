import 'package:flutter/material.dart';
import 'package:get/get.dart';

class rangeController extends GetxController{
  Rx<RangeValues> rangevalues= RangeValues(100, 500).obs;

  void updateRange(RangeValues value){
    rangevalues.value=value;
  }

  void resetRange(){
    rangevalues.value=RangeValues(100, 500);
  }
  
}