import 'package:flutter/material.dart';
import 'package:first/glopalvars.dart';
const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 

class GetReviews extends StatelessWidget {
  


  
  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(Icon(Icons.star, color: brightCoralColor));
      } else {
        stars.add(Icon(Icons.star_border, color: whiteColor));
      }
    }
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('All Reviews', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Card(
            color: deepBlueColor,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  Text(
                    reviews[index],
                    style: TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  SizedBox(height: 8),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: GetReviews(),
  ));
}
