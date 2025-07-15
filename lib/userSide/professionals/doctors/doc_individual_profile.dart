import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocIndividualProfile extends StatefulWidget {
  final String docId;
  const DocIndividualProfile({super.key, required this.docId});

  @override
  State<DocIndividualProfile> createState() => _DocIndividualProfileState();
}

class _DocIndividualProfileState extends State<DocIndividualProfile> {
  late Future<Map<String, dynamic>> doctors;
  late Future<List<Map<String, dynamic>>> reviews;
  TextEditingController reviewController = TextEditingController();
  bool _isTextFieldVisible = false;  
  String name='';

  @override
  void initState() {
    super.initState();
    doctors = fetchDoctors(widget.docId);
    reviews = fetchReview(widget.docId); // Pass docId to fetch reviews for this doctor
    get();
  }

  void get() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  // Function to fetch doctor details
  Future<Map<String, dynamic>> fetchDoctors(String id) async {
    
    var api=baseApi();
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

  // Function to fetch reviews for the specific doctor
  Future<List<Map<String, dynamic>>> fetchReview(String docId) async {
    // final url = 'http://192.168.60.215/api/doc_get_review.php'; 
    try {
    var api=baseApi();
    var response= await api.post('doc_get_review.php', {'docId':docId});

      
        final jsonResponse = response;

        if (jsonResponse is Map && jsonResponse.containsKey('reviews')) {
          List<dynamic> reviews = jsonResponse['reviews']; // This is a list of reviews

          if (reviews.isEmpty) {
            return [];
          }

          return List<Map<String, dynamic>>.from(reviews);
        } else {
          return [];
        }
      
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  // Function to add a review and refresh the reviews list
  void reviewAdd() async {
    
    var api=baseApi();
    var addReview= await api.post('doc_add_review.php', {
        'docId': widget.docId,
        'name': name,
        'review_text': reviewController.text,
      });
     

    if (addReview['status']==true) {
      try {
        var jsonResponse = addReview;
        if (jsonResponse['message'] == 'Review added successfully') {
          reviewController.clear();
          setState(() {
            _isTextFieldVisible = false;
          });

          // After review is added, refresh the reviews list
          setState(() {
            reviews = fetchReview(widget.docId); // Reload reviews from the server
          });
        } else {
          print('Error: ${jsonResponse['message']}');
        }
      } catch (e) {
        print('Error parsing JSON response: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to parse the server response. It may be an HTML page or invalid JSON.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      print('Failed to submit review');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to submit review. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                goto.gobackHome();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
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
                                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${doctors['experience']} years experience',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Available Time: ${doctors['availability_slot_time']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'From: ${doctors['availability_slot_days']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      FutureBuilder<List<Map<String, dynamic>>>( 
                        future: reviews,
                        builder: (context, reviewSnapshot) {
                          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (reviewSnapshot.hasError) {
                            return Center(child: Text('Error: ${reviewSnapshot.error}'));
                          } else if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
                            return Center(child: Text('No reviews available'));
                          } else {
                            final reviews = reviewSnapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reviews:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: reviews.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      color: Theme.of(context).colorScheme.surfaceContainer,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(reviews[index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 4),
                                            Text(reviews[index]['review_text']),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      if (_isTextFieldVisible)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Leave a Review:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: reviewController,
                              decoration: InputDecoration(
                                labelText: 'Write your review here...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (reviewController.text.isNotEmpty) {
                                  reviewAdd();
                                }
                              },
                              child: Text('Submit Review'),
                            ),
                          ],
                        ),
                        FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isTextFieldVisible = !_isTextFieldVisible;  
                        });
                      },
                      backgroundColor: Color.fromRGBO(46, 68, 176, 1),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  

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
