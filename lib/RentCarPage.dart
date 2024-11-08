import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

const Color backgroundColor = Color(0xFFE0F7FA); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color lightBlueColor = Color(0xFF80D8FF); 

class RentCarPage extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final double pricePerDay;

  RentCarPage({
    required this.name,
    required this.imageUrl,
    required this.pricePerDay,
    required this.id,
  });

  @override
  _RentCarPageState createState() => _RentCarPageState();
}

class _RentCarPageState extends State<RentCarPage> {
  int rentalDays = 1;
  String method = 'Delivery';
  String placeDetails = ''; 
  Position? currentPosition; 
  List<Map<String, dynamic>> nearbyPlaces = []; 
  DateTime selectedStartDate = DateTime.now(); 

  
  final List<Map<String, dynamic>> sampleNearbyPlaces = [
    {'name': 'Coffee Shop', 'lat': 55.2305, 'lng': 35.2201},
    {'name': 'Supermarket', 'lat': 55.2305, 'lng': 35.2190},
    {'name': 'Gas Station', 'lat': 55.2305, 'lng': 35.2185},
    {'name': 'Park', 'lat': 55.2305, 'lng': 35.2220},
    {'name': 'Library', 'lat': 55.2305, 'lng': 35.2215},
    {'name': 'Pharmacy', 'lat': 55.2305, 'lng': 35.2230},
    {'name': 'Restaurant', 'lat': 55.2305, 'lng': 35.2195},
    {'name': 'Shopping Mall', 'lat': 55.2305, 'lng': 35.2208},
    {'name': 'Gym', 'lat': 32.2305, 'lng': 35.2240},
    {'name': 'Community Center', 'lat': 55.2305, 'lng': 35.2207},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); 
    nearbyPlaces = sampleNearbyPlaces; 
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
      _showPlaceDetails(LatLng(position.latitude, position.longitude));
    } catch (e) {
      print('Error getting location: $e');
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

  LatLng _findNearestPickupLocation() {
    if (currentPosition == null) return LatLng(0, 0);

    LatLng nearestLocation = LatLng(0, 0);
    double nearestDistance = double.infinity;

    for (var place in nearbyPlaces) {
      LatLng placeLocation = LatLng(place['lat'], place['lng']);
      double distance = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          placeLocation.latitude,
          placeLocation.longitude);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestLocation = placeLocation;
        placeDetails = place[
            'name']; 
      }
    }

    return nearestLocation;
  }

  double _calculateTotalPrice() {
    return widget.pricePerDay * rentalDays;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked; 
      });
  }
String formatDate(DateTime? date) {
    
    if (date == null) {
      return ''; 
    }

    
    int year = date.year;
    int month = date.month;
    int day = date.day;

    
    String formattedMonth = month.toString().padLeft(2, '0');
    String formattedDay = day.toString().padLeft(2, '0');

    
    return '$year-$formattedMonth-$formattedDay';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Car'),
        backgroundColor: deepBlueColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightBlueColor, whiteColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Image.network(widget.imageUrl),
              SizedBox(height: 10),
              Text(widget.name,
                  style: TextStyle(color: deepBlueColor, fontSize: 24)),
              Text('Price per day: \$${widget.pricePerDay}',
                  style: TextStyle(color: deepBlueColor)),
              Text('Delivery Location: $placeDetails',
                  style: TextStyle(color: deepBlueColor)),
              SizedBox(height: 20),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Date: ${selectedStartDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(color: deepBlueColor),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlueColor,
                    ),
                    child: Text('Select Date',
                        style: TextStyle(color: deepBlueColor)),
                  ),
                ],
              ),

              SizedBox(height: 20),

              
              Row(
                children: [
                  Text('Rental Days:', style: TextStyle(color: deepBlueColor)),
                  IconButton(
                    icon: Icon(Icons.remove, color: lightBlueColor),
                    onPressed: () {
                      if (rentalDays > 1) {
                        setState(() {
                          rentalDays--;
                        });
                      }
                    },
                  ),
                  Text('$rentalDays', style: TextStyle(color: deepBlueColor)),
                  IconButton(
                    icon: Icon(Icons.add, color: lightBlueColor),
                    onPressed: () {
                      setState(() {
                        rentalDays++;
                      });
                    },
                  ),
                ],
              ),

              
              Text('Method of Getting the Car:',
                  style: TextStyle(color: deepBlueColor)),
              DropdownButton<String>(
                value: method,
                dropdownColor: deepBlueColor,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: whiteColor,
                ),
                items: ['Delivery', 'Pickup', 'Get from Company']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    method = value ?? 'Delivery';
                    if (method == 'Pickup') {
                      LatLng nearestLocation = _findNearestPickupLocation();
                      placeDetails =
                          'Nearest Location: $placeDetails'; 
                    } else if (method == 'Delivery' &&
                        currentPosition != null) {
                      _showPlaceDetails(LatLng(currentPosition!.latitude,
                          currentPosition!.longitude));
                    } else if (method == 'Get from Company') {
                      placeDetails = 'An-Najah'; 
                    }
                  });
                },
              ),
              SizedBox(height: 20),

              
              Text(
                  'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(color: deepBlueColor, fontSize: 18)),
              SizedBox(height: 20),

              
              ElevatedButton(
              onPressed: () async{
           

                   Map<String, dynamic> profile = await getProfile();
                 
                   
if(method=='Delivery'){
  createRental(carId: widget.id, renterId: userid, startDate: formatDate(selectedStartDate), rentalDuration:rentalDays , rentalMethod: "delivery");
}else if(method=='Pickup'){
                    createRental(
                        carId: widget.id,
                        renterId: userid,
                        startDate: formatDate(selectedStartDate),
                        rentalDuration: rentalDays,
                        rentalMethod: "pickup");
}else{
                    createRental(
                        carId: widget.id,
                        renterId: userid,
                        startDate: formatDate(selectedStartDate),
                        rentalDuration: rentalDays,
                        rentalMethod: "FromCompany");
}

               
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: lightBlueColor,
                ),
                child: Text('Rent Now', style: TextStyle(color: deepBlueColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
