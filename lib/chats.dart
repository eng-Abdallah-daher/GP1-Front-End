import 'dart:async';
import 'package:CarMate/chatpage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer;
  String searchQuery = "";
  List<Chat> filteredUsers = getuserchats();
bool _isDisposed=false;
  @override
  void initState() {
    super.initState();
inchat=true;
    
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
        filterChats();
      });
    });

    
 
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      
      if (_isDisposed) return; 
      if (inchat) {
        await getAllChats();
        if (!_isDisposed) {
          setState(() {
            filterChats();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
     inchat = false;
     _timer?.cancel(); 
    
    _searchController.dispose();
   
    super.dispose();
  }

  
  void filterChats() {
    List<Chat> allChats = getuserchats();
    filteredUsers = allChats.where((chat) {
      if (chat.u1.id == global_user.id) {
        return chat.u2.name.toLowerCase().contains(searchQuery);
      } else if (chat.u2.id == global_user.id) {
        return chat.u1.name.toLowerCase().contains(searchQuery);
      }
      return false;
    }).toList();
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
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: blueAccent,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  hintStyle: TextStyle(color: white.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: blueAccent),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final chat = filteredUsers[index];
                final isCurrentUser = chat.u1.id == global_user.id;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.lightBlueAccent.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      fromsearch = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(m: chat),
                        ),
                      );
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        isCurrentUser
                            ? chat.u2.profileImage!
                            : chat.u1.profileImage!,
                      ),
                      backgroundColor: blueAccent,
                    ),
                    title: Text(
                      isCurrentUser ? chat.u2.name : chat.u1.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: white,
                      ),
                    ),
                    subtitle: Text(
                      chat.messages.isEmpty
                          ? "👋 No messages yet"
                          : chat.messages.last.senderId == global_user.id
                              ? 'Me: ${chat.messages.last.content}'
                              : chat.messages.last.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: chat.messages.isEmpty
                            ? Colors.black
                            : Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: white,
    );
  }
}
