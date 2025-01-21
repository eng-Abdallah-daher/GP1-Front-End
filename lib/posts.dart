import 'package:CarMate/commentpage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:CarMate/profile_page.dart';
import 'package:share_plus/share_plus.dart';




class PostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PostsPage extends StatefulWidget {
  PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
  m();
     
  }
void m() async{
  await getposts();
  setState(() {
    
  });
}
  void _removePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(
            post: posts[posts.length - 1 - index],
            onDelete: () => _removePost(posts.length - 1 - index),
          );
        },
      ),
    );
  }

}

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onDelete;

  PostCard({required this.post, required this.onDelete});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool is_liked() {
    for (int i = 0; i < widget.post.likes.length; i++) {
      if (widget.post.likes[i].userId == global_user.id) {
        widget.post.likeCount = widget.post.likes.length;
        isLiked = true;

        return true;
      }
    }
    return false;
  }

  bool isLiked = false;

  _PostCardState();

  String getTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final duration = DateTime.now().difference(timestamp);
    if (duration.inDays >= 30) {
      if ((duration.inDays ~/ 30) == 1) {
        return '${duration.inDays ~/ 30} month ago';
      }
      return '${duration.inDays ~/ 30} months ago';
    }
    if (difference.inHours > 23) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _reportPost() {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: lightBlue,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Please provide a reason for reporting this post:',
                  style: TextStyle(color: black),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  cursorColor: lightBlue,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Enter your reason here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blue, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(lightBlue),
                        foregroundColor: MaterialStateProperty.all(white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        String reason = reasonController.text.trim();
                        if (reason.isNotEmpty) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Post reported successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Please enter a reason to report.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editPost(BuildContext context) async {
    final updatedDescription = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: widget.post.description);

        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Your Post',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: lightBlue,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: controller,
                  cursorColor: lightBlue,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: blue, width: 2),
                    ),
                  ),
                  maxLines: 4,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(lightBlue),
                        foregroundColor: MaterialStateProperty.all(white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      child: Text('Save', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        Navigator.pop(context, controller.text);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (updatedDescription != null && updatedDescription.isNotEmpty) {
      setState(() {
        widget.post.description = updatedDescription;
      });
    }
  }

  void _deletePost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: lightBlue,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Are you sure you want to delete this post?',
                  style: TextStyle(
                    fontSize: 16,
                    color: black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(lightBlue),
                        foregroundColor: MaterialStateProperty.all(white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      child: Text('Delete', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onDelete();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 250,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            (widget.post.ownerId == global_user.id)
                    ?    ListTile(
                leading: Icon(Icons.edit, color: blue),
                title: Text('Edit Post'),
                onTap: () {
                  Navigator.pop(context);
                  _editPost(context);
                },
              )
                  : SizedBox(
                      height: 0,
                    ),
               (widget.post.ownerId == global_user.id)
                    ? Divider() : SizedBox(
                      height: 0,
                    ),

             (widget.post.ownerId == global_user.id)
                    ?   ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Post'),
                onTap: () {
                  Navigator.pop(context);
                  deletepost(widget.post.id);
                  _deletePost();
                },
              ) : SizedBox(
                      height: 0,
                    ),
               (widget.post.ownerId == global_user.id)
                    ? Divider() : SizedBox(height: 0,),
              ListTile(
                leading: Icon(Icons.report, color: Colors.orange),
                title: Text('Report Post'),
                onTap: () {
                  Navigator.pop(context);
                  _reportPost();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAvatarTapped() {
    fromsearch = false;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: users.sublist(1,users.length)
              .where(
                (element) => element.id == widget.post.ownerId,
              )
              .toList()[0],
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: _onAvatarTapped,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(users
                        .sublist(1, users.length)
                        .where((element) => element.id==widget.post.ownerId,).toList()[0].profileImage!),
                    radius: 28,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        users
                            .sublist(1, users.length)
                            .where(
                              (element) => element.id == widget.post.ownerId,
                            )
                            .toList()[0]
                            .name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: black,
                        ),
                      ),
                      Text(
                        getTimeDifference(widget.post.createdAt),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
               IconButton(
                        icon: Icon(Icons.more_horiz, color: black),
                        onPressed: () => _showMoreOptions(context),
                      )
                   
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.5)),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  widget.post.postImage,
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
                  widget.post.description,
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
                    GestureDetector(
                      onLongPress: () {
                        _showReactionsMenu(context);
                      },
                      child: IconButton(
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
                                addLikeToPost(widget.post.id, global_user.id);
                                widget.post.likes
                                    .add(Like(userId: global_user.id));
                                widget.post.likeCount =
                                    widget.post.likes.length;
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to like the post'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              for (int i = 0;
                                  i < widget.post.likes.length;
                                  i++) {
                                if (widget.post.likes[i].userId ==
                                    global_user.id) {
                                  removeLikeFromPost(widget.post.id,global_user.id);
                                  widget.post.likes.removeAt(i);
                                  widget.post.likeCount =
                                      widget.post.likes.length;
                                  break;
                                }
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Text(
                      '${widget.post.likeCount} Likes',
                      style: TextStyle(color: black),
                    ),
                  ],
                ),

                Text(
                  '${widget.post.commentCount} Comments',
                  style: TextStyle(color: black),
                ),
                IconButton(
                  icon: Icon(Icons.share, color: black),
                  onPressed: () {
                    Share.share("Poster : " +
                        users
                            .sublist(1, users.length)
                            .where(
                              (element) => element.id == widget.post.ownerId,
                            )
                            .toList()[0]
                            .name +
                        "\n" +
                        widget.post.description);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () async {
                setState(() {});
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(post: widget.post),
                  ),
                );

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      white,
                      white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: white,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.grey,
                          size: 26,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Write a comment...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 22,
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


void _showReactionsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildReactionItem(
                    context, 'like', Icons.thumb_up, 'Like', blue),
                _buildReactionItem(
                    context, 'love', Icons.favorite, 'Love', Colors.red),
                _buildReactionItem(
                    context, 'haha', Icons.tag_faces, 'Haha', Colors.yellow),
                _buildReactionItem(
                    context, 'wow', Icons.face, 'Wow', Colors.purple),
                _buildReactionItem(context, 'sad', Icons.sentiment_dissatisfied,
                    'Sad', Colors.blueGrey),
                _buildReactionItem(context, 'angry',
                    Icons.sentiment_very_dissatisfied, 'Angry', Colors.red),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReactionItem(BuildContext context, String value, IconData icon,
      String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); 
        _handleReaction(value); 
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _handleReaction(String reaction) {
    setState(() {
      print(reaction);
      
      if (reaction == 'like') {
        
      } else if (reaction == 'love') {
        
      } else if (reaction == 'haha') {
        
      } else if (reaction == 'wow') {
        
      } else if (reaction == 'sad') {
        
      } else if (reaction == 'angry') {
        
      }
    });
  }
}
