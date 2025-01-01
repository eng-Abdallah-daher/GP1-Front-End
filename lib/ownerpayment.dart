import 'package:flutter/material.dart';
import 'package:CarMate/glopalvars.dart';

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
    m();
    filteredUsers = users
        .sublist(1, users.length)
        .where((user) => user.role == 'owner')
        .toList();
    super.initState();
  }
void m ()async{
  await fetchPaymentRecords();
  setState(() {
    
  });
}
  void filterUsers() {
    setState(() {
      filteredUsers = users.sublist(1, users.length).where((user) {
        return user.role == 'owner' &&
            user.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  bool hasPaid(User user) {
    return paymentHistory.any((record) =>
        record.userId == user.id &&
        record.year == selectedYear &&
        record.month == selectedMonth &&
        record.paid);
  }

  void removePaymentRecord(User user) {
   
    setState(() {
      for(int i=0;i<paymentHistory.length;i++) {
         deletePaymentRecordfromdb(paymentHistory[i].id);
        if(paymentHistory[i].userId == user.id && paymentHistory[i].year == selectedYear && paymentHistory[i].month == selectedMonth) {
          paymentHistory.removeAt(i);
          break;
        }
      }
      
     
    });
  }

  void addPaymentRecord(User user) {
    addPaymentRecordtodb(userId: user.id, year: selectedYear, month: selectedMonth,  id: paymentHistory.isEmpty?0: paymentHistory[paymentHistory.length - 1].id + 1 );
        setState(() {
      paymentHistory.add(PaymentRecord(
        userId: user.id,
        year: selectedYear,
        month: selectedMonth,
        paid: true,
        id: paymentHistory.isEmpty ? 0 : paymentHistory[paymentHistory.length - 1].id + 1,
      ));
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(5, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800)),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                ),
                _buildDropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(DateTime(0, index + 1).monthName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800)),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSearchField(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  User user = filteredUsers[index];
                  return _buildUserCard(user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildDropdownButton<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,Colors.blue.shade100,
            Colors.blue.shade400, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          items: items,
          icon: Icon(
            Icons.arrow_drop_down_circle_rounded,
            color: Colors.white,
            size: 28,
          ),
          dropdownColor: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ),
    );
  }


  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: "Search Owner",
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
        prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.blue.shade50,
        hintText: "Enter owner's name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
      onChanged: (text) => filterUsers(),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Color.fromARGB(255, 194, 218, 237)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profileImage!),
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            user.email,
            style: TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: Icon(
              hasPaid(user) ? Icons.check_circle : Icons.remove_circle,
              color: hasPaid(user) ? Colors.green : Colors.red,
            ),
            onPressed: () {
              
              if (hasPaid(user)) {
                removePaymentRecord(user);
              } else {
                addPaymentRecord(user);
              }
            },
          ),
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
