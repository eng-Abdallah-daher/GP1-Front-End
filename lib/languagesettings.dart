import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final List<String> _languages = ['English', 'العربية'];
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'),
        backgroundColor: blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Select Language'),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  return RadioListTile<String>(
                    title: Text(language, style: TextStyle(fontSize: 16)),
                    value: language,
                    groupValue: _selectedLanguage,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    activeColor: blueAccent,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Language settings updated to $_selectedLanguage!')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: blueAccent,
                shadowColor: Colors.black.withOpacity(0.5),
                elevation: 8,
              ).copyWith(
                side: MaterialStateBorderSide.resolveWith((states) {
                  return BorderSide(color: blueAccent, width: 2);
                }),
                overlayColor:
                    MaterialStateProperty.all(blueAccent.withOpacity(0.2)),
              ),
              child: Text(
                'Save Settings',
                style: TextStyle(
                  fontSize: 18,
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: blueAccent,
        ),
      ),
    );
  }
}
