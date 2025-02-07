import 'package:CarMate/login.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/p1.dart';
import 'package:CarMate/p2.dart';
import 'package:CarMate/p3.dart';
import 'package:CarMate/p4.dart';
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
   getUserSignUpRequests();
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
                    backgroundColor: Color.fromARGB(255, 0, 67, 112),
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
                          color: Color.fromARGB(255, 0, 67, 112),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed:  _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPage == 5
                      ? (acceptTerms ? Color.fromARGB(255, 0, 67, 112) : Colors.transparent)
                      : Color.fromARGB(255, 0, 67, 112),
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
                  ((_currentPage >= 5)) ? "Go to Home" : "Next Page",
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
if(selectedRole=="user"){
      if (_currentPage == 0) {
        if (nameController.text.isEmpty ||
            emailController.text.isEmpty ||
            phoneController.text.isEmpty ||
            birthDateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill all feilds!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            _currentPage++;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
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
        if (carPlateNumberController.text.isEmpty ||
            passwordController.text.isEmpty ||
            confirmpassword.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill all feilds!'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (passwordController.text != confirmpassword.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords do not match!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          _currentPage++;
          _currentPage++;
          setState(() {});
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      } else if (_currentPage == 4) {
        if (acceptTerms) {
          setState(() {
            _currentPage++;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
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
              locationController.text,
              birthDateController.text,
              selectedGender!);

          _addUser();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please accept the terms and conditions!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (_currentPage == 5) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CarServiceLoginApp(),
            ));

        setState(() {});
      }
}else{
     if (_currentPage == 0) {
        if (nameController.text.isEmpty ||
            emailController.text.isEmpty ||
            phoneController.text.isEmpty ||
            birthDateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill all feilds!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            _currentPage++;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      } else if (_currentPage == 1) {
    if(descriptionController.text.isEmpty||locationController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all feilds!'),
          backgroundColor: Colors.red,
        ),
      );
    }else{
      setState(() {
            _currentPage++;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
    
    }
      } else if (_currentPage == 2) {
        if (
            passwordController.text.isEmpty ||
            confirmpassword.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill all feilds!'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (passwordController.text != confirmpassword.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords do not match!'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
        
          _currentPage++;
          setState(() {});
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      } 
      else if (_currentPage==3){
     if(marketImages[0] == null|| marketImages[1] == null||
            marketImages[2] == null){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select all market images!'),
                  backgroundColor: Colors.red,
                ),
              );
            }else{
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
      else if (_currentPage == 4) {
        if (acceptTerms) {
          setState(() {
            _currentPage++;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
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
                position.longitude,
                birthDateController.text,
                selectedGender!);
          } else {
            addUserSignUpRequest(
                userRequests[userRequests.length - 1].requestid + 1,
                nameController.text,
                emailController.text,
                phoneController.text,
                descriptionController.text,
                locationController.text,
                position.latitude,
                position.longitude,
                birthDateController.text,
                selectedGender!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User Signup Requested successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please accept the terms and conditions!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (_currentPage == 5) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CarServiceLoginApp(),
            ));

        setState(() {});
      }
}
      
  }

  void _previousPage() {
    if(isuser&&_currentPage==4)_currentPage--;
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
        accountnumber: '0',
        rate: 0,
        birthDate: birthDateController.text,
        gender: selectedGender!,
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
