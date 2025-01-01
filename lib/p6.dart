import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class p6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _primarySwatch,
          accentColor: _accentColor,
        ),
      ),
      home: NotificationsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const Color _primaryColor = Colors.blueGrey;
const Color _secondaryColor = Colors.black87;
const Color _buttonColor = Colors.orangeAccent;
const Color _textColor = Colors.white;
const Color _textFieldFillColor = Colors.white70;
const Color _iconColor = Colors.blueGrey;
const Color _accentColor = Colors.orangeAccent;

const MaterialColor _primarySwatch = MaterialColor(
  0xFF37474F,
  <int, Color>{
    50: Color(0xFFeceff1),
    100: Color(0xFFcfd8dc),
    200: Color(0xFFb0bec5),
    300: Color(0xFF90a4ae),
    400: Color(0xFF78909c),
    500: Color(0xFF607d8b),
    600: Color(0xFF546e7a),
    700: Color(0xFF455a64),
    800: Color(0xFF37474f),
    900: Color(0xFF263238),
  },
);

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 35, bottom: 38, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'images/logo6.png',
                          width: 500,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(isuser ?
                        'Step 6: Notifications':
                        'Step 7: Notifications',
                        style: TextStyle(
                          fontSize: 34,
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 3),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registration Complete!',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'A confirmation email has been sent to your provided email address. Please check your inbox (and spam folder) for further instructions.',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
