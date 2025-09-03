import 'package:flutter/material.dart';
import 'package:get/get.dart';

class rangeController extends GetxController{
  Rx<RangeValues> rangevalues= RangeValues(100, 1000).obs;
  Rx<RangeValues> rangevaluesExp= RangeValues(1, 20).obs;

  void updateRange(RangeValues value){
    rangevalues.value=value;
  }

  void resetRange(){
    rangevalues.value=RangeValues(100, 1000);
  }

  void updateRangeExp(RangeValues value){
    rangevaluesExp.value=value;
  }

  void resetRangeExp(){
    rangevaluesExp.value=RangeValues(1, 20);
  }
  
}