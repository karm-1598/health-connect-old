import 'package:flutter/material.dart';
import 'package:health_connect2/lab+individual_profile.dart';
import 'package:health_connect2/lab_book_appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LabList extends StatefulWidget {
  const LabList({super.key});

  @override
  State<LabList> createState() => _LabListState();
}

class _LabListState extends State<LabList> {
  late Future<List<Map<String, dynamic>>> labs;
  final searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    labs = fetchLabs();
    searchController.addListener(_searchChanged);
  }

  Future<List<Map<String, dynamic>>> fetchLabs() async {
    const url = 'http://192.168.60.215/api/lab_data.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception('Failed to load labs');
      }
    } catch (e) {
      throw Exception('Failed to load labs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchLabs(String searchValue) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.60.215/api/lab_search.php?search=$searchValue'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to search labs');
      }
    } catch (e) {
      throw Exception('Failed to search labs: $e');
    }
  }

  void _searchChanged() {
    String searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        labs = _searchLabs(searchText);
      });
    } else {
      setState(() {
        labs = fetchLabs();
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
          : Text('Find Your Labs',style: TextStyle(color: Colors.white),),
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
              future: labs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No labs found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final lab = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          color: const Color.fromRGBO(212, 240, 232, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${lab['lab_name']} Laboratory',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: 'Charges: ', 
                                    children: [
                                      TextSpan(
                                        text: '${lab['pricing']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),

                                Text(
                                  'Type: ${lab['lab_type']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Operating Hours: ${lab['operating_hours']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Address: ${lab['lab_address']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder:(context) =>LabBookAppointment(labId:lab['id'])));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1), width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Book Appointment'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder:(context) =>LabIndividualProfile(labId:lab['id'])));
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
