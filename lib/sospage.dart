import 'dart:math';

import 'package:CarMate/EmergencyTowingPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildEmergencyServicesSection(context),
            SizedBox(height: 16),
            _buildEmergencyContactsSection(),
            SizedBox(height: 16),
            _buildEmergencyAdviceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Services',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueAccent,
          ),
        ),
        SizedBox(height: 16),
        _buildButton(
          icon: Icons.car_repair,
          label: 'Emergency Towing',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmergencyTowingPage()));
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: blue.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [blueAccent, Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: blueAccent.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: white,
                size: 28,
              ),
              SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: white,
      shadowColor: black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: blueAccent,
              ),
            ),
            SizedBox(height: 16),
            _buildEmergencyContactTile(
              icon: Icons.phone,
              title: 'Police',
              subtitle: 'Call 100',
              color: Colors.red,
              onTap: () {
                _callNumber("100");
              },
            ),
            _buildEmergencyContactTile(
              icon: Icons.local_hospital,
              title: 'Ambulance',
              subtitle: 'Call 101',
              color: Colors.green,
              onTap: () {
                _callNumber("101");
              },
            ),
            _buildEmergencyContactTile(
              icon: Icons.shield,
              title: 'Civil Defence',
              subtitle: 'Call 102',
              color: Colors.orange,
              onTap: () {
                _callNumber("102");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
    
    }
  }
  Widget _buildEmergencyContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: onTap,
    );
  }

 Widget _buildEmergencyAdviceSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency Advice',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: blueAccent,
                ),
              ),
              SizedBox(height: 16),
              Divider(
                thickness: 1,
                color: blueAccent.withOpacity(0.5),
              ),
              _buildAdviceTile(
                icon: Icons.warning,
                title: 'Advice for this Month',
                subtitle:
                    getEmergencyAdvice(), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdviceTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange.withOpacity(0.1),
        child: Icon(icon, color: Colors.orange),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onTap: () {},
    );
  }


  Widget _buildRepairShopTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: blueAccent,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey[600],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      onTap: () {},
    );
  }

String getEmergencyAdvice() {
    final month = DateFormat.MMMM().format(DateTime.now());

    final random = Random();

    if (['December', 'January', 'February'].contains(month)) {
      final advices = [
        "It's $month, roads may be slippery due to snow or ice. Check tire tread depth.",
        "During $month, always keep an emergency kit with blankets and a flashlight.",
        "In $month, icy roads can be tricky. Keep a safe distance and drive slowly.",
        "Check tire pressure frequently in $month. Cold weather can cause tires to lose air.",
        "Ensure your car's battery is fully charged in $month, as cold temperatures can reduce battery life.",
        "In $month, your visibility may be reduced. Keep your headlights on during snowstorms.",
        "Roads are more hazardous in $month due to icy conditions. Drive at reduced speeds.",
        "During $month, carry an ice scraper and de-icer to keep your windows clear.",
        "Avoid sudden movements in $month when driving on icy roads to prevent losing control.",
        "If you get stuck in $month, stay in your car and wait for help to avoid hypothermia."
      ];
      return advices[random.nextInt(advices.length)];
    } else if (['March', 'April', 'May'].contains(month)) {
      final advices = [
        "In $month, spring rains can make roads slippery. Make sure your tires are in good condition.",
        "During $month, keep your windshield clean to prevent reduced visibility in rain showers.",
        "As $month brings changing weather, check your tire pressure regularly.",
        "In $month, fog is common. Use fog lights and avoid high beams when driving in it.",
        "During $month, the roads might have puddles. Be cautious of hydroplaning.",
        "In $month, monitor weather forecasts for sudden thunderstorms that can affect visibility.",
        "Check the tread on your tires during $month, as rainy weather can increase the risk of skidding.",
        "As $month sees an increase in wildflowers, watch out for wildlife crossing the roads.",
        "In $month, make sure your brakes are functioning properly to handle slick roads.",
        "Keep an emergency rain poncho and waterproof clothing in your car during $month."
      ];
      return advices[random.nextInt(advices.length)];
    } else if (['June', 'July', 'August'].contains(month)) {
      final advices = [
        "In $month, high temperatures can cause tire blowouts. Regularly check your tire pressure.",
        "During $month, make sure your vehicle's air conditioning system is working properly.",
        "As temperatures rise in $month, always carry extra water and emergency supplies.",
        "In $month, the heat can cause your car's fluids to evaporate. Check your oil and coolant levels.",
        "During $month, stay hydrated while driving in extreme heat to prevent fatigue.",
        "If you're driving in $month, keep windows cracked for ventilation when parking in hot weather.",
        "In $month, don't leave pets or children inside a hot vehicle. The temperature can rise quickly.",
        "Always use sunscreen while driving in $month to protect yourself from sunburn.",
        "In $month, road surfaces can get hot and cause damage to your tires. Avoid harsh braking.",
        "In $month, regularly check your car's air filters to ensure proper air circulation during the heat."
      ];
      return advices[random.nextInt(advices.length)];
    } else if (['September', 'October', 'November'].contains(month)) {
      final advices = [
        "In $month, rainstorms are common. Replace wiper blades if they are worn out.",
        "During $month, shorter daylight hours make it harder to see. Drive with your headlights on.",
        "As $month brings cooler weather, check your vehicle's battery and fluid levels.",
        "In $month, fog is more likely in the mornings. Slow down and use low beams in foggy conditions.",
        "During $month, make sure your vehicle's defrost system is working properly to clear fogged windows.",
        "In $month, falling leaves can make roads slippery. Drive cautiously on leaf-covered roads.",
        "During $month, keep your vehicle's tires properly inflated to handle colder temperatures.",
        "In $month, the risk of road salt damaging your car increases. Regularly wash the undercarriage.",
        "During $month, check your vehicle’s heating system to ensure you're comfortable in colder weather.",
        "In $month, prepare for winter by carrying extra warm clothing and an emergency survival kit."
      ];
      return advices[random.nextInt(advices.length)];
    } else {
      return "Unexpected month. Please check your system's time.";
    }
  }
}
