import 'package:ev_homes/pages/cp_pages/cp_tagging_details.dart';
import 'package:flutter/material.dart';

class ClientReport extends StatefulWidget {
  final String selectedFilter;

  const ClientReport({super.key, required this.selectedFilter});

  @override
  State<ClientReport> createState() => _ClientReportState();
}

class _ClientReportState extends State<ClientReport> {
  late String selectedFilter;

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
    // Add more dummy data as needed
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    // Filter clients based on selected filter
    List<Map<String, String>> filteredClients = dummyClients.where((client) {
      if (selectedFilter == 'All') {
        return true;
      }
      return client['taggingStatus'] == selectedFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  icon: const Icon(Icons.filter_list,
                      color: Colors.grey), // Filter icon
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

          // List of filtered clients
          Expanded(
            child: ListView.builder(
              itemCount: filteredClients.length,
              itemBuilder: (context, index) {
                final client = filteredClients[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CpTaggingDeatils(client: client),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.teal[200],
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
                              'Status: ${client['taggingStatus'] == "In Progress" ? "In Progress" : client['taggingStatus']}',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    _getStatusColor(client['taggingStatus']!),
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
}
