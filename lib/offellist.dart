import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class OffersListPage extends StatelessWidget {
  OffersListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offers List',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black54,
      ),
      body: offers.isEmpty
          ? Center(
              child: Text(
                'No Offers Available',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlueAccent
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        '${offers[index].title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white, // Text color for better contrast
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discount: ${offers[index].discount}% off',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Description: ${offers[index].description}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white), // Adjusted text color
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Valid Until: ${offers[index].validUntil.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white), // Adjusted text color
                          ),
                          Text(
                            'Posted By: ${getnameofuser(offers[index].posterid)}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[300]), // Adjusted text color
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.white, // Adjusted icon color
                      ),
                      onTap: () {
                        // Navigate to offer details page (add functionality here)
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
