import 'dart:async';
import 'package:ev_homes/core/helper/helper.dart';
import 'package:ev_homes/core/models/lead.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClosingManagerLeadListPage extends StatefulWidget {
  final String status;
  final String? id;
  const ClosingManagerLeadListPage({
    super.key,
    required this.status,
    this.id,
  });

  @override
  State<ClosingManagerLeadListPage> createState() =>
      _ClosingManagerLeadListPageState();
}

class _ClosingManagerLeadListPageState
    extends State<ClosingManagerLeadListPage> {
  bool isLoading = false;
  bool isFetchingMore = false;
  String searchQuery = '';
  List<Lead> leads = [];
  int currentPage = 1;
  int totalPages = 1;
  Timer? _debounce;

  // Fetch initial leads or leads based on a new search
  Future<void> getLeads({bool resetPage = false}) async {
    final settingProvider = Provider.of<SettingProvider>(
      context,
      listen: false,
    );

    if (resetPage) {
      setState(() {
        currentPage = 1;
        leads = [];
        isLoading = true;
      });
    } else {
      setState(() {
        isFetchingMore = true;
      });
    }

    final visitsResp = await settingProvider.getTeamLeaderLeads(
      widget.id ?? settingProvider.loggedAdmin!.id!,
      searchQuery,
      currentPage,
      10,
      widget.status.toLowerCase() == "total" ? null : widget.status.toString(),
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

  String? getStatus(Lead lead) {
    if (lead.stage == "visit") {
      return lead.visitStatus;
    } else if (lead.stage == "revisit") {
      return lead.revisitStatus;
    } else if (lead.stage == "booking") {
      return lead.bookingStatus;
    }
    return lead.status;
  }

  @override
  void initState() {
    super.initState();
    getLeads(resetPage: true);
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeads = leads;

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
                                          '${lead.stage} ${lead.approvalStatus}' ??
                                              "",
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getStatusColor(
                                            getStatus(lead) ?? "",
                                          ),
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
                                          value: lead.dataAnalyzer != null
                                              ? "${lead.dataAnalyzer?.firstName} ${lead.dataAnalyzer?.lastName}"
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
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'in progress':
    case 'pending':
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
