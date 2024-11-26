import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatefulWidget {
  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final List<Employee> employees = [
    Employee(id: 1, name: 'abdallah', position: 'Mechanic'),
    Employee(id: 2, name: 'Fadi', position: 'Technician'),
    Employee(id: 3, name: 'Momen', position: 'Assistant'),
  ];

  final List<Map<String, String>> availableSchedule = [
    {'date': '2024-10-01', 'time': '09:00 AM', 'task': 'Oil Change'},
    {'date': '2024-10-02', 'time': '11:30 AM', 'task': 'Tire Rotation'},
    {'date': '2024-10-03', 'time': '02:00 PM', 'task': 'Brake Inspection'},
  ];

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Employee> filteredEmployees = employees
        .where((employee) =>
            employee.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee Management',
          style: TextStyle(
            fontSize: 19, // Larger font size
            fontWeight: FontWeight.bold, // Bold for a stronger look
            color: Colors.white, // White for contrast against the gradient
          ),
        ),
        centerTitle: true, // Center the title for a balanced design
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlue
              ], // Gradient for the background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10, // Higher elevation for a more pronounced shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
         TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // Bright background for a clean look
                hintText: 'Search Employee by Name',
                hintStyle: TextStyle(
                  color: Colors.grey[500], // Subtle hint color
                  fontSize: 16,
                  fontStyle: FontStyle.italic, // Italic style for hint
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blueAccent, // Icon color matching the theme
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      30), // More rounded corners for a modern look
                  borderSide: BorderSide.none, // No border line
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 25), // Adequate padding
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2), // Focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2), // Border when not focused
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 2), // Error state border color
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 2), // Focused error border color
                ),
              ),
              style: TextStyle(
                color: Colors.black, // Input text color
                fontSize: 16, // Font size for input text
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),

            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];
                  return _buildEmployeeCard(context, employee);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Employee employee) {
    return GestureDetector(
      onTap: () {
        // Navigate to TaskDetailPage when the employee card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              employee: employee,
              availableSchedule: availableSchedule,
              onTaskRemoved: () {
                setState(
                    () {}); // Refresh the management page when a task is removed
              },
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 10, // Slightly increased elevation for a stronger shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // More rounded corners
        ),
        margin: EdgeInsets.symmetric(
            vertical: 12, horizontal: 8), // Consistent margin
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            employee.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Increased font size for title
              color: Colors.blueAccent,
            ),
          ),
          subtitle: Text(
            'Position: ${employee.position}\nAssigned Tasks: ${employee.assignedTasks.length}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16, // Slightly larger font size for subtitle
            ),
          ),
          trailing: Wrap(
            spacing: 10,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent
                    ], // Define your gradient colors
                    begin: Alignment.topLeft, // Starting point of the gradient
                    end: Alignment.bottomRight, // Ending point of the gradient
                  ),
                  borderRadius: BorderRadius.circular(
                      15), // Match the button's border radius
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Set background color to transparent to see the gradient
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0, // Remove elevation to avoid shadow issues
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8), // Adjusted padding
                  ),
                  onPressed: () {
                    _showEmployeeSchedule(context, employee);
                  },
                  child: Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 14, // Slightly increased font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showEmployeeSchedule(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for the dialog
          ),
          title: Text(
            '${employee.name}\'s Available Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center, // Center title text
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var entry in availableSchedule)
                  Card(
                    elevation:
                        10, // Increased elevation for a more pronounced shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Smooth, modern rounded corners
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16), // Larger margins for better spacing
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ), // Gradient background for a more dynamic look
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ], // More pronounced shadow for a floating effect
                      ),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today_rounded,
                            color: Colors
                                .white), // Task-related icon for a richer UI
                        title: Text(
                          '${entry['date']} at ${entry['time']}',
                          style: TextStyle(
                            fontSize:
                                18, // Increased font size for better readability
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // White color for a stronger contrast with the background
                          ),
                        ),
                        subtitle: Text(
                          'Task: ${entry['task']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70, // Softer white for subtitle
                          ),
                        ),
                        onTap: () {
                          _assignTaskToEmployee(employee, entry);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlue
                    ], // Define your gradient colors here
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10), // Adjust padding as needed
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight
                          .bold // Change text color to white for contrast
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _assignTaskToEmployee(Employee employee, Map<String, String> task) {
    setState(() {
      employee.assignedTasks.add(task);
      availableSchedule.remove(task);
    });
  }
}

class TaskDetailPage extends StatelessWidget {
  final Employee employee;
  final List<Map<String, String>> availableSchedule;
  final Function onTaskRemoved;

  TaskDetailPage({
    required this.employee,
    required this.availableSchedule,
    required this.onTaskRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${employee.name}\'s Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent, // Vibrant color for the app bar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Smoother gradient background
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: employee.assignedTasks.isEmpty
              ? Center(
                  child: Text(
                    '${employee.name} has no tasks assigned.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: employee.assignedTasks.length,
                  itemBuilder: (context, index) {
                    final task = employee.assignedTasks[index];
                    return Card(
                      elevation:
                          10, // Higher elevation for a more powerful shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade100,
                              Colors.blue.shade300
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(
                                  0, 4), // Offset shadow for a "lifted" effect
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(
                              20), // Larger padding for better spacing
                          title: Text(
                            '${task['date']} at ${task['time']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Accent color for task time
                            ),
                          ),
                          subtitle: Text(
                            'Task: ${task['task']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            iconSize: 28, // Larger delete icon for prominence
                            onPressed: () {
                              _removeTaskFromEmployee(employee, task);
                              onTaskRemoved(); // Refresh management page
                              Navigator.of(context).pop(); // Close detail page
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _removeTaskFromEmployee(Employee employee, Map<String, String> task) {
    // Remove task from assigned tasks and add it back to available schedule
    employee.assignedTasks.remove(task);
    availableSchedule.add(task);
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
