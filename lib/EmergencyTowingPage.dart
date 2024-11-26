import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class EmergencyTowingPage extends StatefulWidget {
  @override
  _EmergencyTowingPageState createState() => _EmergencyTowingPageState();
}

class _EmergencyTowingPageState extends State<EmergencyTowingPage> {
  String placeDetails = 'Fetching your location...';
   List<Map<String, dynamic>> _towingServices = [
    {
      'name': 'Towing Service A',
      'phone': '1-800-555-0100',
      'address': '456 Elm St, San Francisco, CA',
    },
    {
      'name': 'Towing Service B',
      'phone': '1-800-555-0200',
      'address': '789 Oak St, San Francisco, CA',
    },
    {
      'name': 'Towing Service C',
      'phone': '1-800-555-0300',
      'address': '101 Pine St, San Francisco, CA',
    },
  ];

  final String googleApiKey =
      'YOUR_GOOGLE_API_KEY'; // Add your Google API Key here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Towing'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlueAccent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Emergency Towing?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you find yourself in a breakdown situation, we are here to help. Tap the button below to request immediate towing assistance.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _requestTowing,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blueAccent,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                    elevation: 4,
                  ),
                  child: Text(
                    'Request Towing',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Current Location:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                placeDetails,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Nearby Towing Services:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
             ..._towingServices.map((service) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      service['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(
                      service['address'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        callNumber(service['phone']);
                      },
                      child: Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _requestTowing() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _showPlaceDetails(latLng);
      await _fetchNearbyTowingServices(
          latLng); // Fetch the nearest towing services

      // Assuming the first service is the nearest one for demo purposes
      final nearestService = _towingServices.isNotEmpty
          ? _towingServices[0]
          : {'name': "alms", 'address': "nablus", "phone": "059"};

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                'Confirm Towing Request',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            content: nearestService != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              placeDetails,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nearest Towing Service:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              nearestService['name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Address: ${nearestService['address']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Phone: ${nearestService['phone']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'No towing services found nearby.',
                      style: TextStyle(fontSize: 14, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.lightBlueAccent
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '  Call  ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0, // No elevation to maintain a flat look
                        backgroundColor: Colors
                            .transparent, // Make butaton background transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Match the container's radius
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.lightBlueAccent
                        ], // Gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0, // No elevation to maintain a flat look
                        backgroundColor: Colors
                            .transparent, // Make button background transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Match the container's radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Could not retrieve your location. Please try again.')),
      );
    }
  }

  Future<String> _getPlaceDetails(LatLng latLng) async {
    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['display_name'] ?? 'Unknown Place';
      } else {
        return 'Failed to retrieve details';
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return 'Error fetching place details';
    }
  }

  void _showPlaceDetails(LatLng latLng) async {
    String details = await _getPlaceDetails(latLng);
    setState(() {
      placeDetails = details;
    });
  }

  Future<void> _fetchNearbyTowingServices(LatLng latLng) async {
    try {
      // Use Google Places API to get nearby towing services
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latLng.latitude},${latLng.longitude}&radius=50000&type=towing&key=$googleApiKey'));

      if (response.statusCode == 200) {
        final List<dynamic> services = jsonDecode(response.body)['results'];
        setState(() {
          _towingServices = services.map((service) {
            return {
              'name': service['name'],
              'address': service['vicinity'],
              'phone': service['formatted_phone_number'] ??
                  'N/A', // Phone numbers might need another API
            };
          }).toList();
        });
      } else {
        print('Failed to fetch towing services: ${response.body}');
      }
    } catch (e) {
      print('Error fetching towing services: $e');
    }
  }

  Future<void> callNumber(String phoneNumber) async {
    String url = 'tel:$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch call')),
      );
    }
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
