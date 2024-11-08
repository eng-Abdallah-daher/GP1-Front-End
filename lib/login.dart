import 'package:first/adminpages.dart';
import 'package:first/glopalvars.dart';
import 'package:first/nentalpages.dart';
import 'package:first/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
                    prefixIcon: Icon(Icons.email, color: Color(0xFFFFFFFF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(color: Color(0xFFE94560), width: 3.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFF0F3460).withOpacity(0.7),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(color: Color(0xFFE94560), width: 3.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFFFFFFF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(color: Color(0xFFE94560), width: 3.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFF0F3460).withOpacity(0.7),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(color: Color(0xFFE94560), width: 3.0),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    bool g=login(context) as bool;
if(g){
   
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login successful')),
                      );
}
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                    backgroundColor: Color(0xFFE94560),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    theme: ThemeData(
      fontFamily: 'Roboto',
    ),
  ));
}
