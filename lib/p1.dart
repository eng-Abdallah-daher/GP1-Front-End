
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class p1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _primarySwatch,
          accentColor: _accentColor,
        ),
      ),
      home: PersonalInfoPage(),
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

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding:
              const EdgeInsets.only(top: 40, bottom: 30, right: 16, left: 16),
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
                      'Step 1: Personal Information',
                      style: TextStyle(
                        fontSize: 34,
                        color: _textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Provide your personal information',
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
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
            TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _textFieldFillColor,
                  hintText: 'Select Gender',
                  prefixIcon: Icon(Icons.person, color: _iconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: TextEditingController(text: selectedGender),
                onTap: () async {
                  String? selectedGendero = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 20,
                        backgroundColor: _primaryColor,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Select Gender",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(
                                color: _accentColor,
                                thickness: 2,
                              ),
                              SizedBox(height: 20),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, 'Male');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 32),
                                  decoration: BoxDecoration(
                                    color: _accentColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _accentColor.withOpacity(0.3),
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Male',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: _accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, 'Female');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 32),
                                  decoration: BoxDecoration(
                                    color: _buttonColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _buttonColor.withOpacity(0.3),
                                        offset: Offset(0, 4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Female',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: _buttonColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );


                  if (selectedGendero != null) {
                    setState(() {
                      selectedGender = selectedGendero;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
  controller: birthDateController,
  decoration: InputDecoration(
    filled: true,
    fillColor: _textFieldFillColor,
    hintText: 'Enter Your Birth Date',
    prefixIcon: Icon(Icons.calendar_today, color: _iconColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  keyboardType: TextInputType.datetime,
  onTap: () async {
    FocusScope.of(context).requestFocus(FocusNode()); // to hide keyboard
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      birthDateController.text = "${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.year}";
    }
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your birth date';
    }
    return null;
  },
),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'owner',
                    groupValue: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        isuser=false;
                        selectedRole = value!;
                      });
                    },
                    activeColor: Colors.orangeAccent,
                  ),
                  Text(
                    'Owner',
                    style: TextStyle(
                      color: selectedRole == 'owner'
                          ? Colors.orangeAccent
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Radio<String>(
                    value: 'user',
                    groupValue: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        isuser=true;
                        selectedRole = value!;
                      });
                    },
                    activeColor: Colors.orangeAccent,
                  ),
                  Text(
                    'User',
                    style: TextStyle(
                      color: selectedRole == 'user'
                          ? Colors.orangeAccent
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
