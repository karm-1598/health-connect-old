import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({super.key});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final _formKey = GlobalKey<FormState>();
  String? date;
  String? startTime;
  String? endTime;
  String? availability;
  String proftype = '';
  String profId = '';

  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    get();
  }

  void get() async {
    var prefs = await SharedPreferences.getInstance();
    profId = prefs.getString('id')!;
    proftype = prefs.getString('provider') ?? '';
  }

  // Function to handle form submission and API request
  void _submitSchedule() async {
    if (_formKey.currentState!.validate()) {
      int uProfId = int.parse(profId);
      String uDate = _dateController.text;
      String uStartTime = _startTimeController.text;
      String uEndTime = _endTimeController.text;

      var api = baseApi();
      var response = await api.post('schedule_appointment.php', {
        'prof_id': uProfId,
        'profession_type': proftype,
        'date': uDate,
        'start_time': uStartTime,
        'end_time': uEndTime,
        'availability': availability == "available" ? "1" : "0",
      });

      try {
        Map<String, dynamic> decodeData;
        if(response is String){
          decodeData = json.decode(response);
        }else if(response is Map<String, dynamic>){
          decodeData = response;
        }else{
          throw Exception('Unexpected response type: ${response.runtimeType}');
        }

        if (decodeData['success'] == true) {
          setState(() {});
          toastMessage.show(decodeData['message']);
          goto.gobackProviderHome();
        } else {
          toastMessage
              .show(decodeData['message'] ?? 'Failed to create schedule');
        }
      } catch (e) {
        print('Error: $e');
        toastMessage.show("Error: $e");
      }
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        date = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = date!;
      });
  }

  Future<void> StartTime() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        startTime = result.format(context);
        _startTimeController.text = startTime!;
      });
    }
  }

  Future<void> EndTime() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        endTime = result.format(context);
        _endTimeController.text = endTime!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: const Text(
          'Create Schedule Appointment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(46, 68, 176, 1),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 160,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(46, 68, 176, 1))),
                          backgroundColor:
                              const Color.fromARGB(255, 128, 172, 247)),
                      onPressed: () {
                        selectDate(context);
                      },
                      label: Text('Date'),
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a date'
                          : null,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              // Start Time Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 55,
                    width: 160,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(46, 68, 176, 1))),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        StartTime();
                      },
                      label: Text('Start Time'),
                      icon: Icon(Icons.access_time),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: InputDecoration(
                        labelText: 'Start Time (AM/PM)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a start time'
                          : null,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              // End Time Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 55,
                    width: 160,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(46, 68, 176, 1))),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        EndTime();
                      },
                      label: Text('End Time'),
                      icon: Icon(Icons.access_time),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: InputDecoration(
                        labelText: 'End Time (AM/PM)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter an end time'
                          : null,
                    ),
                  )
                ],
              ),

              SizedBox(height: 30),

              // Availability Dropdown
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(46, 68, 176, 1), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: DropdownButtonFormField<String>(
                  value: availability,
                  onChanged: (value) {
                    setState(() {
                      availability = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Availability'),
                  items: ['available', 'unavailable']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please select availability' : null,
                ),
              ),

              // Submit Button
              SizedBox(height: 40),

              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Color.fromRGBO(46, 68, 176, 1))),
                    backgroundColor: Color.fromRGBO(46, 68, 176, 1),
                  ),
                  onPressed: () {
                    _submitSchedule();
                  },
                  child: const Text(
                    'Create Schedule',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
