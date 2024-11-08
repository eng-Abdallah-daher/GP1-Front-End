import 'package:flutter/material.dart';

const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _firstNameController.text = 'Abdallah';
    _lastNameController.text = 'Daher';
    _emailController.text = 'anyemail@example.com';
    _phoneController.text = '123456789';
  }

  
  void _updateProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
    
  }

  
  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password change requested!')),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: whiteColor)),
        backgroundColor: deepBlueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: deepBlueColor,
                child: Icon(Icons.person, size: 60, color: whiteColor),
              ),
            ),
            SizedBox(height: 20),

            
            TextField(
              controller: _firstNameController,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: whiteColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: brightCoralColor),
                ),
              ),
            ),
            SizedBox(height: 20),

            
            TextField(
              controller: _lastNameController,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: whiteColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: brightCoralColor),
                ),
              ),
            ),
            SizedBox(height: 20),

            
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: whiteColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: brightCoralColor),
                ),
              ),
            ),
            SizedBox(height: 20),

            
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: whiteColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: brightCoralColor),
                ),
              ),
            ),
            SizedBox(height: 40),

            
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepBlueColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Change Password',
                        style: TextStyle(color: whiteColor)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brightCoralColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Update Profile',
                        style: TextStyle(color: whiteColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}
