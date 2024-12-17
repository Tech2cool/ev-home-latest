import 'dart:async';

import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/channel_partner.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/pages/cp_pages/cp_tagging_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientReport extends StatefulWidget {
  final String selectedFilter;
  final String? id;

  const ClientReport({Key? key, required this.selectedFilter, this.id})
      : super(key: key);

  @override
  State<ClientReport> createState() => _ClientReportState();
}

class _ClientReportState extends State<ClientReport> {
  late String selectedFilter;
  String searchQuery = '';
  String? selectedDateFilter = 'All';
  DateTime? customStartDate;
  DateTime? customEndDate;
  bool isLoading = false;
  bool isFetchingMore = false;
  List<Lead> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;
  String? stage;
  ChannelPartner? selectedChannelPartner;

  // Dummy data
  // final List<Map<String, String>> dummyClients = [
  //   {
  //     'clientName': 'John Doe',
  //     'clientPhoneNumber': '1234567890',
  //     'startDate': '2023-10-01',
  //     'validTillDate': '2023-12-01',
  //     'taggingStatus': 'Approved'
  //   },
  //   {
  //     'clientName': 'Jane Smith',
  //     'clientPhoneNumber': '0987654321',
  //     'startDate': '2023-09-15',
  //     'validTillDate': '2023-11-15',
  //     'taggingStatus': 'Rejected'
  //   },
  //   {
  //     'clientName': 'Emily Johnson',
  //     'clientPhoneNumber': '1122334455',
  //     'startDate': '2023-08-20',
  //     'validTillDate': '2023-10-20',
  //     'taggingStatus': 'In Progress'
  //   },
  // ];

  Future<void> getLeads({bool resetPage = false}) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    if (resetPage) {
      setState(() {
        currentPage = 1; // Reset to first page
        leads = [];
        isLoading = true;
      });
    } else {
      setState(() {
        isFetchingMore = true; // Show loading more indicator
      });
    }

    final visitsResp = await settingProvider.searchLeadChannelPartner(
      widget.id ?? settingProvider.loggedChannelPartner?.id ?? "",
      searchQuery,
      currentPage,
      10,
      widget.selectedFilter.toLowerCase() == "all"
          ? null
          : widget.selectedFilter.toLowerCase(),
      stage,
      // selectedChannelPartner?.id,
    );
    print("Request Parameters:");
    print("widget.id: ${widget.id}");
    print(
        "loggedChannelPartner?.id: ${settingProvider.loggedChannelPartner?.id}");
    print("searchQuery: $searchQuery");
    print("currentPage: $currentPage");
    print("stage: $stage");
    print("selectedFilter: ${widget.selectedFilter.toLowerCase()}");
    // print("selectedChannelPartner?.id: ${selectedChannelPartner?.id}");

    print("API Response:");
// If visitsResp has a `toJson` method

    // print(visitsResp);

    setState(() {
      if (resetPage) {
        leads = visitsResp.data; // Set new leads
      } else {
        leads.addAll(visitsResp.data); // Append more leads
      }
      totalPages = visitsResp.totalPages; // Update total pages
      isLoading = false; // Hide loading
      isFetchingMore = false; // Hide loading more
    });

    print("Total leads: $leads");
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
      await settingProvider.getChannelPartners();
    } catch (e) {
      //
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onRefresh();
    getLeads(resetPage: true);
    selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final filteredClients = leads;
    final settingProvider = Provider.of<SettingProvider>(context);
    // final loggedChannel = settingProvider.loggedChannelPartner?.id;
    // getLeads();
    // print(filteredClients.length);

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
                      selectedDateFilter = newValue;
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
                  items: <String>['All', 'Approved', 'Rejected', 'Pending']
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredClients.length,
              itemBuilder: (context, index) {
                final client = filteredClients[index];
                print(filteredClients.length);
                getLeads();

                return GestureDetector(
                  onTap: () {
                    // Navigate to CpTaggingDetails
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CpTaggingDeatils(
                          lead: client,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                  '${client.firstName ?? ""} ${client.lastName ?? ""}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF005254),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (client.phoneNumber?.toString()) ?? "0",
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
                                  client.startDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(client.startDate!)
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  client.validTill != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(client.validTill!)
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Text(
                            //   Helper.capitalize(
                            //     getStatus1(lead),
                            //   ),
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: _getStatusColor(getStatus1(lead)),
                            //   ),
                            // ),
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

  String getStatus1(Lead lead) {
    if (lead.stage == "visit") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
    } else if (lead.stage == "revisit") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.revisitStatus ?? '')}";
    } else if (lead.stage == "booking") {
      return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.bookingStatus ?? '')}";
    }

    return "${Helper.capitalize(lead.stage ?? "")} ${Helper.capitalize(lead.visitStatus ?? '')}";
  }

  bool _passesDateFilter(String dateString) {
    if (selectedDateFilter == 'All') return true;

    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    switch (selectedDateFilter) {
      case 'Day':
        return date.year == customStartDate!.year &&
            date.month == customStartDate!.month &&
            date.day == customStartDate!.day;
      case 'Week':
        return date.isAfter(customStartDate!.subtract(Duration(days: 1))) &&
            date.isBefore(customEndDate!.add(Duration(days: 1)));
      case 'Month':
        return date.year == customStartDate!.year &&
            date.month == customStartDate!.month;
      case 'Custom':
        return date.isAfter(customStartDate!.subtract(Duration(days: 1))) &&
            date.isBefore(customEndDate!.add(Duration(days: 1)));
      default:
        return true;
    }
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
            customStartDate = picked;
            customEndDate = picked;
          });
        }
        break;
      case 'Week':
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) {
          setState(() {
            customStartDate =
                picked.subtract(Duration(days: picked.weekday - 1));
            customEndDate = customStartDate!.add(Duration(days: 6));
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
            customEndDate = DateTime(picked.year, picked.month + 1, 0);
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
