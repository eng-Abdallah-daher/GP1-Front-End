import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        backgroundColor: blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Notification Types'),
              _buildSwitchListTile(
                title: 'Push Notifications',
                subtitle: 'Enable/Disable push notifications',
                value: _pushNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              SizedBox(height: 10),
              _buildSwitchListTile(
                title: 'Email Notifications',
                subtitle: 'Enable/Disable email notifications',
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notification settings updated!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                  shadowColor: black.withOpacity(0.3),
                  side: BorderSide(color: white, width: 2),
                ),
                child: Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blueAccent,
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: blueAccent,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: blueAccent,
            inactiveTrackColor: Colors.grey[300],
            trackHeight: 6.0,
            thumbColor: blueAccent,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0),
            overlayColor: blueAccent.withOpacity(0.3),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: blueAccent,
            valueIndicatorTextStyle: TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: divisions,
            label: '${value.round()}',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
