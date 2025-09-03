import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
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
  try {
    var api = baseApi();
    var response = await api.post('doc_get_review.php', {'docId': docId});

    print("Raw response: $response"); // Debugging

    // Ensure the response is parsed into a Map
    final jsonResponse = jsonDecode(response);

    if (jsonResponse is Map && jsonResponse.containsKey('reviews')) {
      List<dynamic> reviews = jsonResponse['reviews'];

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
  try {
    var api = baseApi();
    
    print('Sending review request...');
    print('docId: ${widget.docId}');
    print('name: $name');
    print('review_text: ${reviewController.text}');
    
    var addReview = await api.post('doc_add_review.php', {
      'docId': widget.docId,
      'name': name,
      'review_text': reviewController.text,
    });

    print('Raw API response: $addReview');
    print('Response type: ${addReview.runtimeType}');

    // Handle different response types
    Map<String, dynamic>? responseData;
    
    if (addReview is Map<String, dynamic>) {
      responseData = addReview;
    } else if (addReview is String) {
      try {
        responseData = jsonDecode(addReview);
      } catch (e) {
        print('Failed to parse JSON response: $e');
        print('Response content: $addReview');
        _showErrorDialog('Server returned invalid response format');
        return;
      }
    } else {
      print('Unexpected response type: ${addReview.runtimeType}');
      _showErrorDialog('Unexpected response format from server');
      return;
    }

    print('Parsed response: $responseData');

    // Check if response has status field
    if (responseData != null && responseData.containsKey('status')) {
      if (responseData['status'] == true) {
        // Success case
        print('Review added successfully');

        // Clear the text field and hide it
        reviewController.clear();
        setState(() {
          _isTextFieldVisible = false;
        });

        // Refresh the reviews list
        setState(() {
          reviews = fetchReview(widget.docId);
        });
      } else {
        // Server returned status: false
        print('Server error: ${responseData['message']}');
        _showErrorDialog(responseData['message'] ?? 'Failed to add review');
      }
    } else {
      // Response doesn't have status field (legacy format)
      print('Response missing status field, checking for message...');
      
      if (responseData != null && responseData.containsKey('message')) {
        if (responseData['message'] == 'Review added successfully') {
          // Success case for legacy format
          print('Review added successfully (legacy format)');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          reviewController.clear();
          setState(() {
            _isTextFieldVisible = false;
          });

          setState(() {
            reviews = fetchReview(widget.docId);
          });
        } else {
          // Error case for legacy format
          print('Error: ${responseData['message']}');
          _showErrorDialog(responseData['message']);
        }
      } else {
        _showErrorDialog('Invalid response format from server');
      }
    }

  } catch (e) {
    print('Exception in reviewAdd: $e');
    print('Exception type: ${e.runtimeType}');
    _showErrorDialog('Network error: ${e.toString()}');
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
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
