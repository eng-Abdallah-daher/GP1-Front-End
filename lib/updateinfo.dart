import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class UpdatePersonalInfoPage extends StatefulWidget {
  @override
  _UpdatePersonalInfoPageState createState() => _UpdatePersonalInfoPageState();
}

class _UpdatePersonalInfoPageState extends State<UpdatePersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  
  String _phoneNumber = '';
  

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
try{
  
updateUser(global_user.email, _name, _phoneNumber);

global_user.name = _name;
      global_user.phone = _phoneNumber;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Personal info updated successfully!'),
        backgroundColor: Colors.blue,),
        
      );

}catch(e) {
  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update personal info. Please try again.'),
        backgroundColor: Colors.red,),
        
      );
  print(e);
}
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Personal Info'),
        backgroundColor: blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Name',
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                  
                ),
              
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = value!;
                  },
                ),
               
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueAccent,
                      minimumSize: Size(double.infinity, 50),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 18, color: white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: blueAccent, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: blueAccent),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
    );
  }
}
