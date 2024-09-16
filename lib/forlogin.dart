import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class CarServiceLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Service',
      theme: ThemeData(
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _primarySwatch,
          accentColor: _accentColor,
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Define color variables
const Color _primaryColor = Colors.blueGrey;
const Color _secondaryColor = Colors.black87;
const Color _buttonColor = Colors.orangeAccent;
const Color _textColor = Colors.white;
const Color _textFieldFillColor = Colors.white70;
const Color _iconColor = Colors.blueGrey;
const Color _accentColor = Colors.orangeAccent;

const MaterialColor _primarySwatch = MaterialColor(
  0xFF37474F, // primary color value
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithFingerprint() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error using fingerprint: $e");
    }

    if (authenticated) {
      print("Authentication successful");
      // Perform action after successful authentication
    } else {
      print("Authentication failed");
    }
  }

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'images/logo.png',
                        height: 210,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Car Services',
                        style: TextStyle(
                          fontSize: 34,
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Your one-stop solution for car care',
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _textFieldFillColor,
                    hintText: 'Email address',
                    prefixIcon: Icon(Icons.email, color: _iconColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _textFieldFillColor,
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: _iconColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      print("Reset Password button pressed");
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: _textColor.withOpacity(0.7)),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    print("Login button pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonColor,
                    shadowColor: Colors.black45,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: _textColor),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.face, size: 50, color: _accentColor),
                      onPressed: () {
                        print("Face icon pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.fingerprint,
                          size: 50, color: _accentColor),
                      onPressed: () async {
                        print("Fingerprint icon pressed");
                        await _authenticateWithFingerprint();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.lock, size: 50, color: _accentColor),
                      onPressed: () {
                        print("PIN icon pressed");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New to Car Services? ",
                      style: TextStyle(color: _textColor),
                    ),
                    TextButton(
                      onPressed: () {
                        print("Sign Up button pressed");
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: _accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
