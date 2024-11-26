import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Management'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Button: Manage Bookings & Appointments
            ServiceButton(
              label: 'Manage Bookings & Appointments',
              description:
                  'View available times and send notifications to customers about their appointments.',
              icon: Icons.schedule,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Manage Requests & Maintenance
            ServiceButton(
              label: 'Manage Requests & Maintenance',
              description:
                  'View maintenance requests and track their status (in-progress, completed, etc.).',
              icon: Icons.build,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Billing & Payments
            ServiceButton(
              label: 'Billing & Payments',
              description:
                  'Create electronic invoices and handle payments (cash or app-based).',
              icon: Icons.payment,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Employee Management
            ServiceButton(
              label: 'Employee Management',
              description:
                  'Assign employees based on bookings and monitor their progress.',
              icon: Icons.people,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Monthly Performance Review
            ServiceButton(
              label: 'Monthly Performance Review',
              description:
                  'View monthly reports of performance, customers, profits, and feedback.',
              icon: Icons.bar_chart,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Inventory Management
            ServiceButton(
              label: 'Inventory Management',
              description:
                  'Track spare parts and receive alerts when stock is low.',
              icon: Icons.inventory,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Analytics & Reports
            ServiceButton(
              label: 'Analytics & Reports',
              description:
                  'Analyze service data to optimize focus and identify peak times.',
              icon: Icons.analytics,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Complaints & Feedback
            ServiceButton(
              label: 'Complaints & Feedback',
              description:
                  'Monitor complaints and gather feedback to improve services.',
              icon: Icons.feedback,
              onPressed: () {
                // Add functionality here
              },
            ),
            SizedBox(height: 10),

            // Button: Advertisement Management
            ServiceButton(
              label: 'Advertisement Management',
              description: 'Create and manage promotional advertisements.',
              icon: Icons.campaign,
              onPressed: () {
                // Add functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  ServiceButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 36),
        title: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        onTap: onPressed,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ServicesPage(),
  ));
}
