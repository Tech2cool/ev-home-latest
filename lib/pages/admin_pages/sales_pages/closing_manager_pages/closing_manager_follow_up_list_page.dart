import 'dart:async';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClosingManagerFollowUpListPage extends StatefulWidget {
  final String status;
  final String? id;
  const ClosingManagerFollowUpListPage({
    super.key,
    required this.status,
    this.id,
  });

  @override
  State<ClosingManagerFollowUpListPage> createState() =>
      _ClosingManagerFollowUpListPageState();
}

class _ClosingManagerFollowUpListPageState
    extends State<ClosingManagerFollowUpListPage> {
  bool isLoading = false;
  bool isFetchingMore = false;
  String searchQuery = '';
  List<Lead> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;

  List<Lead> getFilteredLeads() {
    // if (widget.status == "Approved") {
    //   return leads
    //       .where((lead) => lead.approvalStage?.status == "Approved")
    //       .toList();
    // } else if (widget.status == "Rejected") {
    //   return leads
    //       .where((lead) => lead.approvalStage?.status == "Rejected")
    //       .toList();
    // } else if (widget.status == "Pending") {
    //   return leads
    //       .where(
    //         (lead) =>
    //             lead.approvalStage?.status == "Pending" ||
    //             lead.approvalStage?.status == "In Progress",
    //       )
    //       .toList();
    // }
    return leads;
  }

  // Fetch initial leads or leads based on a new search
  Future<void> getLeads({bool resetPage = false}) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    if (resetPage) {
      setState(() {
        currentPage = 1; // Reset to first page
        leads = []; // Clear current leads
        isLoading = true;
      });
    } else {
      setState(() {
        isFetchingMore = true; // Show loading more indicator
      });
    }

    final visitsResp = await settingProvider.getTeamLeaderLeads(
      widget.id ?? settingProvider.loggedAdmin!.id!,
      searchQuery,
      currentPage,
      10,
      widget.status.toLowerCase() == "total" ? null : widget.status,
    );

    if (mounted) {
      setState(() {
        if (resetPage) {
          leads = visitsResp.data;
        } else {
          leads.addAll(visitsResp.data);
        }
        totalPages = visitsResp.totalPages;
        isLoading = false;
        isFetchingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLeads(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = getFilteredLeads();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Tagging Report - ${widget.status}"),
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: TextField(
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(seconds: 1), () {
                      setState(() {
                        searchQuery = query;
                      });
                      getLeads(resetPage: true);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Lead',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isFetchingMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      if (currentPage < totalPages) {
                        currentPage++;
                        getLeads(); // Fetch more leads
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: filteredLeads.length + (isFetchingMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == filteredLeads.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final lead = filteredLeads[i];

                      return GestureDetector(
                        onTap: () {
                          // TODO: details page Lead DTA
                          GoRouter.of(context).push(
                            '/closing-manager-lead-details',
                            extra: lead,
                          );

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         AnalyserInternalTaggingDetails(lead: lead),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 15,
                          ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        Helper.capitalize(
                                          lead.approvalStage?.status ?? "",
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getStatusColor(
                                            lead.approvalStage?.status ?? "",
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "status",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    children: [
                                      Text(
                                        Helper.capitalize(
                                          lead.stage ?? "",
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.orangeAccent,
                                        ),
                                      ),
                                      const Text(
                                        "stage",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NamedCard(
                                          heading: "Client Name",
                                          value:
                                              "${lead.firstName} ${lead.lastName}",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Client Phone",
                                          value:
                                              "${lead.countryCode} ${lead.phoneNumber}",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Tagging Date",
                                          value: Helper.formatDate(
                                            lead.startDate.toString(),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        NamedCard(
                                          heading: "Valid Till",
                                          value: Helper.formatDate(
                                            lead.validTill.toString(),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NamedCard(
                                          heading: "CP Firm Name",
                                          value:
                                              lead.channelPartner?.firmName ??
                                                  "NA",
                                        ),
                                        const SizedBox(height: 5),
                                        NamedCard(
                                          heading: "Data Analyser",
                                          value: lead.dataAnalyser != null
                                              ? "${lead.dataAnalyser?.firstName} ${lead.dataAnalyser?.lastName}"
                                              : "NA",
                                        ),
                                        NamedCard(
                                          heading: "Team Leader",
                                          value: lead.teamLeader != null
                                              ? '${lead.teamLeader?.firstName} ${lead.teamLeader?.lastName}'
                                              : "NA",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Approved':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'In Progress':
    case 'Pending':
      return Colors.orange;
    default:
      return Colors.grey;
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
        Flexible(
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
