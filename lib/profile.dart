import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  SlantedClipper2 m = new SlantedClipper2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
           Stack(
  clipBehavior: Clip.none,
  children: [
    _buildCoverPhoto(context), // Cover image with italic effect
    
    // Centered User Name with top positioning
    Positioned(
      top: 40, // Adjust vertical position
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center, // Center horizontally
        child: _buildUserName(), // User's name
      ),
    ),

    // Centered User Location with top positioning
    Positioned(
      top: 110, // Adjust vertical position
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center, // Center horizontally
        child: _buildUserLocation(), // User's location
      ),
    ),

    // Centered Profile Picture with top positioning
    Positioned(
      top: 140, // Adjust vertical position
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center, // Center horizontally
        child: _buildProfilePicture(), // User's avatar
      ),
    ),
  ],
)
,
            SizedBox(height: 100), // Spacing below the avatar and buttons
            _buildStats(), // Stats section (Posts, Followers, Following)
            _buildContactInfo(), // Contact info (email, birthday, etc.)
            _buildFollowButton(), // Follow button
            _buildSocialMediaButtons(), // Social media buttons
          ],
        ),
      ),
    );
  }

  // User's name displayed at the top
  Widget _buildUserName() {
    return Text(
      'abdallah', // Replace with dynamic user name
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // User's location displayed above the avatar image
  Widget _buildUserLocation() {
    return Row(
      mainAxisSize:
          MainAxisSize.min, // Makes the Row take only the needed space
      children: [
        Icon(
          Icons.location_on, // Location marker icon
          color: Colors.lightBlue, // Icon color
          size: 20, // Adjust the icon size
        ),
        SizedBox(width: 5), // Add a small space between the icon and text
        Text(
          'yaseed', // Replace with dynamic location
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Italic cover image that fills the entire width
  Widget _buildCoverPhoto(BuildContext context) {
    return ClipPath(
      clipper: SlantedClipper(), // Apply custom clipper for the slanted bottom
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width, // Fill the entire width
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/gradient.png'), // Your cover image asset
            fit: BoxFit.cover, // Cover to ensure the image fills the container
          ),
        ),
      ),
    );
  }

  // Profile picture (Avatar)
  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.center, // Align the avatar in the center
      children: [
        ClipPath(
          clipper: SlantedClipper(), // Use custom clipper for slanted effect
          child: Container(
            width: 110, // Diameter of the outer border (radius * 2)
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white, // Top 30% white
                  Colors.white, // Transition color for the top
                  Colors.blue, // Bottom 70% blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        CircleAvatar(
          radius: 51, // Inner white background (same as outer container's size)
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 50, // Actual avatar size
            backgroundImage: AssetImage(
                'images/avatarimage.png'), // Your profile image asset
          ),
        ),
      ],
    );
  }

  // Stats for Posts, Followers, Following
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.circle, size: 10, color: Colors.blue),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 10, color: Colors.blue),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 10, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              "About Me",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 10, color: Colors.grey),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 10, color: Colors.grey),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 10, color: Colors.grey),
            SizedBox(width: 10),
          ]),
          SizedBox(height: 10),
          Row(children: [
            Text(
              "ehbal",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn("238", "Posts"),
              Container(
                // Line color
                height: 40, // Adjust height according to your layout
                width: 1, // The width of the line
                color: Colors.blue,
              ),
              _buildInfoColumn("238", "Followers"),
              Container(
                height: 40, // Adjust height according to your layout
                width: 1, // The width of the line
                color: Colors.blue, // Line color
              ),
              _buildInfoColumn("238", "Following"),
            ],
          )
        ],
      ),
    );
  }

  // Info columns like Posts, Followers, Following
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

  // Call and Message buttons on the same row as the profile picture
  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity, // Make the Row span the full width of the screen
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Space items evenly across the width
        children: [
          _buildActionButton(Icons.call, (){}),
          _buildActionButton(Icons.message, (){}),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Function g) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue], // Create a gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4), // Slight shadow
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow positioning
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent, // Make Material transparent
        child: InkWell(
          borderRadius: BorderRadius.circular(50), // Circular ripple effect
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatPage(
            //       chatPartnerName: widget.user.name, // Pass the user's name
            //       chatPartnerAvatar:
            //           widget.user.avatarPath, // Pass the user's avatar
            //     ),
            //   ),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(
                16.0), // Adjust icon padding for a balanced look
            child: Icon(
              icon,
              color: Colors.white, // White icon to stand out against gradient
              size: 28, // Larger icon size for emphasis
            ),
          ),
        ),
      ),
    );
  }


  // Contact info (email, birthdate, etc.)
  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        children: [
          _buildContactRow(Icons.email, "johndoe@example.com"),
          SizedBox(height: 10),
          _buildContactRow(Icons.cake, "March 15, 1993"),
          SizedBox(height: 10),
          _buildContactRow(Icons.person, "Male"),
        ],
      ),
    );
  }

  // Contact info row
  Widget _buildContactRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Text(info, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Follow button
  Widget _buildFollowButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text("Follow"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
        ),
      ),
    );
  }

  // Social media buttons section
  Widget _buildSocialMediaButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialMediaButton(Icons.facebook),
         
        
        ],
      ),
    );
  }

  // Individual social media button
  Widget _buildSocialMediaButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade50,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue),
        onPressed: () {},
      ),
    );
  }
}

class SlantedClipper2 extends CustomClipper<Path> {
  SlantedClipper2();

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.3); // Draw line for top 30% (white)
    path.lineTo(size.width, size.height * 0.3); // Draw line horizontally
    path.lineTo(size.width, size.height); // Draw line to bottom-right
    path.lineTo(0, size.height); // Draw line to bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget _buildProfilePicture() {
  return Stack(
    alignment: Alignment.center, // Align the avatar in the center
    children: [
      ClipPath(
        clipper: SlantedClipper(), // Use custom clipper for slanted effect
        child: Container(
          width: 110, // Diameter of the outer border (radius * 2)
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white, // Top 30% white
                Colors.white, // Transition color for the top
                Colors.blue,   // Bottom 70% blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      CircleAvatar(
        radius: 51, // Inner white background (same as outer container's size)
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 50, // Actual avatar size
          backgroundImage: AssetImage(
              'images/avatarimage.png'), // Your profile image asset
        ),
      ),
    ],
  );
}
class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0.0, size.height - 50); // Start at bottom-left, moved up for slant
    path.lineTo(size.width, size.height); // Draw line to bottom-right
    path.lineTo(size.width, 0.0); // Draw line to top-right
    path.lineTo(0.0, 0.0); // Draw line to top-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget _buildCoverPhoto(BuildContext context) {
  return ClipPath(
    clipper: SlantedClipper(), // Apply custom clipper for the slanted bottom
    child: Container(
      height: 200,
      width: MediaQuery.of(context).size.width, // Fill the entire width
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/gradient.png'), // Your cover image asset
          fit: BoxFit.cover, // Cover to ensure the image fills the container
        ),
      ),
    ),
  );
}
