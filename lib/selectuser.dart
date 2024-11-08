import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';




class UserCardPage extends StatefulWidget {
  @override
  _UserCardPageState createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {


  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<User> filteredUsers = users
        .where((user) =>
            user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepBlueColor,
        title: Text(
          'User Cards',
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: deepBlueColor,
                labelText: 'Search by name',
                labelStyle: TextStyle(color: whiteColor),
                prefixIcon: Icon(Icons.search, color: brightCoralColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  color: deepBlueColor,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: brightCoralColor,
                      child: Text(
                        user.name[0],
                        style: TextStyle(color: whiteColor),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                          color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: ${user.email}',
                          style: TextStyle(color: whiteColor),
                        ),
                        Text(
                          'Phone: ${user.phone}',
                          style: TextStyle(color: whiteColor),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showUserInfo(user);
                     
                       setState(() {
                        selectedUser=user;
                      });
                      
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserInfo(User user) {
    
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: deepBlueColor,
          title: Text(
            'User Information',
            style: TextStyle(color: brightCoralColor),
          ),
          content: Text(
            'Name: ${user.name}\nEmail: ${user.email}\nPhone: ${user.phone}',
            style: TextStyle(color: whiteColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
               
                setState(() {
                  
                });
              },
              child: Text(
                'Close',
                style: TextStyle(color: brightCoralColor),
              ),
            ),
          ],
        );
      },
    );
  }
}


const Color backgroundColor = Color(0xFF1A1A2E); 
const Color whiteColor = Color(0xFFFFFFFF); 
const Color deepBlueColor = Color(0xFF0F3460); 
const Color brightCoralColor = Color(0xFFE94560); 
