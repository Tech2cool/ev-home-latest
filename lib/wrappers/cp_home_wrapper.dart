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
  late Animation<double> _iconAnimation;
  late VideoPlayerController _videoPlayerController;
  DraggableScrollableController controller = DraggableScrollableController();
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
    _iconAnimation = Tween<double>(begin: 0, end: 0.125).animate(_animation);

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
        _animationController.forward(); // Slide-in
      } else {
        _animationController.reverse(); // Slide-out
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const CpHomeScreen(),
      const DashboardScreen(),
      ChatScreen(
        goBack: goback,
      ),
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

                // _buildFloatingActionButton(),
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
                ? Color(0xFF042630)
                : Color.fromARGB(146, 134, 185, 176),
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
          animation: _iconAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _iconAnimation.value * 2 * 3.14159,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 92, 168, 209),
                      Color.fromARGB(255, 92, 168, 209),
                    ],
                    begin:
                        Alignment.topLeft, // Gradient starts from the top left
                    end: Alignment
                        .bottomRight, // Gradient ends at the bottom right
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(176, 4, 38, 48),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Color(0xFF042630),
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
    return DraggableScrollableSheet(
      controller: contr,
      initialChildSize: 0.5, // Initial size of the sheet when displayed
      minChildSize: 0, // Minimum size the sheet can be dragged down to
      maxChildSize: 0.6, // Maximum size the sheet can be dragged up to
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
              controller: scrollController, // Attach scrollController
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
                                  builder: (context) => const EmiCalculator())),
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
                  const SizedBox(
                      height:
                          100), // Extra space to account for the navigation bar
                ],
              ),
            ),
          ),
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
          color: Color.fromARGB(44, 134, 185, 176),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(44, 76, 114, 115),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF042630), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF042630),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
