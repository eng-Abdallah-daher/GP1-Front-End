// import 'package:first/commentpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for formatting date/time

void main() {
  runApp(PostsApp());
}

class PostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Post {
  String posterName;
  String posterAvatar;
  String description;
  String postImage;
  DateTime timestamp;
  int likes; // Add likes count
  List<String> comments; // Add comments list

  Post({
    required this.posterName,
    required this.posterAvatar,
    required this.description,
    required this.postImage,
    required this.timestamp,
    this.likes = 0, // Default likes count
    List<String>? comments, // Default empty comments list
  }) : this.comments = comments ?? [];
}

class PostsPage extends StatefulWidget {
  // Change to StatefulWidget to manage state
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Sample data for posts
  final List<Post> posts = [
    Post(
      posterName: 'John Doe',
      posterAvatar: 'images/logo.png',
      description: 'Check out my new car! Loving the performance.',
      postImage: 'images/logo2.png',
      timestamp: DateTime.parse("2024-09-25 15:23:00"), // Fixed date
    ),
    Post(
      posterName: 'Jane Smith',
      posterAvatar: 'images/logo.png',
      description: 'Just got my car serviced. Highly recommend this shop!',
      postImage: 'images/logo2.png',
      timestamp: DateTime.parse("2024-09-22 15:23:00"), // Fixed date
    ),
    Post(
      posterName: 'Michael Brown',
      posterAvatar: 'images/logo.png',
      description: 'Road trip ready! Excited for the adventure ahead.',
      postImage: 'images/logo2.png',
      timestamp: DateTime.parse("2024-09-25 15:23:00"), // Fixed date
    ),
  ];

  void _removePost(int index) {
    setState(() {
      posts.removeAt(index); // Remove post from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(
            post: posts[index],
            onDelete: () => _removePost(index), // Pass delete function
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
  bool isLiked = false; // Track if the post is liked

  // Function to calculate the time difference for the timestamp
  String getTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours > 23) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _editPost(BuildContext context) async {
    final updatedDescription = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: widget.post.description);
        return AlertDialog(
          title: Text('Edit Post'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Update your post"),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(
                    context, controller.text); // Return the new description
              },
            ),
          ],
        );
      },
    );

    if (updatedDescription != null && updatedDescription.isNotEmpty) {
      setState(() {
        widget.post.description =
            updatedDescription; // Update the post description
      });
    }
  }

  void _deletePost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                widget.onDelete(); // Notify parent widget to delete the post
              },
            ),
          ],
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
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit Post'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _editPost(context); // Handle edit post action
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Post'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _deletePost(); // Handle delete post action
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.report, color: Colors.orange),
                title: Text('Report Post'),
                onTap: () {
                  // Handle report post action
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Information
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.post.posterAvatar),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.posterName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getTimeDifference(
                            widget.post.timestamp), // Show the time difference
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () =>
                      _showMoreOptions(context), // Trigger popup menu
                ), // More options icon
              ],
            ),
          ),
          Divider(), // Divider between header and content

          // Post Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(widget.post.description),
          ),
          SizedBox(height: 10),

          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.post.postImage,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: 200,
            ),
          ),
          SizedBox(height: 10),

          // Engagement Row (Likes, Comments, Shares)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                          widget.post.likes +=
                              isLiked ? 1 : -1; // Update likes count
                        });
                      },
                    ),
                    Text(
                      '${widget.post.likes} Likes', // Display likes count
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(),
                      ),
                    ); // Navigate to comment page
                  },
                  child: Text('View Comments'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Center(
        child: Text('No comments yet!'), // Placeholder for comments
      ),
    );
  }
}
