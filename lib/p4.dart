import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class p4 extends StatelessWidget {
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
      home: TermsAndConditionsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const Color _primaryColor = Colors.blueGrey;
const Color _secondaryColor = Colors.black87;
const Color _buttonColor = Colors.lightBlueAccent;
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

class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {


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
            padding: const EdgeInsets.only(
                top: 51, bottom: 155, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                  
                      Text(
                        isuser ?'Step 4: Terms and Conditions':
                        'Step 5: Terms and Conditions',
                        style: TextStyle(
                          fontSize: 34,
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                        Image.asset(
                        '../images/logo4.png',
                        height: 320,
                        width: 320,
                      ),
                    
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Please read and accept the terms and conditions before proceeding.',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (bool? value) {
                        setState(() {
                        acceptTerms = value ?? false;
                         setState(() {
                           
                         });
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I accept the terms and conditions',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    print("Terms and Conditions link pressed");
                  },
                  child: Text(
                    'View Terms and Conditions',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 138),
             
              ],
            ),
          ),
        ),
      ),
    );
  }
}
