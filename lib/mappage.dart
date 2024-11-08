import 'dart:convert';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

const Color backgroundColor = Colors.lightBlue; 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Colors.blue;
const Color brightCoralColor = Color(0xFFE94560); 

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MapController mapController = MapController();
  LatLng currentLocation = LatLng(32.2276, 35.2206);

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

  // Show dialog with place details and add to list
  void _showPlaceDialog(LatLng latLng) async {
    String placeDetails = await _getPlaceDetails(latLng);
showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: deepBlueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          title: Text('Place Details',
              style: TextStyle(color: whiteColor, fontSize: 24)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Latitude: ${latLng.latitude}',
                    style: TextStyle(color: whiteColor, fontSize: 18)),
                SizedBox(height: 8.0), // Adds some spacing
                Text('Longitude: ${latLng.longitude}',
                    style: TextStyle(color: whiteColor, fontSize: 18)),
                SizedBox(height: 8.0), // Adds some spacing
                Text('Details: $placeDetails',
                    style: TextStyle(color: whiteColor, fontSize: 18)),
                SizedBox(height: 16.0), // Adds some spacing
                Text('Do you want to add this place to the list?',
                    style: TextStyle(color: brightCoralColor, fontSize: 16)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without action
              },
              style: TextButton.styleFrom(
                backgroundColor: whiteColor, // Set background color to white
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // Padding for buttons
              ),
              child: Text('Cancel',
                  style: TextStyle(
                      color: deepBlueColor,
                      fontSize: 16)), // Change text color to deep blue
            ),
            SizedBox(width: 8.0), // Space between buttons
            TextButton(
              onPressed: () {
                setState(() {


                  tappedLocations.add(latLng);
                 createLocation(latLng.latitude, latLng.longitude);




                });
                Navigator.pop(context); // Close dialog
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    brightCoralColor, // Set background color to bright coral
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // Padding for buttons
              ),
              child: Text('Confirm',
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 16)), // Keep text color white
            ),
          ],
        );
      },
    );

  }


  // Function to search for places and return suggestions
  Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=3'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Map with Search', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentLocation,
              zoom: 15.0,
              onTap: (tapPosition, latLng) {
                _showPlaceDialog(latLng); // Show dialog when place is tapped
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLocation,
                    builder: (context) => Icon(Icons.location_on,
                        color: brightCoralColor, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TypeAheadField<Map<String, dynamic>>(
              textFieldConfiguration: TextFieldConfiguration(
                style: TextStyle(color: whiteColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: deepBlueColor,
                  hintText: 'Search for a place...',
                  hintStyle: TextStyle(color: whiteColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              suggestionsCallback: (query) async {
                return await _getPlaceSuggestions(query);
              },
              itemBuilder: (context, Map<String, dynamic> suggestion) {
                return ListTile(
                  title: Text(
                    suggestion['display_name'] ?? 'Unknown',
                    style: TextStyle(color: whiteColor),
                  ),
                  tileColor: deepBlueColor,
                );
              },
              onSuggestionSelected: (Map<String, dynamic> suggestion) {
                double lat = double.parse(suggestion['lat']);
                double lon = double.parse(suggestion['lon']);
                LatLng selectedLocation = LatLng(lat, lon);
                mapController.move(selectedLocation, 15.0);
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    mapController.move(
                        mapController.center, mapController.zoom + 1);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: brightCoralColor,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    mapController.move(
                        mapController.center, mapController.zoom - 1);
                  },
                  child: Icon(Icons.remove),
                  backgroundColor: brightCoralColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapPage(),
  ));
}
