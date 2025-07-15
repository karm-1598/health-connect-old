import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';

class PhysioList extends StatefulWidget {
  const PhysioList({super.key});

  @override
  State<PhysioList> createState() => _PhysioListState();
}

class _PhysioListState extends State<PhysioList> {
  late Future<List<Map<String, dynamic>>> physiotherapists;
  final searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    physiotherapists = fetchPhysios();
    searchController.addListener(_searchChanged);
  }
  var api=baseApi();
  Future<List<Map<String, dynamic>>> fetchPhysios() async {
     var response = await api.get('physio_data.php');
    try {
        List jsonResponse = response;
        return List<Map<String, dynamic>>.from(jsonResponse);
      
    } catch (e) {
      throw Exception('Failed to load physiotherapists: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchPhysios(String searchValue) async {
    try {
      var response= await api.get('physio_search.php',queryParams: {'search':searchValue});
      
        List data = response;
        return data.cast<Map<String, dynamic>>();
      
    } catch (e) {
      throw Exception('Failed to search physiotherapists with this name');
    }
  }

  void _searchChanged() {
    String searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        physiotherapists = _searchPhysios(searchText);
      });
    } else {
      setState(() {
        physiotherapists = fetchPhysios();
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
      
      title: isSearching
          ? TextField(
              style: Theme.of(context).textTheme.bodyMedium,
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
          : Text('Find Your Physioterapist',style: TextStyle(color: Colors.white),),
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
              future: physiotherapists,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No physiotherapists found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final physiotherapist = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Dr. ${physiotherapist['name']} ${physiotherapist['lastname']}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),

                                          Text(physiotherapist['qualification']),

                                          const SizedBox(height: 4),

                                          Text('${physiotherapist['experience']} years experience',),
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
                                        text: '${physiotherapist['avg_consultation_fee']} INR',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),

                                Text('Available Time: ${physiotherapist['availability_slot_time'] }'),

                                Text('From: ${physiotherapist['availability_slot_days'] }'),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        goto.openPhysioBookAppointment(id: physiotherapist['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('Book Appointment'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        goto.openPhysioIndividualProfile(id: physiotherapist['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1 ),
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
