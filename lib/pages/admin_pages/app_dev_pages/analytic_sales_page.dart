import 'package:flutter/material.dart';

class AnalyticSalesPage extends StatelessWidget {
  const AnalyticSalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for designations
    final List<String> designations = [
      "Site Head",
      "Sales Manager",
      "Reception",
    ];

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
          Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Sales List",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: designations.length,
                  itemBuilder: (context, i) {
                    final desg = designations[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: _buildDashboardCard(
                        desg,
                        Icons.analytics,
                        () {
                          //TODO: analytic sales pages routes
                          // if (desg == "Site Head") {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => const SiteheadDashboard(),
                          //     ),
                          //   );
                          // } else if (desg == "Sales Manager") {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           const SalesmangerDashbord(),
                          //     ),
                          //   );
                          // } else if (desg == "Reception") {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           const ReceptionDashboard(),
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    );
                  },
                ),
              )
            ],
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
