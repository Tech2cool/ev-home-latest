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
              const Expanded(child: AttendanceList(isSelf: false)),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceList extends StatelessWidget {
  final bool isSelf;

  const AttendanceList({super.key, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    final List<AttendanceRecord> attendanceRecords = isSelf
        ? [
            AttendanceRecord(
                name: "Mahek",
                date: "2024-11-01",
                timeIn: "09:00",
                timeOut: "17:00",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                name: "Mahek",
                date: "2024-11-02",
                timeIn: "09:15",
                timeOut: "17:10",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                name: "Mahek",
                date: "2024-11-03",
                timeIn: "09:05",
                timeOut: "17:05",
                location: "Your Location",
                status: "Present"),
            AttendanceRecord(
                name: "Mahek",
                date: "2024-11-04",
                timeIn: "09:10",
                timeOut: "17:00",
                location: "Your Location",
                status: "Present"),
          ]
        : [
            AttendanceRecord(
                name: "Mahek",
                date: "2024-11-01",
                timeIn: "12:12",
                timeOut: "-",
                location: "JN2-57/A Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                name: "sheya",
                date: "2024-11-02",
                timeIn: "12:11",
                timeOut: "-",
                location: "6, Karegaonkar Marg, Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                name: "Mayur",
                date: "2024-11-03",
                timeIn: "11:25",
                timeOut: "-",
                location: "JN2-55/B, Vashi, Navi Mumbai",
                status: "Present"),
            AttendanceRecord(
                name: "aktar",
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
          name: record.name,
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
