import 'package:CarMate/AdvertisementManagementPage.dart';
import 'package:CarMate/BillingPaymentPage.dart';
import 'package:CarMate/ComplaintsListPage.dart';
import 'package:CarMate/EmployeeManagementPage.dart';
import 'package:CarMate/InventoryManagementPage.dart';
import 'package:CarMate/ManageBookingsPage.dart';
import 'package:CarMate/ManageRequestsPage.dart';
import 'package:CarMate/MonthlyPerformanceReviewPage.dart';
import 'package:CarMate/glopalvars.dart';
import 'package:CarMate/ownerdelivaryrequests.dart';
import 'package:flutter/material.dart';

class OwnerServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<OwnerServicesPage> {
  bool _isQuickActionsVisible = true;
  List<String> _selectedFilters = [];
  List<Map<String, dynamic>> _actions = [];
  List<Map<String, dynamic>> _filteredActions = [];
late ScrollController _scrollController=  ScrollController();
  @override
  void initState() {
    super.initState();
    _actions = [
      {
        'icon': Icons.schedule,
        'label': "Manage Bookings & Appointments",
        'page': ManageBookingsPage(),
      },
      {
        'icon': Icons.build,
        'label': "Manage Requests & Maintenance",
        'page': ManageRequestsPage(),
      },
      {
        'icon': Icons.people,
        'label': "Employee Management",
        'page': EmployeeManagementPage(),
      },
     
      {
        'icon': Icons.bar_chart,
        'label': "Monthly Performance Review",
        'page': PerformanceAndProfitPage(),
      },
      {
        'icon': Icons.inventory,
        'label': "Sales & Inventory Management",
        'page': InventoryManagementPage(),
      },
      {
        'icon': Icons.car_rental,
        'label': "Delivery Requests",
        'page': OwnerDeliveryRequestsPage(),
      },
      {
        'icon': Icons.feedback_outlined,
        'label': "Complaints & Feedback",
        'page': ComplaintsListPage(),
      },
      {
        'icon': Icons.campaign,
        'label': "Advertisement Management",
        'page': OfferManagementPage(),
      },
    ];

    _filteredActions = List.from(_actions);
  }
void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> filterOptions = [
          "Bookings",
          "Maintenancea",
          "Employees",
       
          "Performance",
          "Inventory",
          "Requests",
          "Complaints",
          "Advertisement"
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.blue.shade50,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Icon(Icons.filter_list,
                      color: Colors.blue.shade800, size: 28),
                ],
              ),
              content: SingleChildScrollView(
           
                child: Column(
                  children: [
                    Divider(color: Colors.blue.shade200, thickness: 1),
                    ...filterOptions.map((option) {
                      return CheckboxListTile(
                        activeColor: Colors.blue.shade700,
                        checkColor: white,
                        title: Row(
                          children: [
                            Icon(
                              _getIconForOption(option),
                              color: Colors.blue.shade700,
                            ),
                            SizedBox(width: 10),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        value: _selectedFilters.contains(option),
                        onChanged: (isSelected) {
                          setState(() {
                            if (isSelected == true) {
                              _selectedFilters.add(option);
                            } else {
                              _selectedFilters.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedFilters.clear();
                          _filteredActions = List.from(_actions);
                          _applyFilters();
                        });
                      },
                      icon: Icon(Icons.clear, color: white),
                      label: Text(
                        "Clear",
                        style: TextStyle(color: white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      icon: Icon(Icons.check, color: white),
                      label: Text(
                        "Apply",
                        style: TextStyle(color: white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getIconForOption(String option) {
    switch (option) {
      case "Bookings":
        return Icons.schedule;
      case "Maintenancea":
        return Icons.build;
      case "Employees":
        return Icons.people;
      
      case "Performance":
        return Icons.bar_chart;
      case "Inventory":
        return Icons.inventory;
      case "Requests":
        return Icons.car_rental;
      case "Complaints":
        return Icons.feedback_outlined;
      case "Advertisement":
        return Icons.campaign;
      default:
        return Icons.help_outline;
    }
  }

  void _applyFilters() {
     
    setState(() {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      if (_selectedFilters.isEmpty) {
        _filteredActions = List.from(_actions);
      } else {
        _filteredActions = _actions.where((action) {
          String label = action['label'];
          return _selectedFilters.any(
              (filter) => label.toLowerCase().contains(filter.toLowerCase()));
        }).toList();
      }
    });
  
 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Aligns the button to the left
              children: [
                Container(
                  width: 250,
                  height: 70, // Set the width for the button
                  child: ElevatedButton(
                    onPressed: _showFilterDialog,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 29, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: blueAccent.withOpacity(0.4),
                    ).copyWith(
                      side: MaterialStateProperty.all(
                        BorderSide(color: blueAccent, width: 2),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.blueAccent.shade700;
                          }
                          return Colors.blueAccent.shade400;
                        },
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.filter_list, color: white),
                            SizedBox(width: 8),
                            Text(
                              'Filter Services',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About Our Services",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Explore a variety of car maintenance and repair services tailored to your needs.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Quick Tips:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  children: [
                    _buildTip(
                      icon: Icons.check_circle,
                      tip: "Manage bookings or customers.",
                      iconColor: Colors.green.shade600,
                    ),
                   _buildTip(
                      icon: Icons.check_circle,
                      tip: "Manage employees for smooth business",
                      iconColor: Colors.green.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
         SingleChildScrollView(
          controller: _scrollController,
          
            child: CollapseableContainer(
              title: 'Quick Actions',
              isVisible: _isQuickActionsVisible,
              onToggle: () {
                setState(() {
                  _isQuickActionsVisible = !_isQuickActionsVisible;
                });
              },
              child: SizedBox(
                height:
                    1100,
                child: GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), 
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: EdgeInsets.all(16),
                  children: [
                    ..._filteredActions.map((action) {
                      return _buildActionButton(
                        action['icon'],
                        action['label'],
                        white,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => action['page']),
                          );
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

Widget _buildTip(
    {required IconData icon, required String tip, required Color iconColor}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: 22),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          tip,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}

ElevatedButton _buildActionButton(
    IconData icon, String label, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 80),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: blue, width: 2),
      ),
      elevation: 10,
      shadowColor: color.withOpacity(0.5),
    ).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return color.withOpacity(0.9);
          }
          return color;
        },
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color, white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 34,
              color: blue,
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: blue,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CollapseableContainer extends StatefulWidget {
  final String title;
  final bool isVisible;
  final VoidCallback onToggle;
  final Widget child;

  CollapseableContainer({
    required this.title,
    required this.isVisible,
    required this.onToggle,
    required this.child,
  });

  @override
  _CollapseableContainerState createState() => _CollapseableContainerState();
}

class _CollapseableContainerState extends State<CollapseableContainer>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isVisible) {
      _animationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(CollapseableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: blueAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                AnimatedIcon(
                  icon: AnimatedIcons.arrow_menu,
                  progress: _animation,
                  color: white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [white, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 450,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
