import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/task.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            MyTextCard(
                              heading: "Task: ",
                              value: widget.task.name ?? "",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Description: ",
                              value: widget.task.details ?? "",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Deadline: ",
                              value: Helper.formatDateOnly(
                                widget.task.deadline?.toIso8601String() ?? "",
                              ),
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Assign To: ",
                              value:
                                  "${widget.task.assignTo?.firstName ?? ""}  ${widget.task.assignTo?.lastName ?? ""}",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Assign by: ",
                              value:
                                  "${widget.task.assignBy?.firstName ?? ""}  ${widget.task.assignBy?.lastName ?? ""}",
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextCard(
                              heading: "Client Name: ",
                              value:
                                  "${widget.task.lead?.firstName ?? ""} ${widget.task.lead?.lastName ?? ""}",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Phone: ",
                              value:
                                  "${widget.task.lead?.countryCode ?? ""} ${widget.task.lead?.phoneNumber ?? ""}",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Alternate Number: ",
                              value:
                                  "${widget.task.lead?.countryCode ?? ""} ${widget.task.lead?.altPhoneNumber ?? ""}",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Email: ",
                              value: widget.task.lead?.email ?? "NA",
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Project: ",
                              value: widget.task.lead?.project
                                      .map((proj) => proj.name)
                                      .join(", ") ??
                                  'NA',
                            ),
                            const SizedBox(height: 8),
                            MyTextCard(
                              heading: "Project: ",
                              value: widget.task.lead?.requirement.join(", ") ??
                                  'NA',
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => TaskDialog(
                              id: widget.task.id!,
                            ),
                          );
                        },
                        child: const Text("Update Status"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyTextCard extends StatelessWidget {
  final String heading;
  final String value;
  final Color? headingColor;
  final Color? valueColor;
  const MyTextCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: headingColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: valueColor),
        ),
      ],
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const CustomTimelineTile({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: color),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: color,
        iconStyle: IconStyle(iconData: Icons.done, color: Colors.white),
      ),
      endChild: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final String id;

  const TaskDialog({super.key, required this.id});
  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  String? selectedTask; // To store selected dropdown value
  final TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );
    return AlertDialog(
      title: Text("Task Dialog"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dropdown
          DropdownButtonFormField<String>(
            value: selectedTask,
            items: [
              DropdownMenuItem(
                value: "completed",
                child: Text("Task Completed"),
              ),
              DropdownMenuItem(
                value: "unavailable",
                child: Text("Unavailable"),
              ),
            ],
            /*["Task Completed", "Unavailable"]
                .map((task) => DropdownMenuItem(
                      value: task,
                      child: Text(task),
                    ))
                .toList(),*/
            onChanged: (value) {
              setState(() {
                selectedTask = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Select Task",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          // Text Field
          TextField(
            controller: remarkController,
            decoration: InputDecoration(
              labelText: "Remark",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ElevatedButton(
              onPressed: () async {
                final selected = selectedTask;
                final remark = remarkController.text;

                if (selected != null && remark.isNotEmpty) {
                  // Handle submission
                  print("Task: $selected");
                  print("Remark: $remark");

                  // You can use Hive here to store the data locally
                  // For example: box.put('task', {'task': selected, 'remark': remark});
                  await settingProvider.updateTaskStatus(
                    widget.id,
                    selectedTask!,
                    remark,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ],
    );
  }
}
