import 'package:CarMate/chatpage.dart';
import 'package:CarMate/commentpage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
   User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

    @override
  void initState() {
    super.initState();

  // m();
  }
  void m() async{
    await getposts();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fromsearch
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  fromsearch = false;
                  setState(() {});
                },
              ),
              title: Text(
                widget.user.name + "'s Profile Page",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              elevation: 4,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            )
          : null,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildCoverPhoto(context),
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildUserName(),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildUserLocation(),
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildProfilePicture(),
                  ),
                ),
              ],
            ),
            ((widget.user.id != global_user.id)&&(widget.user.role == "owner")&&(widget.user.isServiceActive) )
                ? _buildActionButtons()
                : SizedBox(
                    height: 30,
                  ),
            _buildStats(),
            _buildContactInfo(),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Text(
      widget.user.name,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  List<Post> getUserPosts() {
    return posts.where((post) => post.ownerId == widget.user.id).toList();
  }

  Widget _buildPostsSection() {
    List<Post> userPosts = getUserPosts();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...userPosts.map((post) => _buildPostCard(post)).toList(),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    bool isLiked = false;
    bool is_liked() {
      for (int i = 0; i < post.likes.length; i++) {
        if (post.likes[i].userId == global_user.id) {
          post.likeCount = post.likes.length;
          isLiked = true;

          return true;
        }
      }
      return false;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(users
                        .sublist(1, users.length)
                        .where((element) => element.id==widget.user.id,).toList()[0].profileImage!),
                    radius: 28,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: black,
                        ),
                      ),
                      Text(
                        _timeAgo(post.createdAt),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.5)),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  post.postImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(12),
                child: Text(
                  post.description,
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        is_liked()
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        color: isLiked ? blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                          if (isLiked) {
                                    try {
                              addLikeToPost(post.id, global_user.id);
                            post.likes
                                  .add(Like(userId: global_user.id));
                             post.likeCount =post.likes.length;
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Failed to like the post'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          } else {
                            for (int i = 0; i < post.likes.length; i++) {
                              if (post.likes[i].userId == global_user.id) {
                                post.likes.removeAt(i);
                                post.likeCount = post.likes.length;

                                break;
                              }
                            }
                          }
                        });
                      },
                    ),
                    Text('${post.likeCount} Likes',
                        style: TextStyle(color: black)),
                  ],
                ),
                Text('${post.comments.length} Comments',
                    style: TextStyle(color: black)),
                IconButton(
                  icon: Icon(Icons.share, color: black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(post: post),
                  ),
                );

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blue, lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: black,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.comment, color: white),
                    SizedBox(width: 10),
                    Text(
                      'View All Comments',
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime timestamp) {
    final duration = DateTime.now().difference(timestamp);
    if (duration.inDays >= 30) {
      if ((duration.inDays ~/ 30) == 1) {
        return '${duration.inDays ~/ 30} month ago';
      }
      return '${duration.inDays ~/ 30} months ago';
    }
    if (duration.inDays > 0) return '${duration.inDays}d ago';
    if (duration.inHours > 0) return '${duration.inHours}h ago';
    if (duration.inMinutes > 0) return '${duration.inMinutes}m ago';

    return 'Just now';
  }

  Widget _buildUserLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          color: Colors.lightBlue,
          size: 20,
        ),
        SizedBox(width: 1),
        Text(
          widget.user.locatoin!,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCoverPhoto(BuildContext context) {
    return ClipPath(
      clipper: SlantedClipper(),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              startAngle: 3.39,
              endAngle: 3.4,
              colors: [
                Colors.orange,
                Colors.orange,
                Colors.white,
              ],
              stops: [0.3, 0.6, 0.0],
            ),
          ),
        ),
        CircleAvatar(
          radius: 51,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(widget.user.profileImage!),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text(
                "About Me",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.grey,
              ),
              SizedBox(width: 10),
              Icon(Icons.circle, size: 10, color: Colors.grey),
              SizedBox(width: 10),
              Icon(Icons.circle, size: 10, color: Colors.grey),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                widget.user.description!,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn("238", "Posts"),
              Container(
                height: 40,
                width: 1,
                color: Colors.blue,
              ),
              _buildInfoColumn("238", "Followers"),
              Container(
                height: 40,
                width: 1,
                color: Colors.blue,
              ),
              _buildInfoColumn("238", "Following"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          _buildActionButton(Icons.call, () {}),
          SizedBox(
            width: 160,
          ),
          _buildActionButton(Icons.message, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(m: chats[0]),
              ),
            );
          }),
          SizedBox(
            width: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Function g) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 40,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (icon == Icons.message) {
                    for (int i = 0; i < chats.length; i++) {
                      if (chats[i].u1.id == global_user.id &&
                          chats[i].u2.id == widget.user.id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(m: chats[i]),
                          ),
                        );
                        return;
                      }
                      if (chats[i].u2.id == global_user.id &&
                          chats[i].u1.id == widget.user.id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(m: chats[i]),
                          ),
                        );
                        return;
                      }
                    }

                   try{
                     createChat(chats.length, global_user.id, widget.user.id);
                    chats.add(Chat(
                        lastMessage: DateTime.now(),
                        id: chats.length,
                        messages: [],
                        u1: global_user,
                        u2: widget.user));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(m: chats[chats.length - 1]),
                      ),
                    );
                   }catch(e){
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create a chat'),backgroundColor:Colors.red,),
                      );
                   }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        children: [
          _buildContactRow(Icons.email, widget.user.email),
          SizedBox(height: 10),
          _buildContactRow(Icons.cake, "March 15, 1993"),
          SizedBox(height: 10),
          _buildContactRow(Icons.person, "Male"),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Text(info, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildFollowButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          "Follow",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialIconButton('images/logo.png'),
          SizedBox(width: 20),
          _buildSocialIconButton('images/logo.png'),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Image.asset(
        imagePath,
        width: 40,
        height: 40,
      ),
    );
  }
}

class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
