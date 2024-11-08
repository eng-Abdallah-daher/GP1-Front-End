import 'package:first/PieChartPage.dart';
import 'package:first/glopalvars.dart';
import 'package:first/main.dart';
import 'package:first/mappage.dart';
import 'package:first/profits.dart';
import 'package:flutter/material.dart';

const Color backgroundColor = Colors.white; 
const Color lightBlueColor = Color(0xFFADD8E6); 
const Color blueColor = Color(0xFF0F3460); 
const Color cardColor = Color(0xFFB0E0E6); 




class Adminpages extends StatefulWidget {
  @override
  _RentalPagesState createState() => _RentalPagesState();
}

class _RentalPagesState extends State<Adminpages> {
  int _currentIndex = 0;
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
  final List<Widget> _pages = [
    MapPage(),
    ProfitsPage(),
    showreviews(),
  ];

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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: lightBlueColor,
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Profits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'Reviews',
          ),
        ],
      ),
    );
  }
}
