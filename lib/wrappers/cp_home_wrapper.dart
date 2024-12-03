import 'package:ev_homes/pages/cp_pages/cp_chat_page.dart';
import 'package:ev_homes/pages/cp_pages/cp_dashboard_page.dart';
import 'package:ev_homes/pages/cp_pages/cp_forms/cp_enquiry_form.dart';
import 'package:ev_homes/pages/cp_pages/cp_forms/tagging_form_page.dart';
import 'package:ev_homes/pages/cp_pages/cp_performance_page.dart';
import 'package:ev_homes/pages/cp_pages/home_page.dart';
import 'package:ev_homes/pages/customer_pages/emi_calculator.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:video_player/video_player.dart';

class CpHomeWrapper extends StatefulWidget {
  const CpHomeWrapper({super.key});

  @override
  State<CpHomeWrapper> createState() => _CpHomeWrapperState();
}

class _CpHomeWrapperState extends State<CpHomeWrapper>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isMenuVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late VideoPlayerController _videoPlayerController;
  DraggableScrollableController controller = DraggableScrollableController();
  double _sheetHeight = 0.0; // To control the height of the bottom sheet

  void goback() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      reverseDuration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/blue_bg.mp4')
          ..initialize().then((_) {
            _videoPlayerController.setLooping(true);
            _videoPlayerController.play();
            setState(() {});
          });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
      if (_isMenuVisible) {
        _animationController.forward(); // Open the sheet slowly
      } else {
        _animationController.reverse(); // Close the sheet slowly
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const CpHomeScreen(),
      const DashboardScreen(),
      ChatScreen(goBack: goback),
      const PerformanceScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                ..._pages,
              ],
            ),
          ),
          if (_isMenuVisible) ...[
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            _buildBottomSheet(controller),
          ],
          if (_currentIndex != 2) ...[
            _buildBottomNavBar(),
            _buildFloatingActionButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem("Home", FluentIcons.home_12_filled, 0),
            _buildNavItem("Dashboard", Icons.dashboard, 1),
            _buildNavItem("Performance", Icons.directions_walk_outlined, 3),
            _buildNavItem("Chat", FluentIcons.chat_12_filled, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _currentIndex == index
                ? const Color.fromARGB(255, 133, 0, 0)
                : Colors.grey[600],
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.normal,
              color: _currentIndex == index
                  ? const Color(0xFF2e2252)
                  : const Color.fromARGB(255, 0, 0, 0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 55.0,
      left: MediaQuery.of(context).size.width / 2 - 25,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFeedbcd),
                      Color(0xFFeedbcd),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 133, 0, 0).withOpacity(0.8),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 133, 0, 0),
                    size: 30,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomSheet(DraggableScrollableController contr) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        _sheetHeight = _animationController.value *
            0.5; // Adjust the max height during the animation
        return DraggableScrollableSheet(
          controller: contr,
          initialChildSize: _sheetHeight,
          minChildSize: 0,
          maxChildSize: 0.6, // Adjust maximum size
          builder: (BuildContext context, ScrollController scrollController) {
            return NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if (notification.extent == notification.minExtent) {
                  if (_isMenuVisible) {
                    setState(() {
                      _isMenuVisible = false;
                      _animationController.reverse();
                    });
                  }
                }
                return true;
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              'Enquiry Form',
                              Icons.description,
                              'Create a new enquiry',
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CpEnquiryFormScreen())),
                            ),
                          ),
                          Expanded(
                            child: _buildActionCard(
                              'Client Tagging',
                              Icons.label,
                              'Tag your clients',
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ClientTaggingForm())),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              'EMI Calculator',
                              Icons.calculate,
                              'Calculate your EMI',
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmiCalculator())),
                            ),
                          ),
                          Expanded(
                            child: _buildActionCard(
                              'Settings',
                              Icons.settings,
                              'Adjust app settings',
                              () {
                                // Navigate to Settings screen
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
