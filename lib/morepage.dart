import 'dart:io';
// import 'package:first/AboutUsPage.dart';
// import 'package:first/chatpage.dart';
// import 'package:first/customizetheme.dart';
import 'package:first/aboutuspage.dart';
import 'package:first/customizetheme.dart';
import 'package:first/forlogin.dart';
import 'package:first/glopalvars.dart';
// import 'package:first/languagesettings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:first/updateinfo.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:first/changepassword.dart';
// import 'package:first/notifactionsettings.dart';
// import 'package:image_picker/image_picker.dart';

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
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : AssetImage(global_user.profileImage!) as ImageProvider,
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
                subtitle: 'Change name, email, or phone',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => UpdatePersonalInfoPage()),
                  // );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ChangePasswordPage()),
                  // );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.notifications,
                title: 'Notification Settings',
                subtitle: 'Customize your notifications',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => NotificationSettingsPage()),
                  // );
                },
              ),
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
              _buildListTile(
                context,
                icon: Icons.language,
                title: 'Language Settings',
                subtitle: 'Select your preferred language',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => LanguageSettingsPage()),
                  // );
                },
              ),
              SizedBox(height: 16),
              _buildSectionHeader('Support and Help'),
              global_user.role == "owner"
                  ? _buildListTile(
                      context,
                      icon: Icons.help_outline,
                      title: 'Contact Us',
                      subtitle: 'make a chat with the admin',
                      onTap: () {
                        bool loged = false;
                        for (int i = 0; i < chats.length; i++) {
                          if ((chats[i].u1 == global_user.id &&
                                  chats[i].u2 == users[0].id) ||
                              (chats[i].u2 == global_user.id &&
                                  chats[i].u1 == users[0].id)) {
                            loged = true;
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ChatPage(m: chats[i])),
                            // );
                            break;
                          }
                        }
                        if (!loged) {
                          chats.add(Chat(
                              lastMessage: DateTime.now(),
                              id: chats.length,
                              messages: [],
                              u1: global_user,
                              u2: users[0]));

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           ChatPage(m: chats[chats.length - 1])),
                          // );
                        }
                      },
                    )
                  : SizedBox(
                      height: 0,
                    ),
              _buildListTile(
                context,
                icon: Icons.help_outline,
                title: 'FAQs',
                subtitle: 'Find answers to common questions',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.contact_support,
                title: 'Customer Support',
                subtitle: 'Email or call for assistance',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.report,
                title: 'Report an Issue',
                subtitle: 'Let us know about any problems',
                onTap: () {},
              ),
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
                onTap: () {},
              ),
              SizedBox(height: 16),
              _buildSectionHeader('Reviews and Ratings'),
              _buildListTile(
                context,
                icon: Icons.star_rate,
                title: 'Rate the App',
                subtitle: 'Share your feedback and rating',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.comment,
                title: 'Read User Reviews',
                subtitle: 'See what others are saying',
                onTap: () {},
              ),
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
              SizedBox(height: 16),
              _buildSectionHeader('Updates and Offers'),
              _buildListTile(
                context,
                icon: Icons.local_offer,
                title: 'Exclusive Offers',
                subtitle: 'Check out our latest deals',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.new_releases,
                title: 'App Updates',
                subtitle: 'Learn about new features',
                onTap: () {},
              ),
              SizedBox(height: 16),
              _buildSectionHeader('Activity Log'),
              _buildListTile(
                context,
                icon: Icons.history,
                title: 'Emergency Requests',
                subtitle: 'View past emergency help requests',
                onTap: () {},
              ),
              _buildListTile(
                context,
                icon: Icons.search,
                title: 'Search History',
                subtitle: 'See your search activity',
                onTap: () {},
              ),
              SizedBox(height: 16),
              _buildSectionHeader('Logout'),
              _buildListTile(
                context,
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () {
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
