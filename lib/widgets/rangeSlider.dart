import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/rangeController.dart';

class rangeSlider extends StatefulWidget {
  final String max;
  final String min;
  final Function(RangeValues) onChanged;
  
  const rangeSlider(
      {super.key,
      required this.max,
      required this.min,
      required this.onChanged,
      });

  @override
  State<rangeSlider> createState() => _rangeSliderState();
}

class _rangeSliderState extends State<rangeSlider> {
  rangeController controller=Get.find<rangeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>RangeSlider(
        values: controller.rangevalues.value,
        min: double.parse(widget.min),
        max: double.parse(widget.max),
        divisions: 10,
        activeColor: Colors.amber,
        labels: RangeLabels(controller.rangevalues.value.start.round().toString(),
            controller.rangevalues.value.end.round().toString()),
        onChanged: (value) {
          controller.updateRange(value);
        }));
  }
}
