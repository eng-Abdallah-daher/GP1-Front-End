import 'package:flutter/material.dart';
// import 'package:first/assistancerequestpage.dart';
// import 'package:first/RequesttowService.dart';

class SOSPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSOSButton(context),
            SizedBox(height: 16),
            _buildShareLocationButton(context),
            SizedBox(height: 16),
            _buildEmergencyContactsSection(),
            SizedBox(height: 16),
            _buildContactTowServiceButton(context),
            SizedBox(height: 16),
            _buildNearbyRepairShopsSection(),
            SizedBox(height: 16),
            _buildEmergencyInstructionsSection(),
            SizedBox(height: 16),
            _buildPreviousEmergencyRequestsSection(),
            SizedBox(height: 16),
            _buildQuickCallButton(context),
            SizedBox(height: 16),
            _buildRealTimeNotificationsSection(),
            SizedBox(height: 16),
            _buildNotifyFamilyFriendsButton(context),
          ],
        ),
      ),
    );
  }

  // SOS Button
  Widget _buildSOSButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.redAccent,
            Colors.red,
            Colors.deepOrange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.warning,
            color: Colors.white,
            size: 30,
          ),
        ),
        label: Text(
          'Request Immediate Assistance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Assistancerequestpage()),
        //   );
        },
      ),
    );
  }

  // Share Location Button
  Widget _buildShareLocationButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.blue,
            Colors.teal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            Icons.location_on,
            color: Colors.white,
            size: 30,
          ),
        ),
        label: Text(
          'Share Live Location',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          // Location sharing logic goes here
        },
      ),
    );
  }

  // Emergency Contacts Section
  Widget _buildEmergencyContactsSection() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            _buildEmergencyContactTile(
              icon: Icons.phone,
              title: 'Police',
              subtitle: 'Call 100',
              color: Colors.red,
              onTap: () {
                // Call Police logic
              },
            ),
            _buildEmergencyContactTile(
              icon: Icons.local_hospital,
              title: 'Ambulance',
              subtitle: 'Call 101',
              color: Colors.green,
              onTap: () {
                // Call Ambulance logic
              },
            ),
            _buildEmergencyContactTile(
              icon: Icons.car_repair,
              title: 'Tow Service',
              subtitle: 'Call 102',
              color: Colors.orange,
              onTap: () {
                // Call Tow Service logic
              },
            ),
          ],
        ),
      ),
    );
  }

  // Emergency Contact Tile
  Widget _buildEmergencyContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: onTap,
    );
  }

  // Contact Tow Service Button
  Widget _buildContactTowServiceButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.car_repair,
          color: Colors.white,
          size: 50,
        ),
        label: Text(
          'Request Tow Service',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 12,
          shadowColor: Colors.blueAccent.withOpacity(0.6),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.blue.shade700;
              }
              return Colors.transparent;
            },
          ),
        ),
        onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => RequestTowServicePage()),
        //   );
        },
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.7),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
    );
  }

  // Nearby Repair Shops Section
  Widget _buildNearbyRepairShopsSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nearby Repair Shops',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16),
              _buildRepairShopTile(
                icon: Icons.build,
                title: 'Advanced Auto Repair',
                subtitle: '1.2 km away',
              ),
              Divider(
                thickness: 1,
                color: Colors.blueAccent.withOpacity(0.5),
              ),
              _buildRepairShopTile(
                icon: Icons.build,
                title: 'Quick Fix Garage',
                subtitle: '2.5 km away',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Repair Shop Tile
  Widget _buildRepairShopTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        child: Icon(icon, color: Colors.blueAccent),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: () {
        // Navigate to shop details
      },
    );
  }

  // Emergency Instructions Section
  Widget _buildEmergencyInstructionsSection() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Instructions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Stay calm and move to a safe location.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '2. Call emergency services if needed.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '3. Share your location with family or friends.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '4. Wait for help to arrive.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Previous Emergency Requests Section
  Widget _buildPreviousEmergencyRequestsSection() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Emergency Requests',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No previous requests available.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Call Button
  Widget _buildQuickCallButton(BuildContext context) {
    return Container(
      width: double.infinity, // Full-width button
      height: 70, // Button height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.blue,
            Colors.lightBlue
          ], // Gradient for impact
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5), // Subtle glow effect
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.call,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          'Quick Call',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          // Quick call logic goes here
        },
      ),
    );
  }

  // Real-time Notifications Section
  Widget _buildRealTimeNotificationsSection() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Real-time Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No active notifications.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Notify Family/Friends Button
  Widget _buildNotifyFamilyFriendsButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orangeAccent,
            Colors.deepOrange,
            Colors.orange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.people,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          'Notify Family/Friends',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          // Notify family/friends logic
        },
      ),
    );
  }
}
