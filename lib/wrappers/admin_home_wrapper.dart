import 'package:ev_homes/components/unkown_error_page.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/admin_home_page.dart';
import 'package:ev_homes/pages/admin_pages/dashboard_page.dart';
import 'package:ev_homes/pages/admin_pages/more_option_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomModel {
  final IconData icon;
  final String label;

  BottomModel({required this.icon, required this.label});
}

class AdminHomeWrapper extends StatefulWidget {
  const AdminHomeWrapper({super.key});

  @override
  State<AdminHomeWrapper> createState() => _AdminHomeWrapperState();
}

class _AdminHomeWrapperState extends State<AdminHomeWrapper>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showChips = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 275),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Slide from right to left
      end: Offset.zero, // Target position
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget getDashboard() {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    final loggedDesg = settingProvider.loggedAdmin?.designation?.id;

    if (loggedDesg == null) {
      return const UnknownErrorPage();
    }

    // if (loggedDesg.toLowerCase() == "data analyzer") {
    // return const AnalyserDashboardPage();
    // }
    // else if (loggedDesg.toLowerCase() == "team leader") {
    //   return const TlDashboard();
    // } else if (loggedDesg.toLowerCase() == "pre sales executive") {
    //   return const ExecutiveDashboard();
    // } else if (loggedDesg.toLowerCase() == "pre sales head") {
    //   return const PresaleheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "floor manager" ||
    //     loggedDesg.toLowerCase() == "front desk executive") {
    //   return const ReceptionDashboard();
    // } else if (loggedDesg.toLowerCase() == "sales manager" ||
    //     loggedDesg.toLowerCase() == "sr. sales manager") {
    //   return const SalesmanagerDashboard();
    // } else if (loggedDesg.toLowerCase() == "site head") {
    //   return const SiteheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "app developer") {
    //   // return const SiteheadDashboard();
    //   return const AppDevDashboard();
    // } else if (loggedDesg.toLowerCase() == "post sales executive") {
    //   return const PostsaleheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "post sales head") {
//       return const PostsaleheadDashboard();
    // }
    // if (loggedDesg.toLowerCase() == "desg-data-analyzer") {
    //   return const AnalyserDashboardPage();
    // } else if (loggedDesg.toLowerCase() == "desg-pre-sales-team-leader") {
    //   return const TlDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-pre-sales-executive") {
    //   return const ExecutiveDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-pre-sales-head") {
    //   return const PresaleheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-floor-manager" ||
    //     loggedDesg.toLowerCase() == "desg-front-desk-executive") {
    //   return const ReceptionDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-sales-manager" ||
    //     loggedDesg.toLowerCase() == "desg-senior-sales-manager") {
    //   return const SalesmangerDashbord();
    // } else if (loggedDesg.toLowerCase() == "desg-site-head") {
    //   return const SiteheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-app-developer") {
    //   // return const SiteheadDashboard();
    //   return const AppDevDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-post-sales-executive") {
    //   return const PostsaleheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-post-sales-head") {
    //   return const PostsaleheadDashboard();
    // } else if (loggedDesg.toLowerCase() == "desg-senior-closing-manager") {
    //   return const TeamlederDashbord();
    // }
    // "Pre Sales Executive"
    // return const PostsaleheadDashboard();
    return const UnknownErrorPage();
  }

  @override
  Widget build(BuildContext context) {
    // final settingProvider = Provider.of<SettingProvider>(context);
    // final loggedDesg = settingProvider.loggedAdmin?.designation;

    List<Widget> myPages = [
      const AdminHomePage(),
      // getDashboard(),
      // getDashboard(),
      const DashboardPage(),
      // getDashboard(),
      // TaskPage(),
      // ManageSiteVisitPage(),
      const MoreOptionPage(),
    ];

    List<BottomNavigationBarItem> bItems = [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 22,
          color: Colors.black.withAlpha(180),
        ),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.dashboard,
          size: 22,
          color: Colors.black.withAlpha(180),
        ),
        label: "Dashboard",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
          size: 22,
          color: Colors.black.withAlpha(180),
        ),
        label: "More",
      ),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedLabelStyle: const TextStyle(color: Colors.black),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.orange.shade200,
        currentIndex: _selectedIndex,
        items: bItems,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
            _showChips = false;
          });
        },
      ),
      body: Stack(
        children: [
          myPages[_selectedIndex],
          if (_showChips)
            GestureDetector(
              onTap: () {
                setState(() {
                  _animationController.reverse();
                  _showChips = false;
                });
              },
              child: AnimatedOpacity(
                opacity: _showChips ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          Align(
            alignment: const Alignment(0.9, 0.92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showChips) ...[
                  SlideTransition(
                    position: _slideAnimation,
                    child: MyChip(
                      heading: "Add Site Visit Form",
                      onPress: () {
                        GoRouter.of(context).push("/add-site-visit");
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlideTransition(
                    position: _slideAnimation,
                    child: MyChip(
                      heading: "Add Channel Partner",
                      onPress: () {
                        GoRouter.of(context).push("/add-channel-partner");
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlideTransition(
                    position: _slideAnimation,
                    child: MyChip(
                      heading: "Add New Booking",
                      onPress: () {
                        GoRouter.of(context).push("/add-booking");
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlideTransition(
                    position: _slideAnimation,
                    child: MyChip(
                      heading: "Add & View Payment",
                      onPress: () {
                        // Show dialog on tap
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Do you want to?"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Add Payment"),
                                    onTap: () {
                                      //TODO: add payment route
                                      GoRouter.of(context).push(
                                        "/add-payment-info",
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text("View Payments"),
                                    onTap: () {
                                      //TODO: View payment route
                                      GoRouter.of(context).push(
                                        "/view-payment-info",
                                      );
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.purple.shade100.withAlpha(200),
                  onPressed: () {
                    setState(() {
                      if (_showChips) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                      _showChips = !_showChips;
                    });
                  },
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  final String heading;
  final Function() onPress;
  const MyChip({
    super.key,
    required this.heading,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        duration: const Duration(milliseconds: 380),
        child: Text(
          heading,
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
