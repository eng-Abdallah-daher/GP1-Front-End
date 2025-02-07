import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: blueAccent,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Privacy Policy",
                      style:  TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Last updated: January 26, 2025",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildSection("1. Introduction",
                  "Welcome to CarMate! We are committed to protecting your privacy and ensuring your personal information is secure."),
              buildSection("2. Data Collection",
                  "We collect data to improve your experience, including your name, email, location, and payment information."),
              buildSection("3. Data Usage",
                  "Your data is used for account creation, booking requests, and enhancing services like finding nearby workshops or gas stations."),
              buildSection("4. Data Sharing",
                  "We do not share your personal information with third parties, except when required by law or with your explicit consent."),
              buildSection("5. Security",
                  "We implement advanced security measures to ensure your data is protected from unauthorized access."),
              buildSection("6. User Rights",
                  "You have the right to update, delete, or request access to your personal information at any time."),
            
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PrivacyPolicyPage(),
  ));
}
