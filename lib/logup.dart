 import 'package:first/login.dart';

import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}


const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  
  final GlobalKey<FormState> _formKeyPage1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPage2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPage3 = GlobalKey<FormState>();

  
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  
  String? _selectedRole;
  bool emailConfirmed = false;

  Future<void> showEmailConfirmationDialog(
      BuildContext context, String email) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: const Text(
            'Confirm Email',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to continue with the email:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8), 
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent, 
                foregroundColor: Colors.white, 
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            const SizedBox(width: 10), 
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green, 
                foregroundColor: Colors.white, 
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                proceedWithEmail(email);
              },
            ),
          ],
        );
      },
    );
  }



void proceedWithEmail(String email) async {

 

 emailConfirmed=true;
  final Map<String, dynamic> requestData = {
    'email': email,
    'password': passwordController.text,
    'phone_number': phoneController.text,
    'first_name': firstNameController.text,
    'last_name': lastNameController.text,
    'role': _selectedRole,
  };


  final String jsonRequest = jsonEncode(requestData);

  try {
    
   final response = await http.post(
          Uri.parse('http://localhost:4000/api/users/verify-email'), 
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonRequest,
        );

    if (response.statusCode == 200) {
     
      print('Registration successful: ${response.body}');
      emailConfirmed = true;
    } else {
      
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
   
    print('Network error: $e');
  }
}


  final List<String> _roles = ['user', 'renter', 'admin'];

 
  Future<bool> _validateCurrentForm() async {
    if (_currentPage == 0) {
      return _formKeyPage1.currentState!.validate();
    } else if (_currentPage == 1) {
      if (!emailConfirmed) {
        await showEmailConfirmationDialog(context, emailController.text);
      }
      return emailConfirmed && _formKeyPage2.currentState!.validate();
    } else {
      return _formKeyPage3.currentState!.validate();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: deepBlueColor,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), 
        children: [
          _buildFirstPage(),
          _buildSecondPage(),
          _buildThirdPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFirstPage() {
    return Form(
      key: _formKeyPage1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(firstNameController, 'First Name', false),
            SizedBox(height: 16),
            _buildTextField(lastNameController, 'Last Name', false),
            SizedBox(height: 16),
            _buildTextField(
                emailController, 'Email', false, TextInputType.emailAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return Form(
      key: _formKeyPage2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(passwordController, 'Password', true),
            SizedBox(height: 16),
            _buildTextField(
                phoneController, 'Phone Number', false, TextInputType.phone),
            SizedBox(height: 16),
            _buildRoleDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPage() {
    return Form(
      key: _formKeyPage3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
                _buildDigitInputField(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitInputField() {
    return SizedBox(
      width: 240, 
      child: TextFormField(
        controller: verificationCodeController,
        maxLength: 6, 
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 24),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: deepBlueColor, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: brightCoralColor, width: 2.0),
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
      ),
    );
  }


  Widget _buildTextField(
      TextEditingController controller, String label, bool isObscure,
      [TextInputType? keyboardType, int? maxLength]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: whiteColor),
        prefixIcon: Icon(Icons.text_fields, color: whiteColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: deepBlueColor, width: 2.0),
        ),
        filled: true,
        fillColor: brightCoralColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: deepBlueColor, width: 2.0),
        ),
      ),
      obscureText: isObscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

 Widget _buildRoleDropdown() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deepBlueColor.withOpacity(0.8), brightCoralColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        onChanged: (newValue) {
          setState(() {
            _selectedRole = newValue;
          });
        },
        decoration: InputDecoration(
          labelText: 'Select Role',
          labelStyle: TextStyle(color: whiteColor),
          border: InputBorder.none, 
        ),
        items: _roles.map((role) {
          return DropdownMenuItem(
            value: role,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0), 
              child: Text(
                role,
                style: TextStyle(color: whiteColor),
              ),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select a role';
          }
          return null;
        },
        dropdownColor: brightCoralColor, 
      ),
    );
  }


  Widget _buildBottomNavigation() {
    return BottomAppBar(
      color: deepBlueColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentPage == 0 ? null : _previousPage,
            child: Text(
              'Previous',
              style: TextStyle(color: whiteColor),
            ),
          ),
          TextButton(
            onPressed: _currentPage == 2 ? _submitForm : _nextPage,
            child: Text(
              _currentPage == 2 ? 'Submit' : 'Next',
              style: TextStyle(color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() async {
    if (await _validateCurrentForm()) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    setState(() {
      _currentPage--;
    });
    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _submitForm() async {
  
 
    if (await _validateCurrentForm()) {
   
     final Map<String, dynamic> requestData = {
        'email': emailController.text,
        'verification_code': verificationCodeController.text
       
      };

      final String jsonRequest = jsonEncode(requestData);

      try {
final response = await http.post(
          Uri.parse(
              'http://localhost:3000/api/users/register'), 
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonRequest,
        );

        if (response.statusCode == 200) {
          
          emailConfirmed = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );

        } else {

         print(response.body);
        }
      } catch (e) {

        print('Network error: $e');
      }
     
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
    debugShowCheckedModeBanner: false,
  )); 
} 
