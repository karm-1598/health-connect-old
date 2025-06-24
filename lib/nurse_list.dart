import 'package:flutter/material.dart';
import 'package:health_connect2/nurse_book_appointment.dart';
import 'package:health_connect2/nurse_individual_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurseList extends StatefulWidget {
  const NurseList({super.key});

  @override
  State<NurseList> createState() => _NurseListState();
}

class _NurseListState extends State<NurseList> {
  late Future<List<Map<String, dynamic>>> nurses;
  final searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    nurses = fetchNurses();
    searchController.addListener(_searchChanged);
  }

  Future<List<Map<String, dynamic>>> fetchNurses() async {
    const url = 'http://192.168.60.215/api/nurse_data.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception('Failed to load nurses');
      }
    } catch (e) {
      throw Exception('Failed to load nurses: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchNurses(String searchValue) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.60.215/api/nurse_search.php?search=$searchValue'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to search nurses');
      }
    } catch (e) {
      throw Exception('Failed to search nurses: $e');
    }
  }

  void _searchChanged() {
    String searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        nurses = _searchNurses(searchText);
      });
    } else {
      setState(() {
        nurses = fetchNurses();
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
          : Text('Find Your Nurse',style: TextStyle(color: Colors.white),),
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
              future: nurses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No nurses found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final nurse = snapshot.data![index];
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
                                          Text('${nurse['name']} ${nurse['lastname']}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(nurse['qualification']),
                                          const SizedBox(height: 4),
                                          Text('${nurse['experience']} years experience',),
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
                                        text: '${nurse['consultation_fee']} INR',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                Text('Shift Time: ${nurse['shift_time']}'),

                                Text('From: ${nurse['shift_days']}'),

                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => NurseBookAppointment(nurseId: nurse['id']))
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1), width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Book Appointment'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => NurseIndividualProfile(nurseId: nurse['id']))
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color.fromRGBO(46, 68, 176, 1), width: 1),
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
