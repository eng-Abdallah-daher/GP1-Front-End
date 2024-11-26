import 'package:first/profile.dart';
import 'package:flutter/material.dart';
import 'glopalvars.dart'; // Assuming this contains your user data

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  // List of filtered users
  List<User> filteredUsers = [];

  // Search query
  String query = "";

  @override
  void initState() {
    super.initState();
    // Initially, display all users
    filteredUsers = users;
  }

  // Method to filter users based on search query
  void searchUsers(String query) {
    List<User> matchingUsers = users.where((user) {
      final userNameLower = user.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return userNameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredUsers = matchingUsers;
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 76, 129),
        title: Text(
          'Search Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        elevation: 5,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                onChanged: (value) => searchUsers(value),
                decoration: InputDecoration(
                  labelText: 'Search Users',
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Color.fromARGB(255, 234, 243, 250),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(user.profileImage!),
                            radius: 25,
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            'View Profile',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.blueAccent),
                          onTap: () {
                            // Navigate to chat page when a user is selected
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>ProfilePage()
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String chatPartnerName;
  final String chatPartnerAvatar;

  ChatPage({required this.chatPartnerName, required this.chatPartnerAvatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Chat with $chatPartnerName'),
      ),
      body: Center(
        child: Text('Chat interface here with $chatPartnerName'),
      ),
    );
  }
}
