import 'package:first/ComplaintsManagementPage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class ViewWorkshopRatingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workshop Ratings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: blueAccent,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            if (users[index].role == "owner") {
              return _buildWorkshopRatingCard(context, users[index]);
            } else {
              return SizedBox(height: 0);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWorkshopRatingCard(BuildContext context, User rating) {
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
              white,
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
                      rating.getaveragerate().toString(),
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
                  rating.description!,
                  style: TextStyle(
                    fontSize: 16,
                    color: black,
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

  void _onArrowTap(BuildContext context, User rating) {
    if (global_user.israted(rating.id)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.blue.shade50,
            title: Text(
              "Already Rated",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            content: Text(
              "You have already rated this workshop.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintsManagementPage(
            ownerid: rating.id,
          ),
        ),
      );
    }
  }
}
