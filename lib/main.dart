
import 'package:first/BillingPaymentPage.dart';
import 'package:first/EmergencyTowingPage.dart';
import 'package:first/GetEstimatePage.dart';
import 'package:first/InventoryManagementPage.dart';
import 'package:first/MaintenanceHistoryPage%20.dart';
import 'package:first/OfferManagementPage.dart';
import 'package:first/OffersNotificationsPage%20.dart';
import 'package:first/ViewWorkshopRatingsPage%20.dart';
import 'package:first/aboutuspage.dart';
import 'package:first/chatss.dart';
import 'package:first/empmng.dart';
import 'package:first/glopalvars.dart';
import 'package:first/maintanancereminder.dart';
import 'package:first/maintanancerequestt.dart';
import 'package:first/managebookings.dart';
import 'package:first/morepage.dart';
import 'package:first/offellist.dart';
import 'package:first/posts.dart';
import 'package:first/profile.dart';
import 'package:first/repairstatus.dart';
import 'package:first/requestcardelivary.dart';
import 'package:first/search.dart';
import 'package:first/sellpage.dart';
import 'package:first/servicepage.dart';
import 'package:first/sospage.dart';
import 'package:flutter/material.dart';



class Message {
  final int id;
  final int senderId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
}

class ChatPage extends StatefulWidget {
  String chatPartnerName; 
  String chatPartnerAvatar; 

  ChatPage({required this.chatPartnerName, required this.chatPartnerAvatar});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [
    Message(
      id: 1,
      senderId: 2,
      content: "Hey there! How are you?",
      createdAt: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Message(
      id: 2,
      senderId: 1,
      content: "I'm good, thanks! What about you?",
      createdAt: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    Message(
      id: 3,
      senderId: 2,
      content: "Just working on a project. It's going well!",
      createdAt: DateTime.now().subtract(Duration(minutes: 3)),
    ),
    Message(
      id: 4,
      senderId: 1,
      content: "That's great to hear! Need any help?",
      createdAt: DateTime.now().subtract(Duration(minutes: 2)),
    ),
    Message(
      id: 5,
      senderId: 2,
      content: "Actually, yes! I'm stuck on a Flutter issue.",
      createdAt: DateTime.now().subtract(Duration(minutes: 1)),
    ),
    Message(
      id: 6,
      senderId: 1,
      content: "I'd be happy to help! What's the issue?",
      createdAt: DateTime.now(),
    ),
    Message(
      id: 7,
      senderId: 2,
      content: "I'm trying to implement image picking.",
      createdAt: DateTime.now(),
    ),
    Message(
      id: 8,
      senderId: 1,
      content: "I can show you some code if you want!",
      createdAt: DateTime.now(),
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  
  final ScrollController _scrollController =
      ScrollController(); 

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add(Message(
          id: messages.length + 1, 
          senderId: 1, 
          content: messageText,
          createdAt: DateTime.now(),
        ));
        _controller.clear();
      });
      
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _pickImage() async {
    
    
    
    
    
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose(); 
    _scrollController.dispose(); 
    super.dispose();
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(widget.chatPartnerAvatar),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatPartnerName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Online',
                style: TextStyle(color: Colors.greenAccent, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerName + "'s Chat Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          
          _buildChatHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, 
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage =
                    message.senderId == 1; 

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: isUserMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: TextStyle(
                                color:
                                    isUserMessage ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _formatTimestamp(message.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(home: BillingPaymentPage(),));
  // runApp();
}