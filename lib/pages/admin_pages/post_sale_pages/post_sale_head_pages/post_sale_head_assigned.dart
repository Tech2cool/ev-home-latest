import 'package:flutter/material.dart';

class PostSaleHeadAssigned extends StatelessWidget {
  final String status;
  PostSaleHeadAssigned({super.key, required this.status});

  // Updated Dummy data
  final List<Map<String, String>> dummyLeads = [
    {
      'AssignName': 'Manisha',
      'ClientName': 'Rohit',
      'ClientPhone': '9876543210',
      'Status': 'Booking Contacted',
      'Project': '10 Marina',
      'ManagerName': 'Jasprit',
      'BookingDate': '2024-10-02',
      'ClosingManager': 'Rohit',
    },
    {
      'AssignName': 'Manali',
      'ClientName': 'Raj Rajput',
      'ClientPhone': '9876543210',
      'Status': 'Refund Processed',
      'Project': '10 Marina',
      'ManagerName': 'Dipak',
      'BookingDate': '2024-09-02',
      'ClosingManager': 'Rohan',
    },
    {
      'AssignName': 'Manisha',
      'ClientName': 'Priya Verma',
      'ClientPhone': '9876543212',
      'Status': 'Revenue',
      'Project': '9 Square',
      'ManagerName': 'Jasprit',
      'BookingDate': '2024-10-02',
      'ClosingManager': 'Priya',
    },
  ];
  List<Map<String, String>> getLeads(String status) {
    if (status == "Booking Assigned") {
      return dummyLeads; // Show all leads if status is "All"
    }
    return dummyLeads
        .where((lead) => lead['Status']?.toLowerCase() == status.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = getLeads(status);

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Report - $status"),
        actions: [
          IconButton(
            onPressed: () {
              // Implement filter functionality if needed
            },
            icon: const Icon(Icons.filter_alt),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return constraint.maxWidth > 500
              ? GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredLeads.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    final lead = filteredLeads[i];
                    return LeadCard(lead: lead);
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, i) {
                    final lead = filteredLeads[i];
                    return LeadCard(lead: lead);
                  },
                );
        },
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final Map<String, String> lead;
  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.3,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lead['Status']!,
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(lead['Status']!),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NamedCard(
                      heading: "Client Name",
                      value: lead['ClientName']!,
                    ),
                    const SizedBox(height: 5),
                    NamedCard(
                      heading: "Client Phone",
                      value: "+91 ${lead['ClientPhone']!}",
                    ),
                    const SizedBox(height: 5),
                    NamedCard(
                      heading: "Booking Date",
                      value: lead['BookingDate']!,
                    ),
                    const SizedBox(height: 5),
                    NamedCard(
                      heading: "Project",
                      value: lead['Project']!,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NamedCard(
                      heading: "Assign Name",
                      value: lead['AssignName']!,
                    ),
                    NamedCard(
                      heading: "Manager Name",
                      value: lead['ManagerName']!,
                    ),
                    const SizedBox(height: 5),
                    NamedCard(
                      heading: "Closing Manager",
                      value: lead['ClosingManager']!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Booking Contacted':
        return Colors.green;
      case 'Refund Processed':
        return Colors.red;
      case 'Revenue':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class NamedCard extends StatelessWidget {
  final String heading;
  final String value;
  final double? headingSize;
  final double? valueSize;

  const NamedCard({
    super.key,
    required this.heading,
    required this.value,
    this.headingSize,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: headingSize ?? 11,
          ),
        ),
        Text(
          value.length > 18 ? "${value.substring(0, 15)}..." : value,
          style: TextStyle(
            color: Colors.black,
            fontSize: valueSize ?? 12,
          ),
        ),
      ],
    );
  }
}
