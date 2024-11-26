import 'package:first/forlogin.dart';
import 'package:first/glopalvars.dart';
import 'package:first/p1.dart';
import 'package:first/p2.dart';
import 'package:first/p3.dart';
import 'package:first/p4.dart';
import 'package:first/p5.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _currentPage > 0
                ? ElevatedButton(
                    onPressed: _previousPage,
                    child: Text("Previous Page"),
                  )
                : SizedBox(
                    width: 0,
                  ),
            ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == 4 ? "Go to Home" : "Next Page"),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() async {
    if (_currentPage == 0) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage < 4) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _addUser();
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
