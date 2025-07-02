import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCancelledAppointments extends StatefulWidget {
  final String userId;
  const UserCancelledAppointments({super.key, required this.userId});

  @override
  State<UserCancelledAppointments> createState() =>
      _UserCancelledAppointmentsState();
}

class _UserCancelledAppointmentsState extends State<UserCancelledAppointments> {
  late Future<List<Map<String, dynamic>>> appointments;
  String name = '';

  @override
  void initState() {
    super.initState();
    get();
    appointments = getAppointments(widget.userId);
  }

  void get() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  Future<List<Map<String, dynamic>>> getAppointments(String id) async {
    var api = baseApi();
    var response =
        await api.post('user_cancelled_appointments.php', {'user_id': id});

    try {
      var jsonResponse = response;

      print('Response: $jsonResponse');

      if (jsonResponse['status'] == true &&
          jsonResponse['appointments'] is List) {
        return List<Map<String, dynamic>>.from(jsonResponse['appointments']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'No Appointments found');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(
          'Failed to parse Completed Appointment details. Response might be invalid JSON.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cancelled Appointments',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: appointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Appointments found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final appointment = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          color: Color.fromRGBO(212, 240, 232, 1),
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
                                          Text.rich(
                                            TextSpan(
                                              text: 'Patient: ',
                                              style: TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text: '$name',
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Reason: ',
                                              style: TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${appointment['reason']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Status: ',
                                              style: TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${appointment['status']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text.rich(
                                  TextSpan(
                                    text: 'Booked on: ',
                                    style: TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${appointment['date']} at ${appointment['time']}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
