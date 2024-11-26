import 'package:first/glopalvars.dart';
import 'package:flutter/material.dart';

class OwnerPaymentPage extends StatefulWidget {
  @override
  _OwnerPaymentPageState createState() => _OwnerPaymentPageState();
}

class _OwnerPaymentPageState extends State<OwnerPaymentPage> {
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    filteredUsers = users.where((user) => user.role == 'owner').toList();
  }

  void filterUsers() {
    setState(() {
      filteredUsers = users.where((user) {
        return user.role == 'owner' &&
            user.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  bool hasPaid(User user) {
    return PaymentHistory.hasPaid(user.id, selectedYear, selectedMonth);
  }

  void togglePaymentStatus(User user) {
    setState(() {
      PaymentHistory.togglePaymentStatus(user.id, selectedYear, selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200,
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: List.generate(5, (index) {
                      int year = DateTime.now().year - index;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 18.0),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.blue.shade200
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.blue.shade300,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      );
                    }),
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    iconSize: 30,
                    underline: SizedBox(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    dropdownColor: Colors.blue.shade100,
                  ),
                ),
                DropdownButton<int>(
                  value: selectedMonth,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade200,
                              Colors.blue.shade500
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          DateTime(0, index + 1).monthName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  iconSize: 30,
                  underline: SizedBox(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                  dropdownColor: Colors.blue.shade300,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Owner",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
                hintText: "Enter owner's name",
                hintStyle: TextStyle(
                  color: Colors.blue.shade400,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blue.shade600,
                    width: 2.0,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onChanged: (text) => filterUsers(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  User user = filteredUsers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            const Color.fromARGB(255, 194, 218, 237)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(user.profileImage!),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              user.phone,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            hasPaid(user)
                                ? Icons.check_circle
                                : Icons.remove_circle,
                            color: hasPaid(user) ? Colors.green : Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            togglePaymentStatus(user);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String get monthName {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][this.month - 1];
  }
}

void main() {
  runApp(MaterialApp(
    home: OwnerPaymentPage(),
  ));
}
