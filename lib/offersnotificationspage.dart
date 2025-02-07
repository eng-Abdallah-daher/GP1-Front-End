import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';

class OffersNotificationsPage extends StatefulWidget {
  @override
  _OffersNotificationsPageState createState() =>
      _OffersNotificationsPageState();
}

class _OffersNotificationsPageState extends State<OffersNotificationsPage> {
    @override
  void initState() {
    m();
    super.initState();
   
  }
  void m()async{
    await getOffers();
    setState(() {
      
    });
  }

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
      backgroundColor: white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return _buildOfferCard(context, offers[index]);
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
      color: white,
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
              "${offer.discount}% ${offer.title}",
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
            
          ],
        ),
      ),
    );
  }

}
