import 'package:flutter/material.dart';

void main() {
  runApp(const AboutUsPage());
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(46, 68, 176, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 40),
            _buildDedicationSection(),
            const SizedBox(height: 30),
            _buildMentorSection(),
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMemberCard(
              name: 'Karm Patel',
              email: 'karmp8690@gmail.com',
              enrollment: '22BEIT30110',
              college: 'LDRP Institute of Information and Technology',
            ),
            const SizedBox(height: 20),
            _buildMemberCard(
              name: 'Jay Patel',
              email: 'jayypatel444@gmail.com',
              enrollment: '22BEIT30108',
              college: 'LDRP Institute of Information and Technology',
            ),
            const SizedBox(height: 20),
            _buildMemberCard(
              name: 'Prachi Patel',
              email: 'patelprachi9163@gmail.com',
              enrollment: '22BEIT54007',
              college: 'LDRP Institute of Information and Technology',
            ),
            const SizedBox(height: 20),
            _buildMemberCard(
              name: 'Foram Patel',
              email: 'patelforam@gmail.com',
              enrollment: '22BEIT54005',
              college: 'LDRP Institute of Information and Technology',
            ),
          ],
        ),
      ),
    );
  }

  // Hero Section with impactful message and visual design
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(46, 68, 176, 1), Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'HealthConnect Project',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We are committed to revolutionizing healthcare access and improving patient care through innovative solutions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Dedication Section
  Widget _buildDedicationSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Color.fromRGBO(46, 68, 176, 1),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our Dedication to HealthConnect',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our team has worked relentlessly to ensure the HealthConnect project serves as a cutting-edge solution for healthcare professionals and patients alike. Through innovative technology and a commitment to making healthcare more accessible, we aim to improve lives across the world.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Mentor Section
  Widget _buildMentorSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Color.fromRGBO(46, 68, 176, 1),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mentor: Akash Brahbhatt',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We owe a great deal of gratitude to our mentor, Akash Brahbhatt, for his unwavering support and guidance throughout the development of the HealthConnect project. His expertise and encouragement have played an integral role in shaping our vision and ensuring the success of this initiative.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Member Info Section (for each team member)
  Widget _buildMemberCard({
    required String name,
    required String email,
    required String enrollment,
    required String college,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMemberInfo(name, email, enrollment, college),
            const SizedBox(height: 15),
            Divider(thickness: 1.5, color: Color.fromRGBO(46, 68, 176, 1)),
            const SizedBox(height: 15),
            _buildContactInfo(email),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberInfo(
    String name,
    String email,
    String enrollment,
    String college,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(46, 68, 176, 1),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Enrollment No: $enrollment',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        Text(
          'College: $college',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildContactInfo(String email) {
    return Text(
      'Contact: $email',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return Center(
      child: Text(
        'Meet Our Team',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(46, 68, 176, 1),
        ),
      ),
    );
  }
}
