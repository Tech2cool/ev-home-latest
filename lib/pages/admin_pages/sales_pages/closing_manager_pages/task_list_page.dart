import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/admin_pages/sales_pages/closing_manager_pages/task_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatefulWidget {
  final String? id;
  final String? type;
  const TaskListPage({super.key, this.id, this.type});

  @override
  TaskListPageState createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  // Dummy data for cards
  final List<Map<String, String>> clientDetails = [
    {
      'Client Name': 'Rohan Sharma',
      'Subject': "Call to Client",
      'Task': "Fist Call",
      'Task Details': "Call to Client",
      'Client Phone': '9876543210',
      'Requirement': "2BHK2BHK",
      'Project': "EV 10 Marina Bay, EV 9 Square ",
      'CP Name': "tantanatan",
      'Status': "Pending",
    },
    {
      'Client Name': 'Priya Gupta',
      'Subject': "Call to Client",
      'Task': "Fist Call",
      'Task Details': "Call to Client",
      'Client Phone': '9123456789',
      'Requirement': "2BHK2BHK",
      'Project': "EV 10 Marina Bay, EV 9 Square ",
      'CP Name': "tantanatan",
      'Status': "Pending",
    },
    {
      'Client Name': 'Amit Verma',
      'Subject': "Call to Client",
      'Task': "Fist Call",
      'Task Details': "Call to Client",
      'Client Phone': '9988776655',
      'Requirement': "2BHK2BHK",
      'Project': "EV 10 Marina Bay, EV 9 Square ",
      'CP Name': "tantanatan",
      'Status': "Pending",
    },
    {
      'Client Name': 'Neha Mehta',
      'Subject': "Call to Client",
      'Task': "Fist Call",
      'Task Details': "Call to Client",
      'Client Phone': '9876543211',
      'Requirement': "2BHK2BHK",
      'Project': "EV 10 Marina Bay, EV 9 Square ",
      'CP Name': "tantanatan",
      'Status': "Pending",
    },
    {
      'Client Name': 'Karan Joshi',
      'Subject': "Call to Client",
      'Task': "Fist Call",
      'Task Details': "Call to Client",
      'Client Phone': '7896541230',
      'Requirement': "2BHK2BHK",
      'Project': "EV 10 Marina Bay, EV 9 Square ",
      'CP Name': "tantanatan",
      'Status': "Pending",
    },
  ];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    try {
      final settingProvider = Provider.of<SettingProvider>(
        context,
        listen: false,
      );
      await settingProvider.getTask(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final tasks = settingProvider.tasks;
    // Filtered client list based on search query
    final filteredClients = clientDetails
        .where((client) => client['Client Name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type ?? 'First Call Task'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query
                });
              },
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 133, 0, 0),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 133, 0, 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                        255, 133, 0, 0), // Set the border color here
                    width: 2.0, // Set the border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                        199, 248, 85, 4), // Set the color when not focused
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                        255, 248, 85, 4), // Color when the field is focused
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // Client List
          Text("${tasks.length}"),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final client = tasks[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsPage(
                          task: client,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status: ${client.completed ? "Completed" : "Pending"}",
                            style: TextStyle(
                              color: client.completed
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          Text("Subject: ${client.name}"),
                          Text("Details: ${client.details}"),
                          Text(
                            "Asign by: ${client.assignBy?.firstName ?? ""}  ${client.assignBy?.lastName ?? ""}",
                          ),
                          Text(
                            "Deadline: ${Helper.formatDateOnly(client.deadline?.toString() ?? "")}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
