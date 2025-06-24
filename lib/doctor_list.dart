import 'package:flutter/material.dart';
import 'package:health_connect2/book_appointment.dart';
import 'package:health_connect2/doc_individual_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocList extends StatefulWidget {
  const DocList({super.key});

  @override
  State<DocList> createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  late Future<List<Map<String, dynamic>>> doctors;
  final searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    doctors = fetchDocs();
    searchController.addListener(_searchChanged);
  }

  Future<List<Map<String, dynamic>>> fetchDocs() async {
    const url = 'http://192.168.60.215/api/doc_data.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchDoctors(String searchValue) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.60.215/api/doc_search.php?search=$searchValue'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to search doctors');
      }
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  void _searchChanged() {
    String searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        doctors = _searchDoctors(searchText);
      });
    } else {
      setState(() {
        doctors = fetchDocs();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(46, 68, 176, 1),
        ),
      ),
      title: isSearching
          ? TextField(
              style: TextStyle(color: Colors.white),
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      isSearching = false; 
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ),
            )
          : Text('Find Your Doctors',style: TextStyle(color: Colors.white),),
      actions: [
        if (!isSearching) 
          IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
          ),
      ],
    ),
      body: Column(
        children: [
          
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: doctors,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No doctors found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final doctor = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Dr. ${doctor['name']} ${doctor['lastname']}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),

                                          Text(doctor['qualification']),

                                          const SizedBox(height: 4),

                                          Text('${doctor['experience']} years experience',),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                Text.rich(
                                  TextSpan(
                                    text: 'Charges: ', 
                                    children: [
                                      TextSpan(
                                        text: '${doctor['avg_consultation_fee']} INR',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),


                                Text('Available Time: ${doctor['availability_slot_time'] }'),

                                Text('From: ${doctor['availability_slot_days'] }'),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => BookAppointment(docId: doctor['id']))
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1), width: 1), 
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), // Circular border radius
                                        ),
                                      ),
                                      child: Text('Book Appointment'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => DocIndividualProfile(docId: doctor['id']))
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1), width: 1 ), 
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('View Profile'),
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
