import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class p2 extends StatelessWidget {
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
      home: PersonalInfoPage(),
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

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding:
              const EdgeInsets.only(top: 40, bottom: 30, right: 16, left: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    
                    
                    Text(
                      'Step 2: Public Personal Information',
                      style: TextStyle(
                        fontSize: 34,
                        color: _textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    
                    Image.asset(
                      'images/map.png',
                      width: 300,
                    ),
                    Text(
                      'Provide your personal information',
                      style: TextStyle(
                        color: _textColor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.description, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your description';
                  }
                 
                  return null;
                },
              ),  SizedBox(height: 16),
               TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
