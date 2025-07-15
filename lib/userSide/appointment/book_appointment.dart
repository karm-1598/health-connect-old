import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/toastmsg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookAppointment extends StatefulWidget {
  final String docId;
  const BookAppointment({super.key, required this.docId});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  late Future<Map<String, dynamic>> doctors;
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _reasonController = TextEditingController();
  String name = '';
  final _formKey = GlobalKey<FormState>();
  String? date;
  String? Time;
  String? availability;
  String proftype = '';
  String userId = '';

  var _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    doctors = fetchDoctors(widget.docId);
    get();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

// Razor pay payment gateway
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    toastMessage.show("Payment Successfull: ${response.paymentId} ");

    Appointment();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    toastMessage.show("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    toastMessage.show("External Wallet: ${response.walletName}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void get() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      userId = prefs.getString('id')!;
      // String email = prefs.getString('email')!;
      // String phone = prefs.getString('phone')!;
    });
  }

  Future<bool> checkAvailability() async {
    try {
      String uDate = _dateController.text;
      String uTime = _timeController.text;

      // Convert time to 24-hour format
      final inputFormat = DateFormat.jm(); // e.g., 2:00 PM
      final outputFormat = DateFormat.Hm(); // e.g., 14:00
      final time24 = outputFormat.format(inputFormat.parse(uTime));

      final doctorData = await doctors;
      String proId = doctorData['id'].toString();
      String prof_type = 'doctor';

      var api = baseApi();

      var checkAvailability = await api.post('appointment.php', {
        'prof_id': proId,
        'profession_type': prof_type,
        'date': uDate,
        'time': time24,
        'check_only': true
      });

      final data = checkAvailability;

      if (data['success'] == true) {
        return data['available'];
      } else {
        print("Server message: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("Error checking availability: $e");
      return false;
    }
  }

  void startPayment() async {
    final doctorData = await doctors;
    var options = {
      'key': 'rzp_test_y35wLoZwNo17Vp',
      'amount':
          '${int.parse(doctorData['avg_consultation_fee']) * 100}', //in paise.
      'name': 'Health Connect',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Doctor Apointment',
      'timeout': 60, // in seconds
      'prefill': {'contact': '9000090000', 'email': 'karm@example.com'}
    };
    _razorpay.open(options);
  }

  //
  void BookAppointment() async {
    bool available = await checkAvailability();
    if (available) {
      startPayment();
    } else {
      toastMessage.show("Doctor is not available at this time or Day.");
    }
  }

  // Function to book appointements
  void Appointment() async {
    if (_formKey.currentState!.validate()) {
      String uDate = _dateController.text;
      String uTime = _timeController.text;
      String uReason = _reasonController.text;
      final doctorData = await doctors;
      String proId = doctorData['id'].toString();
      String status = 'pending';
      String prof_type = 'doctor';

      var api = baseApi();

      var bookAppointment = await api.post("appointment.php", {
        'user_id': userId,
        'prof_id': proId,
        'profession_type': prof_type,
        'date': uDate,
        'time': uTime,
        'status': status,
        'reason': uReason,
      });
      try {
        var decodeData = bookAppointment;

        if (decodeData.containsKey('success') &&
            decodeData['success'] == true) {
          toastMessage.show(decodeData['message']);
          goto.openhome_screen();
        } else {
          toastMessage.show(
              "Failed to create Appointment: ${decodeData['message'] ?? 'Unknown error'}");
        }
      } catch (e) {
        print('Error: $e');
        toastMessage.show('Error: $e');
      }
    }
  }

  // Function to fetch doctor details
  Future<Map<String, dynamic>> fetchDoctors(String id) async {
    
    var api = baseApi();
    var response= await api.post('doc_single_data.php', {'sid': id});

    
      try {
        List<dynamic> jsonResponse =response;
        if (jsonResponse.isNotEmpty) {
          return jsonResponse[0];
        } else {
          throw Exception('No Doctor found with this ID');
        }
      } catch (e) {
        throw Exception('Failed to parse doctor details. Response might be invalid JSON.');
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

  Future<void> time() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        Time = result.format(context);
        _timeController.text = Time!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
        
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user found'));
          } else {
            final doctors = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[300],
                                      child: const Icon(Icons.person,
                                          size: 40, color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dr. ${doctors['name']} ${doctors['lastname']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            doctors['qualification'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${doctors['experience']} years experience ',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: const Color.fromARGB(255, 210, 204, 204),
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: RichText(
                                    text: TextSpan(
                                  text:
                                      'Conslutation Fee: ${doctors['avg_consultation_fee']} INR',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                )),
                              )),
                        ),
                        const SizedBox(height: 30),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      height: 55,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:BorderRadius.circular(10),),
                                                side:BorderSide(
                                                  color: Theme.of(context).colorScheme.outline,
                                                ) ,
                                            backgroundColor:Theme.of(context).colorScheme.secondaryContainer,),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? 'Please select a date'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 55,
                                      width: 160,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color:Theme.of(context).colorScheme.outline)),
                                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
                                        onPressed: () {
                                          time();
                                        },
                                        label: Text('Time'),
                                        icon: Icon(Icons.access_time),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: TextFormField(
                                        controller: _timeController,
                                        decoration: InputDecoration(
                                          labelText: 'Time (AM/PM)',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? 'Please enter a time'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Reason for Appointment',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  controller: _reasonController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter a reason'
                                          : null,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: Color.fromRGBO(
                                                  46, 68, 176, 1))),
                                      backgroundColor:
                                          Color.fromRGBO(46, 68, 176, 1),
                                    ),
                                    onPressed: () {
                                      BookAppointment();
                                    },
                                    child: const Text(
                                      'Book Appointment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
