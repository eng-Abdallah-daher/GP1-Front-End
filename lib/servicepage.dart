import 'package:first/OffersNotificationsPage.dart';
import 'package:first/RequestApp.dart';
import 'package:first/RequestCarDeliveryPage.dart';
import 'package:first/glopalvars.dart';
import 'package:first/repairestimate.dart';
import 'package:first/mainenancehistorypage.dart';
import 'package:first/maintenancepage.dart';
import 'package:first/store.dart';
import 'package:first/paymentpage.dart';
import 'package:first/trackrepairstatuspage.dart';
import 'package:first/viewratings.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _isQuickActionsVisible = true;

  List<Service> services = [
    Service(
      name: "Repair Shops",
      description: "Find nearby car repair shops.",
      location: "123 Main St",
      rating: 4.5,
      contact: "123-456-7890",
      price: 100,
      specialOffer: "10% off for new customers",
      faq: "Do you offer home service?",
      type: ServiceType.repairShop,
    ),
    Service(
      name: "Gas Stations",
      description: "Find the nearest gas stations.",
      location: "456 Elm St",
      rating: 4.0,
      contact: "987-654-3210",
      price: 3.5,
      specialOffer: "Discount on premium fuel.",
      faq: "Are there car wash services available?",
      type: ServiceType.gasStation,
    ),
  ];

  String selectedFilter = 'All';
  double selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _showFilterDialog,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 29, vertical: 16),
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
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () => _showServiceDetails(service),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            service.type == ServiceType.repairShop
                                ? Icons.build
                                : Icons.local_gas_station,
                            size: 40,
                            color: blueAccent,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: blueAccent),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  service.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange),
                                    SizedBox(width: 4),
                                    Text("${service.rating}",
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CollapseableContainer(
            title: 'Quick Actions',
            isVisible: _isQuickActionsVisible,
            onToggle: () {
              setState(() {
                _isQuickActionsVisible = !_isQuickActionsVisible;
              });
            },
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: EdgeInsets.all(16),
              children: [
                _buildActionButton(
                    Icons.schedule, "Maintenance Reminder", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaintenanceReminderPage()),
                  );
                }),
                _buildActionButton(
                  Icons.build,
                  "Maintenance Request",
                  white,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestApp(),
                      ),
                    );
                  },
                ),
                _buildActionButton(Icons.history, "Maintenance History", white,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaintenanceHistoryPage()),
                  );
                }),
                _buildActionButton(
                    Icons.shopping_cart, "Order Parts Online", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarToolStoreApp()),
                  );
                }),
                _buildActionButton(Icons.star, "View Workshop Ratings", white,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewWorkshopRatingsPage()),
                  );
                }),
                _buildActionButton(
                    Icons.notifications, "Offers Notifications", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OffersNotificationsPage()),
                  );
                }),
                _buildActionButton(
                    Icons.track_changes, "Track Repair Status", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrackRepairStatusPage()),
                  );
                }),
                _buildActionButton(
                    Icons.delivery_dining, "Request Car Delivery", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestCarDeliveryPage()),
                  );
                }),
                _buildActionButton(
                    Icons.assignment, "Get Repair Estimate", white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetEstimatePage()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
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
          side: BorderSide(color: Colors.blue, width: 2),
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
                color: Colors.blue,
              ),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void seestore() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarToolStoreApp()),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              'Filter Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: blueAccent,
              ),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [blueAccent, white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedFilter,
                            decoration: InputDecoration(
                              labelText: 'Select Service Type',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: blueAccent,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: [
                              'All',
                              'Repair Shops',
                              'Gas Stations',
                              'Car Rentals'
                            ]
                                .map(
                                  (filter) => DropdownMenuItem(
                                    value: filter,
                                    child: Row(
                                      children: [
                                        Icon(
                                          filter == 'Repair Shops'
                                              ? Icons.build
                                              : filter == 'Gas Stations'
                                                  ? Icons.local_gas_station
                                                  : filter == 'Car Rentals'
                                                      ? Icons.car_rental
                                                      : Icons.all_inclusive,
                                          color: blueAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Text(filter),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value!;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Minimum Rating',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: blueAccent,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  value: selectedRating,
                                  min: 0,
                                  max: 5,
                                  divisions: 5,
                                  activeColor: blueAccent,
                                  inactiveColor: Colors.blue[100],
                                  label: selectedRating.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRating = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showServiceDetails(Service service) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(service.name,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: blueAccent)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: blueAccent),
                  SizedBox(width: 4),
                  Text("Location: ${service.location}"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  SizedBox(width: 4),
                  Text("Rating: ${service.rating}"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.green),
                  SizedBox(width: 4),
                  Text("Price: \$${service.price}"),
                ],
              ),
              SizedBox(height: 16),
              Text("Details:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blueAccent)),
              Text(service.description),
              SizedBox(height: 16),
              Text("Special Offer: ${service.specialOffer}"),
              SizedBox(height: 16),
              Text("FAQ:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blueAccent)),
              Text(service.faq),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Book Now"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Add to Favorites"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Share"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
  }

  void _searchForCar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Search for Car functionality not yet implemented')));
  }

  void _getAnalysis() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Get Analysis functionality not yet implemented')));
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notifications functionality not yet implemented')));
  }

  void _requestTaxi() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request Taxi functionality not yet implemented')));
  }
}

enum ServiceType { repairShop, gasStation }

class Service {
  final String name;
  final String description;
  final String location;
  final double rating;
  final String contact;
  final double price;
  final String specialOffer;
  final String faq;
  final ServiceType? type;

  Service({
    required this.name,
    required this.description,
    required this.location,
    required this.rating,
    required this.contact,
    required this.price,
    required this.specialOffer,
    required this.faq,
    required this.type,
  });
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

class ReportIssuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Car Issue")),
      body: Center(child: Text("This is the Report Car Issue page.")),
    );
  }
}

class EmergencyServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Services")),
      body: Center(child: Text("This is the Emergency Services page.")),
    );
  }
}
