library globals;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

User global_user = users[1];
Cart cart = carts[0];
final GlobalKey<FormState> formKeyPage1 = GlobalKey<FormState>();
final GlobalKey<FormState> formKeyPage2 = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController carPlateNumberController = TextEditingController();

String getnameofuser(int user_id) {
  for (int i = 0; i < users.length; i++) {
    if (users[i].id == user_id) {
      return users[i].name;
    }
  }
  return "";
}

List<Booking> bookings = [
  Booking(
      userid: 1,
      bookingid: 11,
      ownerid: 0,
      appointmentDate: DateTime.parse("2024-11-23 16:16:00"),
      appointment: DateTime.parse("2024-11-23 10:10:00"),
      customerName: "algorithm",
      status: "Confirmed"),
  Booking(
      appointment: DateTime.now(),
      appointmentDate: DateTime.now(),
      customerName: "alsm",
      status: "Pending",
      userid: 1,
      bookingid: 12,
      ownerid: 0)
];
List<Complaint> complaints = [];
class PaymentRecord {
  final int userId;
  final int year;
  final int month;
  bool paid;

  PaymentRecord({
    required this.userId,
    required this.year,
    required this.month,
    this.paid = false,
  });

  
  void togglePaymentStatus() {
    paid = !paid;
  }

  @override
  String toString() {
    return "${year}-${month.toString().padLeft(2, '0')}: ${paid ? "Paid" : "Not Paid"}";
  }
}

class PaymentHistory {
  static List<PaymentRecord> paymentHistory = [];

  
  static void updatePaymentStatus(int userId, int year, int month, bool paid) {
    
    PaymentRecord? record = paymentHistory.firstWhere(
      (record) =>
          record.userId == userId &&
          record.year == year &&
          record.month == month,
      orElse: () => PaymentRecord(
          userId: userId, year: year, month: month), 
    );

    
    if (!paymentHistory.contains(record)) {
      paymentHistory
          .add(record); 
    }
    record.paid = paid;
  }

  
  static bool hasPaid(int userId, int year, int month) {
    PaymentRecord? record = paymentHistory.firstWhere(
      (record) =>
          record.userId == userId &&
          record.year == year &&
          record.month == month,
      orElse: () => PaymentRecord(
          userId: userId, year: year, month: month), 
    );
    return record.paid;
  }

  
  static List<String> getPaymentHistory(int userId) {
    return paymentHistory
        .where((record) => record.userId == userId)
        .map((record) =>
            "${record.year}-${record.month.toString().padLeft(2, '0')}: ${record.paid ? "Paid" : "Not Paid"}")
        .toList();
  }

  
  static void togglePaymentStatus(int userId, int year, int month) {
    
    PaymentRecord? record = paymentHistory.firstWhere(
      (record) =>
          record.userId == userId &&
          record.year == year &&
          record.month == month,
      orElse: () => PaymentRecord(
          userId: userId, year: year, month: month), 
    );

    
    if (paymentHistory.contains(record)) {
      record.togglePaymentStatus();
    } else {
      
      PaymentRecord newRecord =
          PaymentRecord(userId: userId, year: year, month: month);
      newRecord.togglePaymentStatus();
      paymentHistory.add(newRecord);
    }
  }
}

class Complaint {
  String description;
  String userName;
  int ownerid;
  int rate;
  Complaint({
    required this.description,
    required this.userName,
    required this.ownerid,
    required this.rate,
  });
}

class Booking {
  int userid;
  int bookingid;
  int ownerid;
  String customerName;
  DateTime appointmentDate;
  DateTime appointment;
  String status;

  Booking({
    required this.appointment,
    required this.userid,
    required this.bookingid,
    required this.ownerid,
    required this.customerName,
    required this.appointmentDate,
    required this.status,
  });

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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      ownerId: json['owner_id'],
      description: json['description'],
      postImage: json['post_image'],
      createdAt: DateTime.parse(json['created_at']),
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
      likes: (json['likes'] as List<dynamic>?)
              ?.map((like) => Like.fromJson(like))
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner_id': ownerId,
      'description': description,
      'post_image': postImage,
      'created_at': createdAt.toIso8601String(),
      'like_count': likeCount,
      'comment_count': commentCount,
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}

class Like {
  int userId;

  Like({
    required this.userId,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    };
  }
}

class User {
  int id;
  String name;
  String phone;
  String email;
  String password;
  String carPlateNumber;
  String role;
  String? profileImage;
  String? description;
  String? locatoin;
  List<int> rates;
  bool isServiceActive;

  User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.password,
      required this.carPlateNumber,
      required this.role,
      this.profileImage,
      this.description,
      this.locatoin,
      required this.rates,
      this.isServiceActive = true,
      });

  bool israted(int ownerid) {
    for (int i = 0; i < rates.length; i++) {
      if (rates[i] == ownerid) {
        return true;
      }
    }
    return false;
  }

  double getaveragerate() {
    double sum = 0;
    for (int i = 0; i < rates.length; i++) {
      sum += rates[i];
    }
    if (rates.isEmpty) {
      return 0;
    } else {
      double average = sum / rates.length;
      return double.parse(average.toStringAsFixed(1));
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      rates: json['rates'],
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      carPlateNumber: json['car_plate_number'],
      role: json['role'],
      profileImage: json['profile_image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'car_plate_number': carPlateNumber,
      'role': role,
      'profile_image': profileImage,
      'description': description,
      'locatoin': locatoin,
      'rates': rates,
    };
  }

  map(Widget Function(dynamic post) param0) {}
}

List<maintenancerequest> maintenancerequests = [
  maintenancerequest(
      requestid: 0, owner_id: 2, user_id: 0, time: DateTime.now())
];

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

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentid: json["commentid"],
      commenterid: json['commenter_id'],
      likes: (json['likes'] as List<dynamic>)
          .map((likeJson) => Like.fromJson(likeJson))
          .toList(),
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isLiked: json['is_liked'],
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) => Comment.fromJson(reply))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commenter_id': commenterid,
      'likes': likes.map((like) => like.toJson()).toList(),
      'text': _text,
      'timestamp': timestamp.toIso8601String(),
      'is_liked': isLiked,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}

List<Post> posts = [
  Post(
    createdAt: DateTime.parse("2024-09-25 15:23:00"),
    id: 1,
    description: "any",
    ownerId: 2,
    postImage: "images/logo.png",
    commentCount: 0,
    likeCount: 0,
    likes: [Like(userId: 0)],
    comments: [],
  ),
  Post(
    createdAt: DateTime.parse("2024-09-25 15:23:00"),
    id: 0,
    description: "any",
    ownerId: 1,
    postImage: "images/logo.png",
    commentCount: 2,
    likeCount: 0,
    likes: [],
    comments: [
      Comment(
          commentid: 0,
          likes: List.empty(),
          commenterid: users[1].id,
          text: "k",
          timestamp: DateTime.now(),
          isLiked: false,
          replies: [
            Comment(
                commentid: 1,
                likes: List.empty(),
                commenterid: users[1].id,
                text: "k",
                timestamp: DateTime.now(),
                isLiked: false)
          ]),
      Comment(
          commentid: 2,
          likes: List.empty(),
          commenterid: users[1].id,
          text: "k",
          timestamp: DateTime.now(),
          isLiked: false,
          replies: [
            Comment(
                commentid: 3,
                likes: List.empty(),
                commenterid: users[1].id,
                text: "k",
                timestamp: DateTime.now(),
                isLiked: false)
          ]),
      Comment(
          commentid: 4,
          likes: List.empty(),
          commenterid: users[1].id,
          text: "k",
          timestamp: DateTime.now(),
          isLiked: false,
          replies: [
            Comment(
                commentid: 4,
                likes: List.empty(),
                commenterid: users[3].id,
                text: "alkdk",
                timestamp: DateTime.now(),
                isLiked: false)
          ])
    ],
  ),
];

class maintenancerequest {
  int requestid;
  int owner_id;
  int user_id;
  DateTime time;
  maintenancerequest(
      {required this.requestid,
      required this.owner_id,
      required this.user_id,
      required this.time}) {}
}

List<User> users = [
User(
      carPlateNumber: "",
      email: "abdallahdaher205@gmail.com",
      id: -1,
      name: "admin",
      phone: "0594380216",
      password: "admin",
      role: "admin",
      profileImage: "images/logo.png.png",
      description: "hhh",
      locatoin: "yaseed",
      rates: [3, 3, 4]),

  
  User(
      carPlateNumber: "123",
      email: "abdallahdaher0@gmail.com",
      id: 0,
      name: "abdallahdaher",
      phone: "00123",
      password: "123",
      role: "owner",
      profileImage: "images/logo.png",
      description: "hhh",
      locatoin: "yaseed",
      rates: [3, 3, 4]),
  User(
      locatoin: "yaseed",
      carPlateNumber: "123",
      email: "abdallahdaher1@gmail.com",
      id: 1,
      name: "abdallahdaher1",
      phone: "00123",
      password: "123",
      role: "normal",
      profileImage: "images/logo.png",
      description: "hhh",
      rates: []),
  User(
      locatoin: "yaseed",
      carPlateNumber: "123",
      email: "abdallahdaher2@gmail.com",
      id: 2,
      name: "abdallahdaher2",
      phone: "00123",
      password: "123",
      role: "owner",
      profileImage: "images/avatarimage.png",
      description: "hhh",
      rates: []),
];

late List<Offer> offers = [
  Offer(
    posterid: 0,
    discount: 10,
    title: "Off on Car Wash",
    description:
        "Get your car washed at a discounted price! Valid until Oct 15.",
    validUntil: DateTime(2024, 10, 15),
  ),
  Offer(
    posterid: 0,
    discount: 10,
    title: "Off on Tire Rotation",
    description:
        "Enjoy a free tire rotation with any service. Limited time offer!",
    validUntil: DateTime(2024, 10, 31),
  ),
  Offer(
    posterid: 0,
    discount: 10,
    title: "Off on Oil Change",
    description:
        "Hurry! Book your oil change now and get 20% off. Offer ends soon.",
    validUntil: DateTime(2024, 10, 5),
  ),
];

class Sale {
  int itemid;
  int quantity;
  double price;
  DateTime date;
  int ownerid;
  Sale({
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

  Offer({
    required this.title,
    required this.description,
    required this.discount,
    required this.validUntil,
    required this.posterid,
  });
}

List<Sale> sales = [
  Sale(
    ownerid: 2,
    itemid: 0,
    quantity: 4,
    price: 25.0,
    date: DateTime(2023, 11, 15),
  ),
  Sale(
      ownerid: 2,
      itemid: 1,
      quantity: 1,
      price: 25.0,
      date: DateTime(2023, 11, 15)),
      Sale(
      ownerid: 2,
      itemid: 0,
      quantity: 66,
      price: 25.0,
      date: DateTime(2023, 11, 15)),
];
List<Map<String, dynamic>> getTopSellingTools() {
  final ownerSales =
      sales.where((sale) => sale.ownerid == global_user.id).toList();

  final Map<int, int> itemQuantities = {};

  for (var sale in ownerSales) {
    itemQuantities[sale.itemid] =
        (itemQuantities[sale.itemid] ?? 0) + sale.quantity;
  }

  final sortedItems = itemQuantities.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sortedItems.take(3).map((entry) {
    for(int i=0;i<items.length;i++){
      if(items[i].id == entry.key){
        return {
          'imageUrl':items[i].imagePaths[0],
          'description':items[i].description,
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
}

class Message {
  final int id;

  final int senderId;
  final String content;

  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      senderId: json['sender_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

void sendMessage(Chat chat, int senderId, String content, int reciverid) {
  int messageId = chat.messages.length + 1;
  Message newMessage = Message(
    id: messageId,
    senderId: senderId,
    content: content,
    createdAt: DateTime.now(),
  );

  chat.messages.add(newMessage);
  chat.lastMessage = DateTime.now();
}

List<Chat> chats = [
  Chat(
      lastMessage: DateTime.now(),
      id: 0,
      messages: [
        Message(
            id: 0,
            senderId: 0,
            content: "hi i am user 0",
            createdAt: DateTime.now()),
        Message(
            id: 1,
            senderId: 1,
            content: "hi i am user 1",
            createdAt: DateTime.now())
      ],
      u1: users[2],
      u2: users[1]),
  Chat(
      lastMessage: DateTime.now(),
      id: 1,
      messages: [
        Message(
            id: 0,
            senderId: 0,
            content: "hi i am user 0",
            createdAt: DateTime.now()),
        Message(
            id: 1,
            senderId: 2,
            content: "hi i am user 2",
            createdAt: DateTime.now())
      ],
      u1: users[3],
      u2: users[2]),
];

List<Chat> getuserchats() {
  List<Chat> result = [];

  for (int i = 0; i < chats.length; i++) {
    if (chats[i].u1.id == global_user.id || chats[i].u2.id == global_user.id) {
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
  final int publisherId;

  Item({
    required this.ownerid,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePaths,
    required this.availableQuantity,
    required this.publisherId,
  });
}

List<Item> items = [
  Item(
    ownerid: 2,
    id: 0,
    name: 'Item A',
    price: 25.0,
    description: 'Description of Item A',
    imagePaths: ['images/logo.png', 'images/logo3.png', 'images/logo2.png'],
    availableQuantity: 19,
    publisherId: 0,
  ),
  Item(
    ownerid: 2,
    id: 1,
    name: 'Item B',
    price: 15.0,
    description: 'Description of Item B',
    imagePaths: ['images/logo.png', 'images/logo3.png', 'images/logo2.png'],
    availableQuantity: 5,
    publisherId: 0,
  ),
];

List<Cart> carts = [
  Cart(
    cartId: 0,
    user_id: 0,
  ),
  Cart(
    cartId: 1,
    user_id: 1,
  ),
  Cart(
    cartId: 2,
    user_id: 2,
  ),
];

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
        publisherId: item.publisherId));
  }

  double get totalPrice => items.fold(
        0,
        (sum, cartItem) => sum + (cartItem.price * cartItem.availableQuantity),
      );
}

MaintenanceRecord findMostRecentRecord(List<MaintenanceRecord> records) {
  if (records.isEmpty) {
    return MaintenanceRecord(
      date: DateTime.now(),
      description: "description",
      userid: -1,
    );
  }

  return records.reduce(
    (current, next) => current.date.isAfter(next.date) ? current : next,
  );
}

List<MaintenanceRecord> maintenanceRecords = [
  MaintenanceRecord(
    userid: 1,
    date: DateTime(2023, 9, 25),
    description: "Oil Change\nPerformed at XYZ Service Center",
  ),
  MaintenanceRecord(
    userid: 1,
    date: DateTime(2023, 5, 15),
    description: "Tire Rotation\nChecked and balanced",
  ),
  MaintenanceRecord(
    userid: 1,
    date: DateTime(2023, 1, 10),
    description: "Brake Inspection\nReplaced brake pads",
  ),
];

class MaintenanceRecord {
  final DateTime date;
  final String description;
  final userid;
  MaintenanceRecord(
      {required this.date, required this.description, required this.userid});
  String getFormattedDate() {
    return DateFormat('d-M-yyyy').format(date);
  }
}

class Employee {
  final int id;
  final String name;
  final String position;
  List<Map<String, String>> assignedTasks;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    List<Map<String, String>>? assignedTasks,
  }) : assignedTasks = assignedTasks ?? [];
}

final List<Employee> employees = [
  Employee(id: 1, name: 'abdallah', position: 'Mechanic'),
  Employee(id: 2, name: 'Fadi', position: 'Technician'),
  Employee(id: 3, name: 'Momen', position: 'Assistant'),
];

class DeliveryRequest {
  int userid;
  int ownerid;
  final String phone;
  final String address;
  final String instructions;

  String status;

  DeliveryRequest({
    required this.ownerid,
    required this.userid,
    required this.phone,
    required this.address,
    required this.instructions,
    this.status = 'Pending',
  });
}

List<DeliveryRequest> deliveryRequests = [
  DeliveryRequest(
    userid: 1,
    ownerid: 2,
    phone: '1234567890',
    address: '123 Main St, City',
    instructions: 'Leave at the front door.',
  ),
  DeliveryRequest(
    userid: 1,
    ownerid: 0,
    phone: '0987654321',
    address: '456 Elm St, City',
    instructions: 'Call me upon arrival.',
  ),
];

List<Sale> salesrequest = [
  Sale(
      ownerid: 2,
      itemid: 0,
      quantity: 5,
      price: 10.0,
      date: DateTime.now().subtract(Duration(days: 3))),
];

String getitemnamebyid(int id) {
  for (Item item in items) {
    if (item.id == id) {
      return item.name;
    }
  }
  return 'Item not found';
}
class TowingService {
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  TowingService({
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}
List<TowingService> towingServices = [
  TowingService(
    name: 'TowPro Services',
    address: '123 Main Street, Cityville',
    phone: '1234567890',
 latitude: 80.2276,
    longitude: 80.2206,
  ),
  TowingService(
    name: 'Fast Tow',
    address: '456 Elm Street, Townsville',
    phone: '0987654321',
    
     latitude: 32.2276,
    longitude: 35.2206,
  ),
];




 final List<UserSignUpRequest> userRequests = [
    UserSignUpRequest(
      name: "John Doe",
      email: "johndoe@gmail.com",
      phone: "123-456-7890",
      description: "Looking for assistance with towing my car.",
      location: "New York, USA",
      latitude: 32.2276,
      longitude: 35.2206,
      images: [
        "images/logo2.png", 
        "images/logo.png",
        "images/logo3.png",
      ],
    ),
    UserSignUpRequest(
      name: "Jane Smith",
      email: "janesmith@gmail.com",
      phone: "987-654-3210",
      description: "Need roadside assistance for a flat tire.",
      location: "Los Angeles, USA",
      latitude: 34.0522,
      longitude: -118.2437,
      images: [
        "images/logo4.png", 
        "images/logo6.png",
        "images/logo5.png",
      ],
    ),
  ];

class UserSignUpRequest {
  final String name;
  final String email;
  final String phone;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> images;
  String placeDetails; 

  UserSignUpRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.images,
    this.placeDetails = 'Loading place details...', 
  });
}
