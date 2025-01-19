import 'package:CarMate/login.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/p1.dart';
import 'package:CarMate/p2.dart';
import 'package:CarMate/p3.dart';
import 'package:CarMate/p4.dart';
import 'package:CarMate/p5.dart';
import 'package:CarMate/p6.dart';
import 'package:CarMate/pagetouploadimages.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    getusers();
  }

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    carPlateNumberController.clear();
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
          EnsureImages(),
          p4(),
          p5(),
          p6(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Container(
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0 && _currentPage != 5)
                ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shadowColor: Colors.black45,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
              if (_currentPage == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already has an Account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarServiceLoginApp()),
                        );
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: _currentPage == 5
                    ? (acceptTerms ? _nextPage : null)
                    : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 5
                      ? (acceptTerms ? Colors.orangeAccent : Colors.transparent)
                      : Colors.orangeAccent,
                  shadowColor: Colors.black45,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  minimumSize: Size(120, 40),
                ),
                child: Text(
                  ((_currentPage >= 6)) ? "Go to Home" : "Next Page",
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
    if(users.where((element) => element.email==emailController.text,).isEmpty){
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
          content: Text('Email already exists!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    } else if (_currentPage == 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 2) {
      if (passwordController.text == confirmpassword.text) {
        if (_currentPage == 2 && isuser) {
          _currentPage++;
        }
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords are not the same!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_currentPage < 5) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 5) {
      if (isuser) {
        addUser(
            users[users.length - 1].id + 1,
            0,
            0,
            nameController.text,
            emailController.text,
            phoneController.text,
            passwordController.text,
            carPlateNumberController.text,
            descriptionController.text,
            "normal",
            locationController.text);

        _addUser();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await getUserSignUpRequests();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        if (userRequests.isEmpty) {
          addUserSignUpRequest(
              0,
              nameController.text,
              emailController.text,
              phoneController.text,
              descriptionController.text,
              locationController.text,
              position.latitude,
              position.longitude);
        } else {
          addUserSignUpRequest(
              userRequests[userRequests.length - 1].requestid + 1,
              nameController.text,
              emailController.text,
              phoneController.text,
              descriptionController.text,
              locationController.text,
              position.latitude,
              position.longitude);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Signup Requested successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );

      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
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

  void _addUser() {
    setState(() {
      users.add(User(
        onlineStatus: false,
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
          latitude: 0,
          longitude: 0));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
