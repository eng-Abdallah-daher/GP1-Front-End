import 'package:CarMate/admin.dart';
import 'package:CarMate/forgotpasswordpage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/ownermainpage.dart';

import 'package:CarMate/signup.dart';
import 'package:CarMate/user.dart';
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
        ).copyWith(
          secondary: _accentColor,
        ),
      ),
      home: LoginScreen(),
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticated = false;
  List<BiometricType>? _availableBiometrics;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
     m();
    _checkBiometrics();
  }
  void m()async {
    await getusers();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    List<BiometricType>? availableBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      canCheckBiometrics = false;
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint or use face recognition to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error using biometrics: $e");
    }

    setState(() {
      _isAuthenticated = authenticated;
    });

    if (_isAuthenticated) {
      print("Authentication successful");
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
                      Image.network(
                        'images/c2.Gif',
                        width: 400,
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
                  controller: _emailController,
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
                  controller: _passwordController,
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
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Forgot_Password()),
                      );
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
                      bool loged = false;
if(_emailController.text=="admin"&&_passwordController.text=="admin"){
  global_user=users[0];
  Navigator.push(context, MaterialPageRoute(builder: (context) => adminmainpage()));
loged=true;
}
                    for (int i = 1; i < users.length; i++) {
                      
                      if (_emailController.text == users[i].email) {
                        if (users[i].password == _passwordController.text) {
                          loged = true;
                          global_user = users[i];
                          if (users[i].role == "owner") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ownermainpage()
                                
                                ),
                            );
                          } else {
                            getCarts();
                            getTowingServices();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => usermainpage()),
                            );
                          }
                          break;
                        }
                      }
                    }

                    if (loged==false) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                        content: Text("Invalid email or password"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                      );
                    }
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
                      onPressed: () async {
                        print("Face icon pressed");

                        if (_availableBiometrics != null &&
                            _availableBiometrics!
                                .contains(BiometricType.face)) {
                          await _authenticateWithBiometrics();
                        } else {
                          print("Face authentication not available");
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.fingerprint,
                          size: 50, color: _accentColor),
                      onPressed: () async {
                        print("Fingerprint icon pressed");
                        await _authenticateWithBiometrics();
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
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
