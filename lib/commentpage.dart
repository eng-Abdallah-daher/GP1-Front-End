import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';




class CommentsPage extends StatefulWidget {
  final Post post;

  CommentsPage({required this.post});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {


  final TextEditingController commentController = TextEditingController();
@override
  void initState() {
    m();
    super.initState();
    
  }
  void m() async{
      await getusers();
      setState(() {
        
      });
  }
  final String commenterAvatar = global_user.profileImage!;
  final String commenterName = global_user.name; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: white,
        iconTheme: IconThemeData(color: black),
        titleTextStyle:
            TextStyle(color: black, fontWeight: FontWeight.bold),
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
          
            setState(() {
            
            });
            Navigator.pop(context); 
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.post.comments[index];
                return _buildComment(comment);
              },
            ),
          ),
          Divider(height: 1),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: black, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCommentHeader(comment),
              SizedBox(height: 8),
            (comment.commenterid==global_user.id) ?   _buildCommentActions(comment) : Container() ,
              if (comment.replies.isNotEmpty) _buildReplies(comment),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentHeader(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(users
              .sublist(1, users.length)
              .where(
                (element) => (element.id == comment.commenterid)&&(element.isServiceActive),
              )
              .toList()[0]
              .profileImage!),
          radius: 22,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: users
                          .sublist(1, users.length)
                          .where(
                            (element) => (element.id == comment.commenterid)&&(element.isServiceActive),
                          )
                          .toList()[0]
                          .name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: black, fontSize: 15),
                    ),
                    TextSpan(
                      text: '  ${comment.text}',
                      style: TextStyle(color: black, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              _buildCommentMeta(comment),
            ],
          ),
        ),
      ],
    );
  }
bool islikedcomment(Comment comment){
  for (int i = 0; i < comment.likes.length; i++){
    if(comment.likes[i].userId==global_user.id){
      return true;
    }
  }
  return false;
}
  Widget _buildCommentMeta(Comment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
          comment.isLiked = !comment.isLiked;

              if (comment.isLiked) {
                for (var post in posts) {
                  for (var postComment in post.comments) {
                    if (comment.commentid == postComment.commentid) {
                      
                      postComment.likes.add(Like(userId: global_user.id));

                    }
                  }
                }
              } else {
                for (var post in posts) {
                  for (var postComment in post.comments) {
                    if (comment.commentid == postComment.commentid) {
                      removeLikeFromPost(widget.post.id,global_user.id);
                      postComment.likes
                          .removeWhere((like) => like.userId == global_user.id);
                    }
                  }
                }
              }
  
            });
          },
          child: Text(
            comment.isLiked ? 'Unlike' : 'Like',
            style: TextStyle(
              color: comment.isLiked ? Colors.red : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            _showReplyDialog(comment);
          },
          child: Text('Reply', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        SizedBox(width: 20),
        Text(_timeAgo(comment.timestamp), style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildCommentActions(Comment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () => _showEditCommentDialog(comment),
            child: Text('Edit', style: TextStyle(color: blue))),
        TextButton(
            onPressed: () => _deleteComment(comment),
            child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  Widget _buildReplies(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 50.0),
      child: Column(
        children: comment.replies.map((reply) => _buildReply(reply,comment)).toList(),
      ),
    );
  }

  Widget _buildReply(Comment reply,Comment com) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(users
                .sublist(1, users.length)
                .where((element) => (element.id == reply.commenterid)&&(element.isServiceActive),).toList()[0].profileImage!),
            radius: 18,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: users
                            .sublist(1, users.length)
                            .where(
                              (element) => (element.id == reply.commenterid)&&(element.isServiceActive),
                            )
                            .toList()[0]
                            .name,
                        style: TextStyle(fontWeight: FontWeight.bold, color: black, fontSize: 14),
                      ),
                      TextSpan(
                        text: '  ${reply.text}',
                        style: TextStyle(color: black, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                _buildReplyMeta(reply),
                (reply.commenterid == global_user.id) ? _buildReplyActions(reply,com) : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyMeta(Comment reply) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              reply.isLiked = !reply.isLiked; 
            });
          },
          child: Text(
            reply.isLiked ? 'Unlike' : 'Like',
            style: TextStyle(
              color: reply.isLiked ? Colors.red : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(_timeAgo(reply.timestamp), style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildReplyActions(Comment reply,Comment com) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () => _showEditReplyDialog(reply,com),
            child: Text('Edit', style: TextStyle(color: blue))),
        TextButton(
            onPressed: (){
               deleteReply(widget.post.id, com.commentid, reply.commentid);
              _deleteReply(reply);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(commenterAvatar),
            radius: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: commentController,
              cursorColor: blue,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                _addComment();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: blue),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }

  void _addComment() {


    if (commentController.text.isNotEmpty) {
      setState(() {
    if(widget.post.comments.isNotEmpty){
         addCommentToPost(
            widget.post.id,
            Comment(
              commentid: widget.post.comments[widget.post.comments.length - 1]
                      .commentid +
                  1,
              likes: List.empty(),
              commenterid: global_user.id,
              text: commentController.text,
              timestamp: DateTime.now(),
              isLiked: false,
            ),
          );
          
          widget.post.comments.add(
            Comment(
              commentid: widget.post.comments[widget.post.comments.length - 1]
                      .commentid +
                  1,
              likes: List.empty(),
              commenterid: global_user.id,
              text: commentController.text,
              timestamp: DateTime.now(),
              isLiked: false,
            ),
          );
    }else{
         addCommentToPost(
            widget.post.id,
            Comment(
              commentid:0,
              likes: List.empty(),
              commenterid: global_user.id,
              text: commentController.text,
              timestamp: DateTime.now(),
              isLiked: false,
            ),
          );
          widget.post.comments.add(
            Comment(
              commentid: 0,
              likes: List.empty(),
              commenterid: global_user.id,
              text: commentController.text,
              timestamp: DateTime.now(),
              isLiked: false,
            ),
          );
    }
        commentController.clear();     
      });
          
    }
  }

void _showReplyDialog(Comment comment) {
    final TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
          elevation: 20, 
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  blueAccent,
                  Colors.cyan
                ], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(20), 
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(0, 8), 
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, 
              children: [
                
                Text(
                  'Reply to ${users.sublist(1, users.length).where(
                        (element) =>(element.id == comment.commenterid)&&(element.isServiceActive),
                      ).toList()[0].name}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: white, 
                  ),
                ),
                SizedBox(height: 20),

                
                TextField(
                  controller: replyController,
                  autofocus: true,
                  cursorColor: white,
                  minLines: 1,
                  maxLines: 4,
                  style: TextStyle(fontSize: 18, color: white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: black
                        .withOpacity(0.1), 
                    hintText: 'Write your reply...',
                    hintStyle: TextStyle(color: white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                ),
                SizedBox(height: 20),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                         setState(() {}); 
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async{
                        if (replyController.text.isNotEmpty) {
                         
                         await addReply(widget.post.id, comment.commentid,Comment(
                                commentid: -1,
                                likes: List.empty(),
                                commenterid: global_user.id,
                               
                                text: replyController.text,
                                timestamp: DateTime.now(),
                                isLiked: false,
                              ),);
                            setState(() { 
                              comment.replies.add(
                              Comment(
                                commentid: 192,
                                likes: List.empty(),
                                commenterid: global_user.id,
                               
                                text: replyController.text,
                                timestamp: DateTime.now(),
                                isLiked: false,
                              ),
                            );
                            widget.post.commentCount++;
                          });
                          Navigator.of(context)
                              .pop();
                               setState(() {}); 
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

void _showEditCommentDialog(Comment comment) {
    final TextEditingController editController =
        TextEditingController(text: comment.text);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20), 
          ),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  blueAccent,
                  Colors.cyan
                ], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(0, 8), 
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Edit Comment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: white, 
                  ),
                ),
                SizedBox(height: 20),

                
                TextField(
                  controller: editController,
                  autofocus: true,
                  cursorColor: white,
                  minLines: 1,
                  maxLines: 4,
                  style: TextStyle(fontSize: 18, color: white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: black
                        .withOpacity(0.1), 
                    hintText: 'Edit your comment...',
                    hintStyle: TextStyle(color: white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                ),
                SizedBox(height: 20),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          
                        }); 
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (editController.text.isNotEmpty) {
                          setState(() {
                            updateComment(widget.post.id, comment.commentid, editController.text);
                            comment.text =
                                editController.text; 
                          });
                          Navigator.of(context).pop();
                           setState(() {}); 
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
void _showEditReplyDialog(Comment reply,Comment com) {
    final TextEditingController editController =
        TextEditingController(text: reply.text);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  
                  white,
                   lightBlue,
                ], 
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(0, 8), 
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Edit Reply',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: white, 
                  ),
                ),
                SizedBox(height: 20),

                
                TextField(
                  controller: editController,
                  cursorColor: white,
                  minLines: 1,
                  maxLines: 4,
                  style: TextStyle(fontSize: 18, color: white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: white
                        .withOpacity(0.1), 
                    hintText: 'Edit your reply...',
                    hintStyle: TextStyle(color: white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide.none, 
                    ),
                  ),
                ),
                SizedBox(height: 20),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                         setState(() {}); 
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (editController.text.isNotEmpty) {
                        editReply(widget.post.id,com.commentid, reply.commentid,  editController.text);
                          setState(() {
                            
                            reply.text =
                                editController.text; 
                          });
                          Navigator.of(context).pop();
                           setState(() {}); 
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void _deleteComment(Comment comment) {
    setState(() {
      removeCommentFromPost(widget.post.id, comment.commentid);
      widget.post.comments.remove(comment); 
      widget.post.commentCount--; 
    });
  }

  void _deleteReply(Comment reply) {
    setState(() {
     
      final parentComment = widget.post.comments.firstWhere((c) => c.replies.contains(reply));
      
      parentComment.replies.remove(reply);
    });
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'just now';
  }
}
