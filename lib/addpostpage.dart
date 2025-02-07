import 'dart:convert';
import 'dart:io';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

@override
  void initState(){
    
    super.initState();
   
getposts();

  }

  final TextEditingController _postController = TextEditingController();
  String? _selectedImage;
  bool _isHovering = false;
  List<String> suggestedImages = [
    'https://media.istockphoto.com/id/1373267042/vector/abstract-multicolored-blurred-gradient-background-soft-gradient-background-for-use-in.jpg?s=612x612&w=0&k=20&c=jDPwsgO2PL4HJWXwBR5UxHl3Oem-xiu9fbo_zgiG684=',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSkmBQQbiExuxyWu7U83io6qezHOPPUI9oeA&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ85neARAFrLS6qlxsmdlG3s35OUtS-c0KojA&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyoaYBFVC26UIb1YHh5sfRiMyqCRhPmn_5xg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhXPwI31KEnjKpAJrs8RKg4omGjDGX3OIp5w&s',
  ];
  // void _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = pickedFile.path;
  //     });
  //   }
  // }
  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
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
        _selectedImage=urlofimage;
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
    setState(() {
      
    });
  }

  void _selectSuggestedImage(String imagePath) {
    setState(() {
      _selectedImage = imagePath;
    });
  }

  void _showMessage(String message,Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message),
        backgroundColor: color,
        
        )
        
        );
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
                          ? Image.network(
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
                                black.withOpacity(0.7),
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
                          color: white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your text here...',
                          hintStyle: TextStyle(
                            color: white.withOpacity(0.7),
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
                                    color: black.withOpacity(0.2),
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
                                    
                                    Image.network(
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
                                                white.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Selected',
                                            style: TextStyle(
                                                color: black,
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
                  shadowColor: blueAccent.withOpacity(0.3),
                  side: BorderSide(
                      color: blue,
                      width: 2), 
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.transparent), 
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        blueAccent,
                        blue
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
                          color: white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                white, 
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
                    _showMessage('Please enter text for your post',Colors.red);
                    return;
                  }

                  
                  if (_selectedImage == null) {
                    _showMessage('Please select or upload an image',Colors.red);
                    return;
                  }
                try{

                
                    
                if(posts.isEmpty){
                  addPost(
                          DateTime.now(),
                          0,
                          _postController.text,
                          global_user.id,
                          _selectedImage.toString());
                    posts.add(Post(
                          id: 0,
                          ownerId: global_user.id,
                          description: _postController.text,
                          postImage: _selectedImage.toString(),
                          createdAt: DateTime.now()));
                }else{
                  addPost(
                          DateTime.now(),
                          posts[posts.length - 1].id + 1,
                          _postController.text,
                          global_user.id,
                          _selectedImage.toString());
                          
                            posts.add(Post(
                      id:  posts[posts.length - 1].id + 1,
                      ownerId: global_user.id,
                      description: _postController.text,
                      postImage: _selectedImage.toString(),
                      createdAt: DateTime.now()));
                }

          _showMessage('Post added successfully!',Colors.green);
                  _postController.clear();
                  setState(() {
                    _selectedImage = null;
                  });
                }catch(e){
print(e);
                  _showMessage('Failed to post!',Colors.red);
                }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, 
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                  elevation: 8, 
                  shadowColor: blueAccent.withOpacity(0.3),
                  side: BorderSide(
                      color: blue,
                      width: 2), 
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.transparent), 
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        blueAccent,
                        blue
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
