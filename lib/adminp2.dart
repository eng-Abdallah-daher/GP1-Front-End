import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class AdminP2 extends StatefulWidget {
  @override
  _AdminP2State createState() => _AdminP2State();
}

class _AdminP2State extends State<AdminP2> {
  List<User> filteredUsers = [];
  String query = "";

  @override
  void initState() {
m();
    super.initState();
    filteredUsers = users.sublist(1,users.length);
  }

void m() async{
  await getusers();
}
  void searchUsers(String query) {
    final matchingUsers = users.sublist(1,users.length).where((user) {
      final lowerName = user.name.toLowerCase();
      final lowerQuery = query.toLowerCase();
      return lowerName.contains(lowerQuery);
    }).toList();

    setState(() {
      filteredUsers = matchingUsers;
      this.query = query;
    });
  }

  void toggleService(User user) {



    setState(() {
    try{
        updateUserActiveStatus(user.email, !user.isServiceActive);
      user.isServiceActive = !user.isServiceActive;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(user.isServiceActive ? "Service activated" : "Service Deactivated"),
          backgroundColor: blue,
        ));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update service status: $e"),
        backgroundColor: Colors.red,
      ));
    }
      
    });


    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5), 
                  ),
                ],
              ),
              child: TextField(
                onChanged: searchUsers,
                style: TextStyle(fontSize: 16),
                cursorColor: blueAccent,
                decoration: InputDecoration(
                  labelText: "Search Users",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color: blueAccent),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  fillColor: white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueAccent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), 
                  ),
                  elevation: 8,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shadowColor: Colors.grey.withOpacity(0.5), 
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          white,
                          Colors.blueGrey.shade50
                        ], 
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.profileImage!),
                              radius: 35,
                              backgroundColor: Colors
                                  .blueAccent.shade100, 
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          23, 
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    user.phone,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Role: ${user.role}",
                                    style: TextStyle(
                                        color: Colors.blueAccent.shade200,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: user.role == "owner"
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment
                                  .start, 
                          children: [
                            
                            if (user.role == "owner")
                              ElevatedButton(
                                onPressed: () => toggleService(user),
                                child: Text(
                                  user.isServiceActive
                                      ? "Stop Service"
                                      : "Enable Service",
                                  style: TextStyle(color: white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: user.isServiceActive
                                      ? Colors.orangeAccent
                                      : Colors.green,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            
                            ElevatedButton(
                              onPressed: () => showUpdateDialog(user),
                              child: Text("Update",
                                  style: TextStyle(color: white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blueAccent,
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 8), 
                            
                            ElevatedButton(
                              onPressed: () => showDeleteDialog(user),
                              child: Text("Delete",
                                  style: TextStyle(color: white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showUpdateDialog(User user) {
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController phoneController =
        TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: blueAccent),
              SizedBox(width: 8),
              Text(
                "Update User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: blueAccent,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameController,
                  labelText: "Name",
                  icon: Icons.person,
                ),

                SizedBox(height: 12),
                CustomTextField(
                  controller: phoneController,
                  labelText: "Phone",
                  icon: Icons.phone,
                ),
              ],
            ),
          ),
          actions: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {

               try{
                   updateUser(user.email, nameController.text,phoneController.text);
                  user.name = nameController.text;
                  user.phone = phoneController.text;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("User Updated Successfully"),
                      backgroundColor: blue,
                    ));
                  
                }catch(e){  
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Failed to Update User"),
                    backgroundColor: Colors.red,
                  ));
 
               }
                  
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Update",
                style: TextStyle(color: white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever,
                  size: 60,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 16),
                Text(
                  "Delete User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Are you sure you want to delete ${user.name}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          try{
                            setState(() {
                            deleteUser(user.email);
                            users.remove(user);
                            filteredUsers = users..sublist(1, users.length).toList();
                          });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("User Deleted Successfully"),
                                  backgroundColor: blue,
                                ));
                          }catch(Exception){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Failed to Delete User"),
                                  backgroundColor: Colors.red,
                                ));
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blueAccent, width: 2),
        ),
      ),
    );
  }
}
