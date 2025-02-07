import 'dart:io';
import 'package:CarMate/AboutUsPage.dart';
import 'package:CarMate/PrivacyPolicyPage.dart';
import 'package:CarMate/chatpage.dart';
import 'package:CarMate/customizetheme.dart';
import 'package:CarMate/login.dart';
import 'package:CarMate/glopalvars.dart';
// import 'package:CarMate/languagesettings.dart';
import 'package:flutter/material.dart';
import 'package:CarMate/updateinfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:CarMate/changepassword.dart';
// import 'package:CarMate/notifactionsettings.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';

class Mor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      home: MorePage(),
    );
  }
}

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
    m();
  }

  void m() {
    print(global_rate);
    getglobal_rate();
    print(global_rate);
    setState(() {});
  }

  File? _image;

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
          _image = File(urlofimage);
          updateUserprofileimage(global_user.email, urlofimage);
          global_user.profileImage = urlofimage;
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

  Widget _buildUserInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [blueAccent, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await _pickImage();
              print("\nuserimage:\n" + urlofimage + "\nuserimage:\n");
              global_user.profileImage = _image!.path;
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _image != null
                  ? NetworkImage(_image!.path)
                  : NetworkImage(global_user.profileImage!) as ImageProvider,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                global_user.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                global_user.email,
                style: TextStyle(
                  fontSize: 12,
                  color: white,
                ),
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
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfoSection(),
              _buildSectionHeader('Account Settings'),
              _buildListTile(
                context,
                icon: Icons.account_circle,
                title: 'Update Personal Info',
                subtitle: 'Change name, or phone',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePersonalInfoPage()),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()),
                  );
                },
              ),
              // _buildListTile(
              //   context,
              //   icon: Icons.notifications,
              //   title: 'Notification Settings',
              //   subtitle: 'Customize your notifications',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => NotificationSettingsPage()),
              //     );
              //   },
              // ),
              SizedBox(height: 16),
              _buildSectionHeader('App Settings'),
              _buildListTile(
                context,
                icon: Icons.palette,
                title: 'Customize Theme',
                subtitle: 'Change app colors and appearance',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomizeThemePage()),
                  );
                },
              ),
              // _buildListTile(
              //   context,
              //   icon: Icons.language,
              //   title: 'Language Settings',
              //   subtitle: 'Select your preferred language',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => LanguageSettingsPage()),
              //     );
              //   },
              // ),
              SizedBox(height: global_user.role == "owner" ? 16 : 0),
              global_user.role == "owner"
                  ? _buildSectionHeader('Support and Help')
                  : SizedBox(
                      height: 0,
                    ),
              global_user.role == "owner"
                  ? _buildListTile(
                      context,
                      icon: Icons.help_outline,
                      title: 'Contact Us',
                      subtitle: 'make a chat with the admin',
                      onTap: () async{
                        await getAllChats();
                   
                     List<Chat> chatList =getuserchats().where((element) => (element.u2.id == -1&&element.u1.id==global_user.id)||
                                (element.u1.id == -1 &&
                                    element.u2.id == global_user.id)).toList();
                        if (chatList.isEmpty) {
                          try {
                            createChat(chats[chats.length - 1].id + 1,
                                global_user.id, users[0].id);
                            chats.add(Chat(
                                lastMessage: DateTime.now(),
                                id: chats[chats.length - 1].id + 1,
                                messages: [],
                                u1: global_user,
                                u2: users[0]));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(m: chats[chats.length - 1])),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("failed to create a new chat!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(m: chatList[0])),
                          );
                        }
                      },
                    )
                  : SizedBox(
                      height: 0,
                    ),
              // _buildListTile(
              //   context,
              //   icon: Icons.help_outline,
              //   title: 'FAQs',
              //   subtitle: 'Find answers to common questions',
              //   onTap: () {},
              // ),
              // _buildListTile(
              //   context,
              //   icon: Icons.contact_support,
              //   title: 'Customer Support',
              //   subtitle: 'Email or call for assistance',
              //   onTap: () {},
              // ),
              // _buildListTile(
              //   context,
              //   icon: Icons.report,
              //   title: 'Report an Issue',
              //   subtitle: 'Let us know about any problems',
              //   onTap: () {},
              // ),
              SizedBox(height: 16),
              _buildSectionHeader('About the App'),
              _buildListTile(
                context,
                icon: Icons.info_outline,
                title: 'About Us',
                subtitle: 'Learn about the company',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.update,
                title: 'App Version',
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.policy,
                title: 'Terms and Privacy',
                subtitle: 'Review terms and privacy policies',
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildSectionHeader('Reviews and Ratings'),
              _buildListTile(
                context,
                icon: Icons.star_rate,
                title: 'Rate the App',
                subtitle: 'Share your feedback and rating ,${global_rate}',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      int _rating = global_user.rate;
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            backgroundColor: blueAccent,
                            title: Text(
                              'Rate the App',
                              style: TextStyle(
                                color: white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _rating = index + 1;
                                        });
                                      },
                                      child: Icon(
                                        index < _rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: index < _rating
                                            ? Colors.yellow
                                            : white,
                                        size: 40,
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Rating: $_rating',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _rating = 0;
                                    global_user.rate = 0;
                                    updateRate(global_user.id, 0);
                                  });
                                  getglobal_rate();
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Clear Rate',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_rating >= 1 && _rating <= 5) {
                                    print('Rating Submitted: $_rating');

                                    global_user.rate = _rating;
                                    updateRate(global_user.id, _rating);
                                    getglobal_rate();
                                    setState(() {});
                                  } else {
                                    print('Invalid Rating');
                                  }
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              // _buildListTile(
              //   context,
              //   icon: Icons.comment,
              //   title: 'Read User Reviews',
              //   subtitle: 'See what others are saying',
              //   onTap: () {},
              // ),
              SizedBox(height: 16),
              _buildSectionHeader('Social Links'),
              _buildListTile(
                context,
                icon: Icons.facebook,
                title: 'Facebook',
                subtitle: 'Follow us on Facebook',
                onTap: () async {
                  await launch("https://facebook.com");
                },
              ),
              _buildListTile(
                context,
                icon: Icons.transfer_within_a_station_rounded,
                title: 'Twitter',
                subtitle: 'Follow us on Twitter',
                onTap: () async {
                  await launch("https://x.com/?lang=en");
                },
              ),
              _buildListTile(
                context,
                icon: Icons.interests_sharp,
                title: 'Instagram',
                subtitle: 'Follow us on Instagram',
                onTap: () async {
                  await launch("https://instagram.com");
                },
              ),
            
            
              // _buildListTile(
              //   context,
              //   icon: Icons.local_offer,
              //   title: 'Exclusive Offers',
              //   subtitle: 'Check out our latest deals',
              //   onTap: () {},
              // ),
              // _buildListTile(
              //   context,
              //   icon: Icons.new_releases,
              //   title: 'App Updates',
              //   subtitle: 'Learn about new features',
              //   onTap: () {},
              // ),
              // SizedBox(height: 16),
              // _buildSectionHeader('Activity Log'),
              // _buildListTile(
              //   context,
              //   icon: Icons.history,
              //   title: 'Emergency Requests',
              //   subtitle: 'View past emergency help requests',
              //   onTap: () {},
              // ),
              // _buildListTile(
              //   context,
              //   icon: Icons.search,
              //   title: 'Search History',
              //   subtitle: 'See your search activity',
              //   onTap: () {},
              // ),
              SizedBox(height: 16),
              _buildSectionHeader('Logout'),
              _buildListTile(
                context,
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () {
                  updateUserStatus(global_user.email, false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarServiceLoginApp()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      String? subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: blueAccent),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(Icons.arrow_forward_ios, color: blueAccent),
      onTap: onTap,
    );
  }
}

Future<void> openUrl(String url) async {
  if (url.isNotEmpty && await canLaunch(url)) {
    await launch(url);
  }
}
