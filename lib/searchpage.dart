import 'package:first/profile_page.dart';
import 'package:flutter/material.dart';
import 'glopalvars.dart';

class usersearchPage extends StatefulWidget {
  @override
  _usersearchPageState createState() => _usersearchPageState();
}

class _usersearchPageState extends State<usersearchPage> {
  List<User> filteredusers = [];

  String query = "";

  @override
  void initState() {
    super.initState();

    filteredusers = users.sublist(1,users.length);
  }

  void searchusers(String query) {
    List<User> matchingusers = users.sublist(1, users.length).where((user) {
      final userNameLower = user.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return userNameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredusers = matchingusers;
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 76, 129),
        title: Text(
          'Search users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: white,
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
                onChanged: (value) => searchusers(value),
                decoration: InputDecoration(
                  labelText: 'Search users',
                  prefixIcon: Icon(Icons.search, color: blueAccent),
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
            child: filteredusers.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredusers.length,
                    itemBuilder: (context, index) {
                      final user = filteredusers[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: white,
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
                              color: blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: blueAccent),
                          onTap: () {
                            fromsearch = true;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  user: user,
                                ),
                              ),
                            );
                            setState(() {});
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
