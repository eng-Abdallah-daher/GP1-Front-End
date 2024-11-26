import 'package:first/EmergencyTowingPage.dart';
import 'package:first/ReportCarIssuePage.dart';
import 'package:first/glopalvars.dart';
import 'package:first/servicepage.dart';
import 'package:flutter/material.dart';

class SOSPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildEmergencyServicesSection(context),
            SizedBox(height: 16),
            _buildEmergencyContactsSection(),
            SizedBox(height: 16),
            _buildNearbyRepairShopsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Services',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueAccent,
          ),
        ),
        SizedBox(height: 16),
        _buildButton(
          icon: Icons.car_repair,
          label: 'Emergency Towing',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmergencyTowingPage()));
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [blueAccent, Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: blueAccent.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: white,
                size: 28,
              ),
              SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: white,
      shadowColor: black.withOpacity(0.3),
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
                color: blueAccent,
              ),
            ),
            SizedBox(height: 16),
            _buildEmergencyContactTile(
              icon: Icons.phone,
              title: 'Police',
              subtitle: 'Call 100',
              color: Colors.red,
              onTap: () {},
            ),
            _buildEmergencyContactTile(
              icon: Icons.local_hospital,
              title: 'Ambulance',
              subtitle: 'Call 101',
              color: Colors.green,
              onTap: () {},
            ),
            _buildEmergencyContactTile(
              icon: Icons.car_repair,
              title: 'Tow Service',
              subtitle: 'Call 102',
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

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
                  color: blueAccent,
                ),
              ),
              SizedBox(height: 16),
              Divider(
                thickness: 1,
                color: blueAccent.withOpacity(0.5),
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

  Widget _buildRepairShopTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: blueAccent,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      onTap: () {},
    );
  }
}
