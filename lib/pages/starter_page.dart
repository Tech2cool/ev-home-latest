import 'package:ev_homes/components/animated_box.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/department.dart';
import 'package:ev_homes/core/models/designation.dart';
import 'package:ev_homes/core/models/division.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/models/pagination_model.dart';
import 'package:ev_homes/pages/login_pages/admin_login_page.dart';
import 'package:ev_homes/sections/login_sections/admin_login_section.dart';
import 'package:ev_homes/sections/login_sections/channel_partner_login_section.dart';
import 'package:ev_homes/sections/login_sections/customer_login_section.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  PaginationModel<Employee>? pagination;
  ChannelPartner? channelPartner;
  List<Designation> designation = [];
  List<Employee> employee = [];
  List<Division> division = [];
  List<Department> department = [];
  GoogleSignInAccount? googleSignInAccount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFFB22C),
      end: Colors.white.withOpacity(0.8),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 246, 117, 5),
              Color.fromARGB(255, 255, 248, 200),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'I am a',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  AnimatedBox(
                    imagePath: Constant.cpIcon,
                    label: 'Channel Partner',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ChannelPartnerLoginSection(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.customerIcon,
                    label: 'Customer',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerLoginSection(),
                        ),
                      );
                    },
                  ),
                  AnimatedBox(
                    imagePath: Constant.adminIcon,
                    label: 'Admin',
                    colorAnimation: _colorAnimation,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(context) => const AdminLoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
