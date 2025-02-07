import 'package:flutter/material.dart';
import 'package:CarMate/chats.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/searchpage.dart';
import 'package:CarMate/servicepage.dart';
import 'package:CarMate/morepage.dart';
import 'package:CarMate/sospage.dart';
import 'package:CarMate/map.dart';
import 'package:CarMate/posts.dart';

class usermainpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int numberofmessages=0;
  int _selectedIndex = index;

  bool flag = true;
  List<Widget> _pages = [
    PostsApp(),
    ServicesPage(),
    SOSPage(),
    MorePage(),
    MapPage(),
  ];

  void _onItemTapped(int index) async{
   

    setState(()  {
     
      _selectedIndex = index;
    });
     if (_selectedIndex == 0) {
      await getposts();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => usermainpage(),
        ),
      );
    }
    setState(() {});
  }

  Widget _buildButton(IconData icon, String label, int index) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: _selectedIndex == index ? blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton(String imagePath, String label, int index) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 29,
            width: 29,
            color: _selectedIndex == index ? blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
@override
  void initState() {
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 234, 243, 250),
        elevation: 5,
        title: Text(
          'CarMate',
          style: TextStyle(
            fontSize: 15,
            color: black,
            letterSpacing: 1.7,
            shadows: [
              Shadow(
                color: black.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        actions: [
          Container(
              width: 40,
              height: 40,
              decoration: _selectedIndex == 0
                  ? BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: black.withOpacity(0.2),
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        ),
                      ],
                    )
                  : BoxDecoration(),
              child: _selectedIndex == 0
                  ? Stack(
  children: [
    IconButton(
      icon: Icon(
        flag ? Icons.message : Icons.people_alt_sharp,
        size: 25,
        color: white,
      ),
      onPressed: () {
        flag = !flag;
        getAllChats();
        setState(() {});
      },
      splashRadius: 50,
      splashColor: white.withOpacity(0.5),
      highlightColor: white.withOpacity(0.3),
      padding: EdgeInsets.all(1),
    ),
 if(flag&&(getuserchats()
                                .where(
                                  (element) =>
                                      (element.messages.isNotEmpty
                                          ? element.messages.last.senderId !=
                                              global_user.id
                                          : false) &&
                                      (element.messages.isNotEmpty
                                          ? element.messages.last.isread ==
                                              false
                                          : false),
                                )
                                .isNotEmpty))
    Positioned(
      right: -2,
      top: -2,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '${getuserchats().where(
                                      (element) => (element.messages.isNotEmpty?element.messages.last.senderId !=
                                              global_user.id:false)&&(element.messages.isNotEmpty?element.messages.last.isread==false:false),
                                    ).length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
)
                  : null),
          SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 7,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.search,
                size: 25,
                color: white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => usersearchPage(),
                  ),
                );
              },
              splashRadius: 50,
              splashColor: white.withOpacity(0.5),
              highlightColor: white.withOpacity(0.3),
              padding: EdgeInsets.all(1),
            ),
          ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(global_user.profileImage!),
              radius: 22,
              backgroundColor: white,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
              setState(() {});
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          flag ? PostsApp() : ChatsPage(),
          ServicesPage(),
          SOSPage(),
          MorePage(),
          MapPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 226, 235, 242),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildButton(Icons.home, 'Home', 0),
                  _buildButton(Icons.build, 'Services', 1),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildImageButton('images/sosheadset.png', 'SOS', 2),
                  _buildImageButton('images/more.png', 'More', 3),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(4);
        },
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('images/map.png'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: blue,
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 90, 172, 240),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SectionBlock(
              title: 'Exclusive Offers',
              content: 'Get 20% off on your first car repair service.',
              color: white,
              icon: Icons.local_offer,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Car Maintenance Tips',
              content: 'Make sure to check your tire pressure monthly.',
              color: white,
              icon: Icons.tips_and_updates,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Featured Services',
              content: 'Comprehensive service at 10% off.',
              color: white,
              icon: Icons.star,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Previous Requests',
              content: 'Last gas station you visited: Quick Fuel Station.',
              color: white,
              icon: Icons.history,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Maintenance Notifications',
              content: 'Engine oil change due in 5 days.',
              color: white,
              icon: Icons.notifications,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'User Reviews',
              content: 'Repair shop "Advanced" rated 4.5 out of 5.',
              color: white,
              icon: Icons.rate_review,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Favorites',
              content: 'Your favorite repair shops.',
              color: white,
              icon: Icons.favorite,
            ),
            SizedBox(height: 16),
            SectionBlock(
              title: 'Points',
              content: 'Total points earned in the app.',
              color: white,
              icon: Icons.podcasts,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionBlock extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final IconData icon;

  SectionBlock({
    required this.title,
    required this.content,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 40, color: Color(0xFF5AACF0)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
