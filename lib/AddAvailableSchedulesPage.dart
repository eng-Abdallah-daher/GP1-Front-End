import 'package:CarMate/glopalvars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class AddAvailableSchedulesPage extends StatefulWidget {
  @override
  _AddAvailableSchedulesPageState createState() =>
      _AddAvailableSchedulesPageState();
}

class _AddAvailableSchedulesPageState extends State<AddAvailableSchedulesPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _taskController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  DateTime? _selectedDateTime;
  
  int _taskIdCounter = 1;

  @override
  void dispose() {
    getAssignedTasks();
    _taskController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  void _saveSchedule() {
    if (_formKey.currentState!.validate()) {
      final dateTime = _selectedDateTime!;
      final date = DateFormat('yyyy-MM-dd').format(dateTime);
      final time = DateFormat('hh:mm a').format(dateTime);

      setState(() {
        int p=0;
        if(availableSchedule.isNotEmpty){
 p = int.parse(
                  availableSchedule[availableSchedule.length - 1].taskId) +
              1;
        }
        addTaskToSchedule(AssignedTask(
          taskId: p.toString(),
          date: date,
          time: time,
          task: _taskController.text,
          ownerId: global_user.id.toString(),
        ));
        availableSchedule.add(
          AssignedTask(
            taskId: p.toString(),
            date: date,
            time: time,
            task: _taskController.text,
            ownerId: global_user.id.toString(),
          ),
        );
        _taskController.clear();
        _dateTimeController.clear();
        _selectedDateTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Schedule added successfully!'),
          backgroundColor: Colors.blue.shade800,
        ),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: _buildDatePickerTheme,
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: _buildTimePickerTheme,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateTimeController.text =
              DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!);
        });
      }
    }
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String validatorMessage,
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.blue.shade800),
        hintStyle: TextStyle(color: Colors.blue.shade300),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
        ),
        prefixIcon: Icon(
          Icons.task,
          color: Colors.blue.shade800,
        ),
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }
Widget _buildSchedulesList() {
    if (availableSchedule.isEmpty) {
      return Center(
        child: Text(
          "No schedules added yet.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: availableSchedule.length,
      itemBuilder: (context, index) {
        final schedule = availableSchedule[index];
        if(schedule.ownerId==global_user.id.toString())
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200.withOpacity(0.5),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue.shade800,
                        child: Text(
                          schedule.taskId.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          schedule.task,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade700,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            removeTaskFromSchedule(availableSchedule[index].taskId);
                            availableSchedule.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Schedule removed successfully!'),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(color: Colors.blue.shade400, thickness: 1),
                  SizedBox(height: 8),
                  Text(
                    "Date: ${schedule.date}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Time: ${schedule.time}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget Function(BuildContext, Widget?) get _buildDatePickerTheme =>
      (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.blue.shade50,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
              ),
            ),
          ),
          child: child!,
        );
      };

  Widget Function(BuildContext, Widget?) get _buildTimePickerTheme =>
      (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.blue.shade50,
              dialHandColor: Colors.blue.shade800,
              dayPeriodTextColor: Colors.blue.shade800,
            ),
          ),
          child: child!,
        );
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Available Schedules",
          style: TextStyle(fontWeight: FontWeight.bold,color: white),
        ),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        elevation: 10.0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Set Up Your Schedule",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: "Task",
                hint: "Enter task description",
                controller: _taskController,
                validatorMessage: "Task is required",
              ),
              SizedBox(height: 20),
              _buildInputField(
                label: "Date & Time",
                hint: "Select date and time",
                controller: _dateTimeController,
                validatorMessage: "Date & Time is required",
                readOnly: true,
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveSchedule,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Add Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8.0,
                ),
              ),
              SizedBox(height: 20),
              Expanded(child: _buildSchedulesList()),
            ],
          ),
        ),
      ),
    );
  }
}
