
import 'package:first/glopalvars.dart';
import 'package:first/main.dart';
import 'package:flutter/material.dart';


class RequestStatusPage extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: Drawer(
        child: Container(
          color: Color(0xFF0F3460), 
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFADD8E6), 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF0F3460),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome, User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'user@example.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  if (isLogged) {}
                },
              ),
              Divider(color: Colors.white54, thickness: 1),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Request Status',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0F3460), 
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF1A1A2E), 
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              color: Color(0xFF2A2A3D), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                    color: Color(0xFF0F3460), width: 1.5), 
              ),
              shadowColor: Colors.black.withOpacity(0.5), 
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                   
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        request.imageUrl ,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 16.0),
                   
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.carName ,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE94560), 
                            ),
                          ),
                          Text(
                            request.carModel ,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, 
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Status: ${request.status }',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(request.status ),
                            ),
                          ),
                        ],
                      ),
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
  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFADD8E6)),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      hoverColor: Color(0xFFB0E0E6).withOpacity(0.3), 
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange; 
      case 'rejected':
        return Colors.red; 
      case 'approved':
        return Colors.blueAccent; 
      case 'completed':
        return Colors.greenAccent; 
      default:
        return Colors.white; 
    }
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RequestStatusPage(),
  ));
}
