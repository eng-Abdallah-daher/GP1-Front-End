import 'dart:ui_web';

import 'package:CarMate/adminmap.dart';
import 'package:CarMate/adminp1.dart';
import 'package:CarMate/adminp2.dart';
import 'package:CarMate/chats.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/managetowservices.dart';
import 'package:CarMate/ownerpayment.dart';
import 'package:CarMate/postreports.dart';
import 'package:flutter/material.dart';

class adminmainpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = index;

  List<Widget> _pages = [
    UserRequestsPage(),
    OwnerPaymentPage(),
    AdminP2(),
    ChatsPage(),
    AddTowingServicePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    setState(() {});
  }

  Widget _buildButton(IconData icon, String label, int index) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: _selectedIndex == index ? blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.car_crash_outlined,size: 45,color: blue,),
            onPressed: () {

               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TowingServicePage(),
                  ),
                );
            }),
           IconButton(
  icon: Stack(
    children: [
      Icon(
        color: blue,
        Icons.report,
        size: 45, 
      ),
      if (reportedPosts.length > 0)
        Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.red,
            child: Text(
              '${reportedPosts.length}',
              style: TextStyle(
                color: white,
                fontSize: 12,
              ),
            ),
          ),
        ),
    ],
  ),
  onPressed: () {
   setState(() {
      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportedPostsPage(),
                  ),
                );
   });
   setState(() {
     
   });
  },
)
,
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(global_user.profileImage!),
              radius: 22,
              backgroundColor: white,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            onPressed: () {
             
            },
          ),
          SizedBox(width: 10,)
        ],
        backgroundColor: Color.fromARGB(255, 234, 243, 250),
        elevation: 5,
        title: Text(
          'CarMate',
          style: TextStyle(
            fontSize: 15,
            color: black,
            letterSpacing: 1.7,
            shadows: [
              Shadow(
                color: black.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          UserRequestsPage(),
          OwnerPaymentPage(),
          AdminP2(),
          ChatsPage(),
          AddTowingServicePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 226, 235, 242),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildButton(Icons.assignment, 'Requests', 0),
                  _buildButton(Icons.people, 'Owners', 1),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildButton(Icons.manage_accounts_rounded, 'Manage', 2),
                  _buildButton(Icons.mark_chat_read_sharp, 'Chats', 3),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(4);
        },
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('images/map.png'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: blue,
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void shownewposts() {}
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 90, 172, 240),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SectionBlock(
              title: 'Exclusive Offers',
              content: 'Get 20% off on your first car repair service.',
              color: white,
              icon: Icons.local_offer,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Car Maintenance Tips',
              content: 'Make sure to check your tire pressure monthly.',
              color: white,
              icon: Icons.tips_and_updates,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Featured Services',
              content: 'Comprehensive service at 10% off.',
              color: white,
              icon: Icons.star,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Previous Requests',
              content: 'Last gas station you visited: Quick Fuel Station.',
              color: white,
              icon: Icons.history,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Maintenance Notifications',
              content: 'Engine oil change due in 5 days.',
              color: white,
              icon: Icons.notifications,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'User Reviews',
              content: 'Repair shop "Advanced" rated 4.5 out of 5.',
              color: white,
              icon: Icons.rate_review,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Favorites',
              content: 'Your favorite repair shops.',
              color: white,
              icon: Icons.favorite,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Points',
              content: 'Total points earned in the app.',
              color: white,
              icon: Icons.podcasts,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionBlock extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final IconData icon;

  SectionBlock({
    required this.title,
    required this.content,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 40, color: Color(0xFF5AACF0)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
