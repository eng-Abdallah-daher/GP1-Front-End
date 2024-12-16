import 'package:first/forlogin.dart';
import 'package:first/glopalvars.dart';
import 'package:first/p1.dart';
import 'package:first/p2.dart';
import 'package:first/p3.dart';
import 'package:first/p4.dart';
import 'package:first/p5.dart';
import 'package:first/p6.dart';
import 'package:first/pagetouploadimages.dart';

import 'package:flutter/material.dart';

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
  }

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
          if(selectedRole=="owner")EnsureImages(),
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
                onPressed: _currentPage == 4
                    ? (acceptTerms ? _nextPage : null)
                    : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 4
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
                  ((_currentPage == 4&&selectedRole=="User")||(_currentPage == 5 && selectedRole=="owner")) ? "Go to Home" : "Next Page",
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

      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty) {
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
            content: Text('Please fill all fields'),
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
    } else if ((_currentPage == 2 && isuser)) {
      if (passwordController.text.isNotEmpty &&
          carPlateNumberController.text.isNotEmpty &&
          confirmpassword.text.isNotEmpty) {
        if (confirmpassword.text == passwordController.text) {
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
    } else if ((_currentPage == 3&&isuser)||(!isuser&& _currentPage == 4)) {
      if (acceptTerms) {
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    } else if ((_currentPage == 4 && isuser) ||
        (!isuser && _currentPage == 5)) {
    if (isuser) {
        addUser(
            users.length,
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
      );}else{

        // addUserSignUpRequest(userRequests.length, nameController.text, emailController.text, phoneController.text, descriptionController.text, locationController.text, latitude, longitude, [

        //   marketImages[0].path!,
        //   marketImages[1].path!,
        //   marketImages[2].path!,

        // ]);
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Regeistered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
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
