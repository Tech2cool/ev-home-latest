import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientReport extends StatefulWidget {
  final String selectedFilter;

  const ClientReport({Key? key, required this.selectedFilter}) : super(key: key);

  @override
  State<ClientReport> createState() => _ClientReportState();
}

class _ClientReportState extends State<ClientReport> {
  late String selectedFilter;
  String searchQuery = '';
  String selectedDateFilter = 'All';
  DateTime? customStartDate;
  DateTime? customEndDate;

  // Dummy data
  final List<Map<String, String>> dummyClients = [
    {
      'clientName': 'John Doe',
      'clientPhoneNumber': '1234567890',
      'startDate': '2023-10-01',
      'validTillDate': '2023-12-01',
      'taggingStatus': 'Approved'
    },
    {
      'clientName': 'Jane Smith',
      'clientPhoneNumber': '0987654321',
      'startDate': '2023-09-15',
      'validTillDate': '2023-11-15',
      'taggingStatus': 'Rejected'
    },
    {
      'clientName': 'Emily Johnson',
      'clientPhoneNumber': '1122334455',
      'startDate': '2023-08-20',
      'validTillDate': '2023-10-20',
      'taggingStatus': 'In Progress'
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredClients = dummyClients.where((client) {
      bool passesStatusFilter = selectedFilter == 'All' || client['taggingStatus'] == selectedFilter;
      bool passesSearchFilter = client['clientName']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          client['clientPhoneNumber']!.contains(searchQuery);
      bool passesDateFilter = _passesDateFilter(client['startDate']!);
      return passesStatusFilter && passesSearchFilter && passesDateFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 240, 246),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFF042630),
            title: const Text(
              'Client Report',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search clients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedDateFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDateFilter = newValue!;
                      _showDateRangePicker();
                    });
                  },
                  items: <String>['All', 'Day', 'Week', 'Month', 'Custom']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  icon: const Icon(
                    Icons.filter_list,
                    color: Color(0xFF042630),
                  ),
                  underline: const SizedBox.shrink(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                  items: <String>['All', 'Approved', 'Rejected', 'In Progress']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (customStartDate != null && customEndDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'Selected Range: ${DateFormat('yyyy-MM-dd').format(customStartDate!)} to ${DateFormat('yyyy-MM-dd').format(customEndDate!)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredClients.length,
              itemBuilder: (context, index) {
                final client = filteredClients[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to CpTaggingDetails
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  client['clientName']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF005254),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    client['clientPhoneNumber']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  client['startDate']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  client['validTillDate']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${client['taggingStatus']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: _getStatusColor(client['taggingStatus']!),
                              ),
                            ),
                          ],
                        ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool _passesDateFilter(String dateString) {
    if (selectedDateFilter == 'All') return true;
    if (customStartDate == null || customEndDate == null) return true;

    DateTime date = DateTime.parse(dateString);

    return date.isAfter(customStartDate!.subtract(Duration(days: 1))) &&
           date.isBefore(customEndDate!.add(Duration(days: 1)));
  }

  void _showDateRangePicker() async {
    if (selectedDateFilter == 'All') {
      setState(() {
        customStartDate = null;
        customEndDate = null;
      });
      return;
    }

    DateTime now = DateTime.now();

    switch (selectedDateFilter) {
      case 'Day':
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) {
          setState(() {
            customStartDate = DateTime(picked.year, picked.month, picked.day);
            customEndDate = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
          });
        }
        break;
      case 'Week':
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
          initialDateRange: DateTimeRange(
            start: now.subtract(Duration(days: now.weekday - 1)),
            end: now.add(Duration(days: 7 - now.weekday)),
          ),
        );
        if (picked != null) {
          setState(() {
            customStartDate = picked.start;
            customEndDate = picked.end;
          });
        }
        break;
      case 'Month':
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) {
          setState(() {
            customStartDate = DateTime(picked.year, picked.month, 1);
            customEndDate = DateTime(picked.year, picked.month + 1, 0, 23, 59, 59);
          });
        }
        break;
      case 'Custom':
        DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) {
          setState(() {
            customStartDate = picked.start;
            customEndDate = picked.end;
          });
        }
        break;
    }
  }
}

