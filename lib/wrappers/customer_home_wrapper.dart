import 'package:ev_homes/pages/customer_pages/customer_chat_screen.dart';
import 'package:ev_homes/pages/customer_pages/customer_forms/enquiry_form.dart';
import 'package:ev_homes/pages/customer_pages/customer_forms/my_meeting_page.dart';
import 'package:ev_homes/pages/customer_pages/customer_forms/schedule_meeting.dart';
import 'package:ev_homes/pages/customer_pages/customer_home_page.dart';
import 'package:ev_homes/pages/customer_pages/customer_details/customer_offer_details_page.dart';
import 'package:ev_homes/pages/customer_pages/customer_shorts/shorts_homepage.dart';
import 'package:ev_homes/pages/customer_pages/emi_calculator.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:video_player/video_player.dart';

class CustomerHomeWrapper extends StatefulWidget {
  const CustomerHomeWrapper({super.key});

  @override
  State<CustomerHomeWrapper> createState() => _CustomerHomeWrappertate();
}

class _CustomerHomeWrappertate extends State<CustomerHomeWrapper>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isMenuVisible = false;
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;
  late VideoPlayerController _videoPlayerController;

  final List<Widget> _pages = [
    const HomeScreen(),
    MyMeetings(),
    const ChatScreen(),
    const OfferDetailPage(showDiolog: true),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconAnimation =
        Tween<double>(begin: 0, end: 0.125).animate(_animationController);

    _videoPlayerController =
        VideoPlayerController.asset('assets/video/orange_bg.mov')
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
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_isMenuVisible) _buildBottomSheet(),
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
            Expanded(
                child: _buildNavItem("Home", FluentIcons.home_20_regular, 0)),
            Expanded(
                child:
                    _buildNavItem("Meetings", Icons.meeting_room_rounded, 1)),
            const SizedBox(width: 25),
            Expanded(child: _buildNavItem("Offers", Icons.local_offer, 3)),
            Expanded(
                child: _buildNavItem(
                    "Chat", FluentIcons.chat_empty_20_regular, 2)),
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
            color: _currentIndex == index ? Colors.orange : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.normal,
              color: _currentIndex == index ? Colors.black : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 50.0,
      left: MediaQuery.of(context).size.width / 2 - 25,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: AnimatedBuilder(
          animation: _iconAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _iconAnimation.value * 2 * 3.14159,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2e2252).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
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

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: Stack(
              children: [
                // Video background
                SizedBox.expand(
                  child: _videoPlayerController.value.isInitialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoPlayerController.value.size.width ?? 0,
                            height:
                                _videoPlayerController.value.size.height ?? 0,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                // Semi-transparent overlay
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                // Content
                SingleChildScrollView(
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
                                          const EnquiryForm())),
                            ),
                          ),
                          Expanded(
                            child: _buildActionCard(
                              'Meeting',
                              Icons.label,
                              'Schedule your meetings',
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScheduleMeeting())),
                            ),
                          ),
                        ],
                      ),
                      _buildCircularButton(),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShortsHomepage()));
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const Text(
            "Shorts",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
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
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
