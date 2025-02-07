import 'package:CarMate/addemp.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/removeemp.dart';
import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatefulWidget {
  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  @override
  void initState() {
    
    m();
    super.initState();
  
  }

  void m()async{
     await getEmployees();
    getAssignedTasks();
    setState(() {
      
    });
  }
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
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteEmployeePage(),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.settings_outlined,
                color: white,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeePage(),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.add,
                color: white,
                size: 30,
              ))
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [blueAccent, lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: white,
                hintText: 'Search Employee by Name',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: blueAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: blueAccent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              style: TextStyle(
                color: black,
                fontSize: 16,
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
                  if(employee.ownerid==global_user.id){
                    return _buildEmployeeCard(context, employee);
                  }else{
                    return SizedBox(height: 0,width: 0,);
                  }
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
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(
              employee: employee,
              onTaskRemoved: () {
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Card(
        color: white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            employee.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: blueAccent,
            ),
          ),
          subtitle: Text(
            'Position: ${employee.position}\nAssigned Tasks: ${employee.assignedTaskIds.length}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          trailing: Wrap(
            spacing: 10,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blue, lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    _showEmployeeSchedule(context, employee);
                  },
                  child: Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 14,
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
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '${employee.name}\'s Available Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var entry in availableSchedule)
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade300, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today_rounded,
                            color: white),
                        title: Text(
                          '${entry.date} at ${entry.time}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                        subtitle: Text(
                          'Task: ${entry.task}',
                          style: TextStyle(
                            fontSize: 16,
                            color: white,
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
                    colors: [blueAccent, lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

 void _assignTaskToEmployee(Employee employee, AssignedTask task) {

    setState(() {
      employee.assignedTaskIds.add(task);
      addTask(employee.id, task);
      removeTaskFromSchedule(task.taskId);
      availableSchedule.removeWhere(
          (scheduledTask) => scheduledTask.taskId == task.taskId);
    });
    
  }
}

class TaskDetailPage extends StatelessWidget {
  final Employee employee;
 
  final Function onTaskRemoved;

  TaskDetailPage({
    required this.employee,
 
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
        backgroundColor: blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: employee.assignedTaskIds.isEmpty
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
                  itemCount: employee.assignedTaskIds.length,
                  itemBuilder: (context, index) {
                    final task = employee.assignedTaskIds[index];
                    return Card(
                      elevation: 10,
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
                             Colors. blue.shade300
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(20),
                          title: Text(
                            '${task.date} at ${task.time}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          subtitle: Text(
                            'Task: ${task.task}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            iconSize: 28,
                            onPressed: () {
                          try{
                                _removeTaskFromEmployee(employee, task);
                              onTaskRemoved();
                                  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task removed successfully!'),
        backgroundColor: blue,
        duration: Duration(seconds: 2),
      ),
    );
                          }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to remove the task!'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                          }
                              Navigator.of(context).pop();
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

  void _removeTaskFromEmployee(Employee employee,AssignedTask task) {
    removeTask(employee.id, task.taskId);
      employee.assignedTaskIds.remove(task);
  
    availableSchedule.add(task);
    addTaskToSchedule(task);
  
  }
}
