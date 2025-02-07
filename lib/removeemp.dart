import 'package:flutter/material.dart';
import 'package:CarMate/glopalvars.dart';

class DeleteEmployeePage extends StatefulWidget {
  @override
  _DeleteEmployeePageState createState() => _DeleteEmployeePageState();
}

class _DeleteEmployeePageState extends State<DeleteEmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    m();
  }
void m() async{
   await getEmployees();
    filteredEmployees = List.from(employees);
    setState(() {
      
    });
}

  void _searchEmployee(String query) {
    setState(() {
      filteredEmployees = employees
          .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.redAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Confirm Deletion",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to delete '${filteredEmployees[index].name}'?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: black, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          setState(() {
                            removeEmployee(filteredEmployees[index].id);
                            employees.remove(filteredEmployees[index]);
                            filteredEmployees.removeAt(index);
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Employee deleted successfully!"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Error deleting employee: ${e.toString()}"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateEmployee(int index) {
    Employee employee = filteredEmployees[index];
    TextEditingController _nameController =
        TextEditingController(text: employee.name);
    TextEditingController _positionController =
        TextEditingController(text: employee.position);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Update Employee",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: "Position",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work, color: Colors.grey),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: black, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                     try{
                           updateEmployee(employee.id, _nameController.text,
                              _positionController.text);
                          employee.name = _nameController.text;
                          employee.position = _positionController.text;

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Employee updated successfully!"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                     }catch(e){
                     ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Failed to update the employee!"),
                                  backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,));
                     }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(color: white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Employees",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: blue,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: _searchEmployee,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: "Search Employee",
                prefixIcon: Icon(Icons.search, color: blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredEmployees.isEmpty
                  ? Center(
                      child: Text(
                        "No employees found.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredEmployees.length,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: blue,
                                  child: Icon(Icons.person,
                                      color: white, size: 28),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        employee.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        employee.position,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: blue, size: 24),
                                      onPressed: () => _updateEmployee(index),
                                      tooltip: "Edit Employee",
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red, size: 24),
                                      onPressed: () => _deleteEmployee(index),
                                      tooltip: "Delete Employee",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
