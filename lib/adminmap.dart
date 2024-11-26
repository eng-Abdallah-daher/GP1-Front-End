import 'dart:convert';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;


class AddTowingServicePage extends StatefulWidget {
  @override
  _AddTowingServicePageState createState() => _AddTowingServicePageState();
}

class _AddTowingServicePageState extends State<AddTowingServicePage> {


  final MapController _mapController = MapController();
  LatLng? _selectedLatLng;

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

  void _addTowingService(String name, String address, String phone) {
    if (_selectedLatLng != null) {
      setState(() {
        towingServices.add(
          TowingService(
            name: name,
            address: address,
            phone: phone,
            latitude: _selectedLatLng!.latitude,
            longitude: _selectedLatLng!.longitude,
          ),
        );
      });
    }
  }

void _showAddTowingDialog(BuildContext context, String placeDetails) {
    final nameController = TextEditingController();
    final addressController = TextEditingController(text: placeDetails);
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.blue[900],
          title: Center(
            child: Text(
              'Add Towing Service',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                SizedBox(height: 15.0),
                _buildTextField(
                  controller: addressController,
                  label: 'Address',
                  icon: Icons.location_on,
                ),
                SizedBox(height: 15.0),
                _buildTextField(
                  controller: phoneController,
                  label: 'Phone',
                  icon: Icons.phone,
                  inputType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                _addTowingService(
                  nameController.text,
                  addressController.text,
                  phoneController.text,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[300]),
        filled: true,
        fillColor: Colors.blue[800],
        prefixIcon: Icon(icon, color: Colors.blue[300]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Future<List<String>> _searchPlaces(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        return data.map((place) => place['display_name'].toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(32.2276, 35.2206),
        zoom: 13.0,
        onTap: (tapPosition, latLng) async {
          _selectedLatLng = latLng;
          final placeDetails = await _getPlaceDetails(latLng);
          _showAddTowingDialog(context, placeDetails);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: towingServices.map((service) {
            return Marker(
              point: LatLng(service.latitude, service.longitude),
              builder: (ctx) => Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30.0,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMapWithZoomControls() {
    return Stack(
      children: [
        _buildMap(),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: Column(
            children: [
              SizedBox(
                width: 60.0,
                height: 60.0,
                child: FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () {
                    _mapController.move(
                      _mapController.center,
                      _mapController.zoom + 1,
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 30.0),
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 60.0,
                height: 60.0,
                child: FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () {
                    _mapController.move(
                      _mapController.center,
                      _mapController.zoom - 1,
                    );
                  },
                  child: Icon(Icons.remove, color: Colors.white, size: 30.0),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildSearchBar() {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        style: TextStyle(fontSize: 16.0, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Places',
          hintStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.blue[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.white),
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
              style: TextStyle(color: Colors.white, fontSize: 14.0),
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
          _mapController.move(LatLng(lat, lon), 13.0);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
          Expanded(child: _buildMapWithZoomControls()),
        ],
      ),
    );
  }
}
