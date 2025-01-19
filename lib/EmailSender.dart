import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailSender {
  static const String email = 's12116027@stu.najah.edu';
  static const String password = 'gtgo zpdc mmzd jnoq';

  static Future<void> sendEmail(
      String recipient, String subject, String message) async {
   const String apiUrl = 'https://gp1-ghqa.onrender.com/api/send-email';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": recipient,
          "subject": subject,
          "message": message,
         
        }),
      );
print(jsonDecode(response.body));
    } catch (e) {
      print('Error sendEmail : $e');
    }
  }
}
