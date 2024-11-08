import 'package:first/RentalStorePage.dart';
import 'package:first/makereview.dart';
import 'package:first/rentalreqs.dart';
import 'package:flutter/material.dart';

const Color backgroundColor = Colors.white; 
const Color lightBlueColor = Color(0xFFADD8E6); 
const Color blueColor = Color(0xFF0F3460); 
const Color cardColor = Color(0xFFB0E0E6); 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Pages App',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: blueColor,
      ),
      home: RentalPages(),
    );
  }
}

class RentalPages extends StatefulWidget {
  @override
  _RentalPagesState createState() => _RentalPagesState();
}

class _RentalPagesState extends State<RentalPages> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    RentalStorePage(),
    RequestStatusPage(),
    MakeReview(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Review',
          ),
        ],
      ),
    );
  }
}
