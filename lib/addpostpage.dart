import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _postController = TextEditingController();
  String? _selectedImage;
  bool _isHovering = false;
  List<String> suggestedImages = [
    'images/logo.png',
    'images/logo3.png',
    'images/logo4.png',
    'images/logo5.png',
    'images/logo6.png',
  ];

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
      });
    }
  }

  void _selectSuggestedImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _selectedImage != null
                          ? Image.asset(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 300,
                            )
                          : Container(
                              height: 300,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                            ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: TextField(
                        controller: _postController,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your text here...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Choose an Image:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      ...suggestedImages.map((imagePath) => GestureDetector(
                            onTap: () => _selectSuggestedImage(imagePath),
                            child: AnimatedContainer(
                              width: 60,
                              height: 60,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8), 
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 3), 
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    
                                    Image.asset(
                                      imagePath,
                                      width: 60, 
                                      height: 60, 
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xFF0F3460).withOpacity(0.6)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    
                                    Align(
                                      alignment: Alignment.center,
                                      child: AnimatedOpacity(
                                        opacity: _selectedImage == imagePath
                                            ? 1.0
                                            : 0.0,
                                        duration: Duration(milliseconds: 200),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Selected',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, 
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), 
                  ),
                  elevation: 8, 
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                  side: BorderSide(
                      color: Colors.blue,
                      width: 2), 
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.transparent), 
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.blue
                      ], 
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30), 
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.upload, 
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  
                  if (_postController.text.isEmpty) {
                    _showMessage('Please enter text for your post');
                    return;
                  }

                  
                  if (_selectedImage == null) {
                    _showMessage('Please select or upload an image');
                    return;
                  }

                  _showMessage('Post added successfully!');

                  print('Post Details:');
                  print('Text: ${_postController.text}');
                  print('Image Path: ${_selectedImage ?? "No image selected"}');
                  posts.add(Post(
                      id: posts.length,
                      ownerId: global_user.id,
                      description: _postController.text,
                      postImage: _selectedImage.toString(),
                      createdAt: DateTime.now()));
                  _postController.clear();
                  setState(() {
                    _selectedImage = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, 
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                  elevation: 8, 
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                  side: BorderSide(
                      color: Colors.blue,
                      width: 2), 
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.transparent), 
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.blue
                      ], 
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    alignment: Alignment.center,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, 
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
