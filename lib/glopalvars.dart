library globals;

import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
int estimate=0;
  bool darkMode = false;
bool inchat = false;
String urlofimage = "";
double global_rate = 0;
User global_user = users[0];
Cart cart = carts[0];
String selectedRole = 'user';
bool isuser = true;
List<File?> marketImages = [null, null, null];
final GlobalKey<FormState> formKeyPage1 = GlobalKey<FormState>();
final GlobalKey<FormState> formKeyPage2 = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController carPlateNumberController = TextEditingController();
TextEditingController confirmpassword = TextEditingController();
TextEditingController birthDateController = TextEditingController();
String? selectedGender;
bool acceptTerms = false;
String getnameofuser(int user_id) {
  for (int i = 1; i < users.length; i++) {
    if (users[i].id == user_id) {
      return users[i].name;
    }
  }
  return "";
}

List<Booking> bookings = [];
List<Complaint> complaints = [];

class PaymentRecord {
  final int userId;
  final int year;
  final int month;
  bool paid;
  int id;

  PaymentRecord({
    required this.userId,
    required this.year,
    required this.month,
    this.paid = false,
    required this.id,
  });

  void togglePaymentStatus() {
    paid = !paid;
  }

  @override
  String toString() {
    return "${year}-${month.toString().padLeft(2, '0')}: ${paid ? "Paid" : "Not Paid"}";
  }
}

List<PaymentRecord> paymentHistory = [];

class Complaint {
  int id;
  int userid;
  String description;
  String userName;
  int ownerid;
  int rate;
  Complaint(
      {required this.id,
      required this.userid,
      required this.description,
      required this.userName,
      required this.ownerid,
      required this.rate});
}

class Booking {
  int userid;
  int bookingid;
  int ownerid;
  String customerName;
  DateTime appointmentDate;
  DateTime appointment;
  String status;
  String description;
  Booking({
    required this.description,
    required this.appointment,
    required this.userid,
    required this.bookingid,
    required this.ownerid,
    required this.customerName,
    required this.appointmentDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      description: json['description'],
      userid: json['userId'],
      bookingid: json['bookingId'],
      ownerid: json['ownerId'],
      customerName: json['customerName'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointment: DateTime.parse(json['appointment']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userid,
      'bookingId': bookingid,
      'ownerId': ownerid,
      'customerName': customerName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointment': appointment.toIso8601String(),
      'status': status,
    };
  }

  String getFormattedDate() {
    return '${appointmentDate.day}-${appointmentDate.month}-${appointmentDate.year} ${appointmentDate.hour}:${appointmentDate.minute}';
  }
}

class Post {
  int id;
  int ownerId;
  String description;
  String postImage;
  DateTime createdAt;
  int likeCount;
  int commentCount;
  List<Like> likes;
  List<Comment> comments;
  bool isLiked;

  Post({
    required this.id,
    required this.ownerId,
    required this.description,
    required this.postImage,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    List<Like>? likes,
    List<Comment>? comments,
  })  : likes = likes ?? [],
        comments = comments ?? [];
}

class Like {
  int userId;

  Like({
    required this.userId,
  });
}

class User {
  int id;
  String name;
  String phone;
  String email;
  String password;
  String carPlateNumber;
  String role;
  String profileImage;
  String description;
  String locatoin;

  bool isServiceActive;
  double latitude;
  double longitude;
  bool onlineStatus;
  String birthDate;
  String gender;
  int rate;
  String accountnumber;
  User({

    required this.rate,
    required this.onlineStatus,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.carPlateNumber,
    required this.role,
    required this.profileImage,
    required this.description,
    required this.locatoin,
    this.isServiceActive = true,
    required this.longitude,
    required this.latitude,
    required this.birthDate,
    required this.gender,
    required this.accountnumber,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountnumber: json['accountnumber'] ?? '',
      rate: json['rate'] ?? 0,
      birthDate: json['bitrh'] ?? '',
      gender: json['gender'] ?? '',
      onlineStatus: json['online'],
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      carPlateNumber: json['carPlateNumber'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'],
      description: json['description'],
      locatoin: json['locatoin'],
      isServiceActive: json['isServiceActive'] ?? true,
    );
  }

  bool israted(int ownerid) {
    if (complaints
        .where((element) =>
            (element.ownerid == ownerid) && (element.userid == global_user.id))
        .toList()
        .isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  double getaveragerate() {
    if (complaints.isEmpty) {
      return 0;
    }
    double sum = 0;
    List<Complaint> coms = complaints
        .where(
          (element) => element.ownerid == id,
        )
        .toList();
    if (coms.isEmpty) {
      return 0;
    }
    for (int i = 0; i < coms.length; i++) {
      sum += coms[i].rate;
    }

    double average = sum / coms.length;

    return double.parse(average.toStringAsFixed(1));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'carPlateNumber': carPlateNumber,
      'role': role,
      'profileImage': profileImage,
      'description': description,
      'locatoin': locatoin,
      'isServiceActive': isServiceActive,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

List<maintenancerequest> maintenancerequests = [];

class Comment {
  int commenterid;
  int commentid;
  String _text;
  DateTime timestamp;
  bool isLiked;
  List<Comment> replies;
  List<Like> likes;

  Comment({
    required this.commentid,
    required this.commenterid,
    required String text,
    required this.timestamp,
    required this.isLiked,
    List<Comment>? replies,
    required this.likes,
  })  : _text = text,
        replies = replies ?? [];

  String get text => _text;
  set text(String newText) => _text = newText;
}

late List<Post> posts = [];

class maintenancerequest {
  int requestid;
  int owner_id;
  int user_id;
  DateTime time;
  String description;
  maintenancerequest(
      {required this.requestid,
      required this.owner_id,
      required this.user_id,
      required this.time,
      required this.description}) {}
}

List<User> users = [];

late List<Offer> offers = [];

class Sale {
  int itemid;
  int quantity;
  double price;
  DateTime date;
  int ownerid;
  int id;
  Sale({
    required this.id,
    required this.ownerid,
    required this.itemid,
    required this.quantity,
    required this.price,
    required this.date,
  });

  double get totalPrice => quantity * price;

  String get formattedDate => DateFormat('yyyy-MM-dd – kk:mm').format(date);
}

class Offer {
  String title;
  String description;
  double discount;
  DateTime validUntil;
  int posterid;
  int id;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.validUntil,
    required this.posterid,
  });
}

List<Sale> sales = [];
List<Map<String, dynamic>> getTopSellingTools() {
  final ownerSales =
      sales.where((sale) => sale.ownerid == global_user.id&&sale.itemid>-1).toList();

  final Map<int, int> itemQuantities = {};

  for (var sale in ownerSales) {
 

    itemQuantities[sale.itemid] =
        (itemQuantities[sale.itemid] ?? 0) + sale.quantity;
  }

  final sortedItems = itemQuantities.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sortedItems.take(3).map((entry) {
    for (int i = 0; i < items.length; i++) {
      
      if (items[i].id == entry.key) {
        return {
          'imageUrl': items[i].imagePaths[0],
          'description': items[i].description,
          'name': items[i].name,
          'quantity': entry.value,
        };
      }
    }
    return {
      'name': getitemnamebyid(entry.key),
      'quantity': entry.value,
    };
  }).toList();
}

List<double> calculateMonthlyProfits({
  required int year,
}) {
  List<double> monthlyProfits = List.filled(12, 0.0);

  for (Sale sale in sales) {
    if (sale.ownerid == global_user.id && sale.date.year == year) {
      int month = sale.date.month;
      monthlyProfits[month - 1] += sale.quantity * sale.price;
    }
  }

  return monthlyProfits;
}

int getBestSellingItem() {
  DateTime currentDate = DateTime.now();
  int currentYear = currentDate.year;

  Map<int, int> itemSalesMap = {};

  for (var sale in sales) {
    if (sale.ownerid == global_user.id &&
        sale.date.year >= currentYear - 5 &&
        sale.date.month == DateTime.now().month) {
      if (itemSalesMap.containsKey(sale.itemid)) {
        itemSalesMap[sale.itemid] = itemSalesMap[sale.itemid]! + sale.quantity;
      } else {
        itemSalesMap[sale.itemid] = sale.quantity;
      }
    }
  }

  if (itemSalesMap.isEmpty) {
    return -1;
  }

  int bestSellingItemId = itemSalesMap.keys.first;
  int maxSales = itemSalesMap[bestSellingItemId]!;

  for (var itemId in itemSalesMap.keys) {
    if (itemSalesMap[itemId]! > maxSales) {
      bestSellingItemId = itemId;
      maxSales = itemSalesMap[itemId]!;
    }
  }

  return bestSellingItemId;
}

int index = 0;
bool fromsearch = false;

Color blue = Colors.blue;
Color black = Colors.black;
Color white = Colors.white;
Color lightBlue = Colors.lightBlue;
Color blueAccent = Colors.blueAccent;

class Chat {
  int id;
  List<Message> messages;
  User u1;
  User u2;
  DateTime lastMessage;

  Chat({
    required this.lastMessage,
    required this.id,
    required this.messages,
    required this.u1,
    required this.u2,
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: int.parse(json["id"].toString()),
      lastMessage: DateTime.parse(json['lastMessage']),
      u1: users
          .where(
            (element) => json['u1'] == element.id,
          )
          .toList()[0],
      u2: users
          .where(
            (element) => json['u2'] == element.id,
          )
          .toList()[0],
      messages: (json['messages'] as List<dynamic>)
          .map((msg) => Message.fromJson(msg))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Chat(id: "$id", lastMessage: $lastMessage, user1: $u1, user2: $u2, messages: $messages)';
  }
}

class Message {
  final int id;
  final int senderId;
  final String content;

  final DateTime createdAt;
bool isread;
  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
       required this.isread
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isread: json['isread'] ,
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Message( senderId: $senderId, content: "$content", createdAt: $createdAt)';
  }
}

void sendMessage(Chat chat, int senderId, String content, int reciverid) {

  Message newMessage = Message(
    isread: false,  
    id:chat.messages.isEmpty? 0: chat.messages[chat.messages.length - 1].id + 1 ,
    senderId: senderId,
    content: content,
    createdAt: DateTime.now(),
  );

  chat.messages.add(newMessage);
  chat.lastMessage = DateTime.now();
}

List<Chat> parseChats(List<Map<String, dynamic>> chatData) {
  return chatData.map((chat) {
    return Chat(
      id: chat['id'],
      lastMessage: DateTime.parse(chat['lastMessage']),
      messages: (chat['messages'] as List).map((message) {
        return Message(
          isread: message['isread'] ?? false, 
          id: message['id'],
          senderId: message['senderId'] ?? 0,
          content: message['content'] ?? '',
          createdAt: message['createdAt'] != null
              ? DateTime.parse(message['createdAt'])
              : DateTime.now(),
        );
      }).toList(),
      u1: users.where((element) => element.id == chat['u1']).toList()[0],
      u2: users.where((element) => element.id == chat['u2']).toList()[0],
    );
  }).toList();
}

List<Chat> chats = [];

List<Chat> getuserchats() {
  List<Chat> result = [];

  for (int i = 0; i < chats.length; i++) {
    if (chats[i].u1.id == global_user.id || chats[i].u2.id == global_user.id) {
      if (chats[i].u1.isServiceActive && chats[i].u2.isServiceActive)
        result.add(chats[i]);
    }
  }

  result.sort((a, b) => b.lastMessage.compareTo(a.lastMessage));

  return result;
}

class Item {
  int id;
  int ownerid;
  String name;
  double price;
  String description;
  List<String> imagePaths;
  int availableQuantity;

  Item({
    required this.id,
    required this.ownerid,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePaths,
    required this.availableQuantity,
  });
}

List<Item> items = [];

List<Cart> carts = [];

class Cart {
  int cartId;
  List<Item> localitems = [];
  int user_id;
  Cart({required this.cartId, required this.user_id});
  void addItem(Item item, int quantity) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        items[i].availableQuantity -= quantity;
        break;
      }
    }

    for (int i = 0; i < localitems.length; i++) {
      if (localitems[i].id == item.id) {
        localitems[i].availableQuantity += quantity;
        return;
      }
    }
    localitems.add(Item(
      ownerid: item.ownerid,
      id: item.id,
      availableQuantity: quantity,
      description: item.description,
      name: item.name,
      price: item.price,
      imagePaths: item.imagePaths,
    ));
  }

  double get totalPrice => items.fold(
        0,
        (sum, cartItem) => sum + (cartItem.price * cartItem.availableQuantity),
      );
}

MaintenanceRecord findMostRecentRecord(List<MaintenanceRecord> records) {
  if (records.isEmpty) {
    return MaintenanceRecord(
      id: -1,
      date: DateTime.now(),
      description: "description",
      userid: -1,
    );
  }

  return records.reduce(
    (current, next) => current.date.isAfter(next.date) ? current : next,
  );
}

List<MaintenanceRecord> maintenanceRecords = [];

class MaintenanceRecord {
  final DateTime date;
  final String description;
  final int userid;
  int id;
  MaintenanceRecord(
      {required this.date,
      required this.description,
      required this.userid,
      required this.id});
  String getFormattedDate() {
    return DateFormat('d-M-yyyy').format(date);
  }
}

class Employee {
  final int id;
  String name;
  String position;
  int ownerid;
  List<AssignedTask> assignedTaskIds;

  Employee({
    required this.id,
    required this.ownerid,
    required this.name,
    required this.position,
    List<AssignedTask>? assignedTaskIds,
  }) : assignedTaskIds = assignedTaskIds ?? [];
}

class AssignedTask {
  String taskId;
  String date;
  String time;
  String task;
  String ownerId;

  AssignedTask({
    required this.ownerId,
    required this.taskId,
    required this.date,
    required this.time,
    required this.task,
  });
}

List<Employee> employees = [];
List<AssignedTask> availableSchedule = [];

class DeliveryRequest {
  int requestid;
  int userid;
  int ownerid;
  String phone;
  String address;
  String instructions;

  String status;

  DeliveryRequest({
    required this.requestid,
    required this.ownerid,
    required this.userid,
    required this.phone,
    required this.address,
    required this.instructions,
    this.status = 'Pending',
  });
}

List<DeliveryRequest> deliveryRequests = [];

class SaleRequest {
  final int id;
  final int ownerid;
  final int itemid;
  final int quantity;
  final double price;
  final DateTime date;

  SaleRequest({
    required this.id,
    required this.ownerid,
    required this.itemid,
    required this.quantity,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerid': ownerid,
      'itemid': itemid,
      'quantity': quantity,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  String get formattedDate => DateFormat('yyyy-MM-dd – kk:mm').format(date);
}

List<SaleRequest> salesrequests = [];

String getitemnamebyid(int id) {
  for (Item item in items) {
    if (item.id == id) {
      return item.name;
    }
  }
  return 'Item not found';
}

class TowingService {
  final int id;
   String name;
   String address;
  String phone;
  final double latitude;
  final double longitude;

  TowingService({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

List<TowingService> towingServices = [];

List<UserSignUpRequest> userRequests = [];

class Postreport {
  final int id;
  final String ownerName;
  final String ownerProfileImage;
  final String postImage;
  final String description;
  final String createdAt;
  int postid;

  Postreport({
    required this.postid,
    required this.id,
    required this.ownerName,
    required this.ownerProfileImage,
    required this.postImage,
    required this.description,
    required this.createdAt,
  });

  factory Postreport.fromMap(Map<String, dynamic> map) {
    return Postreport(
      postid: map['postid'] ?? 0,
      id: map['id'] ?? 0,
      ownerName: map['ownerName'] ?? '',
      ownerProfileImage: map['ownerProfileImage'] ?? '',
      postImage: map['postImage'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}

List<Postreport> reportedPosts = [];

class UserSignUpRequest {
  final String name;
  final int requestid;
  final String email;
  final String phone;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> images;
  String birth;
  String gender;
  String placeDetails;
  String password;
  UserSignUpRequest(
      {required this.password,
      required this.requestid,
      required this.name,
      required this.email,
      required this.phone,
      required this.description,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.images,
      this.placeDetails = 'Loading place details...',
      required this.birth,
      required this.gender});
}

Future<void> addBooking(
    String description,
    int userId,
    int bookingId,
    int ownerId,
    DateTime appointmentDate,
    DateTime appointment,
    String customerName,
    String status) async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/bookings';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "description": description,
        "userId": userId,
        "bookingId":bookings.isEmpty?0:bookings.last.bookingid+1,
        "ownerId": ownerId,
        "appointmentDate": appointmentDate.toIso8601String(),
        "appointment": appointment.toIso8601String(),
        "customerName": customerName,
        "status": status,
      }),
    );

    if (response.statusCode == 201) {
      print('Booking added successfully: ${jsonDecode(response.body)}');
    } else {
      print('Failed to add booking: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error adding booking: $e');
  }
}

Future<void> addCart(int userId) async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/carts';
  int id = 0;
  if (carts.isNotEmpty) {
    id = carts[carts.length - 1].cartId + 1;
  }
  final Map<String, dynamic> cartData = {
    "cartId": id,
    "user_id": userId,
    "items": [],
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cartData),
    );

    if (response.statusCode == 201) {
      print("Cart created successfully: ${response.body}");
    } else {
      print("Failed to create cart: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> deletepost(int postid) async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/posts/$postid';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
  } catch (e) {}
}
Future<void> deletetowservice(int id) async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/towingservices/$id';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
  } catch (e) {}
}

Future<void> updatepost(int postid, String description) async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/posts/$postid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'description': description,
      }),
    );
  } catch (e) {}
}
Future<void> updatetowservice(int id, String name,String address,String phone) async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/towingservices/$id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
      }),
    );
    print(response.body);
  } catch (e) {
    print(e);
  }
}

Future<void> deletepostreport(int postid) async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/postReports/$postid';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
    print(response.body);
  } catch (e) {
    print(e);
  }
}

Future<void> addReport({
  required int id,
  required String ownerName,
  required String ownerProfileImage,
  required String postImage,
  required String description,
  required String createdAt,
  required int postid,
}) async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/postReports';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id": reportedPosts.isEmpty?0:reportedPosts.last.id+1,
        "ownerName": ownerName,
        "ownerProfileImage": ownerProfileImage,
        "postImage": postImage,
        "description": description,
        "createdAt": createdAt,
        "postid": postid,
      }),
    );

    if (response.statusCode == 201) {
      print('Report added successfully: ${jsonDecode(response.body)}');
    } else {
      print('Failed to add report: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error adding report: $e');
  }
}

Future<void> addPost(DateTime createdAt, int id, String description,
    int ownerId, String postImage) async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/posts';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "createdAt": createdAt.toIso8601String(),
        "id": id,
        "description": description,
        "ownerId": ownerId,
        "postImage": postImage,
        "commentCount": 0,
        "likeCount": 0,
        "likes": [],
        "comments": []
      }),
    );

    if (response.statusCode == 201) {
      print('Post added successfully: ${jsonDecode(response.body)}');
    } else {
      print('Failed to add post: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error adding post: $e');
  }
}

Future<void> addOffer(int posterId, double discount, String title,
    String description, DateTime validUntil) async {
      await getOffers();
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/offers';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id": offers.isEmpty ? 0 : offers[offers.length - 1].id + 1,
        "posterId": posterId,
        "discount": discount,
        "title": title,
        "description": description,
        "validUntil": validUntil.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      print('Offer added successfully: ${jsonDecode(response.body)}');
    } else {
      print('Failed to add offer: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error adding offer: $e');
  }
}
Future<void> updateaccountnumber(String accountnumber)async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/${global_user.email}/accountnumber";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'accountnumber': accountnumber,
    }),
  );

  if (response.statusCode == 200) {
    print("User accountnumber updated successfully.");
  } else {
    print("Failed to update user accountnumber: ${response.body}");
  }
}
Future<void> addSale(
    {required int ownerId,
    required int itemId,
    required int quantity,
    required double price,
    required DateTime date,
    required int id}) async {
  const String baseUrl = 'https://gp1-ghqa.onrender.com/api';
  final String url = '$baseUrl/sales';
  if (sales.isEmpty) {
    id = 0;
  }
  final Map<String, dynamic> requestBody = {
    'id': id,
    'ownerid': ownerId,
    'itemid': itemId,
    'quantity': quantity,
    'price': price,
    'date': date.toIso8601String(),
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
  } catch (error) {
    print('Error adding sale: $error');
  }
}

Future<void> deleteAnItem(int itemId) async {
  const String baseUrl = 'https://gp1-ghqa.onrender.com/api';
  final String url = '$baseUrl/items/$itemId';

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Item deleted successfully');
    } else {
      print('Failed to delete item: ${response.body}');
    }
  } catch (error) {
    print('Error deleting item: $error');
  }
}

Future<void> addMaintenanceRecord({
  required int userId,
  required int id,
  required DateTime date,
  required String description,
}) async {
  const String baseUrl = 'https://gp1-ghqa.onrender.com/api';
  final String url = '$baseUrl/maintenanceRcords';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': maintenanceRecords.isEmpty?0: maintenanceRecords.last.id+1,
        'userid': userId,
        'date': date.toIso8601String(),
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Maintenance record added successfully');
    } else {
      print('Failed to add maintenance record: ${response.body}');
    }
  } catch (error) {
    print('Error adding maintenance record: $error');
  }
}

Future<void> createChat(int chatId, int u1Id, int u2Id) async {
  const String baseUrl = 'https://gp1-ghqa.onrender.com/api';
  final String endpoint = '/chats';

  final Map<String, dynamic> chatData = {
    "id": chats.isEmpty ? 0 : chatId,
    "lastMessage": DateTime.now().toUtc().toIso8601String(),
    "messages": [],
    "u1": u1Id,
    "u2": u2Id,
  };

  try {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(chatData),
    );

    if (response.statusCode == 201) {
      print('Chat created successfully: ${response.body}');
    } else {
      print('Failed to create chat: ${response.statusCode}, ${response.body}');
    }
  } catch (error) {
    print('Error creating chat: $error');
  }
}

Future<void> addLikeToPost(int postId, int userId) async {
  const String baseUrl = 'https://gp1-ghqa.onrender.com/api/posts';
  final String endpoint = '/$postId/like';

  final Map<String, dynamic> requestBody = {
    "userId": userId,
  };

  try {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Like added successfully: ${response.body}');
    } else {
      print('Failed to add like: ${response.statusCode}, ${response.body}');
    }
  } catch (error) {
    print('Error adding like: $error');
  }
}

Future<void> addMaintenanceRequest({
  required int requestId,
  required int ownerId,
  required int userId,
  required DateTime time,
  required String description,
}) async {
  final url =
      Uri.parse('https://gp1-ghqa.onrender.com/api/maintenanceRequests');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'requestid': maintenancerequests.isEmpty?0: requestId,
      'owner_id': ownerId,
      'user_id': userId,
      'time': time.toIso8601String(),
      'description': description
    }),
  );

  if (response.statusCode == 201) {
    print("Maintenance request created successfully");
  } else {
    print("Failed to create maintenance request: ${response.body}");
  }
}

Future<void> addDeliveryRequest({
  required int id,
  required int userId,
  required int ownerId,
  required String phone,
  required String address,
  required String instructions,
}) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/deliveryRequests/');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "id": deliveryRequests.isEmpty?0: id,
      'userid': userId,
      'ownerid': ownerId,
      'phone': phone,
      'address': address,
      'instructions': instructions,
      'status': 'Pending'
    }),
  );

  if (response.statusCode == 201) {
    print("Delivery request created successfully");
  } else {
    print("Failed to create delivery request: ${response.body}");
  }
}

Future<void> updateItemQuantity(int itemId, int newQuantity) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api";
  final String endpoint = "/sales/$itemId/updateQuantity";

  try {
    final response = await http.patch(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity': newQuantity,
      }),
    );

    if (response.statusCode == 200) {
      print("Quantity updated successfully: ${response.body}");
    } else {
      print(
          "Failed to update quantity: ${response.statusCode} ${response.body}");
    }
  } catch (e) {
    print("Error updating quantity: $e");
  }
}

Future<void> addItemToCart(int cartId, Item item, int quantity) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/carts";
  final String endpoint = "/add-item/$cartId";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'cartId': cartId,
      'itemData': {
        'id': item.id,
        'ownerid': item.ownerid,
        'name': item.name,
        'price': item.price,
        'description': item.description,
        'imagePaths': item.imagePaths,
        'availableQuantity': quantity,
      },
    }),
  );
}

Future<void> addEmployee(int id, String name, String position) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/employees";
  final String endpoint = "/";

  final response = await http.post(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'id': employees.isEmpty?0: id,
      'name': name,
      'position': position,
      'ownerid': global_user.id,
      'assignedTasks': []
    }),
  );

  if (response.statusCode == 201) {
    print("Employee added successfully");
  } else {
    print("Error adding employee: ${response.body}");
  }
}

Future<void> removeEmployee(int id) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/employees";
  final String endpoint = "/$id";

  final response = await http.delete(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("Employee removed successfully");
  } else if (response.statusCode == 404) {
    print("Employee not found");
  } else {
    print("Error removing employee: ${response.body}");
  }
}

Future<void> updateEmployee(int id, String name, String position) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/employees";
  final String endpoint = "/$id";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'position': position,
    }),
  );

  if (response.statusCode == 200) {
    print("Employee updated successfully");
  } else if (response.statusCode == 404) {
    print("Employee not found");
  } else {
    print("Error updating employee: ${response.body}");
  }
}

Future<void> addTowingService(TowingService towingService) async {
  const String baseUrl = "https://gp1-ghqa.onrender.com/api/towingServices";
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(towingService.toJson()),
  );

  if (response.statusCode == 201) {
    print("Towing service added successfully");
  } else {
    print("Error adding towing service: ${response.body}");
  }
}

Future<void> deleteUserSignUpRequest(int id) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/usersignuprequests";
  final Uri url = Uri.parse('$baseUrl/$id');

  final response = await http.delete(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("User sign-up request deleted successfully.");
  } else if (response.statusCode == 404) {
    print("User sign-up request not found.");
  } else {
    print("Failed to delete user sign-up request: ${response.body}");
  }
}

Future<void> addUserSignUpRequest(
    int id,
    String name,
    String email,
    String phone,
    String description,
    String location,
    double latitude,
    double longitude,
    String birth,
    String gender) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/usersignuprequests";
  final Uri url = Uri.parse(baseUrl);
  List<String> images = [
    marketImages[0]!.path,
    marketImages[1]!.path,
    marketImages[2]!.path,
  ];
  final Map<String, dynamic> requestData = {
    'id': userRequests.isEmpty?0: id,
    'name': name,
    'email': email,
    'phone': phone,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'images': images,
    'password': passwordController.text,
    'gender': gender,
    'birthDate': birth
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 201) {
    print("User sign-up request added successfully.");
  } else {
    print("Failed to add user sign-up request: ${response.body}");
  }
}

Future<void> updateUserActiveStatus(String email, bool status) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/$email/activestatus";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'newstatus': status,
    }),
  );

  if (response.statusCode == 200) {
    print("User active status updated successfully.");
  } else {
    print("Failed to update user active status: ${response.body}");
  }
}

Future<void> updateUserprofileimage(String email, String image) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/$email/profileimage";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'newimage': image,
    }),
  );

  if (response.statusCode == 200) {
    print("User active image updated successfully.");
  } else {
    print("Failed to update user image: ${response.body}");
  }
}

Future<void> updateUser(String id, String name, String phone) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/$id";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'phone': phone,
    }),
  );

  if (response.statusCode == 200) {
    print("User updated successfully.");
  } else {
    print("Failed to update user: ${response.body}");
  }
}

Future<void> deleteUser(String email) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/$email";

  final response = await http.delete(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("User deleted successfully.");
  } else {
    print("Failed to delete user: ${response.body}");
  }
}

Future<void> addSaleRequest(SaleRequest saleRequest) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/salesRequests";
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(saleRequest.toJson()),
  );

  if (response.statusCode == 200) {
    print("SaleRequest added successfully");
  } else {
    print("Failed to add SaleRequest: ${response.body}");
  }
}

Future<void> removeItemFromCart({
  required int cartId,
  required int itemId,
}) async {
  final String endpoint =
      "https://gp1-ghqa.onrender.com/api/carts/remove-item/0";

  final response = await http.put(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'cartId': cartId,
      'itemId': itemId,
    }),
  );

  if (response.statusCode == 200) {
    print("Item removed from cart successfully");
  } else {
    print("Failed to remove item from cart: ${response.body}");
  }
}

Future<void> sendmsg({
  required int chatId,
  required int senderId,
  required String text,
  required int msgid,
}) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/chats";
  final String endpoint = "/add-message";

  final Map<String, dynamic> messageData = {
    'id': chatId,
    'msgid':msgid,
    'isread':false,
    "senderId": senderId,
    "content": text,
    "createdAt": DateTime.now().toIso8601String(),
  };

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(messageData),
  );

  if (response.statusCode == 200) {
    print("Message sent successfully.");
  } else {
    print("Error sending message: ${response.body}");
  }
}
Future<void> updatemessageread(int chatId,int msgid,) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/chats";
  final String endpoint = "/message-read";

  final Map<String, dynamic> messageData = {
    'id': chatId,
    'msgid': msgid,
    
  };

  final response = await http.post(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(messageData),
  );

  if (response.statusCode == 200) {
    print("Message sent successfully.");
  } else {
    print("Error sending message: ${response.body}");
  }
}

Future<void> deleteDeliveryRequest(int id) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/deliveryRequests";
  final String endpoint = "/$id";

  final response = await http.delete(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("Delivery request deleted successfully.");
  } else {
    print("Error deleting delivery request: ${response.body}");
  }
}

Future<void> updateItem(int id, String name, int quantity, double price) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/items";
  final String endpoint = "/$id";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'quantity': quantity,
      'price': price,
    }),
  );

  if (response.statusCode == 200) {
    print("Item updated successfully.");
  } else {
    print("Error updating item: ${response.body}");
  }
}

Future<void> updateBooking(
    int bookingId, String customerName, DateTime appointmentDate) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/bookings";
  final String endpoint = "/$bookingId";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'customerName': customerName,
      'appointmentDate': appointmentDate
          .toIso8601String(), // Convert DateTime to ISO8601 string
    }),
  );

  if (response.statusCode == 200) {
    print('Booking updated successfully');
  } else {
    print('Failed to update booking: ${response.body}');
  }
}

Future<void> updateBookingstatus(int bookingId, String status) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/bookings";
  final String endpoint = "/$bookingId/status";

  final response = await http.patch(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'status': status, // Convert DateTime to ISO8601 string
    }),
  );

  if (response.statusCode == 200) {
    print('Booking updated successfully');
  } else {
    print('Failed to update booking: ${response.body}');
  }
}

Future<void> addNewItem(int ownerId, int id, String name, double price,
    String description, List<String> imagePaths, int availableQuantity) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/items";
  final String endpoint = "/";

  final response = await http.post(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'ownerid': ownerId,
      'id':items.isEmpty?0: id,
      'name': name,
      'price': price,
      'description': description,
      'imagePaths': imagePaths,
      'availableQuantity': availableQuantity,
    }),
  );

  if (response.statusCode == 200) {
    print('Item added successfully');
  } else {
    print('Failed to add item: ${response.body}');
  }
}

Future<void> deleteMaintenanceRequest(int id) async {
  final String baseUrl =
      "https://gp1-ghqa.onrender.com/api/maintenanceRequests";
  final String endpoint = "/$id";

  final response = await http.delete(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Maintenance request deleted successfully');
  } else {
    print('Failed to delete maintenance request: ${response.body}');
  }
}

Future<void> updateDeliveryRequestStatus(int id, String status) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/deliveryRequests";
  final String endpoint = "/status/$id";

  try {
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      print('Delivery request status updated successfully');
    } else {
      print('Failed to update status: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> deleteSalesRequest(int id) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/salesRequests";
  final String endpoint = "/$id";

  try {
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Sales request deleted successfully');
    } else {
      print('Failed to delete sales request: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> updateDeliveryRequest(
    int id, String phone, String address, String instructions) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/deliveryRequests";
  final String endpoint = "/$id";

  try {
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'address': address,
        'instructions': instructions,
      }),
    );

    if (response.statusCode == 200) {
      print('Delivery request updated successfully');
    } else {
      print('Failed to update delivery request: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> addTask(int employeeId, AssignedTask taskData) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/employees";
  final String endpoint = "/add-task";

  try {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'employeeId': employeeId,
        'date': taskData.date,
        'time': taskData.time,
        'task': taskData.task,
        'taskId': taskData.taskId,
        'ownerId': taskData.ownerId,
      }),
    );

    if (response.statusCode == 200) {
      print("Task added successfully");
    } else {
      print("Failed to add task: ${response.body}");
    }
  } catch (error) {
    print("Error adding task: $error");
  }
}

Future<void> removeTask(int employeeId, String taskId) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/employees";
  final String endpoint = "/remove-task/$employeeId";

  try {
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'taskId': taskId,
      }),
    );

    if (response.statusCode == 200) {
      print("Task removed successfully");
    } else {
      print("Failed to remove task: ${response.body}");
    }
  } catch (error) {
    print("Error removing task: $error");
  }
  getAssignedTasks();
}

Future<void> addTaskToSchedule(AssignedTask taskData) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/availableSchedules');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': taskData.date,
        'time': taskData.time,
        'task': taskData.task,
        'taskId': taskData.taskId,
        'ownerId': "${global_user.id}"
      }),
    );

    if (response.statusCode == 200) {
      print("Task added successfully!");
    } else {
      print("Failed to add task: ${response.body}");
    }
  } catch (e) {
    print("Error adding task: $e");
  }
}

Future<void> removeTaskFromSchedule(String scheduleId) async {
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/availableSchedules/$scheduleId');

  try {
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Task removed successfully!");
    } else {
      print("Failed to remove task: ${response.body}");
    }
  } catch (e) {
    print("Error removing task: $e");
  }
}

Future<void> getAllChats() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/chats';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> chatListJson = json.decode(response.body);
      chats = chatListJson.map((chatJson) => Chat.fromJson(chatJson)).toList();
    } else {
      print('Failed to fetch chats: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching chats: $e');
  }
}

Future<List<Message>> fetchMessages(int chatId) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/chats/$chatId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      final messagesData = data['messages'] as List;
      List<Message> messages = messagesData
          .map((messageJson) => Message.fromJson(messageJson))
          .toList();
      return messages;
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to fetch messages');
  }
}

Future<void> addUser(
    int id,
    double latitude,
    double longitude,
    String name,
    String email,
    String phone,
    String password,
    String car,
    String des,
    String role,
    String location,
    String bitrh,

    String gender
    ) async {
  if (role == "normal") {
    await getCarts();
    addCart(id);
  }
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/users');
  Map<String, dynamic> userData = {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    'carPlateNumber': car,
    'role': role,
    'rate': 0,
    'profileImage': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYBcoI23p8BwC502B3cS4nTAn2UVsq5g-E5Dm84vYYE8xTD9dDF9BZvoq-VvSKIu4BSh0&usqp=CAU",
    'description': des,
    'location': location,
    'isServiceActive': true,
    'latitude': latitude,
    'longitude': longitude,
    'online': false,
    'bitrh': bitrh,
    'gender': gender,
    'accountnumber':'0'
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
    } else {}
  } catch (error) {}
}

Future<void> getbookings() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/bookings';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> chatListJson = json.decode(response.body);
      bookings =
          chatListJson.map((chatJson) => Booking.fromJson(chatJson)).toList();
     
    } else {
      print('Failed to fetch chats: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching chats: $e');
  }
}

Future<void> getusers() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/users';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      users = [];

      if (jsonData['data'] is List<dynamic>) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> userJson = jsonData['data'][i];
          users.add(User(
            accountnumber: userJson['accountnumber'],
            rate: userJson['rate'],
            birthDate: userJson['bitrh'],
            gender: userJson['gender'],
            onlineStatus: userJson['online'],
            latitude: double.parse(userJson['latitude'].toString()),
            longitude: double.parse(userJson['longitude'].toString()),
            id: int.parse(userJson['id'].toString()),
            name: userJson['name'],
            phone: userJson['phone'],
            email: userJson['email'],
            password: userJson['password'],
            carPlateNumber: userJson['carPlateNumber'],
            role: userJson['role'],
            profileImage: userJson['profileImage'],
            description: userJson['description'],
            locatoin: userJson['location'],
            isServiceActive: userJson['isServiceActive'] ?? true,
          ));
        }
      } else {
        print('Unexpected JSON structure: "data" is not a list.');
      }
    } else {
      print('Failed to fetch users: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching users: $e');
  }
}

Future<void> getcomplaints() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/complaints';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
    
      complaints = [];

      if (jsonData['data'] is List<dynamic>) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> complaintJson = jsonData['data'][i];

          complaints.add(Complaint(
            userid: complaintJson['userid'],
            id: complaintJson['id'],
            description: complaintJson['description'],
            userName: complaintJson['userName'],
            ownerid: complaintJson['ownerId'],
            rate: complaintJson['rate'],
          ));
        }
      } else {
        print('Unexpected JSON structure: "data" is not a list.');
      }
    } else {
      print('Failed to fetch complaints: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching complaints: $e');
  }
}

Future<void> getposts() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/posts';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      posts = [];

      if (jsonData['data'] is List<dynamic>) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          Map<String, dynamic> postJson = jsonData['data'][i];

          User user = users
              .where(
                (element) => element.id == postJson['ownerId'],
              )
              .toList()[0];

          if (user.isServiceActive) {
            List<Like> likes = [];

            if (postJson['likes'] is List<dynamic>) {
              for (var likeUserId in postJson['likes']) {
                if (likeUserId is int) {
                  likes.add(Like(userId: likeUserId));
                }
              }
            }

            List<Comment> comments = [];
            if (postJson['comments'] is List<dynamic>) {
              for (var commentJson in postJson['comments']) {
                List<Comment> replies = [];
                if (commentJson['replies'] is List<dynamic>) {
                  for (var replyJson in commentJson['replies']) {
                    replies.add(Comment(
                      commentid: replyJson['commentid'],
                      commenterid: replyJson['commenterid'],
                      text: replyJson['text'],
                      timestamp: DateTime.parse(replyJson['timestamp']),
                      isLiked: replyJson['isLiked'],
                      replies: [],
                      likes: [],
                    ));
                  }
                }

                comments.add(Comment(
                  commentid: commentJson['commentid'],
                  commenterid: commentJson['commenterid'],
                  text: commentJson['text'],
                  timestamp: DateTime.parse(commentJson['timestamp']),
                  isLiked: commentJson['isLiked'],
                  replies: replies,
                  likes: [],
                ));
              }
            }

            posts.add(Post(
              id: postJson['id'],
              ownerId: postJson['ownerId'],
              description: postJson['description'],
              postImage: postJson['postImage'],
              createdAt: DateTime.parse(postJson['createdAt']),
              likeCount: postJson['likeCount'],
              commentCount: postJson['commentCount'],
              likes: likes,
              comments: comments,
            ));
          }
        }
      } else {
        print('Unexpected JSON structure: "data" is not a list.');
      }
    } else {
      print('Failed to fetch posts: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching posts: $e');
  }
}

Future<void> getSalesRequests() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/salesRequests';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      salesrequests = [];

      for (var saleData in jsonData) {
        SaleRequest saleRequest = SaleRequest(
          id: int.tryParse(saleData['id'].toString()) ?? 0,
          ownerid: int.tryParse(saleData['ownerid'].toString()) ?? 0,
          itemid: int.tryParse(saleData['itemid'].toString()) ?? 0,
          quantity: int.tryParse(saleData['quantity'].toString()) ?? 0,
          price: saleData['price'].toDouble(),
          date: DateTime.parse(saleData['date']),
        );
        print(saleRequest.quantity);
        print(saleRequest.price);
        print(saleRequest.date);
        print(saleRequest.ownerid);
        print(saleRequest.itemid);
        print(saleRequest.id);
        print('----------------');
        salesrequests.add(saleRequest);
      }
    
    } else {
      print('Failed to fetch sales requests: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching sales requests: $e');
  }
}

Future<void> getMaintenanceRequests() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/maintenanceRequests';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      maintenancerequests = [];

      if (jsonData['data'] is List) {
        for (var requestData in jsonData['data']) {
          maintenancerequest maintenanceRequest = maintenancerequest(
            description: requestData['description'],
            requestid: int.tryParse(requestData['requestid'].toString()) ?? 0,
            owner_id: int.tryParse(requestData['owner_id'].toString()) ?? 0,
            user_id: int.tryParse(requestData['user_id'].toString()) ?? 0,
            time: DateTime.parse(requestData['time']),
          );

          maintenancerequests.add(maintenanceRequest);
        }
      } else {
        print('Unexpected JSON structure: data is not a list.');
      }
    } else {
      print('Failed to fetch maintenance requests: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching maintenance requests: $e');
  }
}

Future<void> getItems() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/items';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      items = [];

      if (jsonData['data'] is List) {
        for (var itemData in jsonData['data']) {
          bool additem = users
              .where((element) =>
                  (int.tryParse(itemData['ownerid'].toString()) == element.id))
              .toList()[0]
              .isServiceActive;
          if (additem) {
            Item item = Item(
              id: int.tryParse(itemData['id'].toString()) ?? 0,
              ownerid: int.tryParse(itemData['ownerid'].toString()) ?? 0,
              name: itemData['name'] ?? '',
              price: (itemData['price'] as num).toDouble(),
              description: itemData['description'] ?? '',
              imagePaths: List<String>.from(itemData['imagePaths'] ?? []),
              availableQuantity:
                  int.tryParse(itemData['availableQuantity'].toString()) ?? 0,
            );

            items.add(item);
          }
        }
      } else {
        print('Unexpected JSON structure: data is not a list.');
      }
    } else {
      print('Failed to fetch items: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching items: $e');
  }
}

Future<List<Cart>> getCarts() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/carts';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      carts = [];

      if (jsonData is List) {
        for (var cartData in jsonData) {
          List<Item> items = [];

          for (var itemData in cartData['items']) {
            Item item = Item(
              id: itemData['id'],
              ownerid: itemData['ownerid'],
              name: itemData['name'],
              price: itemData['price'],
              description: itemData['description'],
              imagePaths: List<String>.from(itemData['imagePaths']),
              availableQuantity: itemData['availableQuantity'],
            );
            items.add(item);
          }

          Cart cart = Cart(
            cartId: cartData['cartId'],
            user_id: cartData['user_id'],
          );
          cart.localitems = items;

          carts.add(cart);
        }
      } else {
        print('Error: Unexpected data structure');
      }

      return carts;
    } else {
      print('Failed to load carts: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<List<Sale>> getSales() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/sales';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      sales = [];

      if (jsonData['data'] is List) {
        for (var saleData in jsonData['data']) {
          Sale sale = Sale(
            id: saleData['id'],
            ownerid: saleData['ownerid'],
            itemid: saleData['itemid'],
            quantity: saleData['quantity'],
            price: saleData['price'],
            date: DateTime.parse(saleData['date']),
          );
          sales.add(sale);
        }
      } else {
        print('Error: Unexpected data structure');
      }

      return sales;
    } else {
      print('Failed to load sales: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<void> getOffers() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/offers';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      offers = [];

      if (jsonData['data'] is List) {
        for (var offerData in jsonData['data']) {
 

          Offer offer = Offer(
            id: offerData['id'],
            title: offerData['title'],
            description: offerData['description'],
            discount: offerData['discount'],
            validUntil: DateTime.parse(offerData['validUntil']),
            posterid: offerData['posterId'],
          );
          offers.add(offer);
        }
        offers= offers.reversed.toList();
      } else {
        print('Error: Unexpected data structure');
      }

    
    } else {
      print('Failed to load offers: ${response.statusCode}');
     
    }
  } catch (e) {
    print('Error: $e');
    
  }
}

Future<void> getAssignedTasks() async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/availableSchedules';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData is List) {
        availableSchedule = [];

        for (int i = 0; i < jsonData.length; i++) {
          var taskData = jsonData[i];

          AssignedTask task = AssignedTask(
            ownerId: taskData['ownerId'].toString(),
            taskId: taskData['taskId'].toString(),
            date: taskData['date'].toString(),
            time: taskData['time'].toString(),
            task: taskData['task'].toString(),
          );

          availableSchedule.add(task);
        }
      } else {
        print('Error: "data" is not a list');
      }
    } else {
      print('Failed to load assigned tasks: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> getDeliveryRequests() async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/deliveryRequests';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      deliveryRequests = [];

      if (jsonData['data'] is List) {
        for (int i = 0; i < jsonData['data'].length; i++) {
          var requestData = jsonData['data'][i];
// print(requestData['status']['status']);
          DeliveryRequest request = DeliveryRequest(
            requestid: int.tryParse(requestData['id'].toString()) ?? 0,
            userid: int.tryParse(requestData['userid'].toString()) ?? 0,
            ownerid: int.tryParse(requestData['ownerid'].toString()) ?? 0,
            phone: requestData['phone'] ?? '',
            address: requestData['address'] ?? '',
            instructions: requestData['instructions'] ?? '',
            status: requestData['status'] ?? '',
          );

          deliveryRequests.add(request);
        }
      } else {
        print('Error: "data" is not a list');
      }
    } else {
      print('Failed to load delivery requests: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> getTowingServices() async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/towingservices';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      towingServices = [];

      if (jsonData['data'] is List) {
        for (var serviceData in jsonData['data']) {
          TowingService service = TowingService(
            id: int.tryParse(serviceData['id'].toString()) ?? 0,
            name: serviceData['name'] ?? '',
            address: serviceData['address'] ?? '',
            phone: serviceData['phone'] ?? '',
            latitude:
                double.tryParse(serviceData['latitude'].toString()) ?? 0.0,
            longitude:
                double.tryParse(serviceData['longitude'].toString()) ?? 0.0,
          );

          towingServices.add(service);
        }
      }
    } else {
      print('Failed to load towing services: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> getUserSignUpRequests() async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/usersignuprequests';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      userRequests = [];

      if (jsonData is List) {
        for (var requestData in jsonData) {
          UserSignUpRequest request = UserSignUpRequest(
            birth: requestData['bitrh'],
            gender: requestData['gender'],
            password: requestData['password'] ?? '',
            requestid: int.tryParse(requestData['requestid'].toString()) ?? 0,
            name: requestData['name'] ?? '',
            email: requestData['email'] ?? '',
            phone: requestData['phone'] ?? '',
            description: requestData['description'] ?? '',
            location: requestData['location'] ?? '',
            latitude:
                double.tryParse(requestData['latitude'].toString()) ?? 0.0,
            longitude:
                double.tryParse(requestData['longitude'].toString()) ?? 0.0,
            images: List<String>.from(requestData['images'] ?? []),
          );

          userRequests.add(request);
        }
      } else {
        print('Unexpected data format');
      }
    } else {
      print('Failed to load user sign-up requests: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> getEmployees() async {
  String apiUrl = 'https://gp1-ghqa.onrender.com/api/employees';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      employees = [];

      if (jsonData['data'] is List) {
        for (var employeeData in jsonData['data']) {
          List<AssignedTask> assignedTasks = [];
          if (employeeData['assignedTasks'] is List) {
            for (var taskData in employeeData['assignedTasks']) {
              assignedTasks.add(
                AssignedTask(
                  taskId: taskData['taskId'] ?? '',
                  date: taskData['date'] ?? '',
                  time: taskData['time'] ?? '',
                  task: taskData['task'] ?? '',
                  ownerId: taskData['ownerId'] ?? '',
                ),
              );
            }
          }

          employees.add(
            Employee(
              id: int.tryParse(employeeData['id'].toString()) ?? 0,
              ownerid: int.tryParse(employeeData['ownerid'].toString()) ?? 0,
              name: employeeData['name'] ?? '',
              position: employeeData['position'] ?? '',
              assignedTaskIds: assignedTasks,
            ),
          );
        }
      } else {
        print('Unexpected data format');
      }
    } else {
      print('Failed to load employees: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> getMaintenanceRecords() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/maintenanceRcords';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      maintenanceRecords = [];

      if (jsonData is List) {
        for (var recordData in jsonData) {
          MaintenanceRecord record = MaintenanceRecord(
            id: recordData['id'],
            date: DateTime.parse(recordData['date']),
            description: recordData['description'],
            userid: recordData['userid'],
          );
          maintenanceRecords.add(record);
        }
      } else {
        print('Error: Unexpected data structure');
      }
    } else {
      print('Failed to load maintenance records: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> uploadImageAndGetOptimizedUrl(String base64Image) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/upload');
  final body = jsonEncode({'imageData': base64Image});
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      urlofimage = responseData['optimizedUrl'];
    } else {
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error uploading image: $error');
    throw Exception('Error uploading image');
  }
}

Future<void> removeLikeFromPost(int postId, int userId) async {
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/posts/likes/$postId/$userId');
  try {
    final response = await http.delete(
      url,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: ${data['message']}');
      print('Response Data: ${data['data']}');
    } else {
      final error = jsonDecode(response.body);
      print('Error: ${error['message']}');
    }
  } catch (e) {
    print('Error making request: $e');
  }
}

Future<void> addCommentToPost(int postId, Comment commentData) async {
  final url =
      Uri.parse('https://gp1-ghqa.onrender.com/api/posts/$postId/comment');
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "commentid": commentData.commentid,
        "commenterid": commentData.commenterid,
        "text": commentData.text,
        "timestamp": commentData.timestamp.toIso8601String(),
        "isLiked": commentData.isLiked,
        "replies": commentData.replies
            .map((reply) => {
                  "commentid": reply.commentid,
                  "commenterid": reply.commenterid,
                  "text": reply.text,
                  "timestamp": reply.timestamp.toIso8601String(),
                  "isLiked": reply.isLiked,
                })
            .toList(),
        "likes": commentData.likes
            .map((like) => {
                  "userId": like.userId,
                })
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: ${data['message']}');
      print('Response Data: ${data['data']}');
    } else {
      final error = jsonDecode(response.body);
      print('Error: ${error['message']}');
    }
  } catch (e) {
    print('Error making request: $e');
  }
}

Future<void> removeCommentFromPost(int postId, int commentId) async {
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/posts/$postId/comments/$commentId');

  try {
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Success: ${data['message']}');
      print('Response Data: ${data['data']}');
    } else {
      final error = jsonDecode(response.body);
      print('Error: ${error['message']}');
    }
  } catch (e) {
    print('Error making request: $e');
  }
}

Future<void> updateComment(int postId, int commentId, String newText) async {
  final String url =
      'https://gp1-ghqa.onrender.com/api/posts/$postId/comments/$commentId';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'text': newText,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update comment');
  }
}

Future<void> addReply(int postId, int commentId, Comment reply) async {
  Post post = posts
      .where(
        (element) => element.id == postId,
      )
      .toList()[0];
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/posts/$postId/comments/$commentId/replies');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'commentid': post.comments
                .where(
                  (element) => element.commentid == commentId,
                )
                .toList()[0]
                .replies
                .isEmpty
            ? 0
            : post.comments
                    .where(
                      (element) => element.commentid == commentId,
                    )
                    .toList()[0]
                    .replies[post.comments
                            .where(
                              (element) => element.commentid == commentId,
                            )
                            .toList()[0]
                            .replies
                            .length -
                        1]
                    .commentid +
                1,
        'commenterid': reply.commenterid,
        'text': reply.text,
        'timestamp': reply.timestamp.toIso8601String(),
        'isLiked': reply.isLiked,
        'likes': [],
      }),
    );

    if (response.statusCode == 200) {
      print('Reply added successfully');
    } else {
      print('Failed to add reply: ${response.body}');
    }
  } catch (e) {
    print('Error adding reply: $e');
  }
}

Future<void> editReply(
    int postId, int commentId, int replyId, String newText) async {
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/posts/$postId/comments/$commentId/replies/$replyId');

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'newText': newText,
      }),
    );

    if (response.statusCode == 200) {
      print('Reply updated successfully');
    } else {
      print('Failed to update reply: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> deleteReply(int postId, int commentId, int replyId) async {
  final url = Uri.parse(
      'https://gp1-ghqa.onrender.com/api/posts/$postId/comments/$commentId/replies/$replyId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      print('Reply deletedcessfully');
    } else {
      print('Failed to delete Reply: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<void> addPaymentRecordtodb({
  required int userId,
  required int year,
  required int month,
  required int id,
}) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/payments/');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'year': year,
        'month': month,
        'paid': true,
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      print('Payment record added successfully');
    } else {
      print('Failed to add payment record: ${response.body}');
    }
  } catch (e) {
    print('Error adding payment record: $e');
  }
}

Future<void> deletePaymentRecordfromdb(int id) async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/payments/$id');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Payment record deleted successfully');
    } else {
      print('Failed to delete payment record: ${response.body}');
    }
  } catch (e) {
    print('Error deleting payment record: $e');
  }
}

Future<void> fetchPaymentRecords() async {
  final url = Uri.parse('https://gp1-ghqa.onrender.com/api/payments');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      paymentHistory = data.map((record) {
        return PaymentRecord(
          userId: record['userId'],
          year: record['year'],
          month: record['month'],
          paid: record['paid'],
          id: record['id'],
        );
      }).toList();
      print('Payment records fetched successfully: ${paymentHistory.length}');
    } else {
      print('Failed to fetch payment records: ${response.body}');
    }
  } catch (e) {
    print('Error fetching payment records: $e');
  }
}

Future<void> updatepassword(String email, String newpass) async {
  final String baseUrl = "https://gp1-ghqa.onrender.com/api/users";
  final String endpoint = "/${email}/password";

  final response = await http.put(
    Uri.parse(baseUrl + endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'newPassword': newpass}),
  );
}

Future<void> removeComplaint(int id) async {
  String baseUrl = "https://gp1-ghqa.onrender.com/api/complaints/$id";

  final response = await http.delete(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({}),
  );

  if (response.statusCode == 200) {
    print("complaint deletedsuccessfully.");
  } else {
    print("Failed to delete complaint: ${response.body}");
  }
}

Future<void> updatecomplaint(int id, int rate, String description) async {
  String baseUrl = "https://gp1-ghqa.onrender.com/api/complaints/$id";

  final response = await http.put(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'rate': rate, 'description': description}),
  );

  if (response.statusCode == 200) {
    print("complaint updated successfully.");
  } else {
    print("Failed to update complaint: ${response.body}");
  }
}

Future<void> addRating(
    int id, String description, String userName, int ownerId, int rate) async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/complaints';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id": id,
        "userid": global_user.id,
        "description": description,
        "userName": userName,
        "ownerId": ownerId,
        "rate": rate,
      }),
    );

    if (response.statusCode == 201) {
      print('Rating added successfully: ${jsonDecode(response.body)}');
    } else {
      print('Failed to add rating: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error adding rating: $e');
  }
}

Future<void> updateUserStatus(String email, bool status) async {
  final url =
      Uri.parse('https://gp1-ghqa.onrender.com/api/users/$email/onlinestatus');

  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      print('User status updated successfully');
    } else {
      print(response.body);
    }
  } catch (e) {
    print('Error updating user status: $e');
  }
}

void handlePageCloseOrLeave() {
  html.window.addEventListener('beforeunload', (html.Event event) {
  if(users.isNotEmpty){
      updateUserStatus(global_user.email, false);
  }
    final confirmationMessage = 'Are you sure you want to leave?';
    (event as html.BeforeUnloadEvent).returnValue = confirmationMessage;
  });
}

Future<void> fetchReports() async {
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/postReports';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data'] as List;

      reportedPosts = data.map((report) {
        return Postreport.fromMap(report);
      }).toList();
    } else {
      print('Failed to load reports: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching reports: $e');
  }
}


Future<void> updateRate(int userId, int rate) async {
  String baseUrl = 'https://gp1-ghqa.onrender.com/api/users/newrate/$userId';

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rate': rate,
      }),
    );

    if (response.statusCode == 200) {
      print('Rate added successfully');
    } else if (response.statusCode == 404) {
      print(response.body);
    } else {
      print('Failed to add rate: ${response.body}');
    }
  } catch (error) {
    print('Error adding rate: $error');
  }


  
}
Future<void> getglobal_rate() async {
  await getusers();
  int count = 0;
  int sum = 0;

  if (users.isEmpty) {
    global_rate = 0;
    return;
  }

  for (int i = 0; i < users.length; i++) {
    if (users[i].rate > 0) {
     
      count++;
      sum += users[i].rate;
    }
  }

  global_rate = sum == 0 ? 0 : double.parse((sum / count).toStringAsFixed(1));
}


Future<void>  calculateEstimate(String description) async{
  const String apiUrl = 'https://gp1-ghqa.onrender.com/api/estimate/estimate-repair-cost';

  
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "description": description,
      }),
    );
estimate=jsonDecode(response.body)['cost']['totalCost'];
print(estimate);


}
