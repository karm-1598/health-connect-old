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
    var response = await api.post(
        'provider_view_appointment.php', {'prof_id': id, 'profession_type': type});

    try {
      var jsonResponse = response;

      print('Response: $jsonResponse'); // Debugging Step

      if (jsonResponse['status'] == true &&
          jsonResponse['appointments'] is List) {
        return List<Map<String, dynamic>>.from(jsonResponse['appointments']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'No Appointments found');
      }
    } catch (e) {
      print('Error: $e'); // Debugging Step
      throw Exception(
          'Failed to parse Appointment details. Response might be invalid JSON.');
    }
  }

  void rejectAppointment() async {
    String reason = rejectReasonController.text;
    String uid = uuid;

    var response = await api.post('delete_appointment.php', {
      'id': uid,
      'reason': reason,
    });
    try {
      var decodedData = response;

      if (decodedData['status'] == true) {
        toastMessage.show(decodedData['data']);
        if (mounted) {
          setState(() {
            appointments = getAppointments(widget.profId, widget.proftype);
          });
        }
      } else {
        toastMessage.show("Update failed: ${decodedData['message']}");
      }
    } catch (e) {
      toastMessage.show("Error: $e");
    }
  }

  void completeAppointment() async {
    String uid = uuid;

    try {
      var response = await api
          .post('update_appointement_status.php', {'appointment_id': uid});

      var decodedData = response;

      if (decodedData['status'] == true) {
        toastMessage.show(decodedData['message']);
        if (mounted) {
          setState(() {
            appointments = getAppointments(widget.profId, widget.proftype);
          });
        }
        goto.openProviderHome();
      } else {
        toastMessage.show("Update failed: ${decodedData['message']}");
      }
    } catch (e) {
      toastMessage.show("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Appointment Requestt',
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(46, 68, 176, 1),
          ),
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
                                                  text:
                                                      '${appointment['user_name']} ',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Confirm Your Actions'),
                                              content: Text(
                                                'Are you sure you want to ${appointment['status'] == 'confirmed' ? 'Complete' : 'Confirm'} this appointment ?',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    uuid = appointment[
                                                            'appointment_id']
                                                        .toString();
                                                    appointmentStatus =
                                                        appointment['status'];
                                                    completeAppointment();
                                                  },
                                                  child: Text('Submit'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            color:
                                                Color.fromRGBO(46, 68, 176, 1),
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Circular border radius
                                        ),
                                      ),
                                      child: Text(
                                          appointment['status'] == 'confirmed'
                                              ? 'Complete Appointment'
                                              : 'Confirm Appointment'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        uuid = appointment['appointment_id']
                                            .toString();
                                        // Show a dialog to ask for the reason
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Reason for Rejection'),
                                              content: TextFormField(
                                                controller:
                                                    rejectReasonController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Reason for Rejection',
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    rejectAppointment();
                                                    rejectReasonController
                                                        .clear();
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text('Submit'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            color:
                                                Color.fromRGBO(46, 68, 176, 1),
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Reject'),
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
