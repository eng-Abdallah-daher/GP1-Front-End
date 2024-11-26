import 'package:flutter/material.dart';

class WorkshopRating {
  final String name;
  final double rating;
  final String review;

  WorkshopRating({
    required this.name,
    required this.rating,
    required this.review,
  });
}

class ViewWorkshopRatingsPage extends StatelessWidget {
  final List<WorkshopRating> workshopRatings = [
    WorkshopRating(
      name: "ABC Auto Repair",
      rating: 4.5,
      review: "Great service and friendly staff!",
    ),
    WorkshopRating(
      name: "QuickFix Garage",
      rating: 4.0,
      review: "Very professional and efficient.",
    ),
    WorkshopRating(
      name: "Best Mechanics",
      rating: 5.0,
      review: "Excellent experience, highly recommended!",
    ),
    WorkshopRating(
      name: "City Garage",
      rating: 3.5,
      review: "Decent work, but could improve communication.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workshop Ratings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: workshopRatings.length,
          itemBuilder: (context, index) {
            return _buildWorkshopRatingCard(context, workshopRatings[index]);
          },
        ),
      ),
    );
  }

  Widget _buildWorkshopRatingCard(BuildContext context, WorkshopRating rating) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            _onArrowTap(context, rating);
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              rating.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.rating.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  rating.review,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue.shade600,
            ),
          ),
        ),
      ),
    );
  }

void _onArrowTap(BuildContext context, WorkshopRating rating) {
    // Show a dialog with enhanced design
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blue.shade50,
          title: Text(
            "${rating.name} - Details",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Rating: ${rating.rating}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Review:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  rating.review,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade800, // Background color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
