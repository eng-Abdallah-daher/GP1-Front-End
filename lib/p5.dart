import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class p5 extends StatelessWidget {
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
      home: FinalVerificationPage(),
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

class FinalVerificationPage extends StatefulWidget {
  @override
  _FinalVerificationPageState createState() => _FinalVerificationPageState();
}

class _FinalVerificationPageState extends State<FinalVerificationPage> {
  @override
  Widget build(BuildContext context) {
    final String fullName = nameController.text;
    final String email = emailController.text;;
    final String phone = phoneController.text;
    final String carPlate = carPlateNumberController.text;

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
                const EdgeInsets.only(top: 20, bottom: 37, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.local_gas_station_rounded,
                          size: 200, color: _textColor),
                      SizedBox(height: 16),
                      Text(
isuser ?'Step 5: Final Verification':'Step 6: Final Verification',
                        style: TextStyle(
                          fontSize: 34,
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: 40),
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
                        'Review Your Information',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow('Full Name:', fullName),
                      _buildInfoRow('Email Address:', email),
                      _buildInfoRow('Phone Number:', phone),
                    if(isuser) _buildInfoRow('Car Plate Number:', carPlate),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
