import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 

class MakeReview extends StatefulWidget {
  @override
  _MakeReviewState createState() => _MakeReviewState();
}

class _MakeReviewState extends State<MakeReview> {
  int _rating = 0; 
  final TextEditingController _reviewController =
      TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Make a Review', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: brightCoralColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1; 
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              'Your Review',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: whiteColor),
            ),
            SizedBox(height: 10),
            
            Card(
              elevation: 5,
              color: deepBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _reviewController, 
                style: TextStyle(color: whiteColor),
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: deepBlueColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.all(16), 
                ),
              ),
            ),
            SizedBox(height: 20),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
               
  submitReview(_reviewController.text, _rating);



                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightCoralColor,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  


Future<void> submitReview(String comment, int rating) async {
  const String url = 'http://localhost:4000/api/rentals/reviews';
  
  

  
  try {
    
    if (rating < 1 || rating > 5) {
      print('Rating must be between 1 and 5.');
      return;
    }
    
    
    final Map<String, dynamic> requestBody = {
      'rating': rating,
      'comment': comment,
    };
    
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode(requestBody),
    );

    
    if (response.statusCode == 201) {
      print('Review submitted successfully');
      print('Review ID: ${jsonDecode(response.body)['review_id']}');
    } else if (response.statusCode == 403) {
      print('You are not authorized to submit a review.');
    } else {
      print('Failed to submit review: ${jsonDecode(response.body)['message']}');
    }
  } catch (error) {
    print('Error submitting review: $error');
  }
}

}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: MakeReview(),
  ));
}
