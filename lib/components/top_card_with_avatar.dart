import 'dart:async';
import 'package:ev_homes/components/spinning_icon_btn.dart';
import 'package:ev_homes/core/constant/constant.dart';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/providers/attendance_provider.dart';
import 'package:ev_homes/core/providers/geolocation_provider.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/attendance_pages/attendance_log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:table_calendar/table_calendar.dart';

import '../pages/admin_pages/employees_list.dart';
import '../pages/admin_pages/leave_employee.dart';
import '../pages/attendance_pages/today_attendance.dart';

class TopcardWithAvatar extends StatefulWidget {
  final Function() takePhoto;

  const TopcardWithAvatar({
    super.key,
    required this.takePhoto,
  });

  @override
  _TopcardWithAvatarState createState() => _TopcardWithAvatarState();
}

class _TopcardWithAvatarState extends State<TopcardWithAvatar> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Timer? _timer;
  int _elapsedSeconds = 0;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  final List<DateTime> governmentHolidays = [
    DateTime.utc(2024, 1, 26), // Republic Day
    DateTime.utc(2024, 8, 15), // Independence Day
    DateTime.utc(2024, 10, 2), // Gandhi Jayanti
  ];
  bool isLoading = false;

  Future<void> onRefresh() async {
    final attProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    try {
      setState(() {
        isLoading = true;
      });
      await Future.wait([
        attProvider.getAttendanceAll(settingProvider.loggedAdmin!.id!),
      ]);
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final geolocationProvider = Provider.of<GeolocationProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final duration = attendanceProvider.currentTimerDuration;

    final loggedAdmin = settingProvider.loggedAdmin;
    final bool isInRadius = geolocationProvider.isWithinRadius;
    bool isCheckedIn = attendanceProvider.status == "present";
    Map<DateTime, dynamic> attendanceMap = {
      for (var a in attendanceProvider.attendanceList)
        DateTime(a.year, a.month, a.day): a.status,
    };
    print(attendanceMap);

    String formatTime(int seconds) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.only(right: 10, bottom: 10, left: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          // onTap: () {
                          //   GoRouter.of(context).push("/admin-profile");
                          // },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              image: DecorationImage(
                                image: loggedAdmin?.profilePic != null
                                    ? NetworkImage(loggedAdmin!.profilePic!)
                                    : AssetImage(
                                        (loggedAdmin != null &&
                                                loggedAdmin.gender == "female")
                                            ? Constant.femaleAvatarIcon
                                            : Constant.maleAvatarIcon,
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 10,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Allow the name to wrap to the next line if it's too long
                          Text(
                            loggedAdmin != null
                                ? "${loggedAdmin.firstName} ${loggedAdmin.lastName}"
                                : "NA",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodySmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 4, // Allow up to 2 lines
                            overflow: TextOverflow
                                .ellipsis, // Show ellipsis if it's too long
                          ),
                          const SizedBox(height: 3),
                          Text(
                            loggedAdmin != null
                                ? loggedAdmin.designation?.designation ?? "NA"
                                : "NA",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodySmall!
                                .copyWith(
                                  color: const Color.fromARGB(255, 55, 55, 55),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SlideCountdown(
                          countUpAtDuration: true,
                          duration: duration,
                          separatorStyle: TextStyle(color: Colors.black),
                          style: TextStyle(color: Colors.black),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // Always show minutes and seconds
                          shouldShowMinutes: (duration) => true,
                          shouldShowSeconds: (duration) => true,
                          shouldShowHours: (duration) => true,
                        ),
                        // Text(
                        //   formatTime(_elapsedSeconds),
                        //   style: const TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            if (!isInRadius) {
                              Helper.showCustomSnackBar(
                                "Your Outsite of Geofence",
                              );
                              return;
                            }
                            if (attendanceProvider.attendance?.status ==
                                "completed") {
                              return;
                            }
                            GoRouter.of(context).push("/check-in-out");
                            // setState(() {
                            //   if (!isCheckedIn) {
                            //     _startTimer();
                            //   } else {
                            //     _stopTimer();
                            //   }
                            //   isCheckedIn = !isCheckedIn;
                            // });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            shadowColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor:
                                attendanceProvider.attendance?.status ==
                                        "completed"
                                    ? Colors.grey
                                    : isCheckedIn
                                        ? Colors.red
                                        : Colors.orange.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                          ),
                          child: Text(
                            attendanceProvider.attendance?.status == "completed"
                                ? "Checked-out"
                                : isCheckedIn
                                    ? "Check Out"
                                    : "Check In",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Icon(
                      isInRadius
                          ? Icons.location_on
                          : Icons.location_off_rounded,
                      size: 30,
                      color: isInRadius
                          ? Colors.orange.shade600
                          : Colors.red.withOpacity(0.7),
                    ),
                    // Icon(
                    //   Icons.location_on,
                    //   size: 30,
                    //   color: Colors.orange.shade600,
                    // ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            geolocationProvider.address,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isInRadius
                                  ? Colors.orange.shade600
                                  : Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isInRadius
                                  ? "Within Geofence"
                                  : "Outsite Geofence",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 3),
                    SpinningIconBtn(
                      icon: Icons.sync,
                      iconSize: 30,
                      iconColor: isInRadius
                          ? Colors.orange.shade600
                          : Colors.red.withOpacity(0.8),
                      onTap: () async {
                        await geolocationProvider.getCurrentLocation();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Access",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          //TODO:EMploye list
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmployeesList()),
                          );
                        },
                        child: const ActionTile(
                          icon: Icons.person_search_rounded,
                          label: "Employee",
                          backgroundColor: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          //TODO:Attendance

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AttendanceLog(),
                            ),
                          );
                        },
                        child: const ActionTile(
                            icon: Icons.event_available,
                            label: "Attendance",
                            backgroundColor: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          //TODO: Leave application emp

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LeaveEmplpoyee()),
                          );
                        },
                        child: const ActionTile(
                            icon: Icons.exit_to_app_rounded,
                            label: "Leave",
                            backgroundColor: Colors.green),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attendance Insight",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Divider for line below the text
                const Divider(
                  color: Color.fromARGB(144, 158, 158, 158),
                  thickness: 1,
                ),

                const SizedBox(height: 7),

                // Row with icon, text, number, and button
                Row(
                  children: [
                    // Icon
                    const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 248, 85, 4),
                      size: 30,
                    ),
                    const SizedBox(width: 8),

                    const Text(
                      "Present Today",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // "16" Number Text

                    const Spacer(),
                    const Text(
                      "16",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.green, // Color for the number
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DailyAttendanceScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        elevation: 6,
                        shadowColor: Colors.green,
                        backgroundColor: const Color.fromARGB(255, 248, 85, 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attendance Logs",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                const Divider(
                  color: Color.fromARGB(144, 158, 158, 158),
                  thickness: 1,
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: [
                                    Colors.green, // Present
                                    Colors.red, // Absent
                                    Colors.blue, // Weekly Off
                                    Colors.orange, // Leave
                                    Colors.purple // Other
                                  ][i],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                [
                                  "Present",
                                  "Absent",
                                  "Weekly Off",
                                  "Leave",
                                  "Event"
                                ][i],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                const Divider(
                  color: Color.fromARGB(144, 158, 158, 158),
                  thickness: 1,
                ),
                const SizedBox(height: 7),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      this.focusedDay = focusedDay;
                    });
                  },
                  daysOfWeekVisible: true,
                  pageJumpingEnabled: false,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.black),
                    weekendStyle: TextStyle(color: Colors.blue),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (attendanceMap.containsKey(day)) {
                        final status = attendanceMap[day];
                        if (status == 'present' || status == 'completed') {
                          return _buildDayContainer(day, Colors.green);
                        } else if (status == 'absent') {
                          return _buildDayContainer(day, Colors.red); // Absent
                        }
                      }
                      return null; // Default styling for other days
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const ActionTile({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

Widget _buildDayContainer(DateTime day, Color color) {
  return Container(
    margin: const EdgeInsets.all(6.0),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(
      '${day.day}',
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
