import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/cp_pages/cp_profile_page.dart';
import 'package:ev_homes/pages/cp_pages/resale_property_page.dart';
import 'package:ev_homes/pages/upcoming_project_details.dart';
import 'package:ev_homes/pages/our_project_details.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../components/animated_gradient_bg.dart';
import '../customer_pages/carousel_page.dart';

class CpHomeScreen extends StatefulWidget {
  const CpHomeScreen({super.key});

  @override
  State<CpHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CpHomeScreen> {
  Future<void> fetchProjects() async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);

    try {
      await settingProvider.getOurProject(); // Await the data
    } catch (e) {
      Helper.showCustomSnackBar('Error fetching projects: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedChannelPartner = settingProvider.loggedChannelPartner;
    return Stack(
      children: [
        // AnimatedGradient(),

        Scaffold(
          // backgroundColor: Constant.bgColor,
          backgroundColor: Color.fromARGB(255, 255, 251, 240),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome!",
                        style:
                            TextStyle(color: Color(0xFF4B5945), fontSize: 18),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        loggedChannelPartner?.firstName ?? "",
                        style: const TextStyle(
                            color: Color(0xFF4B5945),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: const TextStyle(
                                color: Color(0xFF4B5945),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF4B5945),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 55, // Match height of the TextField
                        width: 55, // Adjust width as needed
                        child: Lottie.asset('assets/animations/cp_home.json'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Our Projects",
                            style: TextStyle(
                                color: Color(0xFF4B5945),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    OurProjectList(),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Upcoming Projects",
                            style: TextStyle(
                                color: Color(0xFF4B5945),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    UpcomingProjectsList(),
                  ],
                ),
                const SizedBox(height: 5),
                const Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "What's New",
                            style: TextStyle(
                                color: Color(0xFF4B5945),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CarouselPage(),
                  ],
                ),
                const SizedBox(
                  height: 120,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
