import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
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

      var url = Uri.parse('http://192.168.255.215/api/schedule_appointment.php'); 
      var myData = {
        'prof_id': uProfId,
        'profession_type': proftype,
        'date': uDate,
        'start_time': uStartTime,
        'end_time': uEndTime,
        'availability': availability == "available" ? "1" : "0",  
      };

      try {
        var response = await http.post(
          url,
          body: jsonEncode(myData),
          headers: {"Content-Type": "application/json"},
        );

        // Debugging: Print the response to verify its contents
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          var decodeData = jsonDecode(response.body);

          if (decodeData['success'] == true) {
            setState(() {});
            Fluttertoast.showToast(
              msg: decodeData['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
              msg: decodeData['message'] ?? 'Failed to create schedule',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to connect to the server.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        startTime = result.format(context);
        _startTimeController.text = startTime!;
      });
    }
  }

  Future<void> EndTime() async {
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
        title: const Text('Create Schedule Appointment', style: TextStyle(color: Colors.white),),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1))),
                        backgroundColor: const Color.fromARGB(255, 128, 172, 247)
                      ),
                    onPressed: () {
                      selectDate(context);
                    },
                    label: Text('Date'),
                    icon: Icon(Icons.calendar_today),
                  ),),
                 
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),)
                      ),
                    validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
                  ),),
                ],
              ),

              SizedBox(height: 30,),

              // Start Time Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 55,
                    width: 160,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1))),
                        backgroundColor: Colors.white
                      ),
                    onPressed: () {
                      StartTime();
                    },
                    label: Text('Start Time'),
                    icon: Icon(Icons.access_time),
                  ),),

                  SizedBox(
                    width: 160,
                    child: TextFormField(
                    controller: _startTimeController,
                    decoration: InputDecoration(
                      labelText: 'Start Time (AM/PM)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      ),),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a start time' : null,
                  ),),
                ],
              ),

              SizedBox(height: 30,),

              // End Time Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 55,
                    width: 160,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1))),
                        backgroundColor: Colors.white
                      ),
                    onPressed: () {
                      EndTime();
                    },
                    label: Text('End Time'),
                    icon: Icon(Icons.access_time),
                  ),),

              SizedBox(
                width: 160,
                child: TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: 'End Time (AM/PM)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  ),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter an end time' : null,
              ),)
                ],
              ),

              SizedBox(height: 30),

              // Availability Dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(46, 68, 176, 1),width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white
                ),
                
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
                validator: (value) => value == null ? 'Please select availability' : null,
              ),
              ),

              // Submit Button
              SizedBox(height: 40),
              

              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1))),
                        backgroundColor: Color.fromRGBO(46, 68, 176, 1),
                      ),
                onPressed: () {
                  _submitSchedule();
                },
                child: const Text('Create Schedule',
                style: TextStyle(color: Colors.white),),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
