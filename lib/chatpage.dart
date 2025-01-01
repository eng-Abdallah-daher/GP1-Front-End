import 'dart:async';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
class ChatPage extends StatefulWidget {
  Chat m;
  ChatPage({required this.m});
  @override
  _ChatPageState createState() => _ChatPageState(chat: m);
}

class _ChatPageState extends State<ChatPage> {
  Chat chat;
  _ChatPageState({required this.chat});
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    inchat = true;
   int i=0;
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
     
     if(inchat){
       try {
          var newMessages = await fetchMessages(chat.id);

          setState(() {
            chat.messages = newMessages;
          });
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } catch (e) {}
     }
    });
  
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.isNotEmpty) {
      setState(() {
        chat.messages.add(Message(
          senderId: global_user.id,
          content: messageText,
          createdAt: DateTime.now(),
        ));
        chat.lastMessage = DateTime.now();
        _controller.clear();
      });
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

 
   Future<void> _pickImage() async {
    String source="";
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        source = pickedFile.path;
      });

      if (kIsWeb) {
        final reader = html.FileReader();

        final bytes = await pickedFile.readAsBytes();
        final fileData =
            html.File([Uint8List.fromList(bytes)], pickedFile.name);

        reader.readAsDataUrl(fileData);
        reader.onLoadEnd.listen((_) async {
          final fileUrl = reader.result as String;
          await uploadImageAndGetOptimizedUrl(fileUrl);
          source = urlofimage;
              _sendMessage('Image: ${source}');
        });
      } else {
        try {
          final fileBytes = await pickedFile.readAsBytes();
          final fileName = pickedFile.name;

          final base64String = base64Encode(fileBytes);
          print('Base64 Encoded String: $base64String');

          final directory = await getApplicationDocumentsDirectory();
          final targetDir = Directory('${directory.path}/images');
          if (!await targetDir.exists()) {
            await targetDir.create(recursive: true);
          }

          final targetFile = File('${targetDir.path}/$fileName');
          await targetFile.writeAsBytes(fileBytes);

          print('Image saved to: ${targetFile.path}');
        } catch (e) {
          print('Error saving image on Mobile: $e');
        }
      }
    }
    setState(() {});
  }
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    inchat=false;
    _controller.dispose();
    _scrollController.dispose();
    _timer?.cancel();
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
            backgroundImage: NetworkImage((widget.m.u1.id == global_user.id)
                ? widget.m.u2.profileImage!
                : widget.m.u1.profileImage!),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (widget.m.u1.id == global_user.id)
                    ? widget.m.u2.name
                    : widget.m.u1.name,
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
        title: Text((widget.m.u1.id == global_user.id)
            ? widget.m.u2.name
            : widget.m.u1.name + "'s Chat Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildChatHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final message = chat.messages[index];
                final isUserMessage = message.senderId == global_user.id;
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
                    try {
                      sendmsg(
                          chatId: chat.id,
                          senderId: global_user.id,
                          text: _controller.text);
                      _sendMessage(_controller.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send message!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
