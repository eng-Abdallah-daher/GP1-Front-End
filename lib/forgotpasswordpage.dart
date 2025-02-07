import 'dart:math';

import 'package:CarMate/EmailSender.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/login.dart';
import 'package:flutter/material.dart';

class Forgot_Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password Flow',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.blueGrey,
      ),
      home: ForgotPasswordPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('images/logo.png', width: 300),
                    SizedBox(height: 8),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontSize: 34,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Enter your email address to reset your password.',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                  if(users.where((element) => element.email==emailController.text).isEmpty){
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Email address is not in the sytem!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }else{
                     final random = Random();
                      int y = 100000 + random.nextInt(900000);
                      EmailSender.sendEmail(
                          emailController.text,
                          "Reset the Password",
                          "Your password reset code is: ${y} \nPlease do not share this code with anyone for your security.");
                      urlofimage = "$y";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnterCodePage()),
                      );
                  }
                  }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please fill the emailAddress!'),
                            backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Send Reset Link',
                    style: TextStyle(fontSize: 18, color: white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 67, 112)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "remember password?",
                    style: TextStyle(color: white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarServiceLoginApp()),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class EnterCodePage extends StatefulWidget {
  @override
  _EnterCodePageState createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('images/logo3.png', width: 300),
                    SizedBox(height: 8),
                    Text(
                      'Enter Verification Code',
                      style: TextStyle(
                          fontSize: 34,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Enter the code sent to your email.',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  hintText: 'Verification Code',
                  prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (codeController.text == urlofimage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewPasswordPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid verification code')),
                    );
                  }
                },
                child: Text('Verify Code',
                    style: TextStyle(fontSize: 18, color: white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 67, 112)),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('images/logo2.png', width: 300),
                    SizedBox(height: 8),
                    Text(
                      'Set New Password',
                      style: TextStyle(
                          fontSize: 34,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Enter your new password and confirm it.',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  hintText: 'New Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: white,
                  hintText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                        updatepassword(emailController.text, confirmPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password updated successfully')),
                    );

                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarServiceLoginApp()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
                child: Text('Set New Password',
                    style: TextStyle(fontSize: 18, color: white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 67, 112)),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
