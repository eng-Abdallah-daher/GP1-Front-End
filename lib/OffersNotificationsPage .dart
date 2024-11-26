import 'package:flutter/material.dart';

class OffersNotificationsPage extends StatelessWidget {
  final List<Offer> offers = [
    Offer(
      title: "10% Off on Car Wash",
      description:
          "Get your car washed at a discounted price! Valid until Oct 15.",
      validUntil: DateTime(2024, 10, 15),
    ),
    Offer(
      title: "Free Tire Rotation",
      description:
          "Enjoy a free tire rotation with any service. Limited time offer!",
      validUntil: DateTime(2024, 10, 31),
    ),
    Offer(
      title: "20% Off on Oil Change",
      description:
          "Hurry! Book your oil change now and get 20% off. Offer ends soon.",
      validUntil: DateTime(2024, 10, 5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offers Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return _buildOfferCard(context, offers[index]); // Pass context here
          },
        ),
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, Offer offer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.local_offer,
                  color: Colors.blue.shade800,
                  size: 30,
                ),
                Text(
                  "Valid Until: ${offer.validUntil.day}/${offer.validUntil.month}/${offer.validUntil.year}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              offer.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              offer.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade600,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showClaimDialog(context, offer); // Show dialog on button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  "Claim Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showClaimDialog(BuildContext context, Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer,
                color: Colors.blue.shade800,
                size: 30,
              ),
              SizedBox(width: 8),
              Text(
                "Claim Offer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You have claimed the offer:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                offer.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement the claim action here
                _claimOffer(context,offer);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Claim Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
void _claimOffer(BuildContext context, Offer offer) {
    // Show a SnackBar to inform the user about the successful claim
    final snackBar = SnackBar(
      content: Text("Successfully claimed: ${offer.title}"),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.white,
        onPressed: () {
          // Handle the undo action here, e.g., restore offer status
          print("Undo claim for: ${offer.title}");
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Claim Successful",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          content: Text(
            "You've successfully claimed the offer: \n\n${offer.title}",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}

class Offer {
  final String title;
  final String description;
  final DateTime validUntil;

  Offer({
    required this.title,
    required this.description,
    required this.validUntil,
  });
}
