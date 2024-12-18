import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/attendance.dart';
import 'package:ev_homes/core/providers/attendance_provider.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceLog extends StatefulWidget {
  const AttendanceLog({super.key});

  @override
  _AttendanceLogState createState() => _AttendanceLogState();
}

class _AttendanceLogState extends State<AttendanceLog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
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
    _tabController = TabController(length: 2, vsync: this);
    onRefresh();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: const Text("Attendance"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "Self"),
            Tab(icon: Icon(Icons.group), text: "Team"),
          ],
          indicatorColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AttendanceList(
            list: attProvider.attendanceList,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Employee',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: AttendanceList(
                list: [],
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceList extends StatelessWidget {
  final List<Attendance> list;

  const AttendanceList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final record = list[index];
        return AttendanceTile(
          name: record.userId,
          date: "${record.day}-${record.month}-${record.year}",
          timeIn:
              Helper.formatDate(record.checkInTime?.toIso8601String() ?? ""),
          timeOut:
              Helper.formatDate(record.checkOutTime?.toIso8601String() ?? ""),
          location: "${record.checkInLatitude}, ${record.checkInLongitude}",
          status: record.status,
          imageUrl: record.checkInPhoto ?? "",
        );
      },
    );
  }
}

class AttendanceTile extends StatelessWidget {
  final String name;
  final String date;
  final String timeIn;
  final String timeOut;
  final String location;
  final String status;
  final String imageUrl;

  const AttendanceTile({
    super.key,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.location,
    required this.status,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.5),
      color: const Color.fromARGB(219, 255, 255, 255),
      child: ListTile(
        title: Row(
          children: [
            Text(
              "Name: $name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "Time In: $timeIn",
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              "Time Out: $timeOut",
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              "Location: $location",
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              "Status: $status",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceRecord {
  final String name;
  final String date;
  final String timeIn;
  final String timeOut;
  final String location;
  final String status;

  AttendanceRecord({
    required this.name,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.location,
    required this.status,
  });
}
