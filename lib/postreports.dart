import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

 


 class ReportedPostsPage extends StatefulWidget {
  @override
  _ReportedPostsPageState createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends State<ReportedPostsPage> {
@override
  void initState() {
   m();
    super.initState();
  }
  void m() async{
    await fetchReports();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reported Posts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: reportedPosts.length,
        itemBuilder: (context, index) {
          final post = reportedPosts[index];
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
                        onTap: () {
                          
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(post.ownerProfileImage),
                          radius: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.ownerName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                            Text(
                              post.createdAt,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    PopupMenuButton<String>(
                        onSelected: (value) async{
                          if (value == 'remove_post') {
                            
                            for (int i = 0; i < reportedPosts.length; i++) {
                              if (reportedPosts[i].postid == post.postid) {
                                deletepostreport(reportedPosts[i].id);
                                reportedPosts.removeAt(i);
                              }
                            }
                            deletepost(post.postid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Post removed successfully!",
                                  style: TextStyle(color: white),
                                ),
                                backgroundColor: Colors.green.shade600,
                                duration: Duration(seconds: 2),
                              ),
                            );
                      await    fetchReports();
                            
setState(() {
  
});
                            // _removePost(post, context);
                          } else if (value == 'remove_report') {
                            
                            deletepostreport(post.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Report removed successfully!",
                                  style: TextStyle(color: white),
                                ),
                                backgroundColor: Colors.green.shade600,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          await  fetchReports();
                            setState(() {});
                            // _removeReport(post, context);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.blueGrey.shade50,
                        elevation: 4,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'remove_post',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  "Remove Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'remove_report',
                            child: Row(
                              children: [
                                Icon(Icons.flag,
                                    color: Colors.orange, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  "Remove Report",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        icon: Icon(Icons.more_vert,
                            color: Colors.blueGrey.shade700),
                        offset: Offset(0, 40),
                      ),

                    ],
                  ),
                ),
                Divider(color: Colors.grey.withOpacity(0.5)),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _removePost(Postreport post, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blue.shade50,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text(
              "Remove Post",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to permanently remove this post? This action cannot be undone.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade900,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.cancel, color: white),
            label: Text(
              "Cancel",
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              
              
              for(int i=0;i<reportedPosts.length;i++){
                if(reportedPosts[i].postid == post.postid){
                   deletepostreport(reportedPosts[i].id);
                  reportedPosts.removeAt(i);
                 
                  
                }
              }
              deletepost(post.postid);
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Post removed successfully!",
                    style: TextStyle(color: white),
                  ),
                  backgroundColor: Colors.green.shade600,
                  duration: Duration(seconds: 2),
                ),
              );
              fetchReports();
              Navigator.pop(context);

              
          
            },
            icon: Icon(Icons.delete, color: white),
            label: Text(
              "Remove",
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }


  void _removeReport(Postreport post, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.lightBlue.shade50,
        title: Row(
          children: [
            Icon(Icons.report_gmailerrorred_rounded,
                color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text(
              "Remove Report",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to remove this report? The post will no longer be flagged.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade900,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.cancel, color: white),
            label: Text(
              "Cancel",
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              
              deletepostreport(post.id);
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Report removed successfully!",
                    style: TextStyle(color: white),
                  ),
                  backgroundColor: Colors.green.shade600,
                  duration: Duration(seconds: 2),
                ),
              );
              fetchReports();
              Navigator.pop(context);

              
             
            },
            icon: Icon(Icons.delete, color: white),
            label: Text(
              "Remove",
              style: TextStyle(color: white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

}
