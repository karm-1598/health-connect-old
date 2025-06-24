import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhysioIndividualProfile extends StatefulWidget {
  final String physiotherapistId;
  const PhysioIndividualProfile({super.key, required this.physiotherapistId});

  @override
  State<PhysioIndividualProfile> createState() => _PhysioIndividualProfileState();
}

class _PhysioIndividualProfileState extends State<PhysioIndividualProfile> {
  late Future<Map<String, dynamic>> physiotherapist;
  late Future<List<Map<String, dynamic>>> reviews;
  TextEditingController reviewController = TextEditingController();
  bool _isTextFieldVisible = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    physiotherapist = fetchPhysiotherapist(widget.physiotherapistId);
    reviews = fetchReview(widget.physiotherapistId); // Fetch reviews for this physiotherapist
    getUserName();
  }

  void getUserName() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
    });
  }

  // Function to fetch physiotherapist details
  Future<Map<String, dynamic>> fetchPhysiotherapist(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.255.215/api/physio_single_data.php'),
      body: jsonEncode({'sid': id}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.isNotEmpty) {
          return jsonResponse[0];
        } else {
          throw Exception('No physiotherapist found with this ID');
        }
      } catch (e) {
        throw Exception('Failed to parse physiotherapist details. Response might be invalid JSON.');
      }
    } else {
      throw Exception('Failed to load physiotherapist details');
    }
  }

  // Function to fetch reviews for the specific physiotherapist
  Future<List<Map<String, dynamic>>> fetchReview(String physiotherapistId) async {
    final url = 'http://192.168.255.215/api/physio_get_review.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'physiotherapist_id': physiotherapistId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey('reviews')) {
          List<dynamic> reviews = jsonResponse['reviews']; // This is a list of reviews

          if (reviews.isEmpty) {
            return [];
          }

          return List<Map<String, dynamic>>.from(reviews);
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  // Function to add a review and refresh the reviews list
  void reviewAdd() async {
    var url = Uri.parse('http://192.168.255.215/api/physio_add_review.php');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'physiotherapist_id': widget.physiotherapistId,
        'reviewer_name': name,
        'review_text': reviewController.text,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      try {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['message'] == 'Review added successfully') {
          reviewController.clear();
          setState(() {
            _isTextFieldVisible = false;
          });

          // After review is added, refresh the reviews list
          setState(() {
            reviews = fetchReview(widget.physiotherapistId); // Reload reviews from the server
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: physiotherapist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No physiotherapist found'));
          } else {
            final physiotherapist = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xFFE8F5E9),
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
                                        'Dr. ${physiotherapist['name']} ${physiotherapist['lastname']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        physiotherapist['qualification'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${physiotherapist['experience']} years experience',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Available Time: ${physiotherapist['availability_slot_time']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'From: ${physiotherapist['availability_slot_days']}',
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
                          return const Center(child: CircularProgressIndicator());
                        } else if (reviewSnapshot.hasError) {
                          return Center(child: Text('Error: ${reviewSnapshot.error}'));
                        } else if (!reviewSnapshot.hasData || reviewSnapshot.data!.isEmpty) {
                          return const Center(child: Text('No reviews available'));
                        } else {
                          final reviews = reviewSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reviews:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    color: const Color(0xFFE8F5E9),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reviews[index]['reviewer_name'],
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
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
                          const Text(
                            "Leave a Review:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            controller: reviewController,
                            decoration: const InputDecoration(
                              labelText: 'Write your review here...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (reviewController.text.isNotEmpty) {
                                reviewAdd();
                              }
                            },
                            child: const Text('Submit Review'),
                          ),
                        ],
                      ),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isTextFieldVisible = !_isTextFieldVisible;
                        });
                      },
                      backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
