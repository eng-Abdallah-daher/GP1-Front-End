import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRequestsPage extends StatefulWidget {
  @override
  _UserRequestsPageState createState() => _UserRequestsPageState();
}

class _UserRequestsPageState extends State<UserRequestsPage> {
  List<UserSignUpRequest> deletedRequests = [];

  Future<void> fetchPlaceDetails(int index) async {
    setState(() {
      userRequests[index].placeDetails = 'Loading place details...';
    });

    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${userRequests[index].latitude}&lon=${userRequests[index].longitude}&addressdetails=1'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String placeName = data['display_name'] ?? 'Unknown Place';
        String city = data['address']?['city'] ?? 'Unknown City';
        String country = data['address']?['country'] ?? 'Unknown Country';

        setState(() {
          userRequests[index].placeDetails = '$placeName\n$city, $country';
        });
      } else {
        setState(() {
          userRequests[index].placeDetails =
              'Failed to fetch location details.';
        });
      }
    } catch (e) {
      print('Error fetching place details: $e');
      setState(() {
        userRequests[index].placeDetails = 'Error fetching place details.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    m();
  }

  void m() async {
    await getUserSignUpRequests();
    for (int i = 0; i < userRequests.length; i++) {
      fetchPlaceDetails(i);
    }
    setState(() {});
  }

  void _acceptRequest(int index) {
    UserSignUpRequest acceptedRequest = userRequests[index];
    addUser(
        users[users.length - 1].id + 1,
        userRequests[index].latitude,
        userRequests[index].longitude,
        userRequests[index].name,
        userRequests[index].email,
        userRequests[index].phone,
        userRequests[index].password,
        "",
        userRequests[index].description,
        "owner",
        userRequests[index].location);

    setState(() {
      deleteUserSignUpRequest(acceptedRequest.requestid);
      userRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Request Accepted",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.greenAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.yellowAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.shade100,
                          Colors.blueAccent.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Request Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildCustomInfoRow(
                            Icons.person, 'Name', acceptedRequest.name),
                        _buildCustomInfoRow(
                            Icons.email, 'Email', acceptedRequest.email),
                        _buildCustomInfoRow(
                            Icons.phone, 'Phone', acceptedRequest.phone),
                        _buildCustomInfoRow(Icons.description, 'Description',
                            acceptedRequest.description),
                        _buildCustomInfoRow(Icons.location_pin, 'Location',
                            acceptedRequest.location),
                        _buildCustomInfoRow(Icons.map, 'Location Details',
                            acceptedRequest.placeDetails),
                        SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              backgroundColor: Colors.greenAccent.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'CLOSE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Widget _buildCustomInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteRequest(int index) {
    UserSignUpRequest deletedRequest = userRequests[index];

    setState(() {
      userRequests.removeAt(index);
      deletedRequests.add(deletedRequest);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Request Deleted",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.yellowAccent,
          onPressed: () {
            setState(() {
              userRequests.add(deletedRequest);
              deletedRequests.remove(deletedRequest);
            });
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userRequests.isEmpty
          ? Center(
              child: Text(
                "No requests available",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: userRequests.length,
              itemBuilder: (context, index) {
                final request = userRequests[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("User Information"),
                        _buildInfoRow("Name", request.name),
                        _buildInfoRow("Email", request.email),
                        _buildInfoRow("Phone", request.phone),
                        SizedBox(height: 16),
                        _buildSectionTitle("Request Details"),
                        _buildInfoRow("Description", request.description),
                        _buildInfoRow("Location", request.location),
                        _buildInfoRow("Location Details", request.placeDetails),
                        SizedBox(height: 16),
                        _buildSectionTitle("Images"),
                        _buildImageGallery(request.images),
                        SizedBox(height: 24),
                        _buildActionButtons(index),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> images) {
    return Row(
      children: images.map((imgUrl) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imgUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            await fetchPlaceDetails(index);
            _acceptRequest(index);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
          child: Text(
            "Accept",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () => _deleteRequest(index),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
          child: Text(
            "Delete",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
