import 'package:ev_homes/pages/admin_pages/app_dev_pages/analytic_dev_cards.dart';
import 'package:flutter/material.dart';

class AppDevDashboard extends StatelessWidget {
  const AppDevDashboard({super.key});

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
                  "Select Section",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildDashboardCard(
                        "Analytics",
                        Icons.analytics,
                        () {
                          //TODO: analytic dev cards
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AnalyticDevCards(),
                            ),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        "User Management",
                        Icons.people,
                        () {},
                      ),
                      _buildDashboardCard(
                        "Settings",
                        Icons.settings,
                        () {},
                      ),
                      _buildDashboardCard(
                        "Reports",
                        Icons.report,
                        () {},
                      ),
                    ],
                  ),
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
