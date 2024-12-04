import 'package:ev_homes/pages/admin_pages/admin_management/manage_channel_partners.dart';
import 'package:ev_homes/pages/admin_pages/admin_management/manage_employee.dart';
import 'package:flutter/material.dart';

class UserManagementCards extends StatefulWidget {
  const UserManagementCards({super.key});

  @override
  State<UserManagementCards> createState() => UserManagementCardsState();
}

class UserManagementCardsState extends State<UserManagementCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Translucent gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 165, 0, 0.2),
                  Color.fromRGBO(255, 140, 0, 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Welcome to the Dashboard",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    _buildDashboardCard(
                      "Employee",
                      Icons.person,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ManageEmployee()),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      "Channel Partner",
                      Icons.group,
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ManageChannelPartners()),
                        );
                      },
                    ),
                    // _buildDashboardCard(
                    //   "Admin",
                    //   Icons.admin_panel_settings,
                    //   () {
                    //     // Add navigation or action here
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon,
    GestureTapCallback? onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.orangeAccent),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
