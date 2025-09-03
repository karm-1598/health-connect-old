import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/rangeController.dart';

class rangeSlider extends StatefulWidget {
  final String max;
  final String min;
  final Rx<RangeValues> controllerValue;
  final Function(RangeValues) onChanged;
  
  const rangeSlider(
      {super.key,
      required this.max,
      required this.min,
      required this.onChanged,
      required this.controllerValue
      });

  @override
  State<rangeSlider> createState() => _rangeSliderState();
}

class _rangeSliderState extends State<rangeSlider> {
  rangeController controller=Get.find<rangeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>RangeSlider(
        values: widget.controllerValue.value,
        min: double.parse(widget.min),
        max: double.parse(widget.max),
        divisions: 10,
        activeColor: Theme.of(context).appBarTheme.backgroundColor,
        labels: RangeLabels(widget.controllerValue.value.start.round().toString(),
            widget.controllerValue.value.end.round().toString()),
        onChanged: (value) {
          widget.controllerValue.value = value; // ✅ update the correct one
            widget.onChanged(value);
        }));
  }
}
