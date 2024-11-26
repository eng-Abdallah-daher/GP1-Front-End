import 'package:first/chatpage.dart';
import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";

  List<Chat> filteredusers = getuserchats();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
        List<Chat> filt = getuserchats();
        List<Chat> p = [];
        for (int i = 0; i < filt.length; i++) {
          if (filt[i].u1.id == global_user.id) {
            if (filt[i].u2.name.contains(searchQuery)) {
              p.add(filt[i]);
            }
          }
          if (filt[i].u2.id == global_user.id) {
            if (filt[i].u1.name.contains(searchQuery)) {
              p.add(filt[i]);
            }
          }
        }
        filteredusers = p;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  colors: [
                    Colors.blue[200]!,
                    Colors.blue[100]!,
                  ],
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
              itemCount: filteredusers.length,
              itemBuilder: (context, index) {
                final chat = filteredusers[index];

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
                      setState(() {});
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage((chat.u1.id == global_user.id)
                          ? chat.u2.profileImage!
                          : chat.u1.profileImage!),
                      backgroundColor: blueAccent,
                    ),
                    title: Text(
                      (chat.u1.id == global_user.id)
                          ? chat.u2.name
                          : chat.u1.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: white,
                      ),
                    ),
                    subtitle: Text(
                      chat.messages.isEmpty
                          ? "👋"
                          : chat.messages[chat.messages.length - 1].senderId ==
                                  global_user.id
                              ? 'Me:${chat.messages[chat.messages.length - 1].content}'
                              : chat.messages[chat.messages.length - 1].content,
                      style: TextStyle(
                        fontSize: 14,
                        color: chat.messages.length == 0
                            ? Colors.black
                            : Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [],
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

void main() => runApp(MaterialApp(
      home: ChatsPage(),
    ));
