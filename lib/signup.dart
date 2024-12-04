import 'package:first/forlogin.dart';
import 'package:first/glopalvars.dart';
import 'package:first/p1.dart';
import 'package:first/p2.dart';
import 'package:first/p3.dart';
import 'package:first/p4.dart';
import 'package:first/p5.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;




  @override
  void dispose() {
    
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    carPlateNumberController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
        
          p1(),
          p2(),
          p3(),
          p4(),
          p5(),
        ],
      ),
    bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Container(
          color:
              Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          
              if (_currentPage > 0 && _currentPage != 4)
                ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, 
                    shadowColor: Colors.black45, 
                    elevation: 5, 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), 
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0), 
                    minimumSize: Size(120, 40), 
                  ),
                  child: Text(
                    "Previous Page",
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.white, 
                    ),
                  ),
                ),

         
              ElevatedButton(
                onPressed: _currentPage==3 ? (acceptTerms ? _nextPage : null): _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 3
                      ? (acceptTerms ? Colors.orangeAccent : Colors.transparent)
                      : Colors.orangeAccent, 
                  shadowColor: Colors.black45, 
                  elevation: 5, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), 
                  minimumSize: Size(120, 40), 
                ),
                child: Text(
                  _currentPage == 4 ? "Go to Home" : "Next Page",
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.white, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  void _nextPage() async {
    
   
    if (_currentPage == 0) {
     
      if(nameController.text.isNotEmpty&&emailController.text.isNotEmpty&&phoneController.text.isNotEmpty){
          setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }else{
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    } else if (_currentPage == 1) {
    
      
       
      if (passwordController.text.isNotEmpty &&
          carPlateNumberController.text.isNotEmpty &&
          confirmpassword.text.isNotEmpty) {
            if(confirmpassword.text==passwordController.text){
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );}else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords do not match'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    } else if (_currentPage == 2) {
   if(acceptTerms){
       setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
   }
    } else if(_currentPage == 3) {
        _addUser();
        addUser();
        setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
   
    }else{
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CarServiceLoginApp(),
          ));
    }
     setState(() {});
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
  Future<void> addUser() async {
    final url = Uri.parse('https://gp1-ghqa.onrender.com/api/users');
    Map<String, dynamic> userData = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'password': passwordController.text.trim(),
      'carPlateNumber': carPlateNumberController.text.trim(),
      'role': "normal",
      'profileImage': "images/avatarimage.png",
      'description': "",
      'location': "",
      'rates': [], 
    };

    try {
    
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData), 
      );

     
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
      
      }
    } catch (error) {
   
      
    }
  }


  void _addUser() {
    setState(() {
      users.add(User(
        carPlateNumber: carPlateNumberController.text.trim(),
        email: emailController.text.trim(),
        id: users.length,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: "normal",
        profileImage: "images/avatarimage.png",
        description: "",
        locatoin: "",
        rates: [],
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
