import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/toastmsg.dart';

class ProviderViewAppointmentList extends StatefulWidget {
  final String profId;
  final String proftype;
  const ProviderViewAppointmentList(
      {super.key, required this.profId, required this.proftype});

  @override
  State<ProviderViewAppointmentList> createState() =>
      _ProviderViewAppointmentListState();
}

class _ProviderViewAppointmentListState
    extends State<ProviderViewAppointmentList> {
  late Future<List<Map<String, dynamic>>> appointments;
  final rejectReasonController = TextEditingController();
  String uuid = '';
  String appointmentStatus = '';

  @override
  void initState() {
    super.initState();
    appointments = getAppointments(widget.profId, widget.proftype);
  }

  var api = baseApi();
  
  Future<List<Map<String, dynamic>>> getAppointments(String id, type) async {
    try {
      var response = await api.post(
          'provider_view_appointment.php', {'prof_id': id, 'profession_type': type});

      print('Response: $response'); // Debugging Step

      // Check if response is valid and has the expected structure
      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true && response['appointments'] is List) {
          return List<Map<String, dynamic>>.from(response['appointments']);
        } else {
          throw Exception(response['message'] ?? 'No Appointments found');
        }
      } else {
        throw Exception('Invalid response format from server');
      }
    } catch (e) {
      print('Error in getAppointments: $e'); // Debugging Step
      throw Exception('Failed to load appointments: ${e.toString()}');
    }
  }

  void rejectAppointment() async {
    String reason = rejectReasonController.text;
    String uid = uuid;

    if (reason.trim().isEmpty) {
      toastMessage.show("Please provide a reason for rejection");
      return;
    }

    try {
      var response = await api.post('delete_appointment.php', {
        'id': uid,
        'reason': reason,
      });

      print('Reject response: $response'); // Debug log

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          toastMessage.show(response['data'] ?? 'Appointment rejected successfully');
          if (mounted) {
            setState(() {
              appointments = getAppointments(widget.profId, widget.proftype);
            });
          }
        } else {
          toastMessage.show("Update failed: ${response['message'] ?? 'Unknown error'}");
        }
      } else {
        toastMessage.show("Invalid response from server");
      }
    } catch (e) {
      print('Error in rejectAppointment: $e'); // Debug log
      toastMessage.show("Error: ${e.toString()}");
    }
  }

  void completeAppointment() async {
    String uid = uuid;

    try {
      var response = await api.post('update_appointment_status.php', {
        'appointment_id': uid
      });

      print('Complete appointment response: $response'); // Debug log

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == true) {
          toastMessage.show(response['message'] ?? 'Appointment updated successfully');
          if (mounted) {
            setState(() {
              appointments = getAppointments(widget.profId, widget.proftype);
            });
          }
          goto.openProviderHome();
        } else {
          toastMessage.show("Update failed: ${response['message'] ?? 'Unknown error'}");
        }
      } else {
        toastMessage.show("Invalid response from server");
      }
    } catch (e) {
      print('Error in completeAppointment: $e'); // Debug log
      toastMessage.show("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Appointment Request',
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              appointments = getAppointments(widget.profId, widget.proftype);
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
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
                                          Text.rich(
                                            TextSpan(
                                              text: 'Patient: ',
                                              style: const TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text: '${appointment['user_name'] ?? 'Unknown'} ',
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Reason: ',
                                              style: const TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text: '${appointment['reason'] ?? 'Not specified'}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Status: ',
                                              style: const TextStyle(fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text: '${appointment['status'] ?? 'Unknown'}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
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
                                    style: const TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: '${appointment['date'] ?? 'Unknown'} at ${appointment['time'] ?? 'Unknown'}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm Your Action'),
                                              content: Text(
                                                'Are you sure you want to ${appointment['status'] == 'confirmed' ? 'Complete' : 'Confirm'} this appointment?',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    uuid = appointment['appointment_id']?.toString() ?? '';
                                                    appointmentStatus = appointment['status'] ?? '';
                                                    if (uuid.isNotEmpty) {
                                                      completeAppointment();
                                                    } else {
                                                      toastMessage.show("Invalid appointment ID");
                                                    }
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color.fromRGBO(46, 68, 176, 1),
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                          appointment['status'] == 'confirmed'
                                              ? 'Complete Appointment'
                                              : 'Confirm Appointment'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        uuid = appointment['appointment_id']?.toString() ?? '';
                                        if (uuid.isEmpty) {
                                          toastMessage.show("Invalid appointment ID");
                                          return;
                                        }
                                        
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Reason for Rejection'),
                                              content: TextFormField(
                                                controller: rejectReasonController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Reason for Rejection',
                                                  hintText: 'Please provide a reason...',
                                                ),
                                                maxLines: 3,
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    rejectAppointment();
                                                    rejectReasonController.clear();
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color.fromRGBO(46, 68, 176, 1),
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Reject'),
                                    ),
                                  ],
                                )
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