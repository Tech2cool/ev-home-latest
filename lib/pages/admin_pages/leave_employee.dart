import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LeaveEmplpoyee extends StatelessWidget {
  final List<Map<String, String>> leaveData = [
    {
      "appliedOn": "24-Oct-2024",
      "duration": "18 Oct - 19 Oct",
      "type": "comp off",
      "days": "2",
      "reason": "Personal",
      "status": "Pending at Deepak Karki",
      "statusColor": "orange",
    },
    {
      "appliedOn": "10-Oct-2024",
      "duration": "10 Oct - 17 Oct",
      "type": "comp off",
      "days": "7",
      "reason": "Went to delhi",
      "status": "Approved",
      "statusColor": "green",
    },
    {
      "appliedOn": "10-Oct-2024",
      "duration": "05 Oct - 09 Oct",
      "type": "Compensatory off",
      "days": "5",
      "reason": "Went to delhi",
      "status": "Approved",
      "statusColor": "green",
    },
    {
      "appliedOn": "10-Aug-2024",
      "duration": "07 Aug - 08 Aug",
      "type": "comp off",
      "days": "2",
      "reason": "Fory personal reason",
      "status": "Approved",
      "statusColor": "green",
    },
    {
      "appliedOn": "30-Jun-2024",
      "duration": "06 Jun - 06 Jun",
      "type": "Compensatory off",
      "days": "0.5",
      "reason": "Meeting with client",
      "status": "Approved",
      "statusColor": "green",
    },
  ];

  final List<Map<String, String>> teamLeaveData = [
    {
      "name": "Jayshree Dhingra",
      "appliedOn": "04-Nov-2024",
      "duration": "03 Nov - 03 Nov",
      "type": "Comp Off",
      "days": "1",
      "reason": "Due to personal reason",
      "status": "Pending at Vicky Mane",
      "statusColor": "orange",
    },
    {
      "name": "Suraj Ravindran",
      "appliedOn": "03-Nov-2024",
      "duration": "08 Oct - 08 Oct",
      "type": "Paid Leave",
      "days": "0.5",
      "reason": "Personal work",
      "status": "Pending",
      "statusColor": "orange",
    },
    {
      "name": "Megha Sambhaji Navale",
      "appliedOn": "03-Nov-2024",
      "duration": "02 Nov - 03 Nov",
      "type": "Comp Off",
      "days": "2",
      "reason": "Family occasion",
      "status": "Pending",
      "statusColor": "orange",
    },
    {
      "name": "Satish Vanis",
      "appliedOn": "02-Nov-2024",
      "duration": "02 Nov - 03 Nov",
      "type": "Casual Leaves",
      "days": "1",
      "reason": "Official work",
      "status": "Approved",
      "statusColor": "green",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Leave'),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Self', icon: Icon(Icons.person)),
              Tab(text: 'Team', icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Self Tab
            Stack(
              children: [
                ListView.builder(
                  itemCount: leaveData.length,
                  itemBuilder: (context, index) {
                    final leave = leaveData[index];

                    return ListTile(
                      title: Text(
                        leave['appliedOn']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Duration: ${leave['duration']}"),
                            Text("Leave Type: ${leave['type']}"),
                            Text("Number of Days: ${leave['days']}"),
                            Text("Reason: ${leave['reason']}"),
                            Text(
                              "Status: ${leave['status']}",
                              style: TextStyle(
                                color: leave['statusColor'] == 'green'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            Divider(color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      _showAddLeaveDialog(context);
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            // Team Tab
            Column(
              children: [
                // Month Selector
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Oct 2024',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Nov 2024',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search employee',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Leave Details Table Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Applied on',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Leave Details List
                Expanded(
                  child: ListView.builder(
                    itemCount: teamLeaveData.length,
                    itemBuilder: (context, index) {
                      final leave = teamLeaveData[index];
                      return GestureDetector(
                        onTap: () {
                          _showLeaveDetailsDialog(context, leave);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    leave['name']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(leave['appliedOn']!),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text("Duration: ${leave['duration']}"),
                              Text("Leave Type: ${leave['type']}"),
                              Text("Number of Days: ${leave['days']}"),
                              Text("Reason: ${leave['reason']}"),
                              Text(
                                "Status: ${leave['status']}",
                                style: TextStyle(
                                  color: leave['statusColor'] == 'green'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showLeaveDetailsDialog(BuildContext context, Map<String, String> leave) {
  TextEditingController reasonController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Leave Details for ${leave['name']}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Applied On: ${leave['appliedOn']}"),
              Text("Duration: ${leave['duration']}"),
              Text("Leave Type: ${leave['type']}"),
              Text("Number of Days: ${leave['days']}"),
              Text("Reason: ${leave['reason']}"),
              Text(
                "Status: ${leave['status']}",
                style: TextStyle(
                  color: leave['statusColor'] == 'green'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField("Reason", reasonController),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Reject",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Approve", style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}

void _showAddLeaveDialog(BuildContext context) {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController numberOfDaysController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  String leaveType = "Compensatory Off";
  String? attachedFile;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Leave Request"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField("Leave Type", leaveType, (newValue) {
                    setState(() {
                      leaveType = newValue!;
                    });
                  }),
                  const SizedBox(height: 10),
                  _buildDateField("Start Date", startDateController, context),
                  const SizedBox(height: 10),
                  _buildDateField("End Date", endDateController, context),
                  const SizedBox(height: 10),
                  _buildNumberField("Number of Days", numberOfDaysController),
                  const SizedBox(height: 10),
                  _buildTextField("Reason", reasonController),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          attachedFile = result.files.single.path!;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'File selected: ${result.files.single.name}'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text("Attach File"),
                  ),
                  if (attachedFile != null)
                    Flexible(
                      child: Text(
                        'Attached: ${attachedFile!.split('/').last}',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('File attached: $attachedFile');
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildTextField(String label, TextEditingController controller) {
  return TextField(
    maxLines: 4,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}

Widget _buildDateField(
    String label, TextEditingController controller, BuildContext context) {
  return TextField(
    controller: controller,
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
    onTap: () async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (selectedDate != null) {
        controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      }
    },
  );
}

Widget _buildNumberField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}

Widget _buildDropdownField(
    String label, String selectedValue, ValueChanged<String?> onChanged) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
    items: [
      "Compensatory Off",
      "Paid Leave",
      "Unpaid Leave",
      "Sick Leave",
      "Casual Leave",
    ]
        .map((type) => DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            ))
        .toList(),
    onChanged: onChanged,
  );
}
