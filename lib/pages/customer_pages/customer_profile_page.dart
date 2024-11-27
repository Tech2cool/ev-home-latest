import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:ev_homes/pages/customer_pages/account_info_page.dart';
import 'package:ev_homes/pages/login_pages/customer_reset_password_page.dart';
import 'package:ev_homes/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    // const String dummyUserName = "Mayur Thorat";
    // const String dummyUserEmail = "mayurthorat.evgroup@gmail.com";
    // const String dummyUserProfileImage = 'https://picsum.photos/seed/934/600';

    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedCustomer = settingProvider.loggedCustomer;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200], // similar to secondaryBackground
      appBar: _buildAppBar(
          '${loggedCustomer?.firstName ?? "Unknown"} ${loggedCustomer?.lastName ?? "User"}',
          ""),
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(loggedCustomer!.email),
            _buildInfoTile(
              title: 'My Account Information',
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    const begin = Offset(1.0, 0.0); // Slide from right
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
              title: 'Change Password',
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    const begin = Offset(1.0, 0.0); // Slide from right
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation,
                        child: const ResetPasswordCustomer());
                  },
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              ),
            ),
            _buildLogoutButton(() async {
              await SharedPrefService.deleteUser();
              if (context.mounted) {
                // GoRouter.of(context).pushReplacement("/auth-wrapper");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthWrapper(),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(String userName, String profilePic) {
    return AppBar(
      backgroundColor: Colors.grey[200], // similar to secondaryBackground
      title: Text(
        userName,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, // similar to primaryText
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 40,
          backgroundColor:
              Colors.grey[300], // You can set a default background color
          child: profilePic.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profilePic,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 40.0,
                  color: Colors.grey,
                ), // Display an icon when no profile picture is provided
        ),
      ],
      centerTitle: false,
      elevation: 0.0,
    );
  }

  Widget _buildUserInfo(String userEmail) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 12.0),
      child: Text(
        userEmail,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue, // substitute for the constant bgColor
        ),
      ),
    );
  }

  Widget _buildInfoTile({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 0.0,
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0.0, 1.0),
              )
            ],
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(Function() onLogout) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 36.0, 0.0, 0.0),
      child: Center(
        child: ElevatedButton(
          onPressed: onLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // background color
            side: const BorderSide(
              color: Colors.blue, // substitute for Constant.bgColor
              width: 2.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
