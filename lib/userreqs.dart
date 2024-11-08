import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class RentrequestsPage extends StatefulWidget {
  @override
  _RentrequestsPageState createState() => _RentrequestsPageState();
}

class _RentrequestsPageState extends State<RentrequestsPage> {


  Future<void> _approachRequest(RentRequest2 request) async {
   
 final url = Uri.parse("http://localhost:4000/api/rentals/status");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'id': request.id,
       'status': 'approved',
      }),
    );

    if (response.statusCode == 200) {
    

    }
  } catch (error) {}
  }

  Future<void> _rejectRequest(RentRequest2 request) async {
  final url = Uri.parse("http://localhost:4000/api/rentals/status");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'id': request.id,
       'status': 'rejected',
      }),
    );

    if (response.statusCode == 200) {
    

    }
  } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent requests', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F3460), // Deep blue
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF1A1A2E), // Dark navy background
        child: ListView.builder(
          itemCount: requests2.length,
          itemBuilder: (context, index) {
            final request = requests2[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              color: Color(0xFF2A2A3D), // Dark grey for card background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: Color(0xFF0F3460), width: 1.5), // Deep blue border
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        request.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Car details and renter info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.carName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(
                                  0xFFE94560), // Bright coral for car name
                            ),
                          ),
                          Text(
                            request.carModel,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // White for car model
                            ),
                          ),
                          Text(
                            'Price: ${request.price}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Duration: ${request.duration}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Renter: ${request.renterName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Method: ${request.rentalMethod}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                    // Action buttons
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _approachRequest(request),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 71, 193, 19),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () => _rejectRequest(request),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Reject',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


