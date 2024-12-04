import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/customer.dart';
import 'package:ev_homes/core/models/employee.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:ev_homes/pages/starter_page.dart';
import 'package:ev_homes/wrappers/admin_home_wrapper.dart';
import 'package:ev_homes/wrappers/cp_home_wrapper.dart';
import 'package:ev_homes/wrappers/customer_home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import "package:ev_homes/core/constant/constant.dart";
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = initializeUserData();
    // final settingProvider = Provider.of<SettingProvider>(
    //   context,
    //   listen: false,
    // );
    // settingProvider.getEmployess();
    // settingProvider.getClosingManagers();
    // settingProvider.getDepartment();
    // settingProvider.getDesignation();
    // settingProvider.getDivision();
    // settingProvider.getChannelPartners();
    // settingProvider.getOurProject();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userDataFuture,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Lottie.asset(Constant.buildingAnim),
            ),
          );
        } else if (dataSnapshot.hasError) {
          return const StarterPage();
        } else if (dataSnapshot.hasData) {
          final user = dataSnapshot.data!;
          if (user["role"] == 'employee') {
            return const AdminHomeWrapper();
          }
          else if (user["role"] == 'customer') {
            return const CustomerHomeWrapper();
          } else if (user["role"] == 'channel-partner') {
            return const CpHomeWrapper();
          }
          return const StarterPage();
        }
        return const StarterPage();
      },
    );
  }

  Future<Map<String, dynamic>?> initializeUserData() async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    final user = await SharedPrefService.getUser();
    if (user == null) {
      throw Exception('User not found');
    }
    // print(user);
    if (user["role"] == 'employee') {
      settingProvider.updateLoggedAdmin(Employee.fromMap(user));
    }
    if (user["role"] == 'customer') {
      settingProvider.updateLoggedCustomer(Customer.fromMap(user));
    }
    if (user["role"] == 'channel-partner') {
      settingProvider.updateLoggedChannelParter(ChannelPartner.fromMap(user));
    }

    await OneSignal.Notifications.requestPermission(true);

    final playerId = await OneSignal.User.getOnesignalId();
    // String? playerId = await OneSignal.User.pushSubscription.id;

    if (playerId != null) {
      await ApiService().saveOneSignalId(
        user["_id"],
        user["role"],
        playerId,
      );
    }
    return user;
  }
}
