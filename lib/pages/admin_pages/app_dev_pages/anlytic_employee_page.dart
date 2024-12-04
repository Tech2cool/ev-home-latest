import 'package:ev_homes/components/loading/loading_square.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sale_head_pages/post_sale_head_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/post_sale_pages/post_sales_executive_pages/postsaleexecutive_dashboard.dart.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/data_analyzer_pages/data_analyzer_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/pre_sales_pages/pre_sales_executive_pages/pre_sales_executive_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/closing_manager_dashboard.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/sales_manager_pages/sales_manager_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnlyticEmployeePage extends StatefulWidget {
  final Designation designation;
  const AnlyticEmployeePage({
    super.key,
    required this.designation,
  });

  @override
  State<AnlyticEmployeePage> createState() => _AnlyticEmployeePageState();
}

class _AnlyticEmployeePageState extends State<AnlyticEmployeePage> {
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
      await settingProvider.getEmployeeByDesignation(
        widget.designation.id,
      );
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
    final employees = settingProvider.employeeBydDesg;

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
                widget.designation.designation,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, i) {
                      final emp = employees[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: _buildDashboardCard(
                          "${emp.firstName} ${emp.lastName}",
                          Icons.analytics,
                          () {
                            if (widget.designation.id ==
                                "desg-pre-sales-executive") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PreSalesExecutiveDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            } else if (widget.designation.id ==
                                "desg-data-analyzer") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DataAnalyzerDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            } else if (widget.designation.id ==
                                "desg-post-sales-executive") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostsaleexcecutiveDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            } else if (widget.designation.id ==
                                "desg-post-sales-head") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostSaleHeadDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            } else if (widget.designation.id ==
                                    "desg-sales-manager" ||
                                widget.designation.id ==
                                    "desg-sales-executive") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SalesManagerDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            } else if (widget.designation.id ==
                                "desg-senior-closing-manager") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ClosingManagerDashboard(
                                    id: emp.id,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       const SizedBox(height: 80),
          //       const Text(
          //         "Welcome to the Dashboard",
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //       const SizedBox(height: 20),

          //       Expanded(
          //         child: GridView.count(
          //           crossAxisCount: 2,
          //           crossAxisSpacing: 10,
          //           mainAxisSpacing: 10,
          //           children: [
          //             _buildDashboardCard("Pre Sales", Icons.analytics),
          //             _buildDashboardCard("Sales", Icons.settings),
          //             _buildDashboardCard("Post Sales", Icons.people),
          //             _buildDashboardCard("IT", Icons.report),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          if (isLoading) const LoadingSquare()
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
