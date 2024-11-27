import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/anlytic_employee_page.dart';
import 'package:flutter/material.dart';

class AnalyticDesignationsPage extends StatelessWidget {
  final List<Designation> designations;
  final String section;
  const AnalyticDesignationsPage(
      {super.key, required this.designations, required this.section});

  @override
  Widget build(BuildContext context) {
    // final settingProvider = Provider.of<SettingProvider>(context);
    // final designations = settingProvider.designations;
    // final fileteredDesg = designations
    //     .where((el) => el.id.contains("pre-") || el.id.contains("data-"))
    //     .toList();
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
              Text(
                section,
                style: const TextStyle(
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
                        desg.designation,
                        Icons.analytics,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnlyticEmployeePage(
                                designation: desg,
                              ),
                            ),
                          );
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
