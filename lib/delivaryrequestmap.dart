import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Delivaryrequestmap extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<Delivaryrequestmap> {
  LatLng? _selectedLocation;
  LatLng? currentLocation;
  final MapController _mapController = MapController();
  List<Marker> markers = [];
  double currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLocation!, currentZoom);
      markers.add(
        Marker(
          point: currentLocation!,
          builder: (ctx) => Icon(
            Icons.my_location,
            color: blue,
            size: 40,
          ),
        ),
      );
    });
  }

  Future<List<String>> _searchPlaces(String query) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<String>.from(data.map((item) => item['display_name']));
    }
    return [];
  }

  Widget _buildSearchBar() {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        style: TextStyle(fontSize: 16.0, color: white),
        decoration: InputDecoration(
          hintText: 'Search Places',
          hintStyle: TextStyle(color: white),
          filled: true,
          fillColor: Colors.blue[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: white),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 8.0,
        color: Colors.blue[800],
      ),
      suggestionsCallback: (pattern) async {
        return await _searchPlaces(pattern);
      },
      itemBuilder: (context, suggestion) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blue[700],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              suggestion,
              style: TextStyle(color: white, fontSize: 14.0),
            ),
          ),
        );
      },
      onSuggestionSelected: (suggestion) async {
        final response = await http.get(Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=$suggestion&format=json&addressdetails=1'));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)[0];
          final lat = double.parse(data['lat']);
          final lon = double.parse(data['lon']);
          _mapController.move(LatLng(lat, lon), currentZoom);
          setState(() {
            _selectedLocation = LatLng(lat, lon);
            markers.add(
              Marker(
                point: _selectedLocation!,
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: currentLocation ?? LatLng(51.505, -0.09),
          zoom: currentZoom,
          onTap: (tapPosition, point) async {
            setState(() {
              _selectedLocation = point;
           if(markers.length==1){
               markers.add(
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: point,
                    builder: (ctx) => Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                );
           }else{
               markers[1]=  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: point,
                    builder: (ctx) => Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  );
           }
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: markers),
        ],
      ),
  floatingActionButton: _selectedLocation != null
          ? FloatingActionButton.extended(
              onPressed: () async {
                final placeDetails = await _getPlaceDetails(_selectedLocation!);
                Navigator.pop(context, placeDetails);
              },
              label: Text(
                'Confirm Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              icon: Icon(
                Icons.check_circle,
                size: 28,
              ),
              backgroundColor: Colors.blue[900],
              foregroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          : null,

    );
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
}
