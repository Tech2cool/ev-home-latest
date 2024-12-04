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
                        // Add navigation or action here
                      },
                    ),
                    _buildDashboardCard(
                      "Channel Partner",
                      Icons.group,
                      () {
                        // Add navigation or action here
                      },
                    ),
                    _buildDashboardCard(
                      "Admin",
                      Icons.admin_panel_settings,
                      () {
                        // Add navigation or action here
                      },
                    ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color.fromARGB(255, 211, 177, 83).withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 150, // Adjust the width of the card
          height: 150, // Adjust the height of the card
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.orangeAccent),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
