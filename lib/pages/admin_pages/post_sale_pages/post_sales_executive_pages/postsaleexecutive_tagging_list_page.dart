import 'package:ev_homes/core/models/post_sale_lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostSaleLeadListPage extends StatelessWidget {
  final String status;

  const PostSaleLeadListPage({super.key, required this.status});

  // // Dummy data
  // final List<Map<String, String>> dummyLeads = [
  //   {
  //     'client Name': 'Mayur Thorat',
  //     'client Phone': '9876543210',
  //     'status': 'Registration Done',
  //     'Project': '9 Square',
  //     'Manager Name': 'Jasprit',
  //     'Booking date': '2024-10-02',
  //     'closing manager': 'Rohit',
  //   },
  //   {
  //     'client Name': 'Rashmi Maratha',
  //     'client Phone': '9876543210',
  //     'status': 'EOI Received',
  //     'Project': '10 Marina',
  //     'Manager Name': 'Dipak',
  //     'Booking date': '2024-09-02',
  //     'closing manager': 'Rohan',
  //   },
  //   {
  //     'client Name': 'Raj Rajput',
  //     'client Phone': '9876543210',
  //     'status': 'Cancelled',
  //     'Project': '9 Square',
  //     'Manager Name': 'Jasprit',
  //     'Booking date': '2024-10-02',
  //     'closing manager': 'Priya',
  //   },
  //   {
  //     'client Name': 'mahek',
  //     'client Phone': '9876543210',
  //     'status': 'Cancelled',
  //     'Project': '9 Square',
  //     'Manager Name': 'Jasprit',
  //     'Booking date': '2024-10-02',
  //     'closing manager': 'Priya',
  //   },
  //   // Add more dummy leads as needed
  // ];

  List<PostSaleLead> getFilteredLeads(List<PostSaleLead> leads, String status) {
    if (status == "Total") return leads;
    return leads.where((lead) => lead.bookingStatus == status).toList();
    // return leads; // Show all leads for "Total Booking"
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);

    final leadsPostSale = settingProvider.leadsPostSale;

    final filteredLeads = getFilteredLeads(leadsPostSale.data, status);

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
                    return _buildLeadCard(context, lead);
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredLeads.length,
                  itemBuilder: (context, i) {
                    final lead = filteredLeads[i];
                    return _buildLeadCard(context, lead);
                  },
                );
        },
      ),
    );
  }

  Widget _buildLeadCard(BuildContext context, PostSaleLead lead) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 10), // Adds space around the card
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushReplacement(
            "/postsalehead-internal-tagging-details",
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
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
              // Text(
              //   lead.bookingStatus ?? 'NA',
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: _getStatusColor(lead.bookingStatus ?? ''),
              //   ),
              // ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NamedCard(
                          heading: "Client Name",
                          value: "${lead.firstName} ${lead.lastName}" ?? 'N/A',
                        ),
                        const SizedBox(height: 5),
                        NamedCard(
                          heading: "Client Phone",
                          value: "+91 ${lead.phoneNumber ?? ''}",
                        ),
                        const SizedBox(height: 5),
                        NamedCard(
                          heading: "Booking Date",
                          value: lead.date ?? 'N/A',
                        ),
                        const SizedBox(height: 5),
                        NamedCard(
                          heading: "Project",
                          value: lead.project?.name ?? 'N/A',
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
                          heading: "Booking Status",
                          value: lead.bookingStatus?.type ?? 'NA',
                        ),

                        // NamedCard(
                        //   heading: "Manager Name",
                        //   value: lead.closingManager != null
                        //       ? "${lead.closingManager?.fi}"
                        //       : 'N/A',
                        // ),
                        const SizedBox(height: 5),
                        NamedCard(
                          heading: "Closing Manager",
                          value: lead.closingManager != null
                              ? "${lead.closingManager?.firstName ?? ''} ${lead.closingManager?.lastName ?? ""}"
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Registration Done':
        return Colors.green;
      case 'EOI Received':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
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
        Flexible(
          child: Text(
            heading,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: headingSize ?? 11,
            ),
          ),
        ),
        FittedBox(
          child: Text(
            value.length > 18 ? "${value.substring(0, 15)}..." : value,
            style: TextStyle(
              color: Colors.black,
              fontSize: valueSize ?? 12,
            ),
          ),
        ),
      ],
    );
  }
}
