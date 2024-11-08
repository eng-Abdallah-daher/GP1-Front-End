library global;

import 'dart:convert';
import 'package:first/adminpages.dart';
import 'package:first/nentalpages.dart';
import 'package:first/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
  
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
List<Map<String, String>> cars = [];
String userid = "";
String selectedcarimage = "images/logo.png";
String selectedcarmodel = "2021";
String selectedcarname = "BMW";

bool isLogged = true; 
List<int> numbers = [];
List<User> users = [];
String token = "";
List<LatLng> tappedLocations = [];
User selectedUser = User("1", "", "abd", "abd");
Future<bool> login(BuildContext context) async {
  final url = Uri.parse(
      'http://localhost:4000/api/users/login'); 
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': emailController.text,
      'password': passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    token = data["token"];

    Map<String, dynamic> profile = await getProfile();

    if (profile["role"] == "user") {
      await fetchrentars();
      
      await getRents();
      await fetchCars();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => userpages()),
      );
    } else if (profile["role"] == "admin") {
      await getPrices();
      await fetchReviews();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Adminpages()),
      );
    } else {
      await fetchCars();
      await getRentalsByUser();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RentalPages()),
      );
    }
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: ${response.body}')),
    );
  }
  return false;
}
Future<void> createCar(
    String name, String model, String rentPrice, String imagePath) async {
  final String url = 'http://localhost:4000/api/cars/create';

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'UserId': userid,
    'Name': name,
    'Model': model,
    'RentPrice': rentPrice,
    'availability': true,
    'Image': imagePath,
  });

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 201) {
 
  } else {
    throw Exception('Failed to create car: ${response.reasonPhrase}');
  }
}

Future<void> fetchCars() async {
  final String url = 'http://localhost:4000/api/cars';
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    cars=[];
    items = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i]['availability'].toString() == '1') {
          cars.add({
            'id': jsonResponse[i]['id'].toString(),
            'name': jsonResponse[i]['Name'],
            'model': jsonResponse[i]['Model'],
            'pricePerDay': jsonResponse[i]['RentPrice'],
            'imageUrl': jsonResponse[i]['Image'],
            'availability': jsonResponse[i]['availability'].toString()
          });
        }
        print(cars);
        items.add(Item(
            id: jsonResponse[i]['id'],
            name: jsonResponse[i]['Name'],
            description: jsonResponse[i]['Model'],
            price: double.parse(jsonResponse[i]['RentPrice']),
            imageUrl: jsonResponse[i]['Image']));
      }
    } else {
      throw Exception('Failed to load cars');
    }
  } catch (error) {
    throw Exception('Error occurred while fetching cars');
  }
}
String selectedid="";
Future<void> fetchrentars() async {
  final String url = 'http://localhost:4000/api/users/renters';
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);
    cars.clear();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      for (int i = 0; i < jsonResponse.length; i++) {
        users.add(User(
            jsonResponse[i]['user_id'].toString(),
            jsonResponse[i]['first_name'] + jsonResponse[i]['last_name'],
            jsonResponse[i]['email'],
            jsonResponse[i]['phone_number']));
      }
    }
  } catch (error) {
    throw Exception('Error occurred while fetching cars');
  }
}

Future<void> createRental({
  required String carId,
  required String renterId,
  required String startDate,
  required int rentalDuration,
  required String rentalMethod,
}) async {
  final String url = 'http://localhost:4000/api/rentals';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  DateTime start = DateTime.parse(startDate);
  DateTime end = start.add(Duration(days: rentalDuration));
  String endDate = end.toIso8601String();
  final body = jsonEncode({
    'Car-Id': carId,
    'renter_id': renterId,
    'start_date': startDate,
    'end_date': endDate,
    'rental_duration': rentalDuration,
    'rental_method': rentalMethod,
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
    }
  } catch (e) {}
}

List<String> reviews = [];
Future<void> fetchReviews() async {
  final String url =
      'http://localhost:4000/api/admin/reviews'; 

  final headers = {
    'Authorization':
        'Bearer $token', 
    'Content-Type': 'application/json', 
  };

  final response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      final review = jsonResponse[i];
      numbers.add(review['rating']);

      reviews.add(
        review['comment'],
      );
    }
  } else {
    throw Exception('Failed to load reviews: ${response.reasonPhrase}');
  }
}

Future<void> createLocation(double latitude, double longitude) async {
  final url = Uri.parse(
      'http://localhost:4000/api/admin/locations'); 

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', 
  };

  final body = jsonEncode({
    'latitude': latitude,
    'longitude': longitude,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
    }
  } catch (e) {}
}

Future<Map<String, dynamic>> getProfile() async {
  final Uri url = Uri.parse(
      'http://localhost:4000/api/users/profile'); 

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token', 
    },
  );

  if (response.statusCode == 200) {
    userid = json.decode(response.body)['userId'].toString();

    return json.decode(response.body) as Map<String, dynamic>;
  } else if (response.statusCode == 401) {
    throw Exception('Access token missing or invalid. Please log in again.');
  } else if (response.statusCode == 403) {
    throw Exception('Token expired or could not authenticate.');
  } else {
    throw Exception(
        'Failed to fetch profile. Status code: ${response.statusCode}');
  }
}

class User {
  String id;
  String name;
  String email;
  String phone;

  User(this.id, this.name, this.email, this.phone);
}

List<Map<String, dynamic>> profitData = [];

Future<void> getPrices() async {
  List<Map<String, dynamic>> profitData = [];

  try {
   
    final response = await http.get(
      Uri.parse("http://localhost:4000/api/admin/prices"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> prices = jsonDecode(response.body);

      profitData.clear();

      for (int j = 0; j < prices.length; j++) {
        if (isWithinLast5Months(prices[j]['date'])) {
// profitData.add({
// "date": getMonthFromDateString(prices[j]['date']).toString(),
// "profit":prices[j]["total_price"]
// });
        }
      }

      profitData = profitData.reversed.toList();
    }
  } catch (error) {}
}

bool isWithinLast5Months(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    DateTime fiveMonthsAgo = DateTime(now.year, now.month - 5);

    return date.isAfter(fiveMonthsAgo) && date.isBefore(now);
  } catch (e) {
    return false;
  }
}

int getMonthFromDateString(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString); 
    return date.month;
  } catch (e) {
    return -1;
  }
}

Future<void> getRentalsByUser() async {
  getProfile();

  final url = Uri.parse("http://localhost:4000/api/rentals/user/$userid");

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      requests.clear();
      List<dynamic> rentals = jsonDecode(response.body);

      for (int i = 0; i < rentals.length; i++) {
        String carname = "";
        String carmodel = "";
        String carimage = "";
        for (int j = 0; j < cars.length; j++) {
          if (cars[j]['id'].toString() == rentals[i]['Car_Id'].toString()) {
            carname = cars[j]['name']!;
            carmodel = cars[j]['model']!;
            carimage = cars[j]['imageUrl']!;
            break;
          }
        }

        requests.add(
          RentRequest(
            carName: carname,
            carModel: carmodel,
            imageUrl: carimage,
            status: rentals[i]['rental_status'],
          ),
        );
      }
    }
  } catch (error) {}
}

Future<void> deletecar(int id) async {
  final url = Uri.parse("http://localhost:4000/api/cars/$id");

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      print("deleted");
    }
  } catch (error) {}
}

Future<void> updatecar(int id, String name, String model, String price) async {
  final url = Uri.parse("http://localhost:4000/api/cars/$id");

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode({
        'Name': name,
        'Model': model,
        'RentPrice': price,
      }),
    );

    if (response.statusCode == 200) {
      print("Car updated successfully");
    } else {
      print("Failed to update car: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
  }
}


List<RentRequest> requests = [];

class RentRequest {
  final String carName;
  final String carModel;
  final String imageUrl; 
  final String status; 

  RentRequest({
    required this.carName,
    required this.carModel,
    required this.imageUrl,
    required this.status,
  });
}

class Item {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

List<Item> items = [];

class RentRequest2 {
  final String id;
  final String carName;
  final String carModel;
  final String imageUrl;
  final String price;
  final String duration;
  final String renterName;
  final String rentalMethod;
  

  RentRequest2({
    required this.id,
    required this.carName,
    required this.carModel,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.renterName,
    required this.rentalMethod,
    
  });
}
Future<void> getRents() async {
  getProfile();
fetchrentars();
Map carsp;
  final url = Uri.parse("http://localhost:4000/api/users/rents");

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      requests2.clear();
      List<dynamic> rentals = jsonDecode(response.body);
      
String carname="",carmodel="",carimage="";
      for (int i = 0; i < rentals.length; i++) {
        final url = Uri.parse("http://localhost:4000/api/cars/${rentals[i]['Car_Id']}");

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      carsp = jsonDecode(response.body);
      print(carsp);
carname=carsp['Name'];
carmodel=carsp['Model'];
carimage=carsp['Image'];
print(carimage);
    }
  } catch (error) {}
String h="";
  for(int j=0;j<users.length;j++){
    if(users[j].id.toString()==rentals[i]['renter_id'].toString()){
h=users[j].name;
break;
    }
  }
  
       requests2.add(RentRequest2(id: rentals[i]['rental_id'].toString(),carName:carname , carModel: carmodel, imageUrl: carimage, price:rentals[i]['price'] , duration:rentals[i]['rental_duration'] , renterName: h, rentalMethod: rentals[i]['rental_method']));
        }

     
      
    }
  } catch (error) {}
}
List<RentRequest2>requests2=[];
