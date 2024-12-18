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
  String searchQuery = '';
  bool isLoading = false;

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
      setState(() {
        isLoading = true;
      });
      await settingProvider.getTask(
        widget.id ?? settingProvider.loggedAdmin!.id!,
      );
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final tasks = settingProvider.tasks;
    // Filtered client list based on search query
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
                    color: Color.fromARGB(255, 133, 0, 0),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(199, 248, 85, 4),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 248, 85, 4),
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
                            "Asign To: ${client.assignTo?.firstName ?? ""}  ${client.assignTo?.lastName ?? ""}",
                          ),
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
