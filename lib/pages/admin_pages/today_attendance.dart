import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DailyAttendanceScreen extends StatelessWidget {
  final currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

  final List<Map<String, String>> presentData = [
    {
      'name': 'Akash Gawande',
      'timeIn': '12:12',
      'location': 'Vashi Sector 9',
      'timeOut': '--'
    },
    {
      'name': 'Deepak Karki',
      'timeIn': '12:58',
      'location': 'JN2-55/B',
      'timeOut': '--'
    },
  ];

  final List<Map<String, String>> absentData = [
    {
      'name': 'Rohit Sharma',
      'timeIn': '--',
      'location': 'No Location',
      'timeOut': '--'
    },
    {
      'name': 'Virat Kohli',
      'timeIn': '--',
      'location': 'No Location',
      'timeOut': '--'
    },
  ];

  final List<Map<String, String>> lateComersData = [
    {
      'name': 'MS Dhoni',
      'timeIn': '14:00',
      'location': 'Vashi Sector 11',
      'timeOut': '--'
    },
    {
      'name': 'Yuvraj Singh',
      'timeIn': '14:15',
      'location': 'JN2-44/A',
      'timeOut': '--'
    },
  ];

  final List<Map<String, String>> earlyLeaversData = [
    {
      'name': 'Sachin Tendulkar',
      'timeIn': '10:00',
      'location': 'Vashi Sector 15',
      'timeOut': '12:00'
    },
    {
      'name': 'Rahul Dravid',
      'timeIn': '09:00',
      'location': 'JN2-55/D',
      'timeOut': '11:30'
    },
  ];

  final List<Map<String, String>> weekOffData = [
    {
      'name': 'Shikhar Dhawan',
      'timeIn': '--',
      'location': 'On Leave',
      'timeOut': '--'
    },
    {
      'name': 'Ajinkya Rahane',
      'timeIn': '--',
      'location': 'On Leave',
      'timeOut': '--'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Pie chart sections
    final List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        color: Colors.blue,
        value: presentData.length.toDouble(),
        title: '(${presentData.length})',
      ),
      PieChartSectionData(
        color: Colors.red,
        value: absentData.length.toDouble(),
        title: '(${absentData.length})',
      ),
      PieChartSectionData(
        color: Colors.green,
        value: lateComersData.length.toDouble(),
        title: '(${lateComersData.length})',
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: earlyLeaversData.length.toDouble(),
        title: '(${earlyLeaversData.length})',
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: weekOffData.length.toDouble(),
        title: '(${weekOffData.length})',
      ),
    ];

    // Legend Data
    final List<Map<String, dynamic>> legendData = [
      {'color': Colors.blue, 'text': 'Present'},
      {'color': Colors.red, 'text': 'Absent'},
      {'color': Colors.green, 'text': 'Late Comers'},
      {'color': Colors.orange, 'text': 'Early Leavers'},
      {'color': Colors.purple, 'text': 'Week Off'},
    ];

    return DefaultTabController(
      length: 6, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Daily Attendance'),
        ),
        body: Column(
          children: [
            // Date Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    currentDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60, // Adjust height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: legendData.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item['color'],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['text'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  centerSpaceRadius: 50,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Scrollable Legend Section

            // Tab Bar Section
            TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              tabs: [
                Tab(text: 'Present'),
                Tab(text: 'Absent'),
                Tab(text: 'Week of Holiday'),
                Tab(text: 'Leave'),
                Tab(text: 'Late Comers'),
                Tab(text: 'Early Leavers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildListView(presentData),
                  buildListView(absentData),
                  buildListView(weekOffData),
                  buildListView(weekOffData), // You can modify Leave tab data
                  buildListView(lateComersData),
                  buildListView(earlyLeaversData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable ListView Builder for Tabs
  Widget buildListView(List<Map<String, String>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final attendee = data[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(attendee['name'] ?? ''),
            subtitle: Text(
              'Time In: ${attendee['timeIn']}\nLocation: ${attendee['location']}\nTime Out: ${attendee['timeOut']}',
            ),
          ),
        );
      },
    );
  }
}
