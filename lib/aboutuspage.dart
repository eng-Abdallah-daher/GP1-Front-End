import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Strong color for contrast
        elevation: 6, // Stronger shadow for a more powerful appearance
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade200,
                  Colors.blueAccent.shade100,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'images/company_logo.png'), // Your logo or a representative image
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Space between heading and content
                  // Card with details
                  Card(
                    elevation: 6,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Who We Are',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'We are Abdallah Daher and Momen Ramadan, senior Computer Engineering students at An-Najah National University. As part of our graduation project, we are developing Car Mate, a smart solution aimed at enhancing the car service experience.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height:
                                  1.4, // Better line spacing for readability
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(color: Colors.deepPurple),
                          SizedBox(height: 20),
                          Text(
                            'Our Goal',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Our goal is to integrate innovative technology to provide users with easy access to nearby repair shops, gas stations, rental services, and more, all from a single app.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional content (optional)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality
                      },
                      icon: Icon(Icons.contact_mail, color: Colors.white),
                      label: Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        backgroundColor: Colors.deepPurple, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    home: AboutUsPage(),
  ));
}
