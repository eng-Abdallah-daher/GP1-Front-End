import 'package:first/main.dart';
import 'package:flutter/material.dart';


class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> chats = [
    {
      'name': 'محمد',
      'message': 'Hey, what\'s up?',
      'time': '11:46 am',
      'status': 'pinned'
    },
    {
      'name': 'صندوق العائلة',
      'message': 'Family Event Update!',
      'time': '11:21 am',
      'status': 'muted'
    },
    {
      'name': 'fadi',
      'message': 'You reacted 😂 to: "😂😂😂"',
      'time': '11:18 am'
    },
    {
      'name': '💚🤍All Family🤍💚',
      'message': 'Hey everyone, good morning!',
      'time': '5:57 am',
      'avatarUrl': 'images/logo.png',
    },
    {
      'name': 'مؤسسة التعاون',
      'message': 'Reminder for today\'s meeting.',
      'time': 'Yesterday',
      'status': 'muted',
      'avatarUrl': 'images/avatarimage.png',
    },
  ];

  List<Map<String, String>> filteredChats = [];

  @override
  void initState() {
    super.initState();
    filteredChats = chats;
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
        filteredChats = chats.where((chat) {
          return chat['name']!.toLowerCase().contains(searchQuery);
        }).toList();
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
      appBar: AppBar(
        title: Text('Chats',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {}),
        ],
      ),
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
                cursorColor: Colors.blueAccent,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
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
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                bool isPinned = chat['status'] == 'pinned';
                bool isMuted = chat['status'] == 'muted';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatPartnerName:
                              chat['name']!, 
                          chatPartnerAvatar: chat['avatarUrl'] ??
                              'images/default_avatar.png', 
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(chat['avatarUrl'] ?? ''),
                        backgroundColor: Colors.blueAccent,
                      ),
                      title: Text(
                        chat['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        chat['message'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chat['time'] ?? '',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          if (isPinned)
                            Icon(Icons.push_pin,
                                color: Colors.white70, size: 16),
                          if (isMuted)
                            Icon(Icons.volume_off,
                                color: Colors.white60, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: isSelected,
        backgroundColor: isSelected ? Colors.lightBlueAccent : Colors.blue[100],
        onSelected: (_) {},
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: ChatsPage(),
    ));
