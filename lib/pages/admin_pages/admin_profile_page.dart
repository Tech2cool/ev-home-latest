import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  void _changePassword() {
    // TODO: change password functionality
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final loggedAdmin = settingProvider.loggedAdmin;

    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile Picture and User Info Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  color: Colors.orangeAccent,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          if (loggedAdmin != null &&
                              loggedAdmin.profilePic != null)
                            CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                loggedAdmin.profilePic!,
                              ),
                            )
                          else
                            const CircleAvatar(
                              radius: 60.0,
                              backgroundImage: AssetImage(
                                'assets/images/man-user-circle.png',
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name
                      Text(
                        loggedAdmin != null
                            ? "${loggedAdmin.firstName ?? ''} ${loggedAdmin.lastName ?? ''}"
                            : "NA",
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        loggedAdmin?.email ?? "NA",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        loggedAdmin?.designation?.designation ?? "NA",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "About",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 0.5,
                      ),
                      Table(
                        border: TableBorder.all(color: Colors.transparent),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Employee Id',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.employeeId ?? "NA",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Full Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin != null
                                      ? '${loggedAdmin.firstName ?? ''} ${loggedAdmin.lastName ?? ''}'
                                      : "NA",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Division',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.division?.division ?? "NA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Department',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.department?.department ?? "NA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Designation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.designation?.designation ?? "NA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),

                // Reporting To Section
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Reporting To",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            if (loggedAdmin?.reportingTo != null &&
                                loggedAdmin!.reportingTo?.profilePic != null)
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  loggedAdmin.reportingTo!.profilePic!,
                                ),
                              )
                            else
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  'assets/images/man-user-circle.png',
                                ),
                              ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    loggedAdmin?.reportingTo != null
                                        ? "${loggedAdmin?.reportingTo?.firstName ?? ''} ${loggedAdmin?.reportingTo?.lastName ?? ''}"
                                        : "NA",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "(${loggedAdmin?.reportingTo?.designation?.designation ?? "NA"})",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // Contact Info Section
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Contact Info",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 0.5,
                      ),
                      Table(
                        border: TableBorder.all(color: Colors.transparent),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.phoneNumber.toString() ?? "NA",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  loggedAdmin?.email ?? "NA",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),

                // Buttons for Change Password and Logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Expanded(
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                            ),
                            onPressed: _changePassword,
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.red[300],
                    //     ),
                    //     onPressed: () => settingProvider.logoutUser(context),
                    //     child: const Text(
                    //       "Logout",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        Positioned(
          left: 5,
          top: 40,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class MyCard extends StatelessWidget {
  final String heading;
  final String? value;
  const MyCard({
    super.key,
    required this.heading,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Row(
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 30),
          Text(value ?? "NA"),
        ],
      ),
    );
  }
}
