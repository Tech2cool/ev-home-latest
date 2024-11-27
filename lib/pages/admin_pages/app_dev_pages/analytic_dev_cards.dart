import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/analytic_post_sales_page.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/analytic_pre_sales_page.dart';
import 'package:ev_homes/pages/admin_pages/app_dev_pages/analytic_sales_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticDevCards extends StatefulWidget {
  const AnalyticDevCards({super.key});

  @override
  State<AnalyticDevCards> createState() => _AnalyticDevCardsState();
}

class _AnalyticDevCardsState extends State<AnalyticDevCards> {
  bool isLoading = false;
  Future<void> _onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      setState(() {
        isLoading = true;
      });

      await settingProvider.getTeamSections();
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
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
                  children: [
                    ...List.generate(settingProvider.teamSections.length, (i) {
                      final team = settingProvider.teamSections[i];
                      return _buildDashboardCard(
                        team.section,
                        Icons.analytics,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnalyticDesignationsPage(
                                designations: team.designations,
                                section: team.section,
                              ),
                            ),
                          );
                        },
                      );
                    })
                  ],
                ),
                // Expanded(
                //   child: GridView.count(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 10,
                //     mainAxisSpacing: 10,
                //     children: [
                //       _buildDashboardCard(
                //         "Pre Sales",
                //         Icons.analytics,
                //         () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) =>
                //                   const AnalyticPreSalesPage(),
                //             ),
                //           );
                //         },
                //       ),
                //       _buildDashboardCard(
                //         "Sales",
                //         Icons.settings,
                //         () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const AnalyticSalesPage(),
                //             ),
                //           );
                //         },
                //       ),
                //       _buildDashboardCard(
                //         "Post Sales",
                //         Icons.people,
                //         () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) =>
                //                   const AnalyticPostSalesPage(),
                //             ),
                //           );
                //         },
                //       ),
                //       _buildDashboardCard(
                //         "IT",
                //         Icons.report,
                //         () {},
                //       ),
                //     ],
                //   ),
                // ),
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
