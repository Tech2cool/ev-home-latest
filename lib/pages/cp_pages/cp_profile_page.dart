import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:ev_homes/pages/cp_pages/cp_account_profile_page.dart';
import 'package:ev_homes/pages/cp_pages/cp_reset_password_page.dart';
import 'package:ev_homes/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/blue_animated_gradient.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedChannelPartner = settingProvider.loggedChannelPartner;

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFbcd5eb),
                    const Color(0xFFFFbed4e9),
                    const Color(0xFFFF3373b0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        (loggedChannelPartner?.profilePic ?? "").isNotEmpty
                            ? CachedNetworkImageProvider(
                                loggedChannelPartner!.profilePic!)
                            : null,
                    backgroundColor: Colors.white,
                    child: (loggedChannelPartner?.profilePic ?? "").isNotEmpty
                        ? null
                        : const Icon(
                            Icons.person,
                            size: 80.0,
                            color: Color(0xFFFF3373b0),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${loggedChannelPartner?.firstName ?? "Unknown"} ${loggedChannelPartner?.lastName ?? "User"}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Options
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    title: 'My Account Information',
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                              position: offsetAnimation,
                              child: const AccountProfilePage());
                        },
                        transitionDuration: const Duration(milliseconds: 600),
                      ),
                    ),
                  ),
                  _buildInfoTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                              position: offsetAnimation,
                              child: const ResetPasswordScreen());
                        },
                        transitionDuration: const Duration(milliseconds: 600),
                      ),
                    ),
                  ),
                  _buildLogoutTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    onTap: () async {
                      await SharedPrefService.deleteUser();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthWrapper(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF042630),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF042630),
        ),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF042630),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF042630),
          ),
        ),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
