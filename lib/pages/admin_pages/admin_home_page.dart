import 'package:ev_homes/components/top_card_with_avatar.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePage2State();
}

class _AdminHomePage2State extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  // ImagePickerService imagePickerService = ImagePickerService();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    getSiteVisit();
    getLeads();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Adjust to control speed
      vsync: this,
    );

    // Define a smooth slide-in animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth curve
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  Future<void> getSiteVisit() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    await settingProvider.getSiteVisits();
  }

  Future<void> getLeads() async {
    // final settingProvider = Provider.of<SettingProvider>(
    //   context,
    //   listen: false,
    // );
    // await settingProvider.getLeads();
  }
  void openDrawer() {
    _controller.forward(); // Opens the drawer smoothly
  }

  void closeDrawer() {
    _controller.reverse(); // Closes the drawer smoothly
  }

  void onPressWish(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "Wish them happy birthday",
                style:
                    Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
                          color: Colors.black, // Change to a darker color
                        ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Send some comments 🎉🎉🎉 ",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Send"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedAdmin = settingProvider.loggedAdmin;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 26,
        ),
        title: const Text(
          "EV Home People",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        // actions: const [
        //   FaIcon(
        //     FontAwesomeIcons.whatsapp,
        //     size: 26,
        //     color: Colors.white,
        //   ),
        //   SizedBox(width: 10),
        //   Icon(
        //     Icons.notifications_none_outlined,
        //     color: Colors.white,
        //     size: 26,
        //   ),
        //   SizedBox(width: 10),
        // ],
      ),
      // Drawer
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top: 50),
              color: Colors.orange.shade600,
              child: IconButton(
                icon: const Icon(Icons.menu,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(Constant.maleAvatarIcon),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${loggedAdmin?.firstName} ${loggedAdmin?.lastName ?? ""}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          loggedAdmin?.email ?? "NA",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text("Phone: ${loggedAdmin?.phoneNumber ?? "NA"}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: Text(
                        "${loggedAdmin?.designation?.designation ?? "NA"}"),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profile"),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      GoRouter.of(context).push("/admin-profile");
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.info),
                  //   title: const Text("About"),
                  //   onTap: () {
                  //     Navigator.of(context).pop(); // Close the drawer
                  //   },
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.settings),
                  //   title: const Text("Settings"),
                  //   onTap: () {
                  //     Navigator.of(context).pop(); // Close the drawer
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Log out"),
                    onTap: () async {
                      settingProvider.logoutUser(context);
                      //     child: const Text(
                      //       "Logout",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // await SharedPrefService.deleteUser();
                      // if (context.mounted) {
                      //   GoRouter.of(context).pushReplacement("/auth-wrapper");
                      // }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Body
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: [
            TopcardWithAvatar(
              takePhoto: () {
                // Add photo-taking functionality here
              },
            ),
            // const SizedBox(height: 10),
            // Mycustomcard(
            //   childrens: [
            //     UserWishCard(
            //       name: "Mahek",
            //       gender: "female",
            //       onPress: () => onPressWish(context),
            //     ),
            //     UserWishCard(
            //       name: "Mayur",
            //       gender: "male",
            //       onPress: () => onPressWish(context),
            //     ),
            //     UserWishCard(
            //       name: "Aktar",
            //       gender: "male",
            //       onPress: () => onPressWish(context),
            //     ),
            //   ],
            // ),
            // Mycustomcard(
            //   heading: "Announcement",
            //   iconPath: Constant.megaphoneIcon,
            //   circleBackground: const Color.fromARGB(255, 248, 85, 4),
            //   childrens: [
            //     AnnoucementCard(
            //       name: "Welcome to ev Home People",
            //       subtitle: "Today 11:08 AM",
            //       gender: "female",
            //       onPress: () => onPressWish(context),
            //     ),
            //     AnnoucementCard(
            //       name: "Grand Opening Event",
            //       subtitle: "Today at 8:00 PM",
            //       gender: "male",
            //       onPress: () => onPressWish(context),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

// // import 'package:ev_developer/pages/tagging_list_page.dart';
// // import 'package:ev_developer/pages/tagging_task_details_page.dart';
// // import 'package:ev_developer/pages/task_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellowAccent,
//         title: GestureDetector(
//           onTap: () {
//             GoRouter.of(context).push("/profile");
//           },
//           child: Container(
//             child: Row(
//               children: [
//                 Icon(Icons.person), // User icon
//                 SizedBox(width: 10), // Space between icon and text
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text("Welcome"), // Main title
//                     Text("User", style: TextStyle(fontSize: 14)), // Subheading
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Lottie.asset(
//           'assets/animations/business_animation.json', // Lottie animation path
//           width: 300, // Adjust width as needed
//           height: 300, // Adjust height as needed
//           fit: BoxFit.cover, // Fit option for the animation
//         ),
//       ),
//     );
//   }
// }
