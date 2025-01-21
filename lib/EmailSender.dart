import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailSender {


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
   static Future<void> sendEmailwithpdf(String shopName, String userName, String cost, String recipientEmail) async {
    const String apiUrl = 'http://localhost:3000/api/send-email-with-pdf';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
        "shopName":shopName,
         "userName": userName,
         "cost": cost,
         "recipientEmail": recipientEmail,
        }),
      );
      print(jsonDecode(response.body));
    } catch (e) {
      print('Error sendEmail : $e');
    }
  }
}
