import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          // Self Attendance Log with headline only
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Self Attendance Log",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: AttendanceList(isSelf: true)),
            ],
          ),
          // Team Attendance Log with calendar and search
          Column(
            children: [
              // Date Selector and Search for Team Tab
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${selectedDate.toLocal()}".split(' ')[0],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.orange),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        // Perform search action if needed
                      },
                    ),
                  ],
                ),
              ),
              const Expanded(child: AttendanceList(isSelf: false)),
            ],
          ),
        ],
      ),
    );
  }
}

// AttendanceList Widget to show attendance entries
class AttendanceList extends StatelessWidget {
  final bool isSelf;

  const AttendanceList({super.key, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    // Example data
    final List<AttendanceRecord> attendanceRecords = isSelf
        ? [
            AttendanceRecord(
                date: "2024-11-01",
                timeIn: "09:00",
                timeOut: "17:00",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-02",
                timeIn: "09:15",
                timeOut: "17:10",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-03",
                timeIn: "09:05",
                timeOut: "17:05",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-04",
                timeIn: "09:10",
                timeOut: "17:00",
                location: "Your Location",
                status: "Present"),
          ]
        : [
            AttendanceRecord(
                date: "2024-11-01",
                timeIn: "12:12",
                timeOut: "-",
                location: "JN2-57/A Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-02",
                timeIn: "12:11",
                timeOut: "-",
                location: "6, Karegaonkar Marg, Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-03",
                timeIn: "11:25",
                timeOut: "-",
                location: "JN2-55/B, Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                date: "2024-11-04",
                timeIn: "11:29",
                timeOut: "-",
                location: "JN2/36/A, Vashi, Navi Mumbai",
                status: "Present"),
          ];

    return ListView.builder(
      itemCount: attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = attendanceRecords[index];
        return AttendanceTile(
          date: record.date,
          timeIn: record.timeIn,
          timeOut: record.timeOut,
          location: record.location,
          status: record.status,
          imageUrl: "https://via.placeholder.com/50",
        );
      },
    );
  }
}

// AttendanceTile Widget for each entry
class AttendanceTile extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(date),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Time In: $timeIn"),
          Text("Time Out: $timeOut"),
          Text("Location: $location"),
          Text("Status: $status", style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

// Model for Attendance Record
class AttendanceRecord {
  final String date;
  final String timeIn;
  final String timeOut;
  final String location;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.location,
    required this.status,
  });
}
